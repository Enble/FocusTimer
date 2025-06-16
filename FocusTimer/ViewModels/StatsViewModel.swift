//
//  StatsViewModel.swift
//  FocusTimer
//
//  Created by apple on 2025/06/16.
//

import Foundation
import SwiftUI

enum PeriodType: Int {
    case daily = 0
    case weekly = 1
    case monthly = 2
}

struct HourlyData: Identifiable {
    let id = UUID()
    let hour: String
    let minutes: Double
}

struct WeeklyData: Identifiable {
    let id = UUID()
    let dayName: String
    let minutes: Double
}

struct DailyData: Identifiable {
    let id = UUID()
    let date: Date
    let minutes: Double
}

class StatsViewModel: ObservableObject {
    @Published var totalFocusTime: Double = 0
    @Published var totalSessions: Int = 0
    @Published var averageSessionTime: Double = 0
    @Published var completedSessions: Int = 0
    @Published var interruptedSessions: Int = 0
    
    @Published var hourlyData: [HourlyData] = []
    @Published var weeklyData: [WeeklyData] = []
    @Published var monthlyData: [DailyData] = []
    @Published var taskBreakdown: [(String, Double)] = []
    
    private let persistenceManager = PersistenceManager.shared
    private let statisticsCalculator = FocusStatisticsCalculator()
    
    func loadData(for period: PeriodType) {
        let calendar = Calendar.current
        let now = Date()
        let startDate: Date
        let endDate = now
        
        switch period {
        case .daily:
            startDate = calendar.startOfDay(for: now)
            loadDailyData(from: startDate, to: endDate)
        case .weekly:
            startDate = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now)) ?? now
            loadWeeklyData(from: startDate, to: endDate)
        case .monthly:
            startDate = calendar.date(byAdding: .day, value: -29, to: calendar.startOfDay(for: now)) ?? now
            loadMonthlyData(from: startDate, to: endDate)
        }
    }
    
    private func loadDailyData(from startDate: Date, to endDate: Date) {
        let sessions = persistenceManager.fetchSessions(from: startDate, to: endDate)
        calculateBasicStats(sessions)
        
        // 시간대별 데이터 생성
        var hourlyMinutes: [Int: Double] = [:]
        
        for session in sessions where session.isCompleted {
            if let startTime = session.startTime {
                let hour = Calendar.current.component(.hour, from: startTime)
                hourlyMinutes[hour, default: 0] += session.duration / 60
            }
        }
        
        // 24시간 데이터 생성
        hourlyData = (0..<24).map { hour in
            HourlyData(
                hour: String(format: "%02d시", hour),
                minutes: hourlyMinutes[hour] ?? 0
            )
        }
    }
    
    private func loadWeeklyData(from startDate: Date, to endDate: Date) {
        let sessions = persistenceManager.fetchSessions(from: startDate, to: endDate)
        calculateBasicStats(sessions)
        
        // 요일별 데이터 생성
        var weekdayMinutes: [Int: Double] = [:]
        var taskMinutes: [String: Double] = [:]
        
        for session in sessions where session.isCompleted {
            if let startTime = session.startTime {
                let weekday = Calendar.current.component(.weekday, from: startTime)
                weekdayMinutes[weekday, default: 0] += session.duration / 60
                
                let taskTitle = session.title ?? "무제"
                taskMinutes[taskTitle, default: 0] += session.duration / 60
            }
        }
        
        // 요일 데이터 생성
        let weekdayNames = ["일", "월", "화", "수", "목", "금", "토"]
        weeklyData = (1...7).map { weekday in
            WeeklyData(
                dayName: weekdayNames[weekday - 1],
                minutes: weekdayMinutes[weekday] ?? 0
            )
        }
        
        // 작업별 분석 (상위 5개)
        taskBreakdown = taskMinutes.sorted { $0.value > $1.value }
            .prefix(5)
            .map { ($0.key, $0.value) }
    }
    
    private func loadMonthlyData(from startDate: Date, to endDate: Date) {
        let sessions = persistenceManager.fetchSessions(from: startDate, to: endDate)
        calculateBasicStats(sessions)
        
        // 일별 데이터 생성
        var dailyMinutes: [Date: Double] = [:]
        
        for session in sessions where session.isCompleted {
            if let startTime = session.startTime {
                let day = Calendar.current.startOfDay(for: startTime)
                dailyMinutes[day, default: 0] += session.duration / 60
            }
        }
        
        // 30일 데이터 생성
        monthlyData = []
        var currentDate = startDate
        let calendar = Calendar.current
        
        while currentDate <= endDate {
            let dayStart = calendar.startOfDay(for: currentDate)
            monthlyData.append(DailyData(
                date: dayStart,
                minutes: dailyMinutes[dayStart] ?? 0
            ))
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
    }
    
    private func calculateBasicStats(_ sessions: [SessionLog]) {
        let completedWorkSessions = sessions.filter { $0.isWorkSession && $0.isCompleted }
        let interruptedWorkSessions = sessions.filter { $0.isWorkSession && !$0.isCompleted }
        
        totalSessions = sessions.filter { $0.isWorkSession }.count
        completedSessions = completedWorkSessions.count
        interruptedSessions = interruptedWorkSessions.count
        
        totalFocusTime = completedWorkSessions.reduce(0) { $0 + $1.duration } / 60
        
        if completedSessions > 0 {
            averageSessionTime = totalFocusTime / Double(completedSessions)
        } else {
            averageSessionTime = 0
        }
    }
}
