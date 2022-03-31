//
//  SearchFieldView.swift
//  BlockProject
//
//  Created by robevans on 3/31/22.
//

import SwiftUI

struct SearchFieldView: View {
    @Binding var text: String

    @State private var isEditing = false

    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)

                        if isEditing {
                            Button(action: {
                                withAnimation {
                                self.text = ""
                                }
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing)
                            }
                        }
                    }
                )

            if isEditing {
                Button(action: {
                    withAnimation {
                        self.isEditing = false
                        self.text = ""
                    }

                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.fade)
                .animation(.default)

            }
        }
    }
}

struct SearchFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SearchFieldView(text: .constant(""))
    }
}
