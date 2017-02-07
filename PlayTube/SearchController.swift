//
//  ViewController.swift
//  PlayTube
//
//  Created by Adnan Basar on 24/12/2016.
//  Copyright © 2016 Adnan Basar. All rights reserved.
//

import UIKit
import SnapKit
import Material
import Alamofire
import SDWebImage
import FileBrowser
import XCDYouTubeKit
import Graph

class SearchController: SearchBarController {
    
    override func prepare() {
        super.prepare()
        
        statusBarStyle = .lightContent
        statusBar.backgroundColor = Color.lightBlue.darken4
        searchBar.placeholder = "Ara"
        searchBar.placeholderColor = .white
        searchBar.textColor = .white
        searchBar.backgroundColor = Color.lightBlue.darken4
        searchBar.clearButton.image = Icon.cm.search
        searchBar.textField.rightViewMode = .always
        
    }
}

class SearchRootController: UIViewController, UITableViewDataSource, UITextFieldDelegate {
    
    
    var items:[VideoResource] = [VideoResource]()
    lazy var heights = [IndexPath: CGFloat]()
    
    var selectedResource: VideoResource? = nil {
        didSet{
            let actionSheetController = UIAlertController(title: selectedResource?.title, message: "Ne yapmak istersin?", preferredStyle: .alert)
            
            actionSheetController.addAction(UIAlertAction(title: "Oynat", style: .default, handler: nil))
            actionSheetController.addAction(UIAlertAction(title: "Indir", style: .default, handler: {(action) -> Void in
                self.onDownload(resource: self.selectedResource!)
            }))
            actionSheetController.addAction(UIAlertAction(title: "Bosver", style: .cancel, handler: nil))
  
            show(actionSheetController, sender: nil)
        }
    }
    
    var searchButton: IconButton {
        return IconButton(image: Icon.search, tintColor: .white)
    }

    lazy var resultListView: UITableView = {
        var t = UITableView(frame: .zero, style: .plain)
        t.register(ItemCell.self, forCellReuseIdentifier: "cell")
        t.dataSource = self
        t.delegate = self
        t.separatorStyle = .none
        
        self.view.addSubview(t)
        return t
    }()
    
    fileprivate var undoButton: FlatButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultListView.snp.makeConstraints({(make) -> Void in
            make.width.height.equalToSuperview()
        })
        
        searchBarController?.searchBar.textField.delegate = self
        searchBarController?.searchBar.delegate = self
        
        APIClient.sharedInstance.search(query: "stolk", completion: {(items) in
            
            APIClient.sharedInstance.videos(videoIds: items, completion: {(videoItems) -> Void in
                
                self.items = videoItems
                self.resultListView.reloadData()
                
            })
        })
        
        let browseFilesButton = IconButton(image: Icon.cm.photoLibrary, tintColor: .white)
        browseFilesButton.addTarget(self, action: #selector(onBrowseFiles(sender:)), for: .touchUpInside)
        
        
        
        searchBarController?.searchBar.rightViews = [browseFilesButton]
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        prepareUndoButton()
        prepareSnackbar()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemCell
        
        cell.resource = self.items[indexPath.row]
        heights[indexPath] = cell.height
        
        cell.moreButton.tag = indexPath.row
        cell.moreButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMoreButton(sender:))))
        
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onFavoriteButton(sender:))))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PlayerController.sharedInstance.selectedResource = self.items[indexPath.row]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        APIClient.sharedInstance.search(query: textField.text!, completion: {(items) in
            
            APIClient.sharedInstance.videos(videoIds: items, completion: {(videoItems) -> Void in
                
                self.items = videoItems
                self.resultListView.reloadData()
                
            })
        })
        
        textField.resignFirstResponder()
        
        return true
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
                            self.downloadFile(title: "\(resource.title.replacingOccurrences(of: " ", with: "_"))_mp3", url: _mp3, _extension: "mp3")
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

extension SearchRootController: UITableViewDelegate, SearchBarDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heights[indexPath] ?? tableView.height
    }
    
    fileprivate func prepareUndoButton() {
        undoButton = FlatButton(title: "Izle", titleColor: Color.yellow.base)
        undoButton.pulseAnimation = .backing
        undoButton.titleLabel?.font = snackbarController?.snackbar.textLabel.font
    }
    
    fileprivate func prepareSnackbar() {
        guard let snackbar = snackbarController?.snackbar else {
            dump("no snackbar!")
            return
        }
        
        snackbarController?.snackbarAlignment = .upper
        snackbar.text = "Indirme tamamlandi!"
        snackbar.rightViews = [undoButton]
    }
    
    //    fileprivate func scheduleAnimation() {
    //        Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(animateSnackbar), userInfo: nil, repeats: true)
    //    }
    
    @objc
    fileprivate func animateSnackbar() {
        guard let sc = snackbarController else {
            return
        }
        
        _ = sc.animate(snackbar: .visible, delay: 1)
        _ = sc.animate(snackbar: .hidden, delay: 4)
    }
    
    func searchBar(searchBar: SearchBar, didChange textField: UITextField, with text: String?) {
        
        if searchBar.textField.isFirstResponder {
            searchBar.clearButton.image = Icon.cm.clear
        }else {
            searchBar.clearButton.image = Icon.cm.search
        }
    }
}
