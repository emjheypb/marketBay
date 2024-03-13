//
//  UserListings.swift
//  marketBay
//
//  Created by EmJhey PB on 2/27/24.
//

import Foundation
import FirebaseFirestoreSwift

struct MiniListing: Codable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    var title: String
    var status: String
    var price: Double
    var image: String
    
    init(id: String? = nil, title: String, status: String, price: Double) {
        self.id = id
        self.title = title
        self.status = status
        self.price = price
        self.image = ""
    }
    
    init(title: String, status: String, price: Double, image: String) {
        self.title = title
        self.status = status
        self.price = price
        self.image = image
    }
}
