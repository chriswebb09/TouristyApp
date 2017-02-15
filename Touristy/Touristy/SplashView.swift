import UIKit
import SnapKit

typealias completion = () -> Void

final class SplashView: UIView {
    
    var animationDuration: Double = 1
    
    //  let splashViewModel = SplashViewModel(splashImage: UIImage(named: "mapbox-logo-ihs-upload")!, animationDuration: 20)
    
    var splashImageView: UIImageView = {
        let splashView = UIImageView(image: UIImage(named: "mapbox-logo-ihs-upload"))
        return splashView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        frame = UIScreen.main.bounds
        setupConstraints()
    }
    
    func setupConstraints() {
        addSubview(splashImageView)
        splashImageView.translatesAutoresizingMaskIntoConstraints = false
        splashImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
        splashImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        splashImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        splashImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        print(splashImageView.bounds)
    }

   
    func zoomAnimation(_ handler: completion? = nil) {
        let duration: TimeInterval = animationDuration * 0.5
        UIView.animate(withDuration: duration, animations:{ [weak self] in
            if let zoom = self?.zoomOut() {
                self?.splashImageView.transform = zoom
                self?.layoutIfNeeded()
            }
            self?.alpha = 0
            }, completion: { finished in
                self.backgroundColor = UIColor(red:0.30, green:0.40, blue:0.50, alpha:1.0)
                DispatchQueue.main.async {
                    let appScreenVC = UINavigationController(rootViewController:AppScreenViewController())
                    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.window?.rootViewController = appScreenVC
                }
                handler?()
        })
    }
    
    fileprivate func zoomOut() -> CGAffineTransform {
        let zoomOutTranform: CGAffineTransform = CGAffineTransform(scaleX: 05, y: 05)
        return zoomOutTranform
    }
    
}
