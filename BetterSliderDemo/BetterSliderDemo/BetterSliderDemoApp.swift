//
//  BetterSliderDemoApp.swift
//  BetterSliderDemo
//
//  Created by Lukas Pistrol on 23.12.23.
//

import SwiftUI

@main
struct BetterSliderDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            BetterSliderView()
                .tabItem {
                    Label("Default", systemImage: "1.circle")
                }
            RangeSliderView()
                .tabItem {
                    Label("Range", systemImage: "2.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}
