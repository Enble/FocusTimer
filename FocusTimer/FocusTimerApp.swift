//
//  FocusTimerApp.swift
//  FocusTimer
//
//  Created by apple on 2025/06/16.
//


import SwiftUI

@main
struct FocusTimerApp: App {
    let persistenceController = PersistenceManager.shared
    @StateObject private var settingsManager = SettingsManager()
    @StateObject private var notificationManager = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(settingsManager)
                .environmentObject(notificationManager)
                .onAppear {
                    notificationManager.requestAuthorization()
                }
        }
    }
}
