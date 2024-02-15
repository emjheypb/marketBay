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
    let seller: User
    let email: String
    let phoneNumber: String
    let status: PostStatus
    
    // Initializer
    init(id: Int, title: String, description: String, category: Category, price: Double, seller: User, email: String, phoneNumber: String, status: PostStatus) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.price = price
        self.seller = seller
        self.email = email
        self.phoneNumber = phoneNumber
        self.status = status
    }
}
