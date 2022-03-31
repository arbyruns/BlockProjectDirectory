//
//  DirectoryPlaceHolderView.swift
//  BlockProject
//
//  Created by robevans on 3/31/22.
//

import SwiftUI

struct DirectoryPlaceHolderView: View {
    @State private var animate = false

    var body: some View {
        VStack {
            HStack {
                Circle()
                    .fill(.secondary)
                    .frame(width: 55, height: 55, alignment: .center)
                    .shadow(radius: 3)
                VStack(alignment: .leading) {
                    Text("Rob Evans")
                        .font(.headline)
                        .padding(.bottom, 2)
                    Text("employee.team")
                        .font(.caption)
                }
                .padding(.leading, 3)
                Spacer()
            }
            .padding()
            VStack {
                HStack {
                    Image(systemName: "phone")
                        .font(.subheadline)
                    Text("555-555-5555")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.bottom, 4)
                HStack {
                    Image(systemName: "envelope")
                        .font(.subheadline)
                    Text("employee.emailAddress")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.bottom, 4)
            }
        }
        .scaleEffect(animate ? 0.9 : 1.0)
        .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animate)
        .redacted(reason: .placeholder)
    .onAppear {
        withAnimation() {
            animate = true
        }
    }
    }
}

struct DirectoryPlaceHolderView_Previews: PreviewProvider {
    static var previews: some View {
        DirectoryPlaceHolderView()
    }
}
