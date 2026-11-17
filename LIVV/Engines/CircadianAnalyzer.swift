import Foundation

class CircadianAnalyzer {
    static let shared = CircadianAnalyzer()
    
    // Computes intelligent reminder spacing based on wake hours locally
    func calculateDailySchedule(targetCount: Int) -> [Date] {
        let calendar = Calendar.current
        let now = Date()
        
        let startHour = 8 // 8:00 AM morning start
        let endHour = 22  // 10:00 PM wind-down
        
        var reminders: [Date] = []
        let intervalMinutes = (Double(endHour - startHour) * 60.0) / Double(targetCount)
        
        for i in 0..<targetCount {
            let minutesToAdd = Double(i) * intervalMinutes
            if let reminderTime = calendar.date(bySettingHour: startHour, minute: 0, second: 0, of: now)?
                .addingTimeInterval(minutesToAdd * 60) {
                reminders.append(reminderTime)
            }
        }
        return reminders
    }
    
    // Automatically mutes alerts during sleep window (11 PM to 7 AM)
    func isNightModeActive() -> Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour < 7 || hour >= 23
    }
}