//
//  SearchResultResource.swift
//  PlayTube
//
//  Created by Adnan Basar on 15/01/2017.
//  Copyright © 2017 Adnan Basar. All rights reserved.
//

import Foundation

public class SearchResultResource: JSONMappable {

    public let videoId: String
    public let title: String
    
    public required init?(json: JSONObject) {
        
        if let id = json["id"] as? JSONObject, let snippet = json["snippet"] as? JSONObject {
            self.videoId = id["videoId"] as! String
            self.title = snippet["title"] as! String
        }else {
            self.videoId = "nil"
            self.title = "nil"
        }
    }
    
}
