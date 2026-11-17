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