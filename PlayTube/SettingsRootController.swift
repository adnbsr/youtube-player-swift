//
//  SettingsRootController.swift
//  PlayTube
//
//  Created by Adnan Basar on 16/02/2017.
//  Copyright © 2017 Adnan Basar. All rights reserved.
//

import Foundation
import UIKit
import Material
import Graph

class SettingsRootController: UIViewController{
    
    var clearFavoritesBar: Toolbar!
    var clearFavoritesButton: IconButton!
    
    var clearFilesBar: Toolbar!
    var clearFilesButton: IconButton!
    
    
    var keepHistoryBar: Toolbar!
    var keepHistorySwitch: Switch!
    
    //feedback
    var feedbackBar: Toolbar!
    var feedbackButton: IconButton!
    
    //share
    var shareBar: Toolbar!
    var shareButton: IconButton!
    
    //removeAds
    var removeAdsBar: Toolbar!
    var removeAdsButton: IconButton!
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        prepareBars()
    }
    
    private func prepareBars(){
        
        //removeAds
        
        removeAdsBar = Toolbar()
        removeAdsBar.heightPreset = .normal
        removeAdsBar.contentEdgeInsetsPreset = .square1
        removeAdsBar.title = Keys.remove_ads
        removeAdsBar.titleLabel.textAlignment = .left
        removeAdsBar.titleLabel.font = RobotoFont.light(with: 17.0)
        
        removeAdsButton = IconButton(image: UIImage(named: "ic_pan_tool")?.withRenderingMode(.alwaysTemplate), tintColor: .black)
        removeAdsButton.heightPreset = .normal
        
        removeAdsBar.rightViews = [removeAdsButton]
        view.addSubview(removeAdsBar)
        
        //clearFavorites
        
        clearFavoritesBar = Toolbar()
        clearFavoritesBar.heightPreset = .normal
        clearFavoritesBar.contentEdgeInsetsPreset = .square1
        
        clearFavoritesBar.title = Keys.clear_favorites
        clearFavoritesBar.titleLabel.textAlignment = .left
        clearFavoritesBar.titleLabel.font = RobotoFont.light(with: 17.0)
        
        clearFavoritesButton = IconButton(image: UIImage(named: "ic_delete")?.withRenderingMode(.alwaysTemplate), tintColor: .black)
        clearFavoritesButton.heightPreset = .normal
        clearFavoritesButton.addTarget(self, action: #selector(clearFavorites), for: .touchUpInside)
        
        clearFavoritesBar.rightViews = [clearFavoritesButton]
        view.addSubview(clearFavoritesBar)
        
        //clearFiles
        
        clearFilesBar = Toolbar()
        clearFilesBar.heightPreset = .normal
        clearFilesBar.contentEdgeInsetsPreset = .square1
        
        clearFilesBar.title = Keys.clear_files
        clearFilesBar.titleLabel.textAlignment = .left
        clearFilesBar.titleLabel.font = RobotoFont.light(with: 17.0)
        
        clearFilesButton = IconButton(image: UIImage(named: "ic_delete")?.withRenderingMode(.alwaysTemplate), tintColor: .black)
        clearFilesButton.heightPreset = .normal
        clearFilesButton.addTarget(self, action: #selector(clearFiles), for: .touchUpInside)
        
        clearFilesBar.rightViews = [clearFilesButton]
        view.addSubview(clearFilesBar)
        
        //keepHistory
        
        keepHistoryBar = Toolbar()
        keepHistoryBar.heightPreset = .normal
        keepHistoryBar.contentEdgeInsetsPreset = .square1
        
        keepHistoryBar.title = Keys.keep_history
        keepHistoryBar.titleLabel.textAlignment = .left
        keepHistoryBar.titleLabel.font = RobotoFont.light(with: 17.0)
        
        var state: SwitchState = .off
        
        if UserDefaults.standard.bool(forKey: Keys.keepHistory) {
            state = .on
        }
        
        keepHistorySwitch = Switch(state: state, style: .dark, size: .medium)
        keepHistorySwitch.buttonOnColor = .black
        keepHistorySwitch.trackOnColor = Color.grey.base
        
        keepHistorySwitch.delegate = self
        
        keepHistoryBar.rightViews = [keepHistorySwitch]
        view.addSubview(keepHistoryBar)
        
        //feedback
        
        feedbackBar = Toolbar()
        feedbackBar.heightPreset = .normal
        feedbackBar.contentEdgeInsetsPreset = .square1
        
        feedbackBar.title = Keys.feedback
        feedbackBar.titleLabel.textAlignment = .left
        feedbackBar.titleLabel.font = RobotoFont.light(with: 17.0)
        
        
        feedbackButton = IconButton(image: UIImage(named: "ic_feedback")?.withRenderingMode(.alwaysTemplate), tintColor: .black)
        feedbackButton.heightPreset = .normal
        feedbackButton.addTarget(self, action: #selector(feedback), for: .touchUpInside)
        
        
        feedbackBar.rightViews = [feedbackButton]
        view.addSubview(feedbackBar)
        
        //share
        
        shareBar = Toolbar()
        shareBar.heightPreset = .normal
        shareBar.contentEdgeInsetsPreset = .square1
        
        shareBar.title = Keys.share
        shareBar.titleLabel.textAlignment = .left
        shareBar.titleLabel.font = RobotoFont.light(with: 17.0)
        
        
        shareButton = IconButton(image: Icon.share, tintColor: .black)
        shareButton.heightPreset = .normal
        shareButton.addTarget(self, action: #selector(share), for: .valueChanged)
        
        shareBar.rightViews = [shareButton]
        view.addSubview(shareBar)
        
        updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        removeAdsBar.snp.makeConstraints({(make) -> Void in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
        })
        
        clearFavoritesBar.snp.makeConstraints({(make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(removeAdsBar.snp.bottom).offset(4)
        })
        
        clearFilesBar.snp.makeConstraints({(make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(clearFavoritesBar.snp.bottom).offset(4)
        })
        
        keepHistoryBar.snp.makeConstraints({(make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(clearFilesBar.snp.bottom).offset(4)
        })
        
        feedbackBar.snp.makeConstraints({(make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(keepHistoryBar.snp.bottom).offset(4)
        })
        
        shareBar.snp.makeConstraints({(make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(feedbackBar.snp.bottom).offset(4)
        })
    }
}


extension SettingsRootController {
    
    fileprivate func removeAds(){
        
    }
    
    @objc
    fileprivate func clearFavorites(){
        
        let alert: UIAlertController = UIAlertController(title: Keys.clear_favorites, message: "Favorileriniz tamamen silinecektir. Emin misiniz?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Sil", style: .default, handler: {(action) -> Void in
            let graph = Graph()
            let search = Search<Entity>(graph: graph).for(types: Keys.Favorite)
            
            for e in search.sync() {
                e.delete()
            }
            
            graph.async({(complete, error) -> Void in
                
                if complete {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
                }
            })
            
        }))
        
        alert.addAction(UIAlertAction(title: "Vazgec", style: .destructive, handler: nil))
        
        show(alert, sender: nil)
        
        
        
    }
    
    @objc
    fileprivate func clearFiles(){
        let alert: UIAlertController = UIAlertController(title: Keys.clear_files, message: "Dosyalariniz tamamen silinecektir. Emin misiniz?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Sil", style: .default, handler: {(action) -> Void in
            
            let fileManager = FileManager.default
            let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
            
            do {
                let filePaths = try fileManager.contentsOfDirectory(at: documents, includingPropertiesForKeys: [], options: [.skipsHiddenFiles])
                
                for filePath in filePaths {
                    try fileManager.removeItem(at: filePath)
                }
            }catch let error {
                dump(error)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Vazgec", style: .destructive, handler: nil))
        
        show(alert, sender: nil)
        
        
        
    }
    
    @objc
    fileprivate func feedback(){
        UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/us/app/playtube-play-music-and-videos-from-youtube/id1207003930")!)
    }
    
    @objc
    fileprivate func share(){
        
        let objects = ["PlayTube", "http://playtube.com"]
        
        let activityController = UIActivityViewController(activityItems: objects, applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
}

extension SettingsRootController: SwitchDelegate {
    
    func switchDidChangeState(control: Switch, state: SwitchState) {
        
        UserDefaults.standard.set(state == .on ? true : false, forKey: Keys.keepHistory)
    }
    
}
