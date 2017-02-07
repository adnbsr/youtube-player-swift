//
//  SettingsController.swift
//  PlayTube
//
//  Created by Adnan Basar on 25/12/2016.
//  Copyright © 2016 Adnan Basar. All rights reserved.
//

import UIKit
import Foundation
import Material



class SettingsController: ToolbarController {
        
    override func prepare() {
        super.prepare()
        prepareTabBarItem()
        prepareToolbar()
    }
}

extension SettingsController {
    
    fileprivate func prepareToolbar(){
        
        statusBarStyle = .lightContent
        statusBar.backgroundColor = Color.lightBlue.darken4
        
        toolbar.title = Keys.settings
        toolbar.backgroundColor = Color.lightBlue.darken4
        toolbar.titleLabel.textColor = .white
        
    }

    fileprivate func prepareTabBarItem(){
        tabBarItem.image = Icon.settings?.tint(with: Color.blueGrey.base)
        tabBarItem.selectedImage = Icon.settings?.tint(with: Color.blue.base)
        tabBarItem.title = "Settings"
    }
}

class SettingsRootController: UIViewController{

    var clearFavoritesBar: Bar!
    var clearFavoritesLabel: UILabel!
    var clearFavoritesButton: IconButton!
    
    var clearFilesBar: Bar!
    var clearFilesLabel: UILabel!
    var clearFilesButton: IconButton!

    
    var keepHistoryBar: Bar!
    var keepHistoryLabel: UILabel!
    var keepHistorySwitch: Switch!
    
    //feedback
    var feedbackBar: Bar!
    var feedbackLabel: UILabel!
    var feedbackButton: IconButton!
  
    //share
    var shareBar: Bar!
    var shareLabel: UILabel!
    var shareButton: IconButton!
    
    //removeAds
    var removeAdsBar: Bar!
    var removeAdsLabel: UILabel!
    var removeAdsButton: IconButton!
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        prepareBars()
    }
    
    private func prepareBars(){
        
        //removeAds
        
        self.removeAdsBar = Bar()
        self.removeAdsBar.heightPreset = .normal
        self.removeAdsBar.contentEdgeInsetsPreset = .square1
        
        self.removeAdsLabel = UILabel()
        self.removeAdsLabel.text = "Reklamlari Kaldir"
        self.removeAdsLabel.font = RobotoFont.regular(with: 14.0)
        
        
        self.removeAdsButton = IconButton(image: UIImage(named: "ic_pan_tool")?.withRenderingMode(.alwaysTemplate), tintColor: .black)
        self.removeAdsButton.heightPreset = .normal
        
        self.removeAdsBar.leftViews = [self.removeAdsLabel]
        self.removeAdsBar.rightViews = [self.removeAdsButton]
        self.view.addSubview(self.removeAdsBar)
        
        //clearFavorites
        
        self.clearFavoritesBar = Bar()
        self.clearFavoritesBar.heightPreset = .normal
        self.clearFavoritesBar.contentEdgeInsetsPreset = .square1
        
        self.clearFavoritesLabel = UILabel()
        self.clearFavoritesLabel.text = "Favoriler Listesini Temizle"
        self.clearFavoritesLabel.font = RobotoFont.regular(with: 14.0)
        
        self.clearFavoritesButton = IconButton(image: UIImage(named: "ic_delete")?.withRenderingMode(.alwaysTemplate), tintColor: .black)
        self.clearFavoritesButton.heightPreset = .normal
        
        self.clearFavoritesBar.leftViews = [self.clearFavoritesLabel]
        self.clearFavoritesBar.rightViews = [self.clearFavoritesButton]
        self.view.addSubview(self.clearFavoritesBar)
        
        self.clearFilesBar = Bar()
        self.clearFilesBar.heightPreset = .normal
        self.clearFilesBar.contentEdgeInsetsPreset = .square1
        
        self.clearFilesLabel = UILabel()
        self.clearFilesLabel.text = "Dosyalari Sil!"
        self.clearFilesLabel.font = RobotoFont.regular(with: 14.0)
        
        
        self.clearFilesButton = IconButton(image: UIImage(named: "ic_delete")?.withRenderingMode(.alwaysTemplate), tintColor: .black)
        self.clearFilesButton.heightPreset = .normal
        
        self.clearFilesBar.leftViews = [self.clearFilesLabel]
        self.clearFilesBar.rightViews = [self.clearFilesButton]
        self.view.addSubview(self.clearFilesBar)
        
        self.keepHistoryBar = Bar()
        self.keepHistoryBar.heightPreset = .normal
        self.keepHistoryBar.contentEdgeInsetsPreset = .square1
        
        self.keepHistoryLabel = UILabel()
        self.keepHistoryLabel.text = "Arama Gecmisini Sakla?"
        self.keepHistoryLabel.font = RobotoFont.regular(with: 14.0)
        
        
        self.keepHistorySwitch = Switch(state: .on, style: .dark, size: .medium)
        self.keepHistorySwitch.buttonOnColor = .black
        self.keepHistorySwitch.trackOnColor = Color.grey.base
        
        self.keepHistoryBar.leftViews = [self.keepHistoryLabel]
        self.keepHistoryBar.rightViews = [self.keepHistorySwitch]
        self.view.addSubview(self.keepHistoryBar)
        
        self.feedbackBar = Bar()
        self.feedbackBar.heightPreset = .normal
        self.feedbackBar.contentEdgeInsetsPreset = .square1
        
        self.feedbackLabel = UILabel()
        self.feedbackLabel.text = "Yorum Yap"
        self.feedbackLabel.font = RobotoFont.regular(with: 14.0)
        
        
        self.feedbackButton = IconButton(image: UIImage(named: "ic_feedback")?.withRenderingMode(.alwaysTemplate), tintColor: .black)
        self.feedbackButton.heightPreset = .normal
        
        self.feedbackBar.leftViews = [self.feedbackLabel]
        self.feedbackBar.rightViews = [self.feedbackButton]
        self.view.addSubview(self.feedbackBar)
        
        //
        
        self.shareBar = Bar()
        self.shareBar.heightPreset = .normal
        self.shareBar.contentEdgeInsetsPreset = .square1
        
        self.shareLabel = UILabel()
        self.shareLabel.text = "Arkadaslarinla Paylas"
        self.shareLabel.font = RobotoFont.regular(with: 14.0)
        
        
        self.shareButton = IconButton(image: Icon.share, tintColor: .black)
        self.shareButton.heightPreset = .normal
        
        self.shareBar.leftViews = [self.shareLabel]
        self.shareBar.rightViews = [self.shareButton]
        self.view.addSubview(self.shareBar)
        
        updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        self.removeAdsBar.snp.makeConstraints({(make) -> Void in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
        })
        
        self.clearFavoritesBar.snp.makeConstraints({(make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(self.removeAdsBar.snp.bottom).offset(4)
        })
        
        self.clearFilesBar.snp.makeConstraints({(make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(self.clearFavoritesBar.snp.bottom).offset(4)
        })
        
        self.keepHistoryBar.snp.makeConstraints({(make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(self.clearFilesBar.snp.bottom).offset(4)
        })
        
        self.feedbackBar.snp.makeConstraints({(make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(self.keepHistoryBar.snp.bottom).offset(4)
        })
        
        self.shareBar.snp.makeConstraints({(make) -> Void in
            make.width.equalToSuperview()
            make.top.equalTo(self.feedbackBar.snp.bottom).offset(4)
        })
    }
}

