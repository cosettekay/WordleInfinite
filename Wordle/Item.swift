//
//  Item.swift
//  Wordle
//
//  Created by Cosette Tabucol on 4/25/25.
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
