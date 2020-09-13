//
//  DataLoader.swift
//  SplitViewTest
//
//  Created by Pritesh on 12/09/20.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class DataLoader: NSObject {
    let API:String = "https://raw.githubusercontent.com/AxxessTech/Mobile-Projects/master/challenge.json"
    let realmStore = try! Realm()
    lazy var dataItems:Results<DataValue> = {self.realmStore.objects(DataValue.self)}()
    
    ///Loads data from API if it's not available in the local storage
    public func loadData(completion: @escaping () -> Void) {
        guard dataItems.count != 0 else {
            //data not in local storage, fetch it from server
            AF.request(API).responseJSON { response in
                if let json = response.value as? Array<Any> {
                    //write the fetched data to the local storage
                    try! self.realmStore.write() {
                        for dataDict in json {
                            let data = DataValue.init(dict: dataDict as! Dictionary<String, Any>)
                            self.realmStore.add(data)
                        }
                    }
                    self.dataItems = self.realmStore.objects(DataValue.self)
                    //Sort based on 'type' of the DataValue objects
                    self.dataItems = self.dataItems.sorted(byKeyPath: "type")
                }
                completion()
            }
            return
        }
        //Sort based on 'type' of the DataValue objects
        self.dataItems = self.dataItems.sorted(byKeyPath: "type")
        completion()
    }
}
