//
//  PlayerRootController.swift
//  PlayTube
//
//  Created by Adnan Basar on 08/02/2017.
//  Copyright © 2017 Adnan Basar. All rights reserved.
//

import Foundation
import UIKit
import Material
import XCDYouTubeKit
import Alamofire
import AlamofireImage

class PlayerRootController: UIViewController{
    
    static let sharedInstance = PlayerRootController()
    
    var player: Player!
    var nowPlayingCenter: MPNowPlayingInfoCenter!
    var commandCenter: MPRemoteCommandCenter!
    
    
    open var selectedResource: VideoResource? = nil {
        didSet{
            
            self.tabBarController?.selectedIndex = 2
            
            XCDYouTubeClient.default().getVideoWithIdentifier(selectedResource?.id, completionHandler: {(video, error) -> Void in
                
                if let streamURLs = video?.streamURLs, let streamURL = streamURLs[YouTubeVideoQuality._720p] ?? streamURLs[YouTubeVideoQuality._360p] ?? streamURLs[YouTubeVideoQuality._240p] {
                    self.player.setUrl(streamURL)
                    self.player.playFromBeginning()
                
                    if let parent = self.parent as? ToolbarController {
                        parent.toolbar.title = self.selectedResource?.title
                        parent.toolbar.detail = self.selectedResource?.channelTitle
                    }
                    self.updateNowPlayingCenter()
                    
                }else{
                    dump("Video stream url is not found!")
                }
            })
        }
    }
    
    fileprivate var selectedIndexPath: IndexPath? {
        didSet{
            
            if oldValue != nil && oldValue?.row != selectedIndexPath?.row {
                playlistTableView.delegate?.tableView!(playlistTableView, didDeselectRowAt: oldValue!)
            }
            
            self.selectedResource = self.playerQueue[(selectedIndexPath?.row)!]
        }
    }
    
    fileprivate var playerQueue = [VideoResource](){
        didSet{
            self.playlistTableView.reloadData()
        }
    }
    
    var portraitFrame: CGRect {
        get {
            return CGRect(x: 0, y: 0, width: self.view.width, height: self.view.width * 0.5625)
        }
    }
    
    var landscapeFrame: CGRect {
        get{
            return CGRect(x: 0, y: 0, width: Screen.width/2, height: Screen.height - 2 * CGFloat(HeightPreset.normal.rawValue) )
        }
    }
    
    var playerQueueState = PlayerQueueState()
    
