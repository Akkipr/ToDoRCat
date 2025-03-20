//
//  Item.swift
//  ToDoRCat
//
//  Created by Akshayan on 2025-03-20.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
