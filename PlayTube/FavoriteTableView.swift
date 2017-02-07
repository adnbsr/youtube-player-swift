//
//  FavoriteTableView.swift
//  PlayTube
//
//  Created by Adnan Basar on 19/01/2017.
//  Copyright © 2017 Adnan Basar. All rights reserved.
//

import Foundation
import UIKit
import Graph


class FavoriteTableView: UITableView {

    var data = [Entity]() {
        
        didSet{
            reloadData()
        }
    }
    
    init() {
        super.init(frame: .zero, style: .plain)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare() {
        delegate = self
        dataSource = self
        
        register(FavoriteCell.self, forCellReuseIdentifier: "cell")
    }
    
}

extension FavoriteTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
}

extension FavoriteTableView: UITableViewDataSource {
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FavoriteCell
        cell?.data = self.data[indexPath.row]
        
        return cell!
    }
    
}
