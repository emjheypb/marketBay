//
//  UserListings.swift
//  marketBay
//
//  Created by EmJhey PB on 2/27/24.
//

import Foundation

struct MiniListing: Codable, Identifiable {
    var id: String
    var title: String
    var status: String
    var price: Double
    var image: String = ""
}
