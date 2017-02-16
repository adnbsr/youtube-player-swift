//
//  FavoritesController.swift
//  PlayTube
//
//  Created by Adnan Basar on 25/12/2016.
//  Copyright © 2016 Adnan Basar. All rights reserved.
//

import Foundation
import UIKit
import Material
import Graph

class FavoritesController: ToolbarController {
    
    override func prepare() {
        super.prepare()
        prepareTabBarItem()
        prepareStatusBar()
        prepareToolbar()
    }
}

extension FavoritesController {
    
    fileprivate func prepareTabBarItem(){
        tabBarItem.image = Icon.favorite?.tint(with: Color.blueGrey.base)
        tabBarItem.selectedImage = Icon.favorite?.tint(with: Color.blue.base)
        tabBarItem.title = Keys.favorites
    }
    
    fileprivate func prepareStatusBar(){
        statusBarStyle = .lightContent
        statusBar.backgroundColor = Color.lightBlue.darken4
    }
    
    fileprivate func prepareToolbar(){
        toolbar.title = Keys.favorites
        toolbar.titleLabel.textColor = .white
        toolbar.backgroundColor = Color.lightBlue.darken4
        toolbar.detailLabel.textColor = .white
        toolbar.depthPreset = .none
    }
}

