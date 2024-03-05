//
//  PostManager.swift
//  POC_RESTAPI
//
//  Created by Luciano Uchoa on 05/03/24.
//

import Foundation
import Combine

import Foundation

class PersonService {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchPeople() -> AnyPublisher<[Person], Error> {
        guard let url = URL(string: "https://poc-restapi.onrender.com/item") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Person].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func addPerson(nome: String) -> AnyPublisher<Bool, Error> {
        guard let url = URL(string: "https://poc-restapi.onrender.com/item") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let newPerson = ["nome": nome]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: newPerson) else {
            return Fail(error: NSError(domain: "SerializationError", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        
        request.httpBody = jsonData
        
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return true
            }
            .eraseToAnyPublisher()
    }
    
    func deletePerson(id: String) -> AnyPublisher<Bool, Error> {
        guard let url = URL(string: "https://poc-restapi.onrender.com/item/\(id)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return true
            }
            .eraseToAnyPublisher()
    }
    
    func editPersonName(id: String, newName: String) -> AnyPublisher<Bool, Error> {
        guard let url = URL(string: "https://poc-restapi.onrender.com/item/\(id)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let updatedPerson = ["nome": newName]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: updatedPerson) else {
            return Fail(error: NSError(domain: "SerializationError", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }

        request.httpBody = jsonData

        return urlSession.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return true
            }
            .eraseToAnyPublisher()
    }
}


