import UIKit

class SplashViewController: UIViewController {
    
    var splashView = SplashView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        splashView.layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        let when = DispatchTime.now() + 0.5 //
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.splashView.zoomAnimation() {
                print("Animating")
            }
        }
        setupTabBar()
    }
    
    fileprivate func setupTabBar() {
        let tabBar = TabBarController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBar
    }
}

