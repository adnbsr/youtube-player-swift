//
//  PlayerController.swift
//  PlayTube
//
//  Created by Adnan Basar on 25/12/2016.
//  Copyright © 2016 Adnan Basar. All rights reserved.
//

import Foundation
import UIKit
import Material
import XCDYouTubeKit
import Alamofire
import AlamofireImage

class PlayerController: UIViewController{
    
    static let sharedInstance = PlayerController()
    
    var player: Player!
    var videoUrl = URL(string: "https://v.cdn.vine.co/r/videos/AA3C120C521177175800441692160_38f2cbd1ffb.1.5.13763579289575020226.mp4")!
    var nowPlayingCenter: MPNowPlayingInfoCenter!
    var commandCenter: MPRemoteCommandCenter!
    
    
    open var selectedResource: VideoResource? = nil {
        didSet{

            self.tabBarController?.selectedViewController = self
            
            self.nowPlayingInfo[MPMediaItemPropertyTitle] = selectedResource?.title
            self.nowPlayingInfo[MPMediaItemPropertyArtist] = selectedResource?.channelTitle
            
            Alamofire.request((selectedResource?.thumbnailURL)!).responseImage(completionHandler: {(response) -> Void in
                 self.nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork.init(image: response.result.value!)
            })
            
            self.nowPlayingInfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = NSNumber(value: 0.0)
            self.nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: 0.0)
            
            //self.nowPlayingInfo[MPMediaItemPropertyArtwork: MPMediaItemArtwork.ini]
            
            XCDYouTubeClient.default().getVideoWithIdentifier(selectedResource?.id, completionHandler: {(video, error) -> Void in
                
                if let streamURLs = video?.streamURLs, let streamURL = streamURLs[YouTubeVideoQuality._720p] ?? streamURLs[YouTubeVideoQuality._360p] ?? streamURLs[YouTubeVideoQuality._240p] {
                    self.videoUrl = streamURL
                    self.player.setUrl(self.videoUrl)
                    self.player.playFromBeginning()
                }else{
                    dump("Video stream url is not found!")
                }
            })
        }
    }
    
    var nowPlayingInfo: [String:Any] = [MPMediaItemPropertyTitle: "title"]
    
    deinit {
        self.player.willMove(toParentViewController: self)
        self.player.view.removeFromSuperview()
        self.player.removeFromParentViewController()
    }
        
    private convenience init() {
        self.init(nibName: nil, bundle: nil)
        prepareTabBarItem()
    }
        
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.lightBlue.base
        
        prepareNowPlayingCenter()
        
        self.player = Player()
        self.player.muted = false
        
        self.player.delegate = self
        
        self.addChildViewController(self.player)
        self.view.addSubview(self.player.view)
        
        self.player.view.snp.makeConstraints({(make) -> Void in
            make.width.equalToSuperview()
            make.height.equalTo(self.player.view.snp.width).multipliedBy(0.5625)
        })
        
        self.player.didMove(toParentViewController: self)
        self.player.setUrl(self.videoUrl)
                
        self.player.playbackLoops = true
        
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.player.view.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    private func prepareNowPlayingCenter(){
        nowPlayingCenter = MPNowPlayingInfoCenter.default()
        nowPlayingCenter.nowPlayingInfo = self.nowPlayingInfo
        
        self.commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget(handler: {(event) -> MPRemoteCommandHandlerStatus in
            self.player.playFromCurrentTime()
            return MPRemoteCommandHandlerStatus.success
        })
        
        commandCenter.pauseCommand.addTarget(handler: {(event) -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            return MPRemoteCommandHandlerStatus.success
        })
        
    }
    
    fileprivate func updateNowPlayingCenter(){
        
        
        if player.playbackState == .playing {
            self.nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = NSNumber(value: 1.0)
        }else if player.playbackState == .paused {
            self.nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = NSNumber(value: 0.0)
        }
        
        self.nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.player.maximumDuration
        self.nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.player.currentTime
        
        nowPlayingCenter.nowPlayingInfo = self.nowPlayingInfo

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        player.playFromBeginning()
        
    }
    
    func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        switch (self.player.playbackState.rawValue) {
        case PlaybackState.stopped.rawValue:
            self.player.playFromBeginning()
        case PlaybackState.paused.rawValue:
            self.player.playFromCurrentTime()
        case PlaybackState.playing.rawValue:
            self.player.pause()
        case PlaybackState.failed.rawValue:
            self.player.pause()
        default:
            self.player.pause()
        }
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        if toInterfaceOrientation.isLandscape {
            tabBarController?.tabBar.isHidden = true
        }else{
            tabBarController?.tabBar.isHidden = false
        }
    }
    
}

extension PlayerController: PlayerDelegate {
    
    fileprivate func prepareTabBarItem(){
        tabBarItem.image = Icon.cm.movie?.tint(with: Color.blueGrey.base)
        tabBarItem.selectedImage = Icon.cm.movie?.tint(with: Color.blue.base)
        tabBarItem.title = "Player"
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        dump(player.playbackState)
    
        updateNowPlayingCenter()
    }
    
    func playerReady(_ player: Player) {
        updateNowPlayingCenter()
    }
    
}

