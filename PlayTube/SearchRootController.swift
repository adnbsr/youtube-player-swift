//
//  SearchRootController.swift
//  PlayTube
//
//  Created by Adnan Basar on 12/02/2017.
//  Copyright © 2017 Adnan Basar. All rights reserved.
//

import Foundation
import UIKit
import Material
import FileBrowser
import Alamofire
import XCDYouTubeKit
import Crashlytics

class SearchRootController: UIViewController {
    
    
    var items:[VideoResource] = [VideoResource]()
    lazy var heights = [IndexPath: CGFloat]()
    
    var selectedResource: VideoResource? = nil {
        didSet{
            let actionSheetController = UIAlertController(title: selectedResource?.title, message: "Ne yapmak istersin?", preferredStyle: .alert)
            
            actionSheetController.addAction(UIAlertAction(title: "Oynat", style: .default, handler: {(action) -> Void in
                PlayerRootController.sharedInstance.playerQueueState.now = self.selectedResource!
            }))
            
            actionSheetController.addAction(UIAlertAction(title: "Oynatma Listesine Ekle", style: .default, handler: {(action) -> Void in
                PlayerRootController.sharedInstance.playerQueueState.enqueue = self.selectedResource!
            }))
            
            actionSheetController.addAction(UIAlertAction(title: "Indir", style: .default, handler: {(action) -> Void in
                self.onDownload(resource: self.selectedResource!)
            }))
            actionSheetController.addAction(UIAlertAction(title: "Bosver", style: .cancel, handler: nil))
            
            show(actionSheetController, sender: nil)
        }
    }
    
    var submittedText: String = "" {
        didSet{
            
            if submittedText != "" {
                
                Answers.logSearch(withQuery: submittedText, customAttributes: nil)
                
                APIClient.sharedInstance.search(query: submittedText, completion: {(items) in
                    
                    APIClient.sharedInstance.videos(videoIds: items, completion: {(videoItems) -> Void in
                        
                        self.items = videoItems
                        self.searchListView.reloadData()
                        
                    })
                })
                
            }
        }
    }
    
    fileprivate var undoButton: FlatButton!
    fileprivate var searchListView: TableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSearchListView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        prepareSearchListView()
        prepareFileBrowserButton()
        prepareUndoButton()
        prepareSnackbar()
    }
    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        searchListView.frame = CGRect(x: 0, y: 0, width: Screen.width, height: Screen.height - CGFloat(HeightPreset.normal.rawValue))
        snackbarController?.animate(snackbar: .hidden)
        
    }
    

    @objc func onMoreButton(sender: AnyObject){
        dump("onMoreButton")
        selectedResource = self.items[sender.view.tag]
    }
    
    @objc func onBrowseFiles(sender: AnyObject) {
        present(FileBrowser(), animated: true, completion: nil)
    }
    
    @objc
    func onFavoriteButton(sender: AnyObject){
        guard let resource = self.items[(sender.view?.tag)!] as VideoResource?, let f = sender.view! as? IconButton else {
            return
        }
        
        f.image = Icon.favorite
        
        resource.saveAsFavorite()
    }
    
    func onDownload(resource: VideoResource){
        
        let downloadAlertController = UIAlertController(title: resource.title, message: "Kalite seciniz?", preferredStyle: .alert)
        
        XCDYouTubeClient.default().getVideoWithIdentifier(resource.id, completionHandler: {(video, error) -> Void in
            
            if error == nil {
                
                if let stremURLs = video?.streamURLs {
                    
                    if let _720p = stremURLs[YouTubeVideoQuality._720p] {
                        downloadAlertController.addAction(UIAlertAction(title: "720p", style: .default, handler: {(action) -> Void in
                            self.downloadFile(title: "\(resource.title.replacingOccurrences(of: " ", with: "_"))_720p", url: _720p, _extension: "mp4")
                        }))
                    }
                    if let _360p = stremURLs[YouTubeVideoQuality._360p] {
                        downloadAlertController.addAction(UIAlertAction(title: "360p", style: .default, handler: {(action) -> Void in
                            self.downloadFile(title: "\(resource.title.replacingOccurrences(of: " ", with: "_"))_360p", url: _360p, _extension: "mp4")
                        }))
                    }
                    if let _240p = stremURLs[YouTubeVideoQuality._240p] {
                        downloadAlertController.addAction(UIAlertAction(title: "240p", style: .default, handler: {(action) -> Void in
                            self.downloadFile(title: "\(resource.title.replacingOccurrences(of: " ", with: "_"))_240p", url: _240p, _extension: "mp4")
                        }))
                    }
                    
                    if let _mp3 = stremURLs[YouTubeVideoQuality._mp3] {
                        downloadAlertController.addAction(UIAlertAction(title: "mp3", style: .default, handler: {(action) -> Void in
                            self.downloadFile(title: "\(resource.title.replacingOccurrences(of: " ", with: "_"))_mp3", url: _mp3, _extension: "m4a")
                        }))
                    }
                }
            }
        })
        
        downloadAlertController.addAction(UIAlertAction(title: "Iptal", style: .cancel, handler: nil))
        
        show(downloadAlertController, sender: nil)
        
        
        
    }
    
    fileprivate func downloadFile(title: String, url: URL, _extension: String) {
        
        let file = "\(title).\(_extension)"
        
        let destination: DownloadRequest.DownloadFileDestination = {_, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(file)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(url, to: destination).downloadProgress { progress in
            if progress.fractionCompleted == 1.0 {
                self.animateSnackbar()
            }
        }
        
    }
}

