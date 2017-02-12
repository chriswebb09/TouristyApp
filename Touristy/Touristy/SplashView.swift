import UIKit
import SnapKit

typealias completion = () -> Void

final class SplashView: UIView {
    
    var animationDuration: Double = 0.8
    let splashViewModel = SplashViewModel(splashImage: UIImage(), animationDuration: 20)
    
    var splashImageView: UIImageView {
        let splashView = UIImageView(image: UIImage())
        return splashView
    }
    
    override func layoutSubviews() {
        setupConstraints()
        super.layoutSubviews()
    }
    
    private func setupConstraints() {
        addSubview(splashImageView)
        self.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.center.equalTo(self)
        }
    }
}

extension SplashView {
    
    func zoomAnimation(_ handler: completion? = nil) {
        
        let duration: TimeInterval = animationDuration * 0.5
        UIView.animate(withDuration: duration, animations:{ [weak self] in
            if let zoom = self?.zoomOut() {
                self?.splashImageView.transform = zoom
            }
            self?.alpha = 0
            }, completion: { finished in
                DispatchQueue.main.async {
                    
                    //let appScreenVC = UINavigationController(rootViewController:)
                    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.window?.rootViewController = TabBarController()
                }
                handler?()
        })
    }
    
    fileprivate func zoomOut() -> CGAffineTransform {
        let zoomOutTranform: CGAffineTransform = CGAffineTransform(scaleX: 05, y: 05)
        return zoomOutTranform
    }
}
