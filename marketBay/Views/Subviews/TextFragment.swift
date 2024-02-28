//
//  TextFragment.swift
//  marketBay
//
//  Created by EmJhey PB on 2/15/24.
//

import SwiftUI

struct TextFragment: View {
    var title: String
    var details: String
    var bottomPadding: CGFloat = 5
    var leadingPadding: CGFloat = 10
    
    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity, alignment: .leading)
        
        Text(details)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, bottomPadding)
            .padding(.leading, leadingPadding)
    }
}

#Preview {
    TextFragment(title: "Field Name", details: "Placeholder")
}
