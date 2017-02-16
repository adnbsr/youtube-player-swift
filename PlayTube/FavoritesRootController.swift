//
//  FavoritesRootController.swift
//  PlayTube
//
//  Created by Adnan Basar on 12/02/2017.
//  Copyright © 2017 Adnan Basar. All rights reserved.
//

import Foundation
import UIKit
import Graph
import Material

class FavoritesRootController: UIViewController {
    
    var graph: Graph!
    var search: Search<Entity>!
    
    var data: [Entity] {
        return search.sync()
    }
    
    var tableview: TableView!
    var playAllButton: IconButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.lightBlue.base
        
        prepareGraph()
        prepareSearch()
        prepareTableView()
        preparePlayAllButton()
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
        tableview = TableView(frame: view.bounds)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(FavoriteCell.self, forCellReuseIdentifier: Keys.cell)
        view.addSubview(tableview)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    fileprivate func preparePlayAllButton(){
        playAllButton = IconButton(image: Icon.cm.play, tintColor: .white)
        playAllButton.addTarget(self, action: #selector(playAll), for: .touchUpInside)
        toolbarController?.toolbar.rightViews = [playAllButton]
    }
    
    @objc
    fileprivate func reloadData(){
        tableview.reloadData()
        toolbarController?.toolbar.detail = "\(data.count) videos"
        graph.sync()
    }
    
    @objc
    fileprivate func playAll(){
        for entity in data {
            PlayerRootController.sharedInstance.playerQueueState.enqueue = entity.convertToVideoResource()!
        }
    }
    
}


extension FavoritesRootController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PlayerRootController.sharedInstance.playerQueueState.now = data[indexPath.row].convertToVideoResource()
    }
}

extension FavoritesRootController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.cell, for: indexPath) as! FavoriteCell
        cell.data = data[indexPath.row]
        return cell
    }
}
