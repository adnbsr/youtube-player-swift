//
//  PlayerQueueState.swift
//  PlayTube
//
//  Created by Adnan Basar on 12/02/2017.
//  Copyright © 2017 Adnan Basar. All rights reserved.
//

import Foundation

class PlayerQueueState: NSObject {
    dynamic var count = 0
    dynamic var playlist = [VideoResource]()
    dynamic var now: VideoResource?
    dynamic var enqueue: VideoResource?
}
