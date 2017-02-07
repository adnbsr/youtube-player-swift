//
//  ListController.swift
//  PlayTube
//
//  Created by Adnan Basar on 25/12/2016.
//  Copyright © 2016 Adnan Basar. All rights reserved.
//

import Foundation
import UIKit
import Material


class ListController: UIViewController{
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        prepareTabBarItem()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.lightBlue.base
    }
    
}

extension ListController {
    fileprivate func prepareTabBarItem(){
        tabBarItem.image = Icon.cm.audioLibrary?.tint(with: Color.blueGrey.base)
        tabBarItem.selectedImage = Icon.cm.audioLibrary?.tint(with: Color.blue.base)
        tabBarItem.title = "Listeler"
    }
}
