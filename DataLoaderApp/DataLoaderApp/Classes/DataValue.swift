//
//  DataValue.swift
//  SplitViewTest
//
//  Created by Pritesh on 12/09/20.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit
import Alamofire

class DataValue: NSObject {
    public var identifier: String?
    public var date: String?
    public var type: String?
    public var value: String?
    public var imageData:Data?
    public var text: String?

    typealias CompletionHandler = (_ data: DataValue) -> Void

    public init(dict:Dictionary<String,Any>) {
        identifier = dict["id"] as? String
        type = dict["type"] as? String
        value = dict["data"] as? String
        date = dict["date"] as? String
    }
    
    func fetchData(completion: @escaping CompletionHandler) {
        //fetch data based on its type
        if type == "image" {
            if self.imageData != nil {
                completion(self)
                return
            }
            //fetch image from url
            AF.request(value ?? "").response { (response) in
                if let respData = response.data {
                    self.imageData = respData
                } else {
                    self.text = response.error?.localizedDescription
                }
                completion(self)
            }
        } else {
            self.text = self.value
            completion(self)
        }
    }
}

