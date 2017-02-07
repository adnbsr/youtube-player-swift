//
//  JSONDecodable.swift
//  PlayTube
//
//  Created by Adnan Basar on 25/12/2016.
//  Copyright © 2016 Adnan Basar. All rights reserved.
//

import Foundation

public protocol JSONMappable: class {
    init?(json: JSONObject)
}

//extension JSON {
//    func to<T>(type: T?) -> Any? {
//        if let baseObj = type as? JSONMappable.Type {
//            if self.type == .array {
//                var arrObject: [Any] = []
//                for obj in self.arrayValue {
//                    let object = baseObj.init(json: obj)
//                    arrObject.append(object!)
//                }
//                return arrObject
//            } else {
//                let object = baseObj.init(json: self)
//                return object!
//            }
//        }
//        return nil
//    }
//}
