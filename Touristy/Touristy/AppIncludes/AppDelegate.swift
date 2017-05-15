import UIKit
import Mapbox
import MapboxDirections
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: SplashViewController())
        return window
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        MGLAccountManager.setAccessToken(Secrets.mapKey)
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.barTintColor = .navigationBarColor()
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 12)], for: .normal)
        
        navigationBarAppearace.tintColor = .white
        window?.makeKeyAndVisible()
        return true
    }

}

