//
//  BlockProjectTests.swift
//  BlockProjectTests
//
//  Created by robevans on 3/31/22.
//

import XCTest
@testable import BlockProject

class BlockProjectTests: XCTestCase {

    func testPhoneNumberFormat() {
        let employeesModel = EmployeesModel()

        let result = employeesModel.format(sourcePhoneNumber: "5558531970")
        XCTAssertEqual(result, "(555) 853-1970")
    }

    func testFetchData() async throws {
        let employeesModel = EmployeesModel()

        let result = await employeesModel.fetchEmployees()
        XCTAssertNotNil(result)
    }

    func testFetchDataMalformed() async throws {
        let employeesModel = EmployeesModel()
        employeesModel.directoryURL = "https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json"
        let result = await employeesModel.fetchEmployees()
        XCTAssertEqual(employeesModel.showErrorAlert, true)
    }
}
