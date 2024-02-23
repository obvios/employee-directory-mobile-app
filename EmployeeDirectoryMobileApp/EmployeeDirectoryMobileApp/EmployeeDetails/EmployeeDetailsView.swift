//
//  EmployeeDetailsView.swift
//  EmployeeDirectoryMobileApp
//
//  Created by Eric Palma on 2/22/24.
//

import SwiftUI
import EmployeeDirectoryCore

struct EmployeeDetailsView: View {
    private let repository: EmployeesRepository
    private let useCase: FetchEmployeeDetailsUseCase
    private let employeeID: Employee.Identifier
    @State private var employee: Employee?
    
    init(repository: EmployeesRepository, employeeID: Employee.Identifier) {
        self.repository = repository
        self.useCase = FetchEmployeeDetailsUseCase(repository: repository)
        self.employeeID = employeeID
    }
    
    var body: some View {
        VStack {
            // TODO: Improve
            Text(employee?.firstName ?? "")
            Text(employee?.lastName ?? "")
        }
        .task {
            guard let employeeResult = try? await useCase.execute(employeeId: employeeID) else {
                return
            }
            employee = employeeResult
        }
    }
}
