//
//  Condition.swift
//  marketBay
//
//  Created by Cheung K on 13/3/2024.
//

import Foundation

// Enum for listing condition
enum Condition: String, CaseIterable, Codable {
    case preOwned = "Pre-Owned"
    case good = "Good"
    case veryGood = "V. Good"
    case brandNew = "Brand New"
}
