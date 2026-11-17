import SwiftUI

enum ActiveSheet: Identifiable {
    case water, walk, workout, prayers, mixer
    var id: Int { hashValue }
}

struct HomeDashboardView: View {
    @AppStorage("userReligion") private var userReligion: String = "Muslim"
    @ObservedObject var stepSensor = StepSensorManager.shared
    @State private var waterCount = 3
    @State private var targetWater = 8
    @State private var activeSheet: ActiveSheet?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header with Lunar/Religious Milestone
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("LIVV")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text(ReligiousCalendarEngine.shared.getCalendarMilestone(for: userReligion))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button(action: { activeSheet = .mixer }) {
                        Image(systemName: "waveform.circle.fill")
                            .font(.system(size: 26))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)
                
                // Hydration Banner
                VStack(spacing: 8) {
                    Text("\(waterCount * 250) ml / \(targetWater * 250) ml")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Daily Hydration Target")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(Color(.systemGray6).opacity(0.1))
                .cornerRadius(20)
                .padding(.horizontal, 20)
                
                // 2x2 Big Habit Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    HabitTile(title: "Water", icon: "drop.fill", subtitle: "\(waterCount)/\(targetWater) logged") {
                        activeSheet = .water
                    }
                    HabitTile(title: "Walk", icon: "figure.walk", subtitle: "\(stepSensor.steps) steps") {
                        activeSheet = .walk
                    }
                    HabitTile(title: "Workout", icon: "dumbbell.fill", subtitle: "Custom schedule") {
                        activeSheet = .workout
                    }
                    HabitTile(title: "Prayers", icon: "sparkles", subtitle: "\(userReligion) times") {
                        activeSheet = .prayers
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.top, 20)
        }
        .onAppear { stepSensor.startTracking() }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .water: ReminderSetupSheet()
            case .walk: WalkSensorSheet()
            case .workout: WorkoutSetupSheet()
            case .prayers: PrayerScheduleSheet()
            case .mixer: SoundMixerSheet()
            }
        }
    }
}