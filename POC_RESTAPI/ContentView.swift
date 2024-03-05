//
//  ContentView.swift
//  POC_RESTAPI
//
//  Created by Luciano Uchoa on 05/03/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PersonViewModel()
    @State private var newPersonName = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Nome da Pessoa", text: $newPersonName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(8)
                    .overlay(
                        viewModel.isAdding
                        ? ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(8)
                            .background(Color.blue.cornerRadius(8))
                        : nil
                    )
                
                Button("Adicionar Pessoa") {
                    viewModel.addPerson(nome: newPersonName)
                    newPersonName = ""
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                .padding(.bottom, 20)
                
                if viewModel.people.isEmpty {
                    if viewModel.isLoading {
                        ProgressView("Carregando...")
                    } else {
                        Spacer()
                        Text("Nenhuma pessoa encontrada.")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(viewModel.people) { person in
                            NavigationLink(destination: EditPersonView(person: person, editPersonName: viewModel.editPersonName)) {
                                HStack {
                                    Text(person.nome)
                                    Spacer()
                                }
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    viewModel.deletePerson(person: person)
                                } label: {
                                    Label("Excluir", systemImage: "trash")
                                }
                            }
                        }
                        .onDelete(perform: { indexSet in
                            // Handle deletion if needed
                        })
                    }.clipShape(RoundedRectangle(cornerRadius: 10))
                    
                }
            }
            .padding()
            .background(Color.white)
            .navigationBarTitle("Pessoas")
        }.onAppear {
            viewModel.fetchPeople()
        }
        .refreshable {
            viewModel.fetchPeople()
        }
    }
}

struct EditPersonView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var newName: String
    
    let person: Person
    let editPersonName: (Person, String) -> Void
    
    init(person: Person, editPersonName: @escaping (Person, String) -> Void) {
        self.person = person
        self._newName = State(initialValue: person.nome)
        self.editPersonName = editPersonName
    }
    
    var body: some View {
        VStack {
            TextField("Novo Nome", text: $newName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(8)
            
            Button("Salvar") {
                editPersonName(person, newName)
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
        }
        .padding()
        .navigationBarTitle("Editar Pessoa")
    }
}


#Preview {
    ContentView()
}