extension SearchRootController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchItemCell
        
        cell.resource = self.items[indexPath.row]
        heights[indexPath] = cell.height
        
        cell.moreButton.tag = indexPath.row
        cell.moreButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMoreButton(sender:))))
        
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onFavoriteButton(sender:))))
        
        return cell
    }

}

extension SearchRootController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heights[indexPath] ?? tableView.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PlayerRootController.sharedInstance.playerQueueState.count = indexPath.row
        PlayerRootController.sharedInstance.playerQueueState.now = self.items[indexPath.row]
    }
}

extension SearchRootController {
    
    fileprivate func prepareSearchListView(){
        
        let frameSize: CGRect = CGRect(x: 0, y: 0, width: view.width, height: view.height - CGFloat(HeightPreset.normal.rawValue))
        
        searchListView = TableView(frame: frameSize)
        searchListView.delegate = self
        searchListView.dataSource = self
        searchListView.register(SearchItemCell.self, forCellReuseIdentifier: Keys.cell)
        searchListView.separatorStyle = .none
        view.addSubview(searchListView)
        view.layoutIfNeeded()
    }
    
    fileprivate func prepareFileBrowserButton(){
        
        let browseFilesButton = IconButton(image: Icon.cm.photoLibrary, tintColor: .white)
        browseFilesButton.addTarget(self, action: #selector(onBrowseFiles(sender:)), for: .touchUpInside)
    
        searchBarController?.searchBar.rightViews = [browseFilesButton]
    }
    
    fileprivate func prepareUndoButton() {
        undoButton = FlatButton(title: Keys.watch, titleColor: Color.yellow.base)
        undoButton.pulseAnimation = .backing
        undoButton.titleLabel?.font = snackbarController?.snackbar.textLabel.font
    }
    
    fileprivate func prepareSnackbar() {
        guard let snackbar = snackbarController?.snackbar else {
            return
        }
        
        snackbarController?.snackbarAlignment = .upper
        snackbar.text = Keys.downloadComplete
        snackbar.rightViews = [undoButton]
    }
    
    @objc
    fileprivate func animateSnackbar() {
        guard let sc = snackbarController else {
            return
        }
        
    
        
        _ = sc.animate(snackbar: .visible, delay: 1)
        _ = sc.animate(snackbar: .hidden, delay: 4)
    }
    
}
