//
//  Listing.swift
//  marketBay
//
//  Created by Cheung K on 12/2/2024.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore // Import FirebaseFirestore for GeoPoint

struct Listing: Codable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    let title: String
    let description: String
    let category: Category
    let price: Double
    var status: PostStatus
    var favoriteCount: Int // track the number of favorites
    let seller: MiniUser
    var image: String
    let condition: Condition // New property: condition
    let location: GeoPoint // New property: location

    // Initializer
    init(title: String, description: String, category: Category, price: Double, seller: MiniUser, status: PostStatus, favoriteCount: Int, condition: Condition, location: GeoPoint) {
        self.title = title
        self.description = description
        self.category = category
        self.price = price
        self.seller = seller
        self.status = status
        self.favoriteCount = 0
        self.image = ""
        self.condition = condition
        self.location = location
    }
    
    init(id: String, title: String, description: String, category: Category, price: Double, seller: MiniUser, status: PostStatus, favoriteCount: Int, image: String, condition: Condition, location: GeoPoint) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.price = price
        self.seller = seller
        self.status = status
        self.favoriteCount = 0
        self.image = image
        self.condition = condition
        self.location = location
    }
}

