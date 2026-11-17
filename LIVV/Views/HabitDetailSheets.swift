import SwiftUI

// 1. PRAYER SCHEDULE SHEET
struct PrayerScheduleSheet: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("userReligion") private var userReligion: String = "Muslim"
    @State private var prayerTimes: [String: Date] = [:]
    
    var prayers: [String] {
        ReligiousCalendarEngine.shared.getPrayerList(for: userReligion)
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("\(userReligion) Prayers")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Button("Done") { dismiss() }.foregroundColor(.white)
                }
                .padding(.top, 20)
                
                Text(ReligiousCalendarEngine.shared.getCalendarMilestone(for: userReligion))
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                
                ForEach(prayers, id: \.self) { prayer in
                    HStack {
                        Text(prayer).foregroundColor(.white).font(.system(size: 16, weight: .medium))
                        Spacer()
                        DatePicker("", selection: Binding(
                            get: { prayerTimes[prayer] ?? Date() },
                            set: { prayerTimes[prayer] = $0 }
                        ), displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .colorScheme(.dark)
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.08))
                    .cornerRadius(14)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
}

// 2. WALK & MOTION SENSOR SHEET
struct WalkSensorSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var sensor = StepSensorManager.shared
    @AppStorage("dailyStepGoal") private var stepGoal: Int = 8000
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("Walk & Step Sensor")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Button("Done") { dismiss() }.foregroundColor(.white)
                }
                .padding(.top, 20)
                
                VStack(spacing: 8) {
                    Text("\(sensor.steps)")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text(String(format: "%.2f km • Target: %d steps", sensor.distanceKm, stepGoal))
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 28)
                .background(Color(.systemGray6).opacity(0.08))
                .cornerRadius(18)
                
                Stepper("Daily Step Goal: \(stepGoal)", value: $stepGoal, in: 2000...20000, step: 1000)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(.systemGray6).opacity(0.08))
                    .cornerRadius(14)
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .onAppear { sensor.startTracking() }
    }
}

// 3. CUSTOM WORKOUT SHEET
struct WorkoutSetupSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var workoutTime = Date()
    @State private var selectedDays: Set<String> = ["Mon", "Wed", "Fri"]
    let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("Workout Reminder")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Button("Done") { dismiss() }.foregroundColor(.white)
                }
                .padding(.top, 20)
                
                HStack(spacing: 8) {
                    ForEach(days, id: \.self) { day in
                        Button(action: {
                            if selectedDays.contains(day) { selectedDays.remove(day) }
                            else { selectedDays.insert(day) }
                        }) {
                            Text(day)
                                .font(.system(size: 12, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(selectedDays.contains(day) ? Color.white : Color(.systemGray6).opacity(0.1))
                                .foregroundColor(selectedDays.contains(day) ? .black : .white)
                                .cornerRadius(10)
                        }
                    }
                }
                
                DatePicker("Reminder Time", selection: $workoutTime, displayedComponents: .hourAndMinute)
                    .foregroundColor(.white)
                    .colorScheme(.dark)
                    .padding()
                    .background(Color(.systemGray6).opacity(0.08))
                    .cornerRadius(14)
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
}