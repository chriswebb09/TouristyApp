import UIKit


public final class SplashViewController: UIViewController {
    
    var splashView = SplashView()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        edgesForExtendedLayout = []
        view.addSubview(splashView)
        view.backgroundColor = .white
        splashView.layoutSubviews()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) { [unowned self] in
            self.splashView.zoomAnimation() {
                print("Animating")
            }
        }
    }
    
    fileprivate func setupTabBar() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = AppScreenViewController()
    }
}

