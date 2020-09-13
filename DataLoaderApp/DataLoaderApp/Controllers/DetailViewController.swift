//
//  DetailViewController.swift
//  SplitViewTest
//
//  Created by Pritesh on 12/09/20.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    var data: DataValue? {
        didSet {
            // Fetch data to display
            displayData()
        }
    }
    
    // MARK: Helper methods
    
    ///Fetches & displays the details of the data based on it's type
    func displayData() {
        self.navigationItem.title = "\(data!.type)" + "(\(data!.identifier ))"
        //start activity indicator
        self.showSpinner(onView: self.view)
        self.data?.fetchData(completion: { (data) in
            //stop activity indicator
            self.removeSpinner()
            let imageData = data.imageData
            if imageData.count != 0 {
                //render image
                let imageView = UIImageView.init(image: UIImage.init(data: imageData))
                imageView.contentMode = .scaleAspectFit
                self.addCenteredSubView(subview: imageView)
            } else {
                //render text
                let textView = UITextView()
                textView.text = data.text
                textView.textAlignment = .center
                textView.isEditable = false
                self.addCenteredSubView(subview: textView)
            }
        })
    }
    
    ///Adds a centered subview into self.view
    func addCenteredSubView(subview:UIView) {
        self.view.addSubview(subview)
        subview.snp.makeConstraints { (constraintMaker) in
            constraintMaker.width.equalTo(self.view)
            constraintMaker.center.equalTo(self.view)
            constraintMaker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
    }
}

// MARK: Spinner extention

var spinner : UIActivityIndicatorView?

extension UIViewController {
    ///Starts a spinner at the center of a given view
    func showSpinner(onView : UIView) {
        DispatchQueue.main.async {
            let indicator = UIActivityIndicatorView.init(style: .large)
            indicator.startAnimating()
            indicator.center = onView.center
            onView.addSubview(indicator)
            spinner = indicator
        }
    }
    
    ///Stops a spinner
    func removeSpinner() {
        DispatchQueue.main.async {
            spinner?.stopAnimating()
            spinner?.removeFromSuperview()
            spinner = nil
        }
    }
}
