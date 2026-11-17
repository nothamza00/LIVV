import Foundation

enum Religion: String, CaseIterable, Codable {
    case muslim = "Muslim"
    case hindu = "Hindu"
    case christian = "Christian"
    case sikh = "Sikh"
    case buddhist = "Buddhist"
    case other = "General / Reflection"
}

class ReligiousCalendarEngine {
    static let shared = ReligiousCalendarEngine()
    
    // Returns prayer list based on selected religion
    func getPrayerList(for religionString: String) -> [String] {
        guard let religion = Religion(rawValue: religionString) else {
            return ["Morning Reflection", "Evening Reflection"]
        }
        
        switch religion {
        case .muslim:
            return ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"]
        case .hindu:
            return ["Brahma Muhurta (Morning)", "Sandhya Vandanam (Evening)"]
        case .christian:
            return ["Morning Prayer", "Midday Pause", "Evening Vespers"]
        case .sikh:
            return ["Nitnem (Morning - Japji Sahib)", "Rehraas Sahib (Evening)", "Kirt Sohila (Night)"]
        case .buddhist:
            return ["Morning Mindfulness", "Evening Chanting"]
        case .other:
            return ["Morning Intentions", "Gratitude Check"]
        }
    }
    
    // Returns offline lunar/seasonal calendar info
    func getCalendarMilestone(for religionString: String) -> String {
        guard let religion = Religion(rawValue: religionString) else {
            return "Local Routine Calendar"
        }
        
        switch religion {
        case .muslim:
            return "🌙 Islamic Lunar Calendar Active"
        case .hindu:
            return "🕉 Panchang & Tithi Tracker Active"
        case .christian:
            return "✝ Christian Liturgical Calendar"
        case .sikh:
            return "🪯 Nanakshahi Calendar Active"
        case .buddhist:
            return "☸ Lunar Uposatha Calendar"
        case .other:
            return "✨ Season & Solar Rhythm Active"
        }
    }
}