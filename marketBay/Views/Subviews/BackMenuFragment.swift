//
//  BackMenuFragment.swift
//  marketBay
//  Menu fragment with custom back button - for non-root views
//
//  Created by EmJhey PB on 2/13/24.
//

import SwiftUI

struct BackMenuFragment: View {
    @EnvironmentObject private var appRootManager: AppRootManager
    @EnvironmentObject var dataAccess: DataAccess
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
            
            Menu {
                // MARK: Root Screens Menu Items
                let rootScreens = appRootManager.rootScreens
                ForEach(rootScreens.indices) { index in
                    if(appRootManager.currentRoot != rootScreens[index].1) {
                        Button {
                            appRootManager.currentRoot = rootScreens[index].1
                        } label: {
                            Text(rootScreens[index].0)
                            Image(systemName: rootScreens[index].2)
                        }
                    }
                }
                
                // MARK: Logout Menu Item
                Button (role:.destructive) {
                    dataAccess.logout()
                    appRootManager.currentRoot = appRootManager.homePage
                } label:{
                    Text("Logout")
                    Image(systemName: "power")
                }
            } label: {
                Image(systemName: "line.3.horizontal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.black)
            }
        }
    }
}

#Preview {
    BackMenuFragment()
}
