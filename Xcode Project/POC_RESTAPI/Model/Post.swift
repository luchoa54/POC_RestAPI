//
//  Post.swift
//  POC_RESTAPI
//
//  Created by Luciano Uchoa on 05/03/24.
//

import Foundation

struct Person: Identifiable, Decodable {
    let id: String
    let nome: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case nome
    }
}
