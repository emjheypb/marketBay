//
//  CustomBackFragment.swift
//  marketBay
//  Custom back button
//
//  Created by EmJhey PB on 2/13/24.
//

import SwiftUI

struct CustomBackFragment: View {
    @Environment(\.dismiss)  var dismiss
    
    var body: some View {
        HStack {
            // MARK: Custom Back Button
            // includes logo to compansate for removal of back swipe gesture
            Button {
                dismiss()
            } label:{
                Image(systemName: "chevron.backward")
                    .imageScale(.large)
                    .foregroundColor(.blue)
                
                // MARK: Logo
                Image(.marketBay)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 125)
            }
            
            Spacer()
        }
        .padding([.top, .leading, .trailing])
    }
}
