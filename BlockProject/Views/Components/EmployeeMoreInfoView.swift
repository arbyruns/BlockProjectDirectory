//
//  EmployeeMoreInfoView.swift
//  BlockProject
//
//  Created by robevans on 3/31/22.
//

import SwiftUI

struct EmployeeMoreInfoView: View {

    let infoText1: String
    let infoText2: String


    var body: some View {
        VStack(alignment: .leading) {
            Text(infoText1)
                .fontWeight(.semibold)
                .font(.caption)
            Text(infoText2)
                .font(.caption)
                .lineLimit(4)
                .padding(.vertical, 2)
        }
        .padding(4)
    }
}

struct EmployeeMoreInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeMoreInfoView(infoText1: "infoText1", infoText2: "infoText1")
    }
}
