import Foundation
import SwiftUI
import Combine

enum TimerState {
    case idle
    case running
    case paused
}

class TimerViewModel: ObservableObject {
    @Published var timerState: TimerState = .idle
    @Published var isWorkSession = true
    @Published var remainingTime: TimeInterval = 0
    @Published var currentTaskTitle = ""
    @Published var progress: Double = 0
    
    private var timerManager: TimerManager
    private var notificationManager = NotificationManager()
    private var persistenceManager = PersistenceManager.shared
    private var settingsManager = SettingsManager()
    private var cancellables = Set<AnyCancellable>()
    
    private var sessionStartTime: Date?
    private var totalPausedTime: TimeInterval = 0
    private var pauseStartTime: Date?
    
    var timeString: String {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    init() {
        self.timerManager = TimerManager()
        setupBindings()
        updateTimerDuration()
    }
    
    private func setupBindings() {
        timerManager.$remainingTime
            .assign(to: &$remainingTime)
        
        timerManager.$timerState
            .assign(to: &$timerState)
        
        timerManager.$progress
            .assign(to: &$progress)
        
        timerManager.sessionCompleted
            .sink { [weak self] in
                self?.handleSessionCompletion()
            }
            .store(in: &cancellables)
    }
    
    func updateTimerDuration() {
        if timerState == .idle {
            let duration = isWorkSession ? settingsManager.focusDuration : settingsManager.breakDuration
            timerManager.setDuration(duration * 60)
            remainingTime = duration * 60
        }
    }
    
    func start() {
        sessionStartTime = Date()
        totalPausedTime = 0
        timerManager.start()
    }
    
    func pause() {
        pauseStartTime = Date()
        timerManager.pause()
    }
    
    func resume() {
        if let pauseStart = pauseStartTime {
            totalPausedTime += Date().timeIntervalSince(pauseStart)
        }
        pauseStartTime = nil
        timerManager.resume()
    }
    
    func reset() {
        timerManager.reset()
        if let startTime = sessionStartTime {
            // 중단된 세션 저장
            let actualDuration = Date().timeIntervalSince(startTime) - totalPausedTime
            persistenceManager.saveSession(
                title: currentTaskTitle.isEmpty ? "무제" : currentTaskTitle,
                duration: actualDuration,
                isCompleted: false,
                isWorkSession: isWorkSession,
                memo: nil
            )
        }
        sessionStartTime = nil
        totalPausedTime = 0
        currentTaskTitle = ""
    }
    
    func skipSession() {
        reset()
        toggleSessionType()
    }
    
    private func handleSessionCompletion() {
        // 세션 저장
        if let startTime = sessionStartTime {
            let actualDuration = Date().timeIntervalSince(startTime) - totalPausedTime
            persistenceManager.saveSession(
                title: currentTaskTitle.isEmpty ? (isWorkSession ? "집중 세션" : "휴식") : currentTaskTitle,
                duration: actualDuration,
                isCompleted: true,
                isWorkSession: isWorkSession,
                memo: nil
            )
        }
        
        // 알림 발송
        let message = isWorkSession ? "집중 시간이 끝났습니다. 휴식을 취하세요!" : "휴식이 끝났습니다. 다시 집중해봐요!"
        notificationManager.scheduleNotification(
            title: "포커스타이머",
            body: message,
            timeInterval: 0.1
        )
        
        // 세션 전환
        toggleSessionType()
        sessionStartTime = nil
        totalPausedTime = 0
        currentTaskTitle = ""
    }
    
    private func toggleSessionType() {
        isWorkSession.toggle()
        updateTimerDuration()
    }
}
