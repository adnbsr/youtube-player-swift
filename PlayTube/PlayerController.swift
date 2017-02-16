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

class PlayerController: ToolbarController {
    
    override func prepare() {
        super.prepare()
        
        prepareTabBarItem()
        prepareStatusBar()
        prepareToolbar()
    }
    
}

extension PlayerController {

    fileprivate func prepareTabBarItem(){
        tabBarItem.image = Icon.cm.movie?.tint(with: Color.blueGrey.base)
        tabBarItem.selectedImage = Icon.cm.movie?.tint(with: Color.blue.base)
        tabBarItem.title = Keys.player
    }
    
    
    fileprivate func prepareStatusBar(){
        statusBarStyle = .lightContent
        statusBar.backgroundColor = Color.lightBlue.darken4
    }
    
    fileprivate func prepareToolbar(){
        
        toolbar.title = Keys.player
        toolbar.titleLabel.textAlignment = .center
        toolbar.backgroundColor = Color.lightBlue.darken4
        toolbar.titleLabel.textColor = .white
        toolbar.detailLabel.textColor = .white
    }
    
}
