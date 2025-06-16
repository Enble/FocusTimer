//
//  HistoryViewModel.swift
//  FocusTimer
//
//  Created by apple on 2025/06/16.
//

import Foundation
import CoreData

enum FilterType: Int {
    case all = 0
    case completed = 1
    case interrupted = 2
}

class HistoryViewModel: ObservableObject {
    @Published var sessions: [SessionLog] = []
    @Published var filteredSessions: [SessionLog] = []
    @Published var groupedSessions: [Date: [SessionLog]] = [:]
    
    private let persistenceManager = PersistenceManager.shared
    private var currentFilter: FilterType = .all
    
    init() {
        refreshData()
    }
    
    func refreshData() {
        sessions = persistenceManager.fetchSessions()
        filterSessions(by: currentFilter)
    }
    
    func filterSessions(by filter: FilterType) {
        currentFilter = filter
        
        switch filter {
        case .all:
            filteredSessions = sessions
        case .completed:
            filteredSessions = sessions.filter { $0.isCompleted }
        case .interrupted:
            filteredSessions = sessions.filter { !$0.isCompleted }
        }
        
        groupSessionsByDate()
    }
    
    private func groupSessionsByDate() {
        groupedSessions = Dictionary(grouping: filteredSessions) { session in
            Calendar.current.startOfDay(for: session.startTime ?? Date())
        }
    }
    
    func deleteSession(_ session: SessionLog) {
        persistenceManager.deleteSession(session)
        refreshData()
    }
}
