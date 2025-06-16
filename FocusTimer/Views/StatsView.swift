//
//  StatsView.swift
//  FocusTimer
//
//  Created by apple on 2025/06/16.
//

import SwiftUI
import Charts

struct StatsView: View {
    @StateObject private var viewModel = StatsViewModel()
    @State private var selectedPeriod = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 기간 선택
                    Picker("기간", selection: $selectedPeriod) {
                        Text("일간").tag(0)
                        Text("주간").tag(1)
                        Text("월간").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // 총 집중 시간 카드
                    StatsCard(
                        title: "총 집중 시간",
                        value: formatTime(viewModel.totalFocusTime),
                        subtitle: "총 \(viewModel.totalSessions)개 세션"
                    )
                    
                    // 평균 세션 시간 카드
                    StatsCard(
                        title: "평균 세션",
                        value: formatTime(viewModel.averageSessionTime),
                        subtitle: nil
                    )
                    
                    // 목표 달성률
                    if selectedPeriod == 0 || selectedPeriod == 1 {
                        GoalProgressView(viewModel: viewModel, isDaily: selectedPeriod == 0)
                    }
                    
                    // 차트
                    switch selectedPeriod {
                    case 0:
                        DailyChartView(data: viewModel.hourlyData)
                    case 1:
                        WeeklyChartView(data: viewModel.weeklyData)
                    case 2:
                        MonthlyChartView(data: viewModel.monthlyData)
                    default:
                        EmptyView()
                    }
                    
                    // 세션 상태 분포
                    SessionStatusView(
                        completed: viewModel.completedSessions,
                        interrupted: viewModel.interruptedSessions
                    )
                    
                    // 작업별 분석 (주간만)
                    if selectedPeriod == 1 && !viewModel.taskBreakdown.isEmpty {
                        TaskBreakdownView(data: viewModel.taskBreakdown)
                    }
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("통계")
            .onAppear {
                viewModel.loadData(for: PeriodType(rawValue: selectedPeriod) ?? .daily)
            }
            .onChange(of: selectedPeriod) { _ in
                viewModel.loadData(for: PeriodType(rawValue: selectedPeriod) ?? .daily)
            }
        }
    }
    
    private func formatTime(_ minutes: Double) -> String {
        if minutes < 60 {
            return String(format: "%.0f분", minutes)
        } else {
            let hours = Int(minutes) / 60
            let mins = Int(minutes) % 60
            return String(format: "%d시간 %d분", hours, mins)
        }
    }
}

struct StatsCard: View {
    let title: String
    let value: String
    let subtitle: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.system(size: 32, weight: .bold, design: .rounded))
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct GoalProgressView: View {
    @ObservedObject var viewModel: StatsViewModel
    @EnvironmentObject var settingsManager: SettingsManager
    let isDaily: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(isDaily ? "일일 목표" : "주간 목표")
                .font(.headline)
            
            HStack {
                Text("\(Int(viewModel.totalFocusTime))분")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("/")
                    .foregroundColor(.secondary)
                
                Text("\(Int(isDaily ? settingsManager.dailyGoal : settingsManager.weeklyGoal))분")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 12)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(progressColor)
                        .frame(width: geometry.size.width * progressPercentage, height: 12)
                }
            }
            .frame(height: 12)
            
            Text("\(Int(progressPercentage * 100))% 달성")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var progressPercentage: Double {
        let goal = isDaily ? settingsManager.dailyGoal : settingsManager.weeklyGoal
        return min(viewModel.totalFocusTime / goal, 1.0)
    }
    
    private var progressColor: Color {
        if progressPercentage >= 1.0 {
            return .green
        } else if progressPercentage >= 0.7 {
            return .yellow
        } else {
            return .blue
        }
    }
}

struct DailyChartView: View {
    let data: [HourlyData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("시간대별 집중 시간")
                .font(.headline)
                .padding(.horizontal)
            
            Chart(data) { item in
                BarMark(
                    x: .value("시간", item.hour),
                    y: .value("분", item.minutes)
                )
                .foregroundStyle(Color.blue.gradient)
            }
            .frame(height: 200)
            .padding(.horizontal)
        }
    }
}

struct WeeklyChartView: View {
    let data: [WeeklyData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("요일별 집중 시간")
                .font(.headline)
                .padding(.horizontal)
            
            Chart(data) { item in
                BarMark(
                    x: .value("요일", item.dayName),
                    y: .value("분", item.minutes)
                )
                .foregroundStyle(Color.blue.gradient)
            }
            .frame(height: 200)
            .padding(.horizontal)
        }
    }
}

struct MonthlyChartView: View {
    let data: [DailyData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("일별 집중 시간 추이")
                .font(.headline)
                .padding(.horizontal)
            
            Chart(data) { item in
                LineMark(
                    x: .value("날짜", item.date, unit: .day),
                    y: .value("분", item.minutes)
                )
                .foregroundStyle(Color.blue.gradient)
                .symbol {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 6, height: 6)
                }
            }
            .frame(height: 200)
            .padding(.horizontal)
        }
    }
}

struct SessionStatusView: View {
    let completed: Int
    let interrupted: Int
    
    var total: Int {
        completed + interrupted
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("세션 상태")
                .font(.headline)
            
            HStack(spacing: 20) {
                VStack {
                    Text("\(completed)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("완료됨")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text("\(interrupted)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    
                    Text("중단됨")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
            
            if total > 0 {
                GeometryReader { geometry in
                    HStack(spacing: 2) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.green)
                            .frame(width: geometry.size.width * (Double(completed) / Double(total)))
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.red)
                    }
                }
                .frame(height: 8)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct TaskBreakdownView: View {
    let data: [(String, Double)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("작업별 분석")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 8) {
                ForEach(data, id: \.0) { task, minutes in
                    HStack {
                        Text(task)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Text(formatTime(minutes))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical, 8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    private func formatTime(_ minutes: Double) -> String {
        if minutes < 60 {
            return String(format: "%.0f분", minutes)
        } else {
            let hours = Int(minutes) / 60
            let mins = Int(minutes) % 60
            return String(format: "%d시간 %d분", hours, mins)
        }
    }
}
