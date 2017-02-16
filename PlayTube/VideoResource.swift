//
//  VideoResource.swift
//  PlayTube
//
//  Created by Adnan Basar on 15/01/2017.
//  Copyright © 2017 Adnan Basar. All rights reserved.
//

import Foundation
import Graph

extension Date {

    var relativelyFormatted: String {
        
        let now = Date()
        
        let components = Calendar.current.dateComponents(
            [.year, .month, .weekOfYear, .day, .hour, .minute, .second],
            from: self,
            to: now
        )
        
        if let years = components.year, years > 0 {
            return "\(years) year\(years == 1 ? "" : "s") ago"
        }
        
        if let months = components.month, months > 0 {
            return "\(months) month\(months == 1 ? "" : "s") ago"
        }
        
        if let weeks = components.weekOfYear, weeks > 0 {
            return "\(weeks) week\(weeks == 1 ? "" : "s") ago"
        }
        if let days = components.day, days > 0 {
            guard days > 1 else { return "yesterday" }
            
            return "\(days) day\(days == 1 ? "" : "s") ago"
        }
        
        if let hours = components.hour, hours > 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        }
        
        if let minutes = components.minute, minutes > 0 {
            return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
        }
        
        if let seconds = components.second, seconds > 30 {
            return "\(seconds) second\(seconds == 1 ? "" : "s") ago"
        }
        
        return "just now"
    }

}



func dateFromPublishedAt(publishedAt: String) -> Date {
    // 世界時間にする。
    var formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
    let worldDate = formatter.date(from: publishedAt)!
    // ローカル時間にする。
    formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.timeZone = NSTimeZone.default
    let formattedLocalDate = formatter.string(from: worldDate)
    return formatter.date(from: formattedLocalDate)!
}

func formatFromDuration(duration: String) -> String {
    var duration = duration.replacingOccurrences(of: "PT", with: "", options: .regularExpression, range: nil)
    var time = [0, 0, 0]
    for (index, symbol) in ["H", "M", "S"].enumerated() {
        let components = duration.components(separatedBy: symbol)
        if components.count == 2 {
            time[index] = Int(components.first!)!
            duration = duration.replacingOccurrences(of: "\(time[index])\(symbol)", with: "", options: .regularExpression, range: nil)
        }
    }
    var formattedTime = ""
    if time.first! > 0 {
        formattedTime += NSString(format: "%d:", time.first!) as String
    }
    formattedTime += NSString(format: "%02d:%02d", time[1], time[2]) as String
    return formattedTime
}

@objc
public class VideoResource: NSObject, JSONMappable {

    public let id: String
    public let title: String
    public let thumbnailURL: URL
    public let duration: String
    public let channelTitle: String
    public let channelId: String
    public let uploadedDate: String
    public var numberOfWatch: String?
    public var numberOfLikes: Int?
    
    public init(title: String, id: String, thumbnailURL: URL, channelTitle: String, channelId: String, duration: String, publishedDate: String) {
        self.title = title
        self.id = id
        self.thumbnailURL = thumbnailURL
        self.channelTitle = channelTitle
        self.channelId = channelId
        self.duration = duration
        self.uploadedDate = publishedDate
    }
    
    public  required init?(json: JSONObject) {
        self.id = json["id"] as! String
        
        let snippet = json["snippet"] as! JSONObject
        let contentDetails = json["contentDetails"] as! JSONObject
        let statistics = json["statistics"] as! JSONObject
        
        self.title = snippet["title"] as! String
        
        let thumbnail: String = ((snippet["thumbnails"] as! JSONObject)["high"] as! JSONObject)["url"] as! String
        self.thumbnailURL = URL(string: thumbnail)!
        
        self.duration = formatFromDuration(duration: contentDetails["duration"] as! String)
        self.channelTitle = snippet["channelTitle"] as! String
        self.channelId = snippet["channelId"] as! String
        self.uploadedDate = dateFromPublishedAt(publishedAt: snippet["publishedAt"] as! String).relativelyFormatted
        self.numberOfWatch = statistics["viewCount"] as? String
        self.numberOfLikes = 1
        
    }
}

extension VideoResource{

    func saveAsFavorite() {
        
        let graph = Graph()
        
        let e = Entity(type: Keys.Favorite)
        e[Keys.title] = self.title
        e[Keys.id] = self.id
        e[Keys.channelTitle] = self.channelTitle
        e[Keys.channelId] = self.channelId
        e[Keys.thumbnailURL] = self.thumbnailURL
        e[Keys.duration] = self.duration
        e[Keys.publishedDate] = self.uploadedDate
        
        graph.sync()
        
    }
}

