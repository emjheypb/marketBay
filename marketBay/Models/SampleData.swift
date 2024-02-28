//
//  SampleData.swift
//  marketBay
//
//  Created by Cheung K on 14/2/2024.
//

import Foundation

struct SampleData {
    static func generateSampleListings() -> [Listing] {
        // Define sample users
        
        let user1 = User(id: 1, name: "MJ", email: "mj@example.com", password: "password", phoneNumber: "123-456-7890")
        let user2 = User(id: 2, name: "Gordon", email: "gck@example.com", password: "password", phoneNumber: "987-654-3210")
        let user3 = User(id: 3, name: "Dayeeta", email: "day@example.com", password: "password", phoneNumber: "987-654-3210")
        // Define sample listings
        let sampleListings: [Listing] = [
            Listing(id: 1, title: "Sample Listing 1", description: "This is a sample listing description.", category: .electronics, price: 99.99, seller: user1, email: user1.email, phoneNumber: user1.phoneNumber, status: .available, favoriteCount: 0),
            Listing(id: 2, title: "Sample Listing 2", description: "Another sample listing description.", category: .homeAndGarden, price: 49.99, seller: user1, email: user1.email, phoneNumber: user1.phoneNumber, status: .available, favoriteCount: 0),
            Listing(id: 3, title: "Sample Listing 3", description: "Yet another sample listing description.", category: .mensClothing, price: 29.99, seller: user1, email: user1.email, phoneNumber: user1.phoneNumber, status: .offTheMarket, favoriteCount: 0),
            Listing(id: 4, title: "Sample Listing 4", description: "More sample listing description.", category: .toys, price: 19.99, seller: user1, email: user1.email, phoneNumber: user1.phoneNumber, status: .offTheMarket, favoriteCount: 0),
            Listing(id: 5, title: "Sample Listing 5", description: "Another description for a sample listing.", category: .electronics, price: 149.99, seller: user2, email: user2.email, phoneNumber: user2.phoneNumber, status: .available, favoriteCount: 0),
            Listing(id: 6, title: "Sample Listing 6", description: "Another description for a sample listing.", category: .furniture, price: 199.99, seller: user2, email: user2.email, phoneNumber: user2.phoneNumber, status: .available, favoriteCount: 0),
            Listing(id: 7, title: "Sample Listing 7", description: "Another description for a sample listing.", category: .homeAndGarden, price: 79.99, seller: user2, email: user2.email, phoneNumber: user2.phoneNumber, status: .available, favoriteCount: 0),
            Listing(id: 8, title: "Sample Listing 8", description: "Another description for a sample listing.", category: .electronics, price: 249.99, seller: user2, email: user2.email, phoneNumber: user2.phoneNumber, status: .available, favoriteCount: 0),
            Listing(id: 9, title: "Sample Listing 9", description: "Another description for a sample listing.", category: .toys, price: 9.99, seller: user3, email: user3.email, phoneNumber: user3.phoneNumber, status: .offTheMarket, favoriteCount: 0),
            Listing(id: 10, title: "Sample Listing 10", description: "Another description for a sample listing.", category: .womensClothing, price: 39.99, seller: user3, email: user3.email, phoneNumber: user3.phoneNumber, status: .offTheMarket, favoriteCount: 0)
        ]
        
        return sampleListings
    }
}
