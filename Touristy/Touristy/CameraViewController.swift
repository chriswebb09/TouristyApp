import UIKit
import AVFoundation
import CoreMotion
import CoreImage

class CameraViewController: UIViewController {
    var camera = Camera()
    
    lazy var cameraSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetHigh
        session.usesApplicationAudioSession = false
        return session
    }()
    
    lazy var preview: AVCaptureVideoPreviewLayer = {
        self.preview =  AVCaptureVideoPreviewLayer(session: self.cameraSession)
        self.preview.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.preview.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        self.preview.videoGravity = AVLayerVideoGravityResize
        return self.preview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch UIDevice.current.orientation {
        case .portrait:
            self.preview.connection.videoOrientation = .portrait
        default:
            self.preview.connection.videoOrientation = .portrait
        }
    }
}

