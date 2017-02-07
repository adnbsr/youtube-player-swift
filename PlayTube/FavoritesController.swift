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

class FavoritesRootController: UIViewController {
    
    var graph: Graph!
    var search: Search<Entity>!
    
    var data: [Entity] {
        return search.sync()
    }
    
    var tableview: FavoriteTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.lightBlue.base
        
        prepareGraph()
        prepareSearch()
        prepareTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadData()
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        reloadData()
    }
}

extension FavoritesRootController {

    fileprivate func prepareGraph(){
        graph = Graph()
    }
    
    fileprivate func prepareSearch(){
        search = Search<Entity>(graph: graph).for(types: "Favorite")
    }
    
    fileprivate func prepareTableView(){
        tableview = FavoriteTableView()
        view.layout(tableview).edges()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    @objc
    fileprivate func reloadData(){
        tableview.data = data
        toolbarController?.toolbar.detail = "\(data.count) videos"
    }
    
}
