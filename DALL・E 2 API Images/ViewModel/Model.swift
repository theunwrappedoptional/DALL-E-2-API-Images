//
//  Model.swift
//  DALL・E 2 API Images
//
//  Created by Manhattan on 12/01/23.
//

import Foundation

struct DataResponse: Codable {
    let url: String
}

struct ModelResponse: Codable {
    let data: [DataResponse]
}
