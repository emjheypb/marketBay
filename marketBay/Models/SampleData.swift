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
        
        let user1 = User(id: "", name: "MJ", phoneNumber: "123-456-7890")
        let user2 = User(id: "", name: "Gordon", phoneNumber: "987-654-3210")
        let user3 = User(id: "", name: "Dayeeta", phoneNumber: "987-654-3210")
        // Define sample listings
        let sampleListings: [Listing] = [
            Listing(title: "Sample Listing 1", description: "This is a sample listing description.", category: .electronics, price: 99.99, seller: MiniUser(name:user1.name, email:user1.id!, phoneNumber:user1.phoneNumber), status: .available, favoriteCount: 0),
            Listing(title: "Sample Listing 2", description: "Another sample listing description.", category: .homeAndGarden, price: 49.99, seller: MiniUser(name:user1.name, email:user1.id!, phoneNumber:user1.phoneNumber), status: .available, favoriteCount: 0),
            Listing(title: "Sample Listing 3", description: "Yet another sample listing description.", category: .mensClothing, price: 29.99, seller: MiniUser(name:user1.name, email:user1.id!, phoneNumber:user1.phoneNumber), status: .offTheMarket, favoriteCount: 0),
            Listing(title: "Sample Listing 4", description: "More sample listing description.", category: .toys, price: 19.99, seller: MiniUser(name:user1.name, email:user1.id!, phoneNumber:user1.phoneNumber), status: .offTheMarket, favoriteCount: 0),
            Listing(title: "Sample Listing 5", description: "Another description for a sample listing.", category: .electronics, price: 149.99, seller: MiniUser(name:user2.name, email:user2.id!, phoneNumber:user2.phoneNumber), status: .available, favoriteCount: 0),
            Listing(title: "Sample Listing 6", description: "Another description for a sample listing.", category: .furniture, price: 199.99, seller: MiniUser(name:user2.name, email:user2.id!, phoneNumber:user2.phoneNumber), status: .available, favoriteCount: 0),
            Listing(title: "Sample Listing 7", description: "Another description for a sample listing.", category: .homeAndGarden, price: 79.99, seller: MiniUser(name:user2.name, email:user2.id!, phoneNumber:user2.phoneNumber), status: .available, favoriteCount: 0),
            Listing(title: "Sample Listing 8", description: "Another description for a sample listing.", category: .electronics, price: 249.99, seller: MiniUser(name:user2.name, email:user2.id!, phoneNumber:user2.phoneNumber), status: .available, favoriteCount: 0),
            Listing(title: "Sample Listing 9", description: "Another description for a sample listing.", category: .toys, price: 9.99, seller: MiniUser(name:user3.name, email:user3.id!, phoneNumber:user3.phoneNumber), status: .offTheMarket, favoriteCount: 0),
            Listing(title: "Sample Listing 10", description: "Another description for a sample listing.", category: .womensClothing, price: 39.99, seller: MiniUser(name:user3.name, email:user3.id!, phoneNumber:user3.phoneNumber), status: .offTheMarket, favoriteCount: 0)
        ]
        
        return sampleListings
    }
}
