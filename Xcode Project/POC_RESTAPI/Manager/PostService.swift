//
//  PostManager.swift
//  POC_RESTAPI
//
//  Created by Luciano Uchoa on 05/03/24.
//

import Foundation
import Alamofire
import Combine

class PersonService {
    
    func fetchPeople() -> AnyPublisher<[Person], Error> {
        let url = "https://poc-restapi.onrender.com/item"
        
        return AF.request(url)
            .publishDecodable(type: [Person].self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func addPerson(nome: String) -> AnyPublisher<Bool, Error> {
        let url = "https://poc-restapi.onrender.com/item"
        
        let parameters = ["nome": nome]
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .publishData()
            .tryMap { response in
                return true
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func deletePerson(id: String) -> AnyPublisher<Bool, Error> {
        let url = "https://poc-restapi.onrender.com/item/\(id)"
        
        return AF.request(url, method: .delete)
            .validate(statusCode: 200..<300)
            .publishData()
            .tryMap { response in
                return true
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func editPersonName(id: String, newName: String) -> AnyPublisher<Bool, Error> {
        let url = "https://poc-restapi.onrender.com/item/\(id)"
        
        let parameters = ["nome": newName]
        
        return AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .publishData()
            .tryMap { response in
                return true
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
