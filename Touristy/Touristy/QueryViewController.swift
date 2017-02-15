import UIKit

class QueryViewController: UIViewController {
    
    let queryView = QueryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.addSubview(queryView)
        queryView.layoutSubviews()
        queryView.firstChoiceButton.addTarget(self, action: #selector(loadTabbar), for: .touchUpInside)
        queryView.secondChoiceButton.addTarget(self, action: #selector(loadTabbar), for: .touchUpInside)
    }
    
    func loadTabbar() {
        let tabBar = TabBarController()
        //let settings = SettingsViewController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.window?.rootViewController = settings
        appDelegate.window?.rootViewController = tabBar
    }
}
