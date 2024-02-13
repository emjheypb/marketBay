//
//  Listing.swift
//  marketBay
//
//  Created by Cheung K on 12/2/2024.
//

import Foundation

struct Listing: Codable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let price: Double
    let seller: User
    let email: String
    let phoneNumber: String
    
<<<<<<< HEAD
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
=======
    init(id: Int, title: String, description: String, price: Double, sellerID: Int) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.sellerID = sellerID
        
        DataAccess().savePosts(post: self)
    }
    
    // Function to retrieve seller's information
    func getSeller() -> User? {
        // Logic to fetch the user with the sellerID
        return nil // Placeholder for demo, replace with actual logic
    }
>>>>>>> 9399aa9 (F: menu navigation; E: models, menu login check, comments)
}
