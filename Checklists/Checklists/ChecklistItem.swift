//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Zhaofei Yin on 07.11.17.
//  Copyright © 2017 Zhaofei Yin. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
    var text = ""
    var chcked = false
    
    func toggleCheckmark() {
        chcked = !chcked
    }
}
