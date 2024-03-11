//
//  PageHeadingFragment.swift
//  marketBay
//
//  Created by EmJhey PB on 2/14/24.
//

import SwiftUI

struct PageHeadingFragment: View {
    var pageTitle: String
    var padding: CGFloat = 5
    
    var body: some View {
        Text(pageTitle)
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.title)
            .fontWeight(.bold)
            .padding([.top, .bottom], padding)
    }
}

#Preview {
    PageHeadingFragment(pageTitle: "Title")
}
