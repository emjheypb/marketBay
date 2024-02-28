//
//  UserListings.swift
//  marketBay
//
//  Created by EmJhey PB on 2/27/24.
//

import Foundation

struct MiniListing: Codable {
//    @DocumentID var id: String? = UUID().uuidString
    var title: String
    var status: String
    var price: Double
    var image: String
}
