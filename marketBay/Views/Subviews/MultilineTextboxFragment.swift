//
//  MultilineTextboxFragment.swift
//  marketBay
//
//  Created by EmJhey PB on 2/14/24.
//

import SwiftUI

struct MultilineTextboxFragment: View {
    var fieldName: String
    var placeholder: String
    @State var binding: Binding<String>
    var bottomPadding: CGFloat = 5
    var keyboardType: UIKeyboardType = .default
    var lineLimit: Int = 3
    var reserveSpace: Bool = true
    
    var body: some View {
        Text(fieldName)
            .frame(maxWidth: .infinity, alignment: .leading)
        TextField(placeholder, text: binding, axis: .vertical)
            .lineLimit(lineLimit, reservesSpace: reserveSpace)
            .padding(.bottom, bottomPadding)
            .keyboardType(keyboardType)
            .textFieldStyle(.roundedBorder)
    }
}

#Preview {
    MultilineTextboxFragment(fieldName: "Field Name", placeholder: "Placeholder", binding: .constant("Binding"), keyboardType: .default)
}
