//
//  TextboxFragment.swift
//  marketBay
//
//  Created by EmJhey PB on 2/14/24.
//

import SwiftUI

struct TextboxFragment: View {
    var fieldName: String
    var placeholder: String
    @State var binding: Binding<String>
    var bottomPadding: CGFloat = 5
    var keyboardType: UIKeyboardType = .default
    var isMandatory: Bool = false
    
    var body: some View {
        HStack {
            if(isMandatory) {
                Text("*")
                    .fontWeight(.bold)
                    .foregroundStyle(.red)
            }
            Text(fieldName)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        TextField(placeholder, text: binding)
            .padding(.bottom, bottomPadding)
            .keyboardType(keyboardType)
            .textFieldStyle(.roundedBorder)
    }
}

#Preview {
    TextboxFragment(fieldName: "Field Name", placeholder: "Placeholder", binding: .constant("Binding"), keyboardType: .default)
}
