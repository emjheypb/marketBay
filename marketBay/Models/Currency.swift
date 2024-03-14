//
//  Currency.swift
//  marketBay
//
//  Created by Dayeeta Ganguly on 2024-03-13.
//

import Foundation
 
 struct Currency: Codable {
    var base_code          : String = ""
    var rates              : [String : Double] = [:]
}