    var playlistTableView: TableView!
    lazy var heights = [IndexPath: CGFloat]()
    
    
    var nowPlayingInfo: [String:Any] = [MPMediaItemPropertyTitle: "title"]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        addObservers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.player.willMove(toParentViewController: self)
        self.player.view.removeFromSuperview()
        self.player.removeFromParentViewController()
        removeObservers()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        prepareNowPlayingCenter()
        preparePlayer()
        preparePlaylistTableView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutSubviews()
    }
    
    func layoutSubviews(){
    
        if Application.isPortrait {
            player.view.frame = portraitFrame
            
            let diff = (view.height - player.view.height - CGFloat(HeightPreset.normal.rawValue))
            playlistTableView.frame = CGRect(x: 0, y: player.view.height, width: view.width, height: diff)
        } else {
            player.view.frame = landscapeFrame
            playlistTableView.frame = CGRect(x: player.view.width, y: 0, width: player.view.width, height: player.view.height)
    
        }
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
    
    fileprivate func preparePlayer(){
        
        self.player = Player()
        self.player.muted = false
        
        self.player.delegate = self
        
        self.addChildViewController(self.player)
        view.addSubview(player.view)
        
        self.player.didMove(toParentViewController: self)
        
        self.player.playbackLoops = false
        
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.player.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    fileprivate func preparePlaylistTableView(){
        self.playlistTableView = TableView()
        self.playlistTableView.dataSource = self
        self.playlistTableView.delegate = self
        self.playlistTableView.register(PlayerQueueCell.self, forCellReuseIdentifier: Keys.cell)
        self.playlistTableView.allowsMultipleSelection = false
        self.playlistTableView.allowsSelection = true
        
        view.addSubview(playlistTableView)
    }
    
    fileprivate func updateNowPlayingCenter(){
        
        guard let item = self.selectedResource else {
            return
        }
        
        self.nowPlayingInfo[MPMediaItemPropertyTitle] = item.title
        self.nowPlayingInfo[MPMediaItemPropertyArtist] = item.channelTitle
        
        Alamofire.request(item.thumbnailURL).responseImage(completionHandler: {(response) -> Void in
            self.nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork.init(image: response.result.value!)
        })
        
        self.nowPlayingInfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = NSNumber(value: 0.0)
        self.nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: 0.0)
        
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
        self.playlistTableView.reloadData()
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
}

// PlayerQueueContext
private var queueStateContext: Int = 0

// PlayerQueueKeys

private let playerQueueCountKey: String = "count"
private let playerQueueNowKey: String = "now"
private let playerQueuePlaylistKey: String = "playlist"
private let playerQueueEnqueueKey: String = "enqueue"

extension PlayerRootController: PlayerDelegate {
    
    func playerPlaybackStateDidChange(_ player: Player) {
        dump(player.playbackState)
        
        updateNowPlayingCenter()
    }
    
    func playerReady(_ player: Player) {
        updateNowPlayingCenter()
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
        playNext(row: (selectedIndexPath?.row)!)
    }
    
    internal func addObservers(){
        self.playerQueueState.addObserver(self, forKeyPath: playerQueueCountKey, options: .new, context: &queueStateContext)
        self.playerQueueState.addObserver(self, forKeyPath: playerQueueNowKey, options: .new, context: &queueStateContext)
        self.playerQueueState.addObserver(self, forKeyPath: playerQueueEnqueueKey, options: .new, context: &queueStateContext)
    }
    
    internal func removeObservers(){
        self.playerQueueState.removeObserver(self, forKeyPath: playerQueueCountKey)
        self.playerQueueState.removeObserver(self, forKeyPath: playerQueueNowKey)
        self.playerQueueState.removeObserver(self, forKeyPath: playerQueueEnqueueKey)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if context == &queueStateContext {
            
            if keyPath == playerQueueNowKey {

                if let item = change?[NSKeyValueChangeKey.newKey] as? VideoResource {
                    playerQueue.insert(item, at: 0)
                    selectRow(row: 0)
                }
            }
            
            if keyPath == playerQueueCountKey {
                dump("count changed!")
            }
            
            if keyPath == playerQueueEnqueueKey {
                
                if let item = change?[NSKeyValueChangeKey.newKey] as? VideoResource {
                    self.playerQueue.append(item)
                }
            }
        }
    }
    
}

extension PlayerRootController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playerQueue.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heights[indexPath] ?? tableView.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedIndexPath == indexPath && indexPath.row != 0 {
            return
        }
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.borderWidth = 2.0
        cell?.borderColor = Color.lightBlue.darken1
        
        selectedIndexPath = indexPath
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.borderWidth = 0.0
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    fileprivate func playNext(row: Int) {
        
        if playerQueue.count == 0 {
            return
        }
        
        if row == self.playerQueue.count - 1 {
            selectRow(row: 0)
        }else {
            selectRow(row: row + 1)
        }
    }
    
    fileprivate func selectRow(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        
        playlistTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        playlistTableView.delegate?.tableView!(playlistTableView, didSelectRowAt: indexPath)
    }
    
}

extension PlayerRootController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.cell, for: indexPath) as! PlayerQueueCell
        cell.resource = self.playerQueue[indexPath.row]
        heights[indexPath] = cell.height
        
        if selectedIndexPath == indexPath {
            cell.borderWidth = 2.0
            cell.borderColor = Color.lightBlue.darken1
        }else{
            cell.borderWidth = 0.0
        }
        
        cell.moreButton.tag = indexPath.row
        cell.moreButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onMoreButton(sender:))))
        
        return cell
    }
    
    @objc
    fileprivate func onMoreButton(sender: AnyObject) {
        
        let row: Int = (sender.view?.tag)!
        
        guard let r = playerQueue[row] as VideoResource? else {
            return
        }
        
        let alert: UIAlertController = UIAlertController(title: r.title, message: "Ne yapmak istersin?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Oynatma listesinden cikar", style: .default, handler: {(action) -> Void in
            
            self.playerQueue.remove(at: row)
            self.playlistTableView.reloadData()
            
            if self.selectedIndexPath?.row == row {
                self.player.stop()
                self.playNext(row: row - 1)
            }
            


        }))
        
        alert.addAction(UIAlertAction(title: "Vazgec", style: .destructive, handler: nil))
        
        show(alert, sender: nil)
        
    }
    
}


