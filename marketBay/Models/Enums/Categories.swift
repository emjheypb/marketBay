//
//  Categories.swift
//  marketBay
//
//  Created by Cheung K on 14/2/2024.
//

import Foundation

enum Category: String, CaseIterable, Codable {
    case all = "All"
    case auto = "Auto"
    case furniture = "Furniture"
    case electronics = "Electronics"
    case womensClothing = "Women's Clothing"
    case mensClothing = "Men's Clothing"
    case toys = "Toys"
    case homeAndGarden = "Home & Garden"
}
