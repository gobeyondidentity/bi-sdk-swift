import Foundation

public struct Tagged<Tag, Value> {
    public let value: Value
    
    public init(_ value: Value) {
        self.value = value
    }
}

extension Tagged: Decodable where Value: Decodable {
    public init(from decoder: Decoder) throws {
        do {
            self.init(try decoder.singleValueContainer().decode(Value.self))
        } catch {
            self.init(try .init(from: decoder))
        }
    }
}

extension Tagged: Encodable where Value: Encodable {
    public func encode(to encoder: Encoder) throws {
        do {
            var container = encoder.singleValueContainer()
            try container.encode(self.value)
        } catch {
            try self.value.encode(to: encoder)
        }
    }
}

extension Tagged: Equatable where Value: Equatable {}
