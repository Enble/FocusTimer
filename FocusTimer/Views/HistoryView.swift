//
//  HistoryView.swift
//  FocusTimer
//
//  Created by apple on 2025/06/16.
//

import SwiftUI
import CoreData

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @State private var selectedSegment = 0
    @State private var editingSession: SessionLog?
    @State private var showingMemoEditor = false
    
    var body: some View {
        NavigationView {
            VStack {
                // 세그먼트 컨트롤
                Picker("세션 타입", selection: $selectedSegment) {
                    Text("전체").tag(0)
                    Text("완료됨").tag(1)
                    Text("중단됨").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // 세션 목록
                if viewModel.filteredSessions.isEmpty {
                    EmptyStateView()
                } else {
                    List {
                        ForEach(viewModel.groupedSessions.keys.sorted(by: >), id: \.self) { date in
                            Section(header: Text(formatSectionHeader(date))) {
                                ForEach(viewModel.groupedSessions[date] ?? []) { session in
                                    SessionRowView(session: session)
                                        .onTapGesture {
                                            editingSession = session
                                            showingMemoEditor = true
                                        }
                                }
                                .onDelete { indexSet in
                                    deleteSession(at: indexSet, for: date)
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("세션 기록")
            .sheet(isPresented: $showingMemoEditor) {
                if let session = editingSession {
                    MemoEditorView(session: session) {
                        viewModel.refreshData()
                    }
                }
            }
            .onAppear {
                viewModel.refreshData()
            }
            .onChange(of: selectedSegment) { _ in
                viewModel.filterSessions(by: FilterType(rawValue: selectedSegment) ?? .all)
            }
        }
    }
    
    private func formatSectionHeader(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        
        if Calendar.current.isDateInToday(date) {
            return "오늘"
        } else if Calendar.current.isDateInYesterday(date) {
            return "어제"
        } else {
            formatter.dateFormat = "M월 d일 (EEEE)"
            return formatter.string(from: date)
        }
    }
    
    private func deleteSession(at offsets: IndexSet, for date: Date) {
        guard let sessions = viewModel.groupedSessions[date] else { return }
        for index in offsets {
            viewModel.deleteSession(sessions[index])
        }
    }
}

struct SessionRowView: View {
    let session: SessionLog
    
    var body: some View {
        HStack {
            // 완료 상태 아이콘
            Image(systemName: session.isCompleted ? "checkmark.circle.fill" : "xmark.circle")
                .foregroundColor(session.isCompleted ? .green : .red)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(session.title ?? "무제")
                    .font(.headline)
                
                HStack {
                    Text(formatTime(session.startTime ?? Date()))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text(formatDuration(session.duration))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let memo = session.memo, !memo.isEmpty {
                    Text(memo)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            if !session.isWorkSession {
                Text("휴식")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.2))
                    .foregroundColor(.green)
                    .cornerRadius(4)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm"
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d분 %d초", minutes, seconds)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("아직 기록된 세션이 없습니다")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("타이머를 시작하여 첫 집중 세션을 기록해보세요!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MemoEditorView: View {
    let session: SessionLog
    @State private var memo: String = ""
    let onSave: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // 세션 정보
                VStack(alignment: .leading, spacing: 8) {
                    Text(session.title ?? "무제")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Label(formatDate(session.startTime ?? Date()), systemImage: "calendar")
                        Spacer()
                        Label(formatDuration(session.duration), systemImage: "clock")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                // 메모 입력
                VStack(alignment: .leading, spacing: 8) {
                    Text("메모")
                        .font(.headline)
                    
                    TextEditor(text: $memo)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .frame(minHeight: 150)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("세션 상세")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        PersistenceManager.shared.updateSession(session, memo: memo)
                        onSave()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                memo = session.memo ?? ""
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d분 %d초", minutes, seconds)
    }
}
