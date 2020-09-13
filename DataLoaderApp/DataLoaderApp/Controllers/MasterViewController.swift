//
//  MasterViewController.swift
//  SplitViewTest
//
//  Created by Pritesh on 12/09/20.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    // MARK: Properties
    var detailViewController: DetailViewController? = nil
    let dataLoader = DataLoader()
    
    // MARK: Life Cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Data Loader"
        // Do any additional setup after loading the view.
        self.loadDataSource()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    // MARK: Helper methods
    
    func loadDataSource() -> Void {
        //start activity indicator
        self.showSpinner(onView: self.tableView)
        dataLoader.loadData {
            //stop activity indicator & reload data
            self.removeSpinner()
            self.tableView.reloadData()
        }
    }

    // MARK: - Table View methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLoader.dataItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style:.subtitle, reuseIdentifier: "Cell")
        let data = dataLoader.dataItems[indexPath.row]
        cell.textLabel!.text = "Data(id : " + (data.identifier) + ")"
        cell.detailTextLabel?.text = "Type: " + (data.type) + "\t\t\t Date: " + (data.date)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.data = dataLoader.dataItems[indexPath.row]
        let nc = UINavigationController()
        self.detailViewController = vc
        nc.viewControllers = [vc]
        UIView.animate(withDuration: 0.2) {
            self.splitViewController?.preferredDisplayMode = .primaryHidden
        }
        self.showDetailViewController(nc, sender: self)
    }
}
