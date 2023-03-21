//
//  MainTabView.swift
//  FirebaseLoginAndMemberHandling
//
//  Created by Djallil Elkebir on 2023-03-20.
//

import SwiftUI

struct MainTabView: View {
    @State private var currentTab: Tabs = .home
    var body: some View {
        TabView(selection: $currentTab) {
            Button(action: {
                currentTab = .profil
            }) {
                Text("Go To Profil")
            }
                .tabItem {
                    tabItemFor(.home)
                }
                .tag(Tabs.home)
            #warning("Deprecated in iOS 16, use NavigationStack if you support only iOS16+")
            NavigationView {
                ProfilView()
            }
                .tabItem {
                    tabItemFor(.profil)
                }
                .tag(Tabs.profil)
        }
    }
    
    @ViewBuilder
    private func tabItemFor(_ tab: Tabs) -> some View {
        Label(tab.title, systemImage: tab.icon)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
