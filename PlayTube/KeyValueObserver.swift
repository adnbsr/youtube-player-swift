//
//  KeyValueObserver.swift
//  PlayTube
//
//  Created by Adnan Basar on 12/02/2017.
//  Copyright © 2017 Adnan Basar. All rights reserved.
//

import Foundation

class KeyValueObserver: NSObject {
    typealias KeyValueObservingCallback = (_ change: [NSKeyValueChangeKey : Any]) -> Void
    
    private let object: NSObject
    private let keyPath: String
    private let callback: KeyValueObservingCallback
    private var kvoContext = 0
    
    init(object: NSObject, keyPath: String, options: NSKeyValueObservingOptions, callback: @escaping KeyValueObservingCallback) {
        self.object = object
        self.keyPath = keyPath
        self.callback = callback
        super.init()
        object.addObserver(self, forKeyPath: keyPath, options: options, context: &kvoContext)
    }
    
    deinit {
        object.removeObserver(self, forKeyPath: keyPath, context: &kvoContext)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if context == &kvoContext {
            self.callback(change!)
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
        
    }
    
    
//    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutableRawPointer) {
//        if context == &kvoContext {
//            self.callback(change)
//        }
//        else {
//            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
//        }
//    }
}
