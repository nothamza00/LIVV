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