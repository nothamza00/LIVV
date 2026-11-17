import SwiftUI

struct ReligionSetupView: View {
    @AppStorage("userReligion") private var userReligion: String = ""
    var onComplete: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("LIVV")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Select your tradition for localized prayer reminders and lunar calendar tracking.")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .padding(.top, 40)
                
                VStack(spacing: 12) {
                    ForEach(Religion.allCases, id: \.self) { religion in
                        Button(action: {
                            userReligion = religion.rawValue
                            onComplete()
                        }) {
                            HStack {
                                Text(religion.rawValue)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray)
                            }
                            .padding(20)
                            .background(Color(.systemGray6).opacity(0.08))
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
}