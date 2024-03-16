//
//  EmployeeListView.swift
//  EmployeeDirectoryMobileApp
//
//  Created by Eric Palma on 2/21/24.
//

import SwiftUI
import EmployeeDirectoryCore

struct EmployeeListView: View {
    private let repository: EmployeesRepository
    private let useCase: FetchEmployeeListUseCase
    @State private var employees: [Employee] = []
    @State private var searchTerm: String = ""
    
    init(repository: EmployeesRepository) {
        self.repository = repository
        useCase = FetchEmployeeListUseCase(repository: repository)
    }
    
    var body: some View {
        NavigationStack {
            List(employees) { employee in
                NavigationLink(employee.firstName + " " + employee.lastName, value: employee.id)
            }
            .searchable(text: $searchTerm)
            .task {
                await search()
            }
            .navigationDestination(for: Employee.Identifier.self) { id in
                EmployeeDetailsView(repository: repository, employeeID: id)
            }
            .onAppear {
                Task {
                    guard let employeesResult = try? await useCase.execute() else { return }
                    employees = employeesResult
                }
            }
        }
    }
    
    /// Performs a search using the search term.
    private func search() async {
        guard let employeesResult = try? await useCase.execute(searchTerm: searchTerm) else { return }
        employees = employeesResult
    }
}
