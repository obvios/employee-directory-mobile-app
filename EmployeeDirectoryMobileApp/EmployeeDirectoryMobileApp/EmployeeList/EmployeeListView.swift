//
//  EmployeeListView.swift
//  EmployeeDirectoryMobileApp
//
//  Created by Eric Palma on 2/21/24.
//

import SwiftUI
import EmployeeDirectoryCore

struct EmployeeListView: View {
    let useCase: FetchEmployeeListUseCase
    @State var employees: [Employee] = []
    
    var body: some View {
        List(employees) { employee in
            Text(employee.firstName + " " + employee.lastName)
        }
        .task {
            guard let employeesResult = try? await useCase.execute() else { return }
            employees = employeesResult
        }
    }
}
