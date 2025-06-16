//
//  NotificationManager.swift
//  FocusTimer
//
//  Created by apple on 2025/06/16.
//

import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    @Published var isAuthorized = false
    
    init() {
        checkAuthorizationStatus()
    }
    
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        
        // 먼저 현재 권한 상태 확인
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                // 권한 요청
                center.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
                    DispatchQueue.main.async {
                        self?.isAuthorized = granted
                    }
                    
                    if let error = error {
                        print("Notification authorization error: \(error)")
                    }
                }
            case .denied:
                // 설정으로 이동 안내
                DispatchQueue.main.async { [weak self] in
                    self?.isAuthorized = false
                    print("알림 권한이 거부되었습니다. 설정에서 권한을 허용해주세요.")
                }
            case .authorized:
                DispatchQueue.main.async { [weak self] in
                    self?.isAuthorized = true
                }
            default:
                break
            }
        }
    }
    
    func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval) {
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
