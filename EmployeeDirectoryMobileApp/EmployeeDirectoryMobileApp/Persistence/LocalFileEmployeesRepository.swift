//
//  LocalFileEmployeesRepository.swift
//  EmployeeDirectoryMobileApp
//
//  Created by Eric Palma on 2/20/24.
//

import Foundation
import EmployeeDirectoryCore

enum RepositoryError: Error {
    case employeeNotFound
    case fileOperationFailed(String)
}

// Concrete implementation of `EmployeesRepository`. Uses
// a local json file for data persistence.
class LocalFileEmployeesRepository: EmployeesRepository {
    private let fileURL: URL
    
    init() {
        // Seed the local file database with mock data
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = documentDirectory.appendingPathComponent("employees.json")
        
        // Seed the file with mock data if it doesn't exist
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let mockEmployees = [
                    Employee(id: "1", firstName: "John", lastName: "Doe", dateStarted: Date(), email: "john.doe@example.com", title: "Software Engineer"),
                    Employee(id: "2", firstName: "Jane", lastName: "Doe", dateStarted: Date(), email: "jane.doe@example.com", title: "Project Manager")
                ]
                let data = try JSONEncoder().encode(mockEmployees)
                try data.write(to: fileURL, options: [.atomicWrite])
            } catch {
                print("Failed to seed employees: \(error)")
            }
        }
    }
    
    /// Fetches all employees.
    func fetchEmployees() async throws -> [Employee] {
        do {
            let data = try Data(contentsOf: fileURL)
            let employees = try JSONDecoder().decode([Employee].self, from: data)
            return employees
        } catch {
            throw RepositoryError.fileOperationFailed("Failed to fetch employees.")
        }
    }
    
    /// Fetches a single Employee using the id.
    func fetchEmployeeDetails(id: String) async throws -> Employee {
        do {
            let employees = try await fetchEmployees()
            guard let employee = employees.first(where: { $0.id == id }) else {
                throw RepositoryError.employeeNotFound
            }
            return employee
        } catch {
            throw error
        }
    }
    
    /// Updates employee information.
    func updateEmployeeInformation(employee: Employee) async throws {
        do {
            var employees = try await fetchEmployees()
            guard let index = employees.firstIndex(where: { $0.id == employee.id }) else {
                throw RepositoryError.employeeNotFound
            }
            employees[index] = employee
            let data = try JSONEncoder().encode(employees)
            try data.write(to: fileURL, options: [.atomicWrite])
        } catch {
            throw RepositoryError.fileOperationFailed("Failed to update employee information.")
        }
    }
}

