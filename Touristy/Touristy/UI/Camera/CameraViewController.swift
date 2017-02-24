import UIKit
import AVFoundation
import CoreMotion
import CoreImage

final class CameraViewController: UIViewController {
    var camera = Camera()
    
    lazy var cameraSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetHigh
        session.usesApplicationAudioSession = false
        return session
    }()
    
    lazy var preview: AVCaptureVideoPreviewLayer = {
        var preview = AVCaptureVideoPreviewLayer(session: self.cameraSession)
        preview?.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        preview?.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        preview?.videoGravity = AVLayerVideoGravityResize
        return preview!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch UIDevice.current.orientation {
        case .portrait:
            preview.connection.videoOrientation = .portrait
        default:
            preview.connection.videoOrientation = .portrait
        }
    }
}

