//
//  Collection.swift
//  marketBay
//
//  Created by Cheung K on 15/2/2024.
//

import Foundation

struct Collection: Codable, Identifiable {
    var id: UUID = UUID() // Unique identifier for each collection
    var name: String
    var listings: [MiniListing] = [] // Listings in this collection
    let ownerID: String  // ID of the user who owns or created the collection
}
