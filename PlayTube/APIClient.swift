//
//  APIClient.swift
//  PlayTube
//
//  Created by Adnan Basar on 11/01/2017.
//  Copyright © 2017 Adnan Basar. All rights reserved.
//

import Box
import Result
import Alamofire
import Foundation


class APIClient {

    static let sharedInstance = APIClient()
    
    func search(query: String, completion: @escaping (Array<String>) -> Void){
        
        Alamofire.request(API.search(query: query)).responseJSON(completionHandler: {(object) -> Void in
            
            switch self.validate(object: object) {
            case .success(let json):
                
                if let _items = json["items"] as? JSONArray{
                    let items = _items.map{(item) -> String in
                        return SearchResultResource(json: item)!.videoId
                    }
                    completion(items)
                
                }
        
                break
            case .failure(let error):
                dump(error)
                break
            }
        })
        
    }
    
    func videos(videoIds: Array<String>, completion: @escaping (Array<VideoResource>) -> Void ){
        
        Alamofire.request(API.videos(videoIds: videoIds.joined(separator: ","))).responseJSON(completionHandler: {(object) -> Void in
          
            switch self.validate(object: object) {
            case .success(let json):
                
                if let _items = json["items"] as? JSONArray{
                    let items = _items.map{(item) -> VideoResource in
                        return VideoResource(json: item)!
                    }
                    completion(items)
                }
                
                break
            case .failure(let error):
                dump(error)
                break
            }
            
        })
    }
        
    private func validate(object: DataResponse<Any>) -> RSLT{
    
        if object.result.isSuccess {
            if let json = object.result.value as? JSONObject {
                return Result.success(json)
            }else{
                return Result.failure(AnyError.error(from: object.result.error!))
            }
        }else{
            return Result.failure(object.result.error as! AnyError)
        }
    
    }
    
}
