//
//  ContentView.swift
//  Unifood Admin
//
//  Created by Ilia Loviagin on 3/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var order = Order()
    
    var body: some View {
        TabView {
            OrderView(order: order)
                .tabItem {
                    Label("Заказ", systemImage: "cart")
                }
            
            AccountView()
                .tabItem {
                    Label("Аккаунт", systemImage: "person")
                }
        }
    }
}

#Preview {
    ContentView()
}
