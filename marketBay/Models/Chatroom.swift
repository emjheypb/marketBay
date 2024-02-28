//
//  Chatroom.swift
//  marketBay
//
//  Created by EmJhey PB on 2/27/24.
//

import Foundation

struct Chatroom: Codable {
//    @DocumentID var id: String? = UUID().uuidString
    var title: String
    var status: String
    var lastMessage: String
    var timestamp: String
    var seller: String // user ID
    var customer: String // userID
    var listing: MiniListing
}
