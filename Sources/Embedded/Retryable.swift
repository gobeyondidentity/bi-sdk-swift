import Foundation

protocol Retryable {}

extension Retryable {
    internal static func retryAsync<T>(
        maxAttempts: Int = 100,
        operation: @escaping () async throws -> T
    ) async throws -> T {
        var attempts = 0
        while true {
            do {
                return try await operation()
            } catch let error {
                attempts += 1
                if attempts >= maxAttempts || !error.isReentrant {
                    throw error
                }
                try await Task.sleep(nanoseconds: UInt64(TimeInterval.retryDelay * 1_000_000_000))
            }
        }
    }

    internal static func retry<T, E: Error>(
        maxAttempts: Int = 100,
        operation: @escaping ((@escaping (Result<T, E>) -> Void) -> Void)
    ) -> (@escaping (Result<T, E>) -> Void) -> Void {
        return { callback in
            func attempt(count: Int) {
                operation { result in
                    switch result {
                    case .success(let value):
                        callback(.success(value))
                    case .failure(let error):
                        if count >= maxAttempts || !error.isReentrant {
                            callback(.failure(error))
                            return
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + .retryDelay) {
                            attempt(count: count + 1)
                        }
                    }
                }
            }
            attempt(count: 0)
        }
    }
}

extension Error {
    var isReentrant: Bool {
        localizedDescription.lowercased().contains("reentrant")
    }
}

extension TimeInterval {
    // Retry delay is the amount of time we wait
    // before retrying calling an effect with
    // `retryAsync`. This is randomized to prevent
    // two effects from firing off in unison
    // and possibly blocking each other due
    // to a reentrant error.
    static var retryDelay: TimeInterval {
        TimeInterval.random(in: 0.05...0.1)
    }
}

