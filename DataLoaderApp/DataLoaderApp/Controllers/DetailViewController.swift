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
        self.view.backgroundColor = .white
    }
    
    var data: DataValue? {
        didSet {
            // Fetch data to display
            displayData()
        }
    }
    
    // MARK: Helper methods
    func displayData() {
        //start activity indicator
        self.showSpinner(onView: self.view)
        self.data?.fetchData(completion: { (data) in
            //stop activity indicator
            self.removeSpinner()
            if let imageData = data.imageData {
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
    
    func showSpinner(onView : UIView) {
        DispatchQueue.main.async {
            let indicator = UIActivityIndicatorView.init(style: .large)
            indicator.startAnimating()
            indicator.center = onView.center
            onView.addSubview(indicator)
            spinner = indicator
        }
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            spinner?.stopAnimating()
            spinner?.removeFromSuperview()
            spinner = nil
        }
    }
}
