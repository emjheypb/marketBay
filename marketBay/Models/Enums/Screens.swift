//
//  Screens.swift
//  manage root screen changes
//  manage screen navigationlink tags
//
//  Created by EmJhey PB on 2/8/24.
//

import Foundation

// MARK: Root Screen Management
final class AppRootManager: ObservableObject {
    // MARK: Home Page
    @Published var currentRoot: Screens = .marketplaceView
    let homePage: Screens = .marketplaceView
    
    var rootScreens : [(String, Screens, String)] = [
        ("Dashboard", .dashboardView, "house.fill"),
        ("Marketplace", .marketplaceView, "basket.fill"),
        ("My Posts", .myPostsView, "tag.fill"),
        ("Favorites", .favoritesView, "star.fill"),
        ("Profile", .profileView, "person.fill")
    ]
}

// MARK: NavigationLink Tags
enum Screens {
    case dashboardView
    case registrationView
    case favoritesView
    case myPostsView
    case profileView
    case marketplaceView
    case listingView
}
