//
//  DashboardView.swift
//  marketBay
//  Have access points to ProfileView, FavoritesView, MyPostsView, 
//  Created by EmJhey PB on 2/8/24.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var dataAccess: DataAccess
    
    var body: some View {
        NavigationStack {
            MenuTemplate().environmentObject(dataAccess)
            VStack {
                Text("DASHBOARD")
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    DashboardView()
}
