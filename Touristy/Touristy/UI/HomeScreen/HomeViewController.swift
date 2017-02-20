import UIKit

final class HomeViewController: UIViewController {
    
    var homeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(homeView)
        homeView.layoutSubviews()
        homeView.loginButton.addTarget(self, action: #selector(newTourButtonTapped), for: .touchUpInside)
    }
    
    func newTourButtonTapped() {
        navigationController?.pushViewController(QueryViewController(), animated: true)
    }
}
