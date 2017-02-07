//
//  Snippet.swift
//  PlayTube
//
//  Created by Adnan Basar on 25/12/2016.
//  Copyright © 2016 Adnan Basar. All rights reserved.
//

import Foundation
import SwiftyJSON

//public class Snippet: JSONMappable {
//    public let publishedAt: String
//    public let channelId: String
//    public let title: String
//    public let description: String
//    public let thumbnails: Thumbnails
//    public let channelTitle: String
//    public let liveBroadcastContent: String
//    
//    
//    public required init?(json: JSON) {
//        publishedAt = json["publishedAt"].string!
//        channelId = json["channelId"].string!
//        title = json["title"].string!
//        description = json["description"].string!
//        //thumbnails = json["thumbnails"].to(type: Thumbnails.self) as! Thumbnails
//        channelTitle = json["channelTitle"].string!
//        liveBroadcastContent = json["liveBroadcastContent"].string!
//    }
//    
//    public required init?(json: NSDictionary) {
//        
//    }
//}

public class Snippet: JSONMappable {
    
    public let title: String

    public required init?(json: JSONObject) {
        title = json["title"] as! String
    }
}
