//
//  Item.swift
//  PlayTube
//
//  Created by Adnan Basar on 25/12/2016.
//  Copyright © 2016 Adnan Basar. All rights reserved.
//

import Foundation

public class Item: JSONMappable {
    
    public let kind: String
    public let etag: String
    public let id: String
    public var snippet: Snippet?

    public required init?(json: JSONObject) {
        kind = json["kind"] as! String
        etag = json["etag"] as! String
        
        if let id = json["id"] as? NSDictionary {
            self.id = id["videoId"] as! String
        }else {
            self.id = json["id"] as! String
        }
        
        if let _snippet = json["snippet"] as? JSONObject {
            snippet = Snippet(json: _snippet)!
        }
        
    }
}
