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

    @State private var searchString: String = ""
    @State private var minAmount: String = ""
    @State private var maxAmount: String = ""
    
    let categories: [Category] = [.all, .auto, .furniture, .electronics, .womensClothing, .mensClothing, .toys, .homeAndGarden]

        var body: some View {
            NavigationStack {
                VStack {
                    // Horizontal Category Selector
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 15, height: 15)
                        TextField("Enter item name", text: $searchString)
                            .textInputAutocapitalization(.never)
                    }
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.horizontal)
                    
                    HStack {
                        HStack {
                            Text("$")
                            TextField("0.00", text: $minAmount)
                                .keyboardType(.numbersAndPunctuation)
                            Text("to")
                            TextField("0.00", text: $maxAmount)
                                .keyboardType(.numbersAndPunctuation)
                        }
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.horizontal)
                        
                        Picker("Select category", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) { category in
                                Text(category.rawValue)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: 160, alignment: .leading)
                    }
//                    ScrollView(.horizontal, showsIndicators: false) {
//                            ForEach(categories, id: \.self) { category in
//                                Button(action: {
//                                    selectedCategory = category
//                                }) {
//                                    VStack {
//                                        Image(systemName: "circle.fill") // Placeholder image
//                                            .foregroundColor(category == selectedCategory ? .blue : .gray)
//                                        Text(category.rawValue) // Access the rawValue
//                                            .font(.caption)
//                                            .foregroundColor(category == selectedCategory ? .blue : .black)
//                                    }
//                                    .padding(.horizontal, 10)
//                                }
//                            }
//                        }
//                    }
//                    .padding(.vertical)
                    
                    // Grid-like Display of Items
                   ScrollView {
                       LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                           ForEach(sellingFireDBHelper.listings.filter {
                               ($0.category == selectedCategory || selectedCategory == .all)
                               && $0.status == PostStatus.available
                               && (searchString.isEmpty || $0.title.lowercased().contains(searchString.lowercased()))
                               && (minAmount.isEmpty || Double(minAmount) == nil || Double(minAmount) ?? 0 < $0.price)
                               && (maxAmount.isEmpty || Double(maxAmount) == nil || Double(maxAmount) ?? 0 > $0.price)
                           }) { listing in
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
        .frame(width: 170, height: 250) // Set a fixed frame size

    }
}
