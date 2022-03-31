//
//  Employees.swift
//  BlockProject
//
//  Created by robevans on 3/30/22.
//

import Foundation

// MARK: - Employees
struct Employees: Codable {
    let employees: [Employee]

    enum CodingKeys: String, CodingKey {
        case employees = "employees"
    }
}

// MARK: - Employee
struct Employee: Codable {
    let uuid: String
    let fullName: String
    let phoneNumber: String?
    let emailAddress: String
    let biography: String?
    let photoURLSmall: String?
    let photoURLLarge: String?
    let team: String
    let employeeType: EmployeeType

    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        case fullName = "full_name"
        case phoneNumber = "phone_number"
        case emailAddress = "email_address"
        case biography = "biography"
        case photoURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
        case team = "team"
        case employeeType = "employee_type"
    }
}

enum EmployeeType: String, Codable {
    case contractor = "CONTRACTOR"
    case fullTime = "FULL_TIME"
    case partTime = "PART_TIME"
}
