//
//  MyPostsRow.swift
//  marketBay
//
//  Created by EmJhey PB on 2/14/24.
//

import SwiftUI

struct MyPostsRow: View {
    var listing: MiniListing
    
    var body: some View {
        HStack {
            // Image, Title, Price
            if(listing.image.isEmpty) {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            } else {
                AsyncImage(url: URL(string: listing.image)) {
                    image in
                    image.image?.resizable()
                }
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            }
            
            VStack(alignment: .leading) {
                Text("# \(listing.id)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(listing.title)
                Text("$ \(String(format: "%0.2f", listing.price))")
            }
            
            Spacer()
        }
    }
}
