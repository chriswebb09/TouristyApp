//
//  TabBarController.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import Firebase
import SnapKit
import Mapbox

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // view.backgroundColor = .white
        self.setupTabs()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupTabBar(tabBar:tabBar, view:view)
    }
    
    private func setTabTitles(controllers: [UINavigationController]) {
        viewControllers = controllers
        tabBar.items?[0].title = "Home"
        tabBar.items?[1].title = "Map"
        selectedIndex = 0
    }
    
    func setupTabs() {
        super.viewDidLoad()
        setupControllers()
    }
//
    fileprivate func setupControllers() {
        let mapTab = self.setupMapTab(mapVC: TourMapViewController())
        let homeTab = self.setupHomeTab(homeVC: HomeViewController())
        let controllers = [mapTab, homeTab]
        setTabTitles(controllers: controllers)
    }
    
//    private func setTabTitles(controllers: [UINavigationController]) {
//        viewControllers = controllers
//        tabBar.items?[0].title = "Map"
//        tabBar.items?[1].title = "Home"
//        selectedIndex = 0
//    }
//    
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
//
//    fileprivate func setupHomeTab(homeVC: HomeViewController) -> UINavigationController {
//        let homeTab = UINavigationController(rootViewController: homeVC)
//        configureNav(nav: homeTab.navigationBar, view:view)
//        homeTab.navigationBar.topItem?.title = "TaskHero"
//        return homeTab
//    }
    
    fileprivate func setupHomeTab(homeVC: HomeViewController) -> UINavigationController {
        let homeTab = UINavigationController(rootViewController: homeVC)
        configureNav(nav: homeTab.navigationBar, view:view)
        homeTab.navigationBar.topItem?.title = "TaskHero"
        return homeTab
    }
    
    fileprivate func setupMapTab(mapVC: TourMapViewController) -> UINavigationController {
        let mapTab = UINavigationController(rootViewController: mapVC)
        configureNav(nav: mapTab.navigationBar, view: view)
        mapTab.navigationBar.topItem?.title = "MAP"
        return mapTab
    }

//
//    fileprivate func setupProfileTab(mapViewController: TourMapViewController) -> UINavigationController {
//        //mapViewController.viewDidLoad()
//        
//        let mapTab = UINavigationController(rootViewController: mapViewController)
//        configureNav(nav:mapTab.navigationBar, view: mapViewController.view)
//        //        if let map = mapViewController.mapView {
//        //            configureNav(nav:mapTab.navigationBar, view: map)
//        //        }
//        //     mapViewController.mapView = MGLMapView(frame: self.view.frame)
//        
//        mapTab.navigationBar.topItem?.title = "Map"
//        return mapTab
//    }
    
    func configureNav(nav:UINavigationBar, view: UIView) {
        nav.frame = CGRect(x:0, y:0, width:view.frame.width, height:view.frame.height * 1.2)
    }
}

