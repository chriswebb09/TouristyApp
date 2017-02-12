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
        navigationController?.navigationBar.isHidden = true
        let when = DispatchTime.now() + 0.5 //
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.splashView.zoomAnimation({
                //self.view.backgroundColor = UIColor(red:0.30, green:0.40, blue:0.50, alpha:1.0)
                print("Animating")
            })
        }
    }
    
    fileprivate func setupTabBar() {
        let tabBar = AppScreenViewController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBar
    }
}

