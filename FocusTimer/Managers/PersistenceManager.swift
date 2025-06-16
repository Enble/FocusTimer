import Foundation
import CoreData

class PersistenceManager {
    static let shared = PersistenceManager()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "FocusTimer")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func saveSession(title: String, duration: TimeInterval, isCompleted: Bool, isWorkSession: Bool, memo: String?) {
        let context = container.viewContext
        let session = SessionLog(context: context)
        
        session.id = UUID()
        session.title = title
        session.startTime = Date()
        session.duration = duration
        session.isCompleted = isCompleted
        session.isWorkSession = isWorkSession
        session.memo = memo
        
        do {
            try context.save()
        } catch {
            print("Failed to save session: \(error)")
        }
    }
    
    func fetchSessions() -> [SessionLog] {
        let request: NSFetchRequest<SessionLog> = SessionLog.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \SessionLog.startTime, ascending: false)]
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Failed to fetch sessions: \(error)")
            return []
        }
    }
    
    func fetchSessions(from startDate: Date, to endDate: Date) -> [SessionLog] {
        let request: NSFetchRequest<SessionLog> = SessionLog.fetchRequest()
        request.predicate = NSPredicate(
            format: "startTime >= %@ AND startTime <= %@ AND isWorkSession == true",
            startDate as NSDate,
            endDate as NSDate
        )
        request.sortDescriptors = [NSSortDescriptor(keyPath: \SessionLog.startTime, ascending: false)]
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Failed to fetch sessions: \(error)")
            return []
        }
    }
    
    func updateSession(_ session: SessionLog, memo: String) {
        session.memo = memo
        
        do {
            try container.viewContext.save()
        } catch {
            print("Failed to update session: \(error)")
        }
    }
    
    func deleteSession(_ session: SessionLog) {
        container.viewContext.delete(session)
        
        do {
            try container.viewContext.save()
        } catch {
            print("Failed to delete session: \(error)")
        }
    }
    
    // 모든 세션 데이터 삭제
    func deleteAllSessions() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = SessionLog.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try container.viewContext.execute(deleteRequest)
            try container.viewContext.save()
            print("All sessions deleted successfully")
        } catch {
            print("Failed to delete all sessions: \(error)")
        }
    }
    
    // 시연용 샘플 데이터 생성
    #if DEBUG
    func generateSampleData() {
        let calendar = Calendar.current
        let now = Date()
        
        // 지난 30일간의 샘플 데이터 생성
        for dayOffset in 0..<30 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: now) else { continue }
            
            // 하루에 3-8개의 세션 생성
            let sessionCount = Int.random(in: 3...8)
            
            for sessionIndex in 0..<sessionCount {
                let startHour = Int.random(in: 9...20)
                guard let sessionDate = calendar.date(bySettingHour: startHour, minute: sessionIndex * 30, second: 0, of: date) else { continue }
                
                let session = SessionLog(context: container.viewContext)
                session.id = UUID()
                session.title = ["개발 작업", "문서 작성", "회의 준비", "공부", "프로젝트", "리서치"].randomElement()!
                session.startTime = sessionDate
                session.duration = TimeInterval(25 * 60) // 25분
                session.isCompleted = Bool.random() || sessionIndex < sessionCount - 1
                session.isWorkSession = true
                session.memo = session.isCompleted ? nil : "중단됨"
                
                // 휴식 세션도 추가
                if sessionIndex < sessionCount - 1 {
                    guard let breakDate = calendar.date(byAdding: .minute, value: 25, to: sessionDate) else { continue }
                    let breakSession = SessionLog(context: container.viewContext)
                    breakSession.id = UUID()
                    breakSession.title = "휴식"
                    breakSession.startTime = breakDate
                    breakSession.duration = TimeInterval(5 * 60) // 5분
                    breakSession.isCompleted = true
                    breakSession.isWorkSession = false
                }
            }
        }
        
        do {
            try container.viewContext.save()
            print("Sample data generated successfully")
        } catch {
            print("Failed to generate sample data: \(error)")
        }
    }
    #endif
}
