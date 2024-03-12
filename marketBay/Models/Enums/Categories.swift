//
//  Categories.swift
//  marketBay
//
//  Created by Cheung K on 14/2/2024.
//

import Foundation

enum Category: String, CaseIterable, Codable {
    case all = "All"
    case auto = "Auto"
    case furniture = "Furniture"
    case electronics = "Electronics"
    case womensClothing = "Women's Clothing"
    case mensClothing = "Men's Clothing"
    case toys = "Toys"
    case homeAndGarden = "Home & Garden"
    
    var systemImageName: String {
           switch self {
               case .all: return "all.fill"
               case .auto: return "car.fill"
               case .furniture: return "house.fill"
               case .electronics: return "bolt.fill"
               case .womensClothing: return "personw.fill"
               case .mensClothing: return "personm.fill"
               case .toys: return "game.fill"
               case .homeAndGarden: return "leaf.fill"
           }
       }
    
    var imageURL: URL? {
            let storageURLString = "https://firebasestorage.googleapis.com/v0/b/marketbay-46fde.appspot.com/o"
            let path = "General/\(self.systemImageName).png"
            let escapedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
            let token = "a43955cc-7b69-40d7-94a0-95855f096ecd" // Replace with your Firebase storage token
            let urlString = "\(storageURLString)/\(escapedPath)?alt=media&token=\(token)"
            return URL(string: urlString)
        }
}
