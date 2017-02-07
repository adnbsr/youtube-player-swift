//
//  VideoResouce+Entity.swift
//  PlayTube
//
//  Created by Adnan Basar on 25/01/2017.
//  Copyright © 2017 Adnan Basar. All rights reserved.
//

import Foundation
import Graph

extension Entity {

    func convertToVideoResource() -> VideoResource? {
        
        if type != Keys.Favorite {
            return nil
        }
    
        return VideoResource(
            title: self[Keys.title] as! String,
            id: self[Keys.id] as! String,
            thumbnailURL: self[Keys.thumbnailURL] as! URL,
            channelTitle: self[Keys.channelTitle] as! String,
            channelId: self[Keys.channelId] as! String,
            duration: self[Keys.duration] as! String,
            publishedDate: self[Keys.publishedDate] as! String
        )
    }
    
}
