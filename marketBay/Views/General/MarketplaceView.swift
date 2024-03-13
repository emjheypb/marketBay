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
    @EnvironmentObject var authFireDBHelper: AuthenticationFireDBHelper
    @EnvironmentObject var fireAuthHelper: FireAuthHelper



    
    let categories: [Category] = [.all, .auto, .furniture, .electronics, .womensClothing, .mensClothing, .toys, .homeAndGarden]

        var body: some View {
            NavigationStack {
                VStack {
                    // Horizontal Category Selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(categories, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category
                                }) {
                                    VStack {
                                        Image(systemName: "circle.fill") // Placeholder image
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
                                   ItemView(listing: listing).environmentObject(authFireDBHelper)
                                   .environmentObject(generalFireDBHelper)
                                   .environmentObject(fireAuthHelper)
                                   .environmentObject(sellingFireDBHelper)
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
            }
        }

    }



struct ItemView: View {
    let listing: Listing // Add a property to hold the listing information

    @EnvironmentObject var sellingFireDBHelper: SellingFireDBHelper
    @EnvironmentObject var generalFireDBHelper: GeneralFireDBHelper
    @EnvironmentObject var authFireDBHelper: AuthenticationFireDBHelper
    @EnvironmentObject var fireAuthHelper: FireAuthHelper


    var body: some View {
        NavigationLink(destination: ListingView(listing: listing).environmentObject(sellingFireDBHelper)
            .environmentObject(authFireDBHelper)
            .environmentObject(generalFireDBHelper)
            .environmentObject(fireAuthHelper)) {
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
