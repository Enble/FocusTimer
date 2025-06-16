//
//  StatisticsCalculator.swift
//  FocusTimer
//
//  Created by apple on 2025/06/16.
//

import Foundation

class FocusStatisticsCalculator {
    
    func calculateDailyStats(sessions: [SessionLog]) -> DailyStats {
        let completedSessions = sessions.filter { $0.isCompleted && $0.isWorkSession }
        let totalMinutes = completedSessions.reduce(0) { $0 + $1.duration } / 60
        let averageMinutes = completedSessions.isEmpty ? 0 : totalMinutes / Double(completedSessions.count)
        
        return DailyStats(
            totalMinutes: totalMinutes,
            sessionCount: completedSessions.count,
            averageSessionMinutes: averageMinutes
        )
    }
    
    func calculateWeeklyStats(sessions: [SessionLog]) -> WeeklyStats {
        let calendar = Calendar.current
        var dailyTotals: [Date: Double] = [:]
        
        for session in sessions where session.isCompleted && session.isWorkSession {
            if let startTime = session.startTime {
                let day = calendar.startOfDay(for: startTime)
                dailyTotals[day, default: 0] += session.duration / 60
            }
        }
        
        let totalMinutes = dailyTotals.values.reduce(0, +)
        let averageDailyMinutes = dailyTotals.isEmpty ? 0 : totalMinutes / Double(dailyTotals.count)
        
        return WeeklyStats(
            totalMinutes: totalMinutes,
            averageDailyMinutes: averageDailyMinutes,
            activeDays: dailyTotals.count
        )
    }
    
    func calculateMonthlyStats(sessions: [SessionLog]) -> MonthlyStats {
        let calendar = Calendar.current
        var weeklyTotals: [Int: Double] = [:]
        
        for session in sessions where session.isCompleted && session.isWorkSession {
            if let startTime = session.startTime {
                let weekOfMonth = calendar.component(.weekOfMonth, from: startTime)
                weeklyTotals[weekOfMonth, default: 0] += session.duration / 60
            }
        }
        
        let totalMinutes = weeklyTotals.values.reduce(0, +)
        let averageWeeklyMinutes = weeklyTotals.isEmpty ? 0 : totalMinutes / Double(weeklyTotals.count)
        
        return MonthlyStats(
            totalMinutes: totalMinutes,
            averageWeeklyMinutes: averageWeeklyMinutes,
            activeWeeks: weeklyTotals.count
        )
    }
    
    func getMostProductiveTimeSlot(sessions: [SessionLog]) -> String? {
        var timeSlotMinutes: [Int: Double] = [:]
        
        for session in sessions where session.isCompleted && session.isWorkSession {
            if let startTime = session.startTime {
                let hour = Calendar.current.component(.hour, from: startTime)
                let timeSlot = hour / 3 // 3시간 단위로 그룹화
                timeSlotMinutes[timeSlot, default: 0] += session.duration / 60
            }
        }
        
        guard let mostProductiveSlot = timeSlotMinutes.max(by: { $0.value < $1.value }) else {
            return nil
        }
        
        let startHour = mostProductiveSlot.key * 3
        let endHour = min(startHour + 3, 24)
        
        return "\(startHour)시 - \(endHour)시"
    }
    
    func getMostProductiveDay(sessions: [SessionLog]) -> String? {
        let calendar = Calendar.current
        var weekdayMinutes: [Int: Double] = [:]
        
        for session in sessions where session.isCompleted && session.isWorkSession {
            if let startTime = session.startTime {
                let weekday = calendar.component(.weekday, from: startTime)
                weekdayMinutes[weekday, default: 0] += session.duration / 60
            }
        }
        
        guard let mostProductiveDay = weekdayMinutes.max(by: { $0.value < $1.value }) else {
            return nil
        }
        
        let weekdayNames = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"]
        return weekdayNames[mostProductiveDay.key - 1]
    }
}

struct DailyStats {
    let totalMinutes: Double
    let sessionCount: Int
    let averageSessionMinutes: Double
}

struct WeeklyStats {
    let totalMinutes: Double
    let averageDailyMinutes: Double
    let activeDays: Int
}

struct MonthlyStats {
    let totalMinutes: Double
    let averageWeeklyMinutes: Double
    let activeWeeks: Int
}
