//
//  BottomNavigationController.swift
//  PlayTube
//
//  Created by Adnan Basar on 25/12/2016.
//  Copyright © 2016 Adnan Basar. All rights reserved.
//

import Foundation
import Material


class AppBottomNavigationController: BottomNavigationController{
    
    override func prepare() {
        super.prepare()
        prepareNavigationBar()
    }
}

extension AppBottomNavigationController{

    fileprivate func prepareNavigationBar(){
        tabBar.dividerColor = Color.gray
        tabBar.depthPreset = .none
    }
}
