import SwiftUI

@main
struct LIVVApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark) // Locks the app to your black minimal aesthetic
        }
    }
}
2. App/ContentView.swift
Swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeDashboardView()
    }
}
3. Engines/CircadianAnalyzer.swift
Swift
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
4. Views/HomeDashboardView.swift
Swift
import SwiftUI

struct HomeDashboardView: View {
    @State private var waterCount = 3
    @State private var targetWater = 8
    @State private var showingSetup = false
    @State private var showingSoundMixer = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("LIVV")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text(CircadianAnalyzer.shared.isNightModeActive() ? "🌙 Night Wind-Down Active" : "☀️ Daytime Circadian Active")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    
                    // Sound Mixer Quick Button
                    Button(action: { showingSoundMixer = true }) {
                        Image(systemName: "waveform.circle.fill")
                            .font(.system(size: 26))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)
                
                // Progress Ring Banner
                VStack(spacing: 8) {
                    Text("\(waterCount * 250) ml / \(targetWater * 250) ml")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Daily Hydration Target")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 28)
                .background(Color(.systemGray6).opacity(0.1))
                .cornerRadius(20)
                .padding(.horizontal, 20)
                
                // 2x2 Big Habit Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    HabitTile(title: "Water", icon: "drop.fill", subtitle: "\(waterCount)/\(targetWater) logged") {
                        showingSetup = true
                    }
                    HabitTile(title: "Walk", icon: "figure.walk", subtitle: "2.4 km today") {
                        showingSetup = true
                    }
                    HabitTile(title: "Workout", icon: "dumbbell.fill", subtitle: "Rest Day") {
                        showingSetup = true
                    }
                    HabitTile(title: "Sleep Sync", icon: "moon.stars.fill", subtitle: "Multi-track audio") {
                        showingSoundMixer = true
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.top, 20)
        }
        .sheet(isPresented: $showingSetup) {
            ReminderSetupSheet()
        }
        .sheet(isPresented: $showingSoundMixer) {
            SoundMixerSheet()
        }
    }
}

struct HabitTile: View {
    var title: String
    var icon: String
    var subtitle: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background(Color(.systemGray6).opacity(0.08))
            .cornerRadius(18)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }
}
5. Views/ReminderSetupSheet.swift
Swift
import SwiftUI

struct ReminderSetupSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var reminderCount = 8
    @State private var selectedSound = "Water Drop"
    let sounds = ["Water Drop", "Gentle Chime", "Soft Beep", "Subtle Pulse", "Vibration Haptic"]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 24) {
                // Header
                HStack {
                    Text("Configure Reminder")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Button("Done") { dismiss() }
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .semibold))
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Frequency Stepper
                VStack(alignment: .leading, spacing: 10) {
                    Text("Daily Reminders: \(reminderCount) times")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    Slider(value: Binding(
                        get: { Double(reminderCount) },
                        set: { reminderCount = Int($0) }
                    ), in: 1...14, step: 1)
                    .accentColor(.white)
                }
                .padding(20)
                .background(Color(.systemGray6).opacity(0.08))
                .cornerRadius(16)
                .padding(.horizontal, 20)
                
                // Sound Selector
                VStack(alignment: .leading, spacing: 12) {
                    Text("Alert Sound")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    ForEach(sounds, id: \.self) { sound in
                        Button(action: { selectedSound = sound }) {
                            HStack {
                                Text(sound)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                Spacer()
                                if selectedSound == sound {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                            .background(selectedSound == sound ? Color.white.opacity(0.1) : Color.clear)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(20)
                .background(Color(.systemGray6).opacity(0.08))
                .cornerRadius(16)
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
}
6. Views/SoundMixerSheet.swift
Swift
import SwiftUI

struct SoundMixerSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var rainVolume: Double = 0.6
    @State private var cricketVolume: Double = 0.0
    @State private var birdVolume: Double = 0.2
    @State private var windVolume: Double = 0.0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Sleep Sync Mixer")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        Text("Layer multiple sounds simultaneously")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button("Done") { dismiss() }
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .semibold))
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Sliders
                VStack(spacing: 16) {
                    SoundSliderRow(title: "🌧 Rooftop Rain", volume: $rainVolume)
                    SoundSliderRow(title: "🦗 Night Crickets", volume: $cricketVolume)
                    SoundSliderRow(title: "🐦 Morning Birds", volume: $birdVolume)
                    SoundSliderRow(title: "💨 Deep Night Wind", volume: $windVolume)
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
}

struct SoundSliderRow: View {
    var title: String
    @Binding var volume: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .medium))
                Spacer()
                Text("\(Int(volume * 100))%")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            }
            Slider(value: $volume, in: 0...1)
                .accentColor(.white)
        }
        .padding(16)
        .background(Color(.systemGray6).opacity(0.08))
        .cornerRadius(14)
    }
}
7. Engines/AudioManager.swift
Swift
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    
    private var players: [String: AVAudioPlayer] = [:]
    
    // Placeholder engine for multi-track audio playback using AVFoundation
    func setVolume(for sound: String, volume: Float) {
        // Multi-channel volume control logic for local audio tracks
        players[sound]?.volume = volume
    }
}