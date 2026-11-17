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