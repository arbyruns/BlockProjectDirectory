//
//  ContentView.swift
//  BlockProject
//
//  Created by robevans on 3/30/22.
// https://square.github.io/microsite/mobile-interview-project/

import SDWebImageSwiftUI
import SwiftUI

struct DirectoryView: View {

    @StateObject var employeeData = EmployeesModel()

    @State private var searchText = ""
    @State private var animate = false

    var body: some View {
        NavigationView {
            VStack {
                // if we have an error we're show ErrorView in place.
                switch employeeData.showErrorAlert {
                case true:
                    ErrorView(errorMessage: employeeData.errorMessage)
                default:
                    // placeholder until data loads
                    if employeeData.employeesData.isEmpty {
                        List {
                            VStack {
                                DirectoryPlaceHolderView()
                                Text("*Waiting on Data...*")
                                    .font(.title2)
                            }
                            .onAppear {
                                withAnimation() {
                                    animate = true
                                }
                            }
                        }
                    } else if employeeData.showErrorAlert {
                        ErrorView(errorMessage: employeeData.errorMessage)

                    }
                    else {
                            // we have the directory and show the view
                            VStack {
                                SearchFieldView(text: $searchText)
                                List {
                                    ForEach(employeeData.employeesData.filter({ searchText.isEmpty ? true : $0.fullName.lowercased().contains(searchText.lowercased()) }), id: \.uuid) { employee in
                                            EmployeeView(employee: employee)
                                                .padding(.bottom, 30)
                                    }
                                    .listRowSeparator(.hidden)
                                }
                                .gesture(DragGesture().onChanged { gesture in
                                    hideKeyboard()

                                })
                            .refreshable {
                                withAnimation {
                                    employeeData.employeesData = []
                                }
                                // this is put in place just to show the placeholder
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    Task {
                                        employeeData.employeesData = await employeeData.fetchEmployees()
                                    }
                                }
                            }
                            .listStyle(.plain)
                        }
                    }
                }
            }
            .task {
                employeeData.employeesData = await employeeData.fetchEmployees()
            }
            .navigationTitle("Employee Directory")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Refresh") {
                        withAnimation {
                            employeeData.employeesData = []
                        }
                        // this is put in place just to show the placeholder
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            Task {
                                employeeData.employeesData = await employeeData.fetchEmployees()
                            }
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("Update URL") {
                        Button("Working URL") {
                            withAnimation {
                                employeeData.employeesData = []
                                employeeData.directoryURL = employeeData.workingURL
                            }
                            // this is put in place just to show the placeholder
                            Task {
                                employeeData.showErrorAlert = false
                                employeeData.employeesData = await employeeData.fetchEmployees()
                            }
                        }
                        Button("Malformed URL") {
                            withAnimation {
                                employeeData.employeesData = []
                                employeeData.directoryURL = employeeData.malformedURL
                            }
                            // this is put in place just to show the placeholder
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                Task {
                                    employeeData.showErrorAlert = false
                                    employeeData.employeesData = await employeeData.fetchEmployees()
                                }
                            }
                        }
                        Button("Empty URL") {
                            withAnimation {
                                employeeData.employeesData = []
                                employeeData.directoryURL = employeeData.emptyURL
                            }
                            // this is put in place just to show the placeholder
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                Task {
                                    employeeData.showErrorAlert = false
                                    employeeData.employeesData = await employeeData.fetchEmployees()
                                }
                            }
                        }
                    }

                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}



struct DirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryView()
    }
}

extension View {
    /// Use to dismiss keyboard when using Search
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
