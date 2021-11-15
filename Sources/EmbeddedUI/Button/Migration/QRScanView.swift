import Anchorage
import AVFoundation
import BeyondIdentityEmbedded
import SharedDesign
#if os(iOS)
import UIKit

class QRScanView: View {
    lazy var borderLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = Colors.border2.value.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = .square
        return shapeLayer
    }()
    
    private let cameraView = CameraView()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(cameraView)
        cameraView.verticalAnchors == verticalAnchors
        cameraView.horizontalAnchors == horizontalAnchors
        
        clipsToBounds = false
        layer.addSublayer(borderLayer)
    }
    
    func configure(callback: @escaping (Result<(), Error>) -> Void){
        cameraView.configure(callback: callback)
    }
    
    func stopCameraSession() {
        cameraView.captureSession.stopRunning()
    }
    
    func startCameraSession() {
        cameraView.captureSession.startRunning()
    }
    
    override func layoutSubviews() {
        setCornerRadius(for: .camera)
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        borderLayer.path = drawBorderPath(rect)
    }
    
    func drawBorderPath(_ rect: CGRect) -> CGMutablePath {
        let length: CGFloat = rect.width / 4
        
        let cornerRadius: CGFloat = layer.cornerRadius
        
        let upperLeftPoint = CGPoint(x: rect.minX, y: rect.minY)
        let upperRightPoint = CGPoint(x: rect.maxX, y: rect.minY)
        let lowerRightPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        let lowerLeftPoint = CGPoint(x: rect.minX, y: rect.maxY)
        
        let upperLeftCorner = UIBezierPath()
        upperLeftCorner.move(to: upperLeftPoint.offsetBy(x: 0, y: length))
        upperLeftCorner.addArc(
            withCenter: upperLeftPoint.offsetBy(cornerRadius),
            radius: cornerRadius,
            startAngle: .pi,
            endAngle: 3 * .pi / 2,
            clockwise: true
        )
        upperLeftCorner.addLine(to: upperLeftPoint.offsetBy(x: length, y: 0))
        
        let upperRightCorner = UIBezierPath()
        upperRightCorner.move(to: upperRightPoint.offsetBy(x: -length, y: 0))
        upperRightCorner.addArc(
            withCenter: upperRightPoint.offsetBy(x: -cornerRadius, y: cornerRadius),
            radius: cornerRadius,
            startAngle: 3 * .pi / 2,
            endAngle: 0,
            clockwise: true
        )
        upperRightCorner.addLine(to: upperRightPoint.offsetBy(x: 0, y: length))
        
        let lowerRightCorner = UIBezierPath()
        lowerRightCorner.move(to: lowerRightPoint.offsetBy(x: 0, y: -length))
        lowerRightCorner.addArc(
            withCenter: lowerRightPoint.offsetBy(-cornerRadius),
            radius: cornerRadius,
            startAngle: 0,
            endAngle: .pi / 2,
            clockwise: true
        )
        lowerRightCorner.addLine(to: lowerRightPoint.offsetBy(x: -length, y: 0))
        
        let lowerLeftCorner = UIBezierPath()
        lowerLeftCorner.move(to: lowerLeftPoint.offsetBy(x: length, y: 0))
        lowerLeftCorner.addArc(
            withCenter: lowerLeftPoint.offsetBy(x: cornerRadius, y: -cornerRadius),
            radius: cornerRadius,
            startAngle: .pi / 2,
            endAngle: .pi,
            clockwise: true
        )
        lowerLeftCorner.addLine(to: lowerLeftPoint.offsetBy(x: 0, y: -length))
        
        let combinedPath = CGMutablePath()
        combinedPath.addPath(upperLeftCorner.cgPath)
        combinedPath.addPath(upperRightCorner.cgPath)
        combinedPath.addPath(lowerRightCorner.cgPath)
        combinedPath.addPath(lowerLeftCorner.cgPath)
        
        return combinedPath
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class CameraView: View {
    let captureSession = AVCaptureSession()
    
    private(set) var callback: ((Result<(), Error>) -> Void)? = nil
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .clear
        setUpCamera()
    }
    
    func configure(callback: @escaping (Result<(), Error>) -> Void){
        self.callback = callback
    }
    
    override class var layerClass: AnyClass  {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        return super.layer as! AVCaptureVideoPreviewLayer
    }
    
    override func layoutSubviews() {
        setCornerRadius(for: .camera)
    }
    
    func setUpCamera() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch let error {
            guard let callback = callback else { return }
            callback(.failure(error))
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            guard let callback = callback else { return }
            callback(.failure(BISDKError.description("\(videoInput) cannot be added to the session")))
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            guard let callback = callback else { return }
            callback(.failure(BISDKError.description("\(metadataOutput) cannot be added to the session")))
            return
        }
        
        previewLayer.session = captureSession
        previewLayer.videoGravity = .resizeAspectFill
        
        captureSession.startRunning()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: Coder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CameraView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let code = readableObject.stringValue,
                  let callback = callback else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            Embedded.shared.importCredentials(token: CredentialToken(value: code)) { [weak self] result in
                switch result {
                case .success:
                    callback(.success(()))
                case let .failure(error):
                    callback(.failure(error))
                    self?.captureSession.startRunning()
                }
            }
        }
    }
}
#endif
