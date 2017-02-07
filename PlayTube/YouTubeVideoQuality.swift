//
//  YouTubeVideoQuality.swift
//  PlayTube
//
//  Created by Adnan Basar on 18/01/2017.
//  Copyright © 2017 Adnan Basar. All rights reserved.
//

import Foundation
import XCDYouTubeKit

public struct YouTubeVideoQuality {
    public static let _720p = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
    public static let _360p = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
    public static let _240p = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
    public static let _mp3  = NSNumber(value: (XCDYouTubeVideoQuality.init(rawValue: 140)?.rawValue)!)
}
