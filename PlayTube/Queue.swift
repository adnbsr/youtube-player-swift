//
//  Queue.swift
//  PlayTube
//
//  Created by Adnan Basar on 12/02/2017.
//  Copyright © 2017 Adnan Basar. All rights reserved.
//

import Foundation

// 1
public struct Queue<T> {
    
    // 2
    //fileprivate var list = LinkedList<T>()
    fileprivate var list = LinkedList<T>()
    
    public var size: Int {
        return list.count
    }
    
    public func getList() -> LinkedList<T>{
        return self.list
    }
    
    public var isEmpty: Bool {
        return list.isEmpty
    }
    
    // 3
    public mutating func enqueue(_ element: T) {
        list.append(element)
    }
    
    // 4
    public mutating func dequeue() -> T? {
        guard !list.isEmpty, let element = list.first else { return nil }
        
        list.remove(node: element)
        
        return element.value
    }
    
    // 5
    public func peek() -> T? {
        return list.first?.value
    }
}

