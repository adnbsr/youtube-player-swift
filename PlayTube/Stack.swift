//
//  Stack.swift
//  PlayTube
//
//  Created by Adnan Basar on 12/02/2017.
//  Copyright © 2017 Adnan Basar. All rights reserved.
//

import Foundation

struct Stack<Element> {
    
    var items = [Element]()
    
    mutating func push(element: Element) {
        items.append(element)
    }
    
    mutating func pop() -> Element {
        return items.removeLast()
    }
    
}
