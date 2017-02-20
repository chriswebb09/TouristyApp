import UIKit

class AppScreenViewController: UIViewController {
    
    let appScreenView = AppScreenView()
    
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(appScreenView)
        appScreenView.layoutSubviews()
        appScreenView.loginButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = "Touristy"
    }
}

extension AppScreenViewController {
    
    func mapButtonTapped() {
        navigationController?.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        navigationController?.pushViewController(QueryViewController(), animated: true)
    }
}
