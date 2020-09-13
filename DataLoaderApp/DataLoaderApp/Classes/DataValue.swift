//
//  DataValue.swift
//  SplitViewTest
//
//  Created by Pritesh on 12/09/20.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class DataValue: Object {
    @objc dynamic var identifier = ""
    @objc dynamic var date = ""
    @objc dynamic var type = ""
    @objc dynamic var value = ""
    @objc dynamic var imageData = Data()
    @objc dynamic var text = ""

    typealias CompletionHandler = (_ data: DataValue) -> Void

    required init() {
    }
    
    public init(dict:Dictionary<String,Any>) {
        identifier = dict["id"] as? String ?? ""
        type = dict["type"] as? String ?? ""
        value = dict["data"] as? String ?? ""
        date = dict["date"] as? String ?? ""
    }
    
    ///Fetches the data from server if it's not available in the local storage
    func fetchData(completion: @escaping CompletionHandler) {
        let realmStore = try! Realm()
        //fetch data based on its type
        if type == "image" {
            //if image data is available, simply return
            if self.imageData.count != 0 {
                completion(self)
                return
            }
            //fetch image data from url
            AF.request(value).response { (response) in
                try! realmStore.write() {
                    if let respData = response.data {
                        self.imageData = respData
                    } else {
                        self.text = response.error?.localizedDescription ?? "no image available"
                    }
                }
                completion(self)
            }
        } else {
            //for other 'type's, use textual data
            try! realmStore.write() {
                self.text = self.value
                completion(self)
            }
        }
    }
}

