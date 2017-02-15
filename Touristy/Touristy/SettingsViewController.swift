//
//  SettingsViewController.swift
//  Touristy
//
//  Created by Christopher Webb-Orenstein on 2/15/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: view.bounds,
                                    style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.frame.origin.y = self.view.bounds.height * 0.5
      //  tableView.frame.origin.y += 166
       // view.translatesAutoresizingMaskIntoConstraints = false
      //  tableView.translatesAutoresizingMaskIntoConstraints = false
       // tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
      //  tableView.frame.size.height = self.view.bounds.height * (UIScreen.main.bounds.height * 0.5)
        tableView.frame.size.height = UIScreen.main.bounds.height * 0.5
    }
    
   
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    
    
    
}
