//
//  API.swift
//  PlayTube
//
//  Created by Adnan Basar on 25/12/2016.
//  Copyright © 2016 Adnan Basar. All rights reserved.
//

import Foundation
import Alamofire

enum API: URLRequestConvertible {

    case search(query: String)
    case videos(videoIds: String)

    static let baseURL: String = "https://www.googleapis.com/youtube/v3"
    
    func asURLRequest() throws -> URLRequest {
        
        
        var result: (path: String, params : Parameters) = {
            
            switch self {
            case let .search(query):
                return ("/search",["part": "snippet","q": query, "maxResults": 25,"type": "video"])
            case let .videos(ids):
                return ("/videos",["part": "snippet,contentDetails,statistics","id":ids])
            }
        }()
        
        result.params["key"] = "AIzaSyBf6KuzCPz-Qj14rRgFSNQlIzhzK6_X0xk"
        
        let url = try API.baseURL.asURL()
        let request = URLRequest(url: url.appendingPathComponent(result.path))
        
        return try URLEncoding.default.encode(request, with: result.params)
        
    }
    
}
