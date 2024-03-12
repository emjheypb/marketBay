//
//  MarketplaceView.swift
//  marketBay
//  Home Screen of App for browsing listings
//  Have access points to DashboardView and ListingView,
//  Created by Cheung K on 12/2/2024.
//

import SwiftUI

struct MarketplaceView: View {
    @State private var selectedCategory: Category = .all
    @EnvironmentObject var sellingFireDBHelper: SellingFireDBHelper
    @EnvironmentObject var generalFireDBHelper: GeneralFireDBHelper

    var body: some View {
        NavigationStack {
                   VStack {
                       // Horizontal Category Selector
                       ScrollView(.horizontal, showsIndicators: false) {
                           HStack {
                               ForEach(generalFireDBHelper.categories, id: \.self) { category in
                                   Button(action: {
                                       selectedCategory = category
                                   }) {
                                       VStack {
                                           AsyncImage(url: category.imageURL) { image in
                                                                                  image
                                                                                      .resizable()
                                                                                      .frame(width: 40, height: 40) // Adjust size as needed
                                                                              } // Category icon
                                               .foregroundColor(category == selectedCategory ? .blue : .gray)
                                           Text(category.rawValue) // Access the rawValue
                                               .font(.caption)
                                               .foregroundColor(category == selectedCategory ? .blue : .black)
                                       }
                                       .padding(.horizontal, 10)
                                   }
                               }
                           }
                       }
                       .padding(.vertical)
                
                // Grid-like Display of Items
               ScrollView {
                   LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                       ForEach(sellingFireDBHelper.listings.filter { $0.category == selectedCategory || selectedCategory == .all }) { listing in
                               ItemView(listing: listing)
                           }
                   }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
        .onAppear() {
            if(sellingFireDBHelper.listener == nil) {
                sellingFireDBHelper.getAll()
            }
            
            if(generalFireDBHelper.listener == nil) {
                generalFireDBHelper.createCategoriesCollectionIfNeeded()
            }
        }
    }

}

struct ItemView: View {
    let listing: Listing // Add a property to hold the listing information

    var body: some View {
        NavigationLink(destination: ListingView(listing: listing)) {
            VStack {
                // Image and Title
                if(listing.image.isEmpty) {
                    Image(systemName: "photo") // Placeholder image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                } else {
                    AsyncImage(url: URL(string: listing.image)) {
                        image in
                        image.image?.resizable()
                    }
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                }
                Text(listing.title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                // Price
                Text("$\(String(format:"%.2f", listing.price))")
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .padding(.vertical, 5)
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
