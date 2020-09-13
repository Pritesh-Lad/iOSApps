//
//  DataLoader.swift
//  SplitViewTest
//
//  Created by Pritesh on 12/09/20.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit
import Alamofire

class DataLoader: NSObject {
    var API:String = "https://raw.githubusercontent.com/AxxessTech/Mobile-Projects/master/challenge.json"
    
    var dataItems = Array<DataValue>()
    
    public func loadData(completion: @escaping () -> Void) {
        AF.request(API).responseJSON { response in
            if let json = response.value as? Array<Any> {
                // serialized json response
                print("JSON: \(json)")
                for dataDict in json {
                    let data = DataValue.init(dict: dataDict as! Dictionary<String, Any>)
                    self.dataItems.append(data)
                }                
                //Sort based on 'type' of the DataValue objects
                self.dataItems.sort { (data1, data2) -> Bool in
                    return data1.type!.compare(data2.type!) == ComparisonResult.orderedAscending
                }
            }
            completion()
        }
    }
    
}
