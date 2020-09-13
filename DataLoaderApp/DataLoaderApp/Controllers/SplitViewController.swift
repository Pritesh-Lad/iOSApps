//
//  SplitViewController.swift
//  SplitViewTest
//
//  Created by Pritesh on 13/09/20.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        preferredDisplayMode = .primaryOverlay
        let master = UINavigationController(rootViewController: MasterViewController())
        let detail = UINavigationController(rootViewController: DetailViewController())
        viewControllers = [master, detail]
        delegate = self
    }
    
    // MARK: - Split view delegate    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.data == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
}
