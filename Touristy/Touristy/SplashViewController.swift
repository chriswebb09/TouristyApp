import UIKit

public final class SplashViewController: UIViewController {
    
    var splashView = SplashView()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.addSubview(splashView)
        view.backgroundColor = .white
        splashView.layoutSubviews()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        let when = DispatchTime.now() + 0.5 //
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.splashView.zoomAnimation() {
                print("Animating")
            }
        }
    }
    
    fileprivate func setupTabBar() {
        let tabBar = AppScreenViewController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBar
    }
}

