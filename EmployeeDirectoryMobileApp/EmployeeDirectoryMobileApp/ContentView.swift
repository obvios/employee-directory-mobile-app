//
//  ContentView.swift
//  EmployeeDirectoryMobileApp
//
//  Created by Eric Palma on 2/20/24.
//

import SwiftUI

struct ContentView: View {
    let repository = LocalFileEmployeesRepository()
    
    var body: some View {
        EmployeeListView(repository: repository)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
