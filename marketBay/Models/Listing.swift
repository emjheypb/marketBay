//
//  Listing.swift
//  marketBay
//
//  Created by Cheung K on 12/2/2024.
//

import Foundation

struct Listing: Codable, Identifiable {
    var id: Int
    let title: String
    let description: String
    let category: Category
    let price: Double
    var status: PostStatus
    var favoriteCount: Int // track the number of favorites
    let seller: User // TODO: CHANGE TO MiniUser - MiniUser.swift

    
    // Initializer
    init(id: Int, title: String, description: String, category: Category, price: Double, seller: User, email: String, phoneNumber: String, status: PostStatus, favoriteCount: Int) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.price = price
        self.seller = seller
        self.status = status
        self.favoriteCount = 0
    }
}
