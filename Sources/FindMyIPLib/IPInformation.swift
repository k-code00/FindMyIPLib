//
//  IPInformation.swift
//
//
//  Created by Kojo on 22/11/2023.
//

import Foundation

//ip model
struct IPInformation: Decodable {
    var ip: String
    var version: String
    var city: String
    var region: String
}
