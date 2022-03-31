//
//  EmployeesViewModel.swift
//  BlockProject
//
//  Created by robevans on 3/31/22.
//

import Foundation

class EmployeesModel: ObservableObject {

    @Published var employeesData: [Employee] = []

    @Published var showErrorAlert = false
    @Published var errorMessage = ""

    // sample URL for testing
    var directoryURL = "https://s3.amazonaws.com/sq-mobile-interview/employees.json"
    var malformedURL = "https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json"
    var emptyURL = "https://s3.amazonaws.com/sq-mobile-interview/employees_empty.json"

    /// Used to fetch employee directory
    /// - Returns: Returns system employee directory
    func fetchEmployees() async -> [Employee] {

        guard let url = URL(string: directoryURL) else {
            return []
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                    switch httpResponse.statusCode {
                    case 404:
                        showErrorAlert = true
                        errorMessage = "Network error: \(httpResponse.statusCode). Oops the pages wasn't found."
                    case 500:
                        showErrorAlert = true
                        errorMessage = "Network error: \(httpResponse.statusCode). Oops looks like an issue with our server."
                    case 503:
                        showErrorAlert = true
                        errorMessage = "Network error: \(httpResponse.statusCode). Oops looks like an issue with our server. Please try again later."
                    default:
                        showErrorAlert = true
                        errorMessage = "Unknown network error: \(httpResponse.statusCode)"
                    }
                }
                return []
            }

            let employeeData = try JSONDecoder().decode(Employees.self, from: data)
            let results = employeeData.employees.sorted{ $0.fullName.compare($1.fullName, options: .caseInsensitive) == .orderedAscending }
            return results
        } catch {
            showErrorAlert = true
            errorMessage = ("Error: \(error.localizedDescription)")
            print("\(#function) \(error)")
            return []
        }
    }

    // Credit to stack overflow discussion here https://stackoverflow.com/questions/32364055/formatting-phone-number-in-swift
    /// Used to format a string ten character phone number from the employee directory
    /// - Returns: Returns formatted phone number
    func format(sourcePhoneNumber: String) -> String? {
        // Remove any character that is not a number
           let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
           let length = numbersOnly.count
           let hasLeadingOne = numbersOnly.hasPrefix("1")

           // Check for supported phone number length
           guard length == 7 || (length == 10 && !hasLeadingOne) || (length == 11 && hasLeadingOne) else {
               return nil
           }

           let hasAreaCode = (length >= 10)
           var sourceIndex = 0

           // Leading 1
           var leadingOne = ""
           if hasLeadingOne {
               leadingOne = "1 "
               sourceIndex += 1
           }

           // Area code
           var areaCode = ""
           if hasAreaCode {
               let areaCodeLength = 3
               guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                   return nil
               }
               areaCode = String(format: "(%@) ", areaCodeSubstring)
               sourceIndex += areaCodeLength
           }

           // Prefix, 3 characters
           let prefixLength = 3
           guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
               return nil
           }
           sourceIndex += prefixLength

           // Suffix, 4 characters
           let suffixLength = 4
           guard let suffix = numbersOnly.substring(start: sourceIndex, offsetBy: suffixLength) else {
               return nil
           }

           return leadingOne + areaCode + prefix + "-" + suffix
       }

}

extension String {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }

        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }

        return String(self[substringStartIndex ..< substringEndIndex])
    }
}
