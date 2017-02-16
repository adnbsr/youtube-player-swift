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
import Graph

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
        tabBarItem.title = Keys.settings
    }
}


