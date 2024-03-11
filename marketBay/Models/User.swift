//
//  User.swift
//  marketBay
//
//  Created by Cheung K on 12/2/2024.
//

import Foundation
import FirebaseFirestoreSwift

struct User : Codable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String = ""
    var phoneNumber: String = ""
    var listings: [MiniListing] = []
    var favorites: [MiniListing] = []
    var collections: [Collection] = []
    var chatRooms: [String:Bool] = [:]
    
    
    init(id: String, name: String, phoneNumber: String) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.listings = []
        self.favorites = []
        self.collections = []
        self.chatRooms = [:]
    }
}
