//
//  Item.swift
//  Robin's Recipeez
//
//  Created by Robert Adams on 5/6/26.
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
