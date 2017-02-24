import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        view.addSubview(tableView)
    }
    
    func setupTableView() {
        tableView.frame.origin.y = self.view.bounds.height * 0.5
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView = UITableView(frame: view.bounds, style: UITableViewStyle.plain)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.frame.size.height = UIScreen.main.bounds.height * 0.5
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
