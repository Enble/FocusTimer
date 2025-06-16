//
//  ContentView.swift
//  FocusTimer
//
//  Created by apple on 2025/06/16.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var selectedTab = 0
    
    var body: some View {
        if !hasSeenOnboarding {
            OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
        } else {
            TabView(selection: $selectedTab) {
                TimerView()
                    .tabItem {
                        Label("타이머", systemImage: "timer")
                    }
                    .tag(0)
                
                HistoryView()
                    .tabItem {
                        Label("기록", systemImage: "list.bullet")
                    }
                    .tag(1)
                
                StatsView()
                    .tabItem {
                        Label("통계", systemImage: "chart.bar")
                    }
                    .tag(2)
                
                SettingsView()
                    .tabItem {
                        Label("설정", systemImage: "gearshape")
                    }
                    .tag(3)
            }
        }
    }
}
