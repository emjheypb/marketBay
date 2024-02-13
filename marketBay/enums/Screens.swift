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
    @Published var currentRoot: Screens = .dashboardView
    
    var rootScreens : [(String, Screens, String)] = [
        ("Login", .loginView, "lock.fill"),
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
    case loginView
    case registrationView
    case favoritesView
    case myPostsView
    case profileView
    case marketplaceView
    case listingView
}
