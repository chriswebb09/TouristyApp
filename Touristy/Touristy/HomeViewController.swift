import UIKit

class HomeViewController: UIViewController {
    
    var homeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(homeView)
        homeView.layoutSubviews()
    }
}
