//
//  Listing.swift
//  marketBay
//
//  Created by Cheung K on 12/2/2024.
//

import Foundation
import FirebaseFirestoreSwift

struct Listing: Codable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    let title: String
    let description: String
    let category: Category
    let price: Double
    var status: PostStatus
    var favoriteCount: Int // track the number of favorites
    let seller: MiniUser

    
    // Initializer
    init(title: String, description: String, category: Category, price: Double, seller: MiniUser, status: PostStatus, favoriteCount: Int) {
        self.title = title
        self.description = description
        self.category = category
        self.price = price
        self.seller = seller
        self.status = status
        self.favoriteCount = 0
    }
}
