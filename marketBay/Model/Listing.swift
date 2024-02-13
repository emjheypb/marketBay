//
//  Listing.swift
//  marketBay
//
//  Created by Cheung K on 12/2/2024.
//

import Foundation

struct Listing {
    let id: Int
    let title: String
    let description: String
    let category: String
    let price: Double
    let seller: User
    let email: String
    let phoneNumber: String
    
    // Initializer
    init(id: Int, title: String, description: String, category: String, price: Double, seller: User, email: String, phoneNumber: String) {
            self.id = id
            self.title = title
            self.description = description
            self.category = category
            self.price = price
            self.seller = seller
            self.email = email
            self.phoneNumber = phoneNumber
       }
}
