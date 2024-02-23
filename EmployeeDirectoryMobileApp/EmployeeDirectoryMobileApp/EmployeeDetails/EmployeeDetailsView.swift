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
        VStack(spacing: 10) {
            VStack(alignment: .leading) {
                if viewModel.isEditing {
                    TextField("First Name", text: $viewModel.editedFirstName)
                    TextField("Last Name", text: $viewModel.editedLastName)
                    TextField("Email", text: $viewModel.editedEmail)
                    TextField("Title", text: $viewModel.editedTitle)
                    Button("Save") {
                        viewModel.saveEmployeeDetails()
                    }
                } else {
                    Text("First Name: " + (viewModel.employee?.firstName ?? ""))
                    Text("Last Name: " + (viewModel.employee?.lastName ?? ""))
                    Text("Email: " + (viewModel.employee?.email ?? ""))
                    Text("Title: " + (viewModel.employee?.title ?? ""))
                }
            }
            .textFieldStyle(.roundedBorder)
            
            Button("Edit") {
                viewModel.enableEditing()
            }
        }
    }
}


