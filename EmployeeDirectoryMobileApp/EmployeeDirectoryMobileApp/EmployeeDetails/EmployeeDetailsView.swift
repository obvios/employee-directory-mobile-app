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
    private let fetchUseCase: FetchEmployeeDetailsUseCase
    private let editUseCase: UpdateEmployeeInformationUseCase
    private let employeeID: Employee.Identifier
    @State private var employee: Employee?
    @State private var isEditing = false // Add state to track editing mode
    
    // Temporary states for editing
    @State private var editedFirstName: String = ""
    @State private var editedLastName: String = ""
    @State private var editedEmail: String = ""
    @State private var editedTitle: String = ""
    
    init(repository: EmployeesRepository, employeeID: Employee.Identifier) {
        self.repository = repository
        self.fetchUseCase = FetchEmployeeDetailsUseCase(repository: repository)
        self.editUseCase = UpdateEmployeeInformationUseCase(repository: repository)
        self.employeeID = employeeID
    }
    
    var body: some View {
        VStack {
            if isEditing {
                TextField("First Name", text: $editedFirstName)
                TextField("Last Name", text: $editedLastName)
                TextField("Email", text: $editedEmail)
                TextField("Title", text: $editedTitle)
                Button("Save") {
                    // Implement saving logic here
                    guard let employee = employee else { return }
                    let updatedEmployee = Employee(id: employee.id, firstName: editedFirstName, lastName: editedLastName, dateStarted: employee.dateStarted, email: editedEmail, title: editedTitle)
                    Task {
                        do {
                            try await editUseCase.execute(employee: updatedEmployee)
                            self.employee = updatedEmployee // Update the local employee state
                            isEditing = false // Exit editing mode
                        } catch {
                            // Handle error
                            print("Failed to update employee")
                        }
                    }
                }
            } else {
                Text(employee?.firstName ?? "")
                Text(employee?.lastName ?? "")
                Text(employee?.email ?? "")
                Text(employee?.title ?? "")
                Button("Edit") {
                    // Prepare for editing
                    editedFirstName = employee?.firstName ?? ""
                    editedLastName = employee?.lastName ?? ""
                    editedEmail = employee?.email ?? ""
                    editedTitle = employee?.title ?? ""
                    isEditing = true
                }
            }
        }
        .task {
            guard let employeeResult = try? await fetchUseCase.execute(employeeId: employeeID) else {
                return
            }
            employee = employeeResult
            // Initialize editing fields
            editedFirstName = employeeResult.firstName
            editedLastName = employeeResult.lastName
            editedEmail = employeeResult.email
            editedTitle = employeeResult.title
        }
    }
}

