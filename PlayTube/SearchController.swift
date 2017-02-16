//
//  ViewController.swift
//  PlayTube
//
//  Created by Adnan Basar on 24/12/2016.
//  Copyright © 2016 Adnan Basar. All rights reserved.
//

import UIKit
import SnapKit
import Material
import Alamofire
import SDWebImage
import FileBrowser
import XCDYouTubeKit
import Graph

class SearchController: SearchBarController {
    
    override func prepare() {
        super.prepare()
        
        statusBarStyle = .lightContent
        statusBar.backgroundColor = Color.lightBlue.darken4
        searchBar.placeholder = "Ara"
        searchBar.placeholderColor = .white
        searchBar.textColor = .white
        searchBar.backgroundColor = Color.lightBlue.darken4
        searchBar.clearButton.image = Icon.cm.search
        searchBar.clearButton.tintColor = .white
        searchBar.textField.delegate = self
        searchBar.textField.rightViewMode = .always
        searchBar.textField.returnKeyType = .search
        searchBar.isClearButtonAutoHandleEnabled = false
        searchBar.clearButton.addTarget(self, action: #selector(handleClearButton), for: .touchUpInside)
    }
}

extension SearchController: UITextFieldDelegate {

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let c = rootViewController as? SearchRootController {
            c.submittedText = textField.text!
            
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        searchBar.clearButton.image = Icon.cm.clear
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchBar.clearButton.image = Icon.cm.search
    }
    
    @objc
    fileprivate func handleClearButton() {
        guard nil == searchBar.textField.delegate?.textFieldShouldClear || true == searchBar.textField.delegate?.textFieldShouldClear?(searchBar.textField) else {
            return
        }
        
        searchBar.textField.becomeFirstResponder()
        let t = searchBar.textField.text
        
        searchBar.delegate?.searchBar?(searchBar: searchBar, willClear: searchBar.textField, with: t)
        
        searchBar.textField.text = nil
        
        searchBar.delegate?.searchBar?(searchBar: searchBar, didClear: searchBar.textField, with: t)
    }
    
}
