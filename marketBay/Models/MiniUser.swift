//
//  MiniUser.swift
//  marketBay
//
//  Created by EmJhey PB on 2/27/24.
//

import Foundation
import FirebaseFirestoreSwift

struct MiniUser: Codable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var email: String
    var phoneNumber: String
}
