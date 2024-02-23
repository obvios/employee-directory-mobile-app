//
//  EmployeeDetailsViewModel.swift
//  EmployeeDirectoryMobileApp
//
//  Created by Eric Palma on 2/23/24.
//

import Foundation
import EmployeeDirectoryCore

@MainActor
class EmployeeDetailsViewModel: ObservableObject {
    private let fetchUseCase: FetchEmployeeDetailsUseCase
    private let editUseCase: UpdateEmployeeInformationUseCase
    private let employeeID: Employee.Identifier
    @Published var employee: Employee?
    @Published var isEditing = false

    // Temporary states for editing
    @Published var editedFirstName: String = ""
    @Published var editedLastName: String = ""
    @Published var editedEmail: String = ""
    @Published var editedTitle: String = ""

    init(fetchUseCase: FetchEmployeeDetailsUseCase, editUseCase: UpdateEmployeeInformationUseCase, employeeID: Employee.Identifier) {
        self.fetchUseCase = fetchUseCase
        self.editUseCase = editUseCase
        self.employeeID = employeeID
        fetchEmployeeDetails()
    }

    func fetchEmployeeDetails() {
        Task {
            do {
                let employeeResult = try await fetchUseCase.execute(employeeId: employeeID)
                self.employee = employeeResult
                // Initialize editing fields
                self.editedFirstName = employeeResult.firstName
                self.editedLastName = employeeResult.lastName
                self.editedEmail = employeeResult.email
                self.editedTitle = employeeResult.title
            } catch {
                print("Failed to fetch employee details: \(error)")
            }
        }
    }

    func saveEmployeeDetails() {
        guard let employee = employee else { return }
        let updatedEmployee = Employee(id: employee.id, firstName: editedFirstName, lastName: editedLastName, dateStarted: employee.dateStarted, email: editedEmail, title: editedTitle)
        Task {
            do {
                try await editUseCase.execute(employee: updatedEmployee)
                self.employee = updatedEmployee // Update the local employee state
                self.isEditing = false // Exit editing mode
            } catch {
                print("Failed to update employee")
            }
        }
    }

    func enableEditing() {
        guard let employee = employee else { return }
        editedFirstName = employee.firstName
        editedLastName = employee.lastName
        editedEmail = employee.email
        editedTitle = employee.title
        isEditing = true
    }
}

