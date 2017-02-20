import UIKit
import Firebase
import SnapKit
import Mapbox

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        DispatchQueue.main.async {
            self.setupTabs()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupTabBar(tabBar:tabBar, view:view)
    }
    
    private func setTabTitles(controllers: [UINavigationController]) {
        DispatchQueue.main.async {
            self.viewControllers = controllers
            self.tabBar.items?[0].title = "Map"
            self.tabBar.items?[1].title = "Home"
            self.selectedIndex = 0
        }
    }
    
    func setupTabs() {
        super.viewDidLoad()
        self.setupControllers()
    }
    
    fileprivate func setupControllers() {
        let mapTab = self.setupMapTab(mapVC: TourMapViewController())
        let homeTab = self.setupHomeTab(homeVC: HomeViewController())
        let controllers = [mapTab, homeTab]
        setTabTitles(controllers: controllers)
    }
    
    func setupTabBar(tabBar:UITabBar, view:UIView) {
        var tabFrame = tabBar.frame
        let tabBarHeight = view.frame.height * 0.09
        tabFrame.size.height = tabBarHeight
        tabFrame.origin.y = view.frame.size.height - tabBarHeight
        tabBar.frame = tabFrame
        tabBar.isTranslucent = false
        tabBar.tintColor = UIColor(red:0.07, green:0.59, blue:1.00, alpha:1.0)
        tabBar.barTintColor = .gray
    }
    
    fileprivate func setupHomeTab(homeVC: HomeViewController) -> UINavigationController {
        homeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "sattelite")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "sattelite")?.withRenderingMode(.alwaysOriginal))
        let homeTab = UINavigationController(rootViewController: homeVC)
        configureNav(nav: homeTab.navigationBar, view:view)
        homeTab.navigationBar.topItem?.title = "Home"
        return homeTab
    }
    
    fileprivate func setupMapTab(mapVC: TourMapViewController) -> UINavigationController {
         mapVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "planet")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "planet")?.withRenderingMode(.alwaysOriginal))
        let mapTab = UINavigationController(rootViewController: mapVC)
        configureNav(nav: mapTab.navigationBar, view: view)
        mapTab.navigationBar.topItem?.title = "Map"
        return mapTab
    }
    
    func configureNav(nav:UINavigationBar, view: UIView) {
        nav.frame = CGRect(x:0, y:0, width:view.frame.width, height:view.frame.height * 1.2)
    }
}

