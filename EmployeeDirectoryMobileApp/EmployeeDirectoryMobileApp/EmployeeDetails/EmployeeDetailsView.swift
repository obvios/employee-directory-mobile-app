//
//  EmployeeDetailsView.swift
//  EmployeeDirectoryMobileApp
//
//  Created by Eric Palma on 2/22/24.
//

import SwiftUI
import EmployeeDirectoryCore

struct EmployeeDetailsView: View {
    @StateObject private var viewModel: EmployeeDetailsViewModel
    
    init(repository: EmployeesRepository, employeeID: Employee.Identifier) {
        let fetchUseCase = FetchEmployeeDetailsUseCase(repository: repository)
        let editUseCase = UpdateEmployeeInformationUseCase(repository: repository)
        _viewModel = StateObject(wrappedValue: EmployeeDetailsViewModel(fetchUseCase: fetchUseCase, editUseCase: editUseCase, employeeID: employeeID))
    }
    
    var body: some View {
        VStack {
            if viewModel.isEditing {
                TextField("First Name", text: $viewModel.editedFirstName)
                TextField("Last Name", text: $viewModel.editedLastName)
                TextField("Email", text: $viewModel.editedEmail)
                TextField("Title", text: $viewModel.editedTitle)
                Button("Save") {
                    viewModel.saveEmployeeDetails()
                }
            } else {
                Text(viewModel.employee?.firstName ?? "")
                Text(viewModel.employee?.lastName ?? "")
                Text(viewModel.employee?.email ?? "")
                Text(viewModel.employee?.title ?? "")
                Button("Edit") {
                    viewModel.enableEditing()
                }
            }
        }
        .textFieldStyle(.roundedBorder)
    }
}


