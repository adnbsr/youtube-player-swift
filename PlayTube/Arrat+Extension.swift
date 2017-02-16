//
//  Arrat+Extension.swift
//  PlayTube
//
//  Created by Adnan Basar on 13/02/2017.
//  Copyright © 2017 Adnan Basar. All rights reserved.
//

import Foundation

extension Array {

    func find(includedElement: (Element) -> Bool) -> Int? {
        for (idx, element) in self.enumerated() {
            if includedElement(element) {
                return idx
            }
        }
        return nil
    }
}
