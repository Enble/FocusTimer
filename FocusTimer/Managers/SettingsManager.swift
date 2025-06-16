//
//  SettingsManager.swift
//  FocusTimer
//
//  Created by apple on 2025/06/16.
//

import Foundation
import SwiftUI
import Combine

class SettingsManager: ObservableObject {
    @AppStorage("focusDuration") var focusDuration: Double = 25 {
        didSet {
            focusDurationPublisher.send(focusDuration)
        }
    }
    @AppStorage("breakDuration") var breakDuration: Double = 5 {
        didSet {
            breakDurationPublisher.send(breakDuration)
        }
    }
    @AppStorage("longBreakDuration") var longBreakDuration: Double = 15
    @AppStorage("sessionsUntilLongBreak") var sessionsUntilLongBreak: Int = 4
    @AppStorage("enableNotifications") var enableNotifications: Bool = true
    @AppStorage("enableSound") var enableSound: Bool = true
    @AppStorage("selectedTheme") var selectedTheme: String = "system"
    @AppStorage("dailyGoal") var dailyGoal: Double = 120 // 분 단위
    @AppStorage("weeklyGoal") var weeklyGoal: Double = 600 // 분 단위
    
    // Publishers for Combine
    let focusDurationPublisher = PassthroughSubject<Double, Never>()
    let breakDurationPublisher = PassthroughSubject<Double, Never>()
    
    // 타이머 설정 범위
    let focusDurationRange = 5.0...60.0
    let breakDurationRange = 5.0...30.0
    let longBreakDurationRange = 10.0...60.0
    
    // 테마 옵션
    let themeOptions = ["system", "light", "dark"]
    
    func resetToDefaults() {
        focusDuration = 25
        breakDuration = 5
        longBreakDuration = 15
        sessionsUntilLongBreak = 4
        enableNotifications = true
        enableSound = true
        selectedTheme = "system"
        dailyGoal = 120
        weeklyGoal = 600
    }
}
