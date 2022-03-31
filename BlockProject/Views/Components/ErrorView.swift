//
//  ErrorView.swift
//  BlockProject
//
//  Created by robevans on 3/31/22.
//

import SwiftUI

struct ErrorView: View {
    let errorMessage: String

    var body: some View {
        VStack {
            Image(systemName: "xmark.octagon")
                .foregroundColor(.red)
                .font(.largeTitle)
            Text(errorMessage)
                .multilineTextAlignment(.center)
                .padding(.top)
                .padding(.horizontal)
        }
    }
}

#if DEBUG
struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(errorMessage: "Sample Error")
    }
}
#endif
