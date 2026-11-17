import SwiftUI

struct ContentView: View {
    @AppStorage("userReligion") private var userReligion: String = ""
    
    var body: some View {
        if userReligion.isEmpty {
            ReligionSetupView {
                // Automatically transitions to HomeDashboardView once userReligion is set
            }
        } else {
            HomeDashboardView()
        }
    }
}