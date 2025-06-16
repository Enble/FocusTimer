//
//  TimerManager.swift
//  FocusTimer
//
//  Created by apple on 2025/06/16.
//

import Foundation
import Combine

class TimerManager: ObservableObject {
    @Published var remainingTime: TimeInterval = 0
    @Published var timerState: TimerState = .idle
    @Published var progress: Double = 1.0
    
    let sessionCompleted = PassthroughSubject<Void, Never>()
    
    private var timer: Timer?
    private var totalDuration: TimeInterval = 0
    
    init() {
        // 초기화
    }
    
    func setDuration(_ duration: TimeInterval) {
        totalDuration = duration
        remainingTime = duration
        progress = 1.0
    }
    
    func start() {
        timerState = .running
        startTimer()
    }
    
    func pause() {
        timerState = .paused
        timer?.invalidate()
        timer = nil
    }
    
    func resume() {
        timerState = .running
        startTimer()
    }
    
    func reset() {
        timer?.invalidate()
        timer = nil
        timerState = .idle
        remainingTime = totalDuration
        progress = 1.0
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.remainingTime > 0 {
                self.remainingTime -= 1
                self.progress = self.remainingTime / self.totalDuration
            } else {
                self.timer?.invalidate()
                self.timer = nil
                self.timerState = .idle
                self.sessionCompleted.send()
                self.reset()
            }
        }
    }
}
