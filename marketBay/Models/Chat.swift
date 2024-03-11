//
//  Chat.swift
//  marketBay
//
//  Created by EmJhey PB on 2/27/24.
//

import Foundation

struct Chat: Codable {
//    @DocumentID var id: String? = UUID().uuidString
    var userID: String // user ID
    var userName: String // user name
    var message: String
    var timestamp: String
}
