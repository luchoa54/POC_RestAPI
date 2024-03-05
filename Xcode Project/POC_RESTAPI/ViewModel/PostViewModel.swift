//
//  PostViewModel.swift
//  POC_RESTAPI
//
//  Created by Luciano Uchoa on 05/03/24.
//

import Foundation
import Combine

class PersonViewModel: ObservableObject {
    
    @Published var people: [Person] = []
    @Published var isLoading: Bool = false
    @Published var isAdding: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    private var service = PersonService()

    func fetchPeople() {
        isLoading = true
        service.fetchPeople()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                self.isLoading = false
            }) { result in
                self.isLoading = false
                self.people = result
            }
            .store(in: &cancellables)
    }

    func addPerson(nome: String) {
        isAdding = true
        service.addPerson(nome: nome)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { success in
                if success {
                    self.isAdding = false
                    self.fetchPeople()
                } else {
                    self.isAdding = false
                    print("Erro ao adicionar pessoa.")
                }
            }
            .store(in: &cancellables)
    }

    func deletePerson(person: Person) {
        service.deletePerson(id: person.id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { success in
                if success {
                    self.fetchPeople()
                } else {
                    print("Erro ao excluir pessoa.")
                }
            }
            .store(in: &cancellables)
    }
    
    func editPersonName(person: Person, newName: String) {
        service.editPersonName(id: person.id, newName: newName)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { success in
                if success {
                    self.fetchPeople()
                } else {
                    print("Erro ao editar nome da pessoa.")
                }
            }
            .store(in: &cancellables)
    }

}
