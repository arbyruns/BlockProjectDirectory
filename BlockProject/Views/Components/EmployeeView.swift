//
//  EmployeeView.swift
//  BlockProject
//
//  Created by robevans on 3/31/22.
//

import SDWebImageSwiftUI
import SwiftUI

struct EmployeeView: View {
    @Environment(\.colorScheme) var colorScheme

    let employee: Employee
    let employeesModel = EmployeesModel()
    @State var showMoreContactInfo = false

    var body: some View {
        RoundedRectangle(cornerRadius: 13)
            .frame(height: showMoreContactInfo ? 325 : 195)
            .foregroundColor(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
            .shadow(radius: 3)
            .overlay(
                VStack {
                    HStack {
                        WebImage(url: URL(string: employee.photoURLSmall ?? ""))
                            .resizable()
                            .placeholder(Image(systemName: "person.crop.circle"))
                            .transition(.fade(duration: 0.5))
                            .frame(width: 55, height: 55, alignment: .center)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                        VStack(alignment: .leading) {
                            Text(employee.fullName)
                                .font(.headline)
                                .padding(.bottom, 2)
                            Text(employee.team)
                                .font(.caption)
                        }
                        .padding(.leading, 3)
                        Spacer()
                    }
                    .padding()
                    VStack {
                        if !(employee.phoneNumber?.isEmpty ?? false) {
                            HStack {
                                Button(action: {
                                    let teltoUrl = URL(string: "tel://\(employee.phoneNumber ?? "")")
                                    if UIApplication.shared.canOpenURL(teltoUrl!) {
                                        UIApplication.shared.open(teltoUrl!, options: [:])
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "phone")
                                            .font(.subheadline)
                                        Text(employeesModel.format(sourcePhoneNumber: employee.phoneNumber ?? "") ?? "")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .buttonStyle(.plain)
                                Spacer()
                            }
                            .padding(.bottom, 4)
                        }
                        if !employee.emailAddress.isEmpty {
                        HStack {
                            Button(action: {
                                let mailtoUrl = URL(string: "mailto:\(employee.emailAddress)")!
                                if UIApplication.shared.canOpenURL(mailtoUrl) {
                                    UIApplication.shared.open(mailtoUrl, options: [:])
                                }
                            }) {
                                HStack {
                                    Image(systemName: "envelope")
                                        .font(.subheadline)
                                    Text(employee.emailAddress)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .buttonStyle(.plain)
                            Spacer()
                        }
                        .padding(.bottom, 4)
                    }
                        Button(action: {
                            withAnimation(.easeInOut) {
                                showMoreContactInfo.toggle()
                            }
                        }) {
                            HStack {
                                Spacer()
                                Image(systemName: showMoreContactInfo ? "chevron.up.circle" : "chevron.down.circle")
                                    .padding(.bottom, 8)
                            }
                        }
                        .buttonStyle(.plain)
                        if showMoreContactInfo {
                            VStack(alignment: .leading) {
                                Divider()
                                    .padding(.horizontal)
                                EmployeeMoreInfoView(infoText1: "Employee Type:", infoText2: employeesModel.getStatus(employeeType: employee.employeeType))
                                EmployeeMoreInfoView(infoText1: "Biography:", infoText2: employee.biography ?? "")
                                Spacer()
                            }
                            .transition(.asymmetric(insertion: .fade(duration: 0.9), removal: .fade))
                        }
                    }
                }
                    .padding()
            )
    }
}

struct EmployeeView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeView(employee: Employee(uuid: "", fullName: "Full Name", phoneNumber: "12343534342", emailAddress: "foo@email.com", biography: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit", photoURLSmall: "", photoURLLarge: "", team: "Point of Sale", employeeType: EmployeeType.contractor))
        EmployeeView(employee: Employee(uuid: "", fullName: "Full Name", phoneNumber: "12343534342", emailAddress: "foo@email.com", biography: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", photoURLSmall: "", photoURLLarge: "", team: "Point of Sale", employeeType: EmployeeType.contractor))
            .colorScheme(.dark)
    }
}
