import UIKit

class QueryViewController: UIViewController {
    
    let queryView = QueryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(queryView)
        queryView.layoutSubviews()
    }
}
