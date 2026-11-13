import SwiftUI
import FirebaseCore


@main
struct SwiftChallenge2App: App {
    init(){
        FirebaseApp.configure()
        print("configured Firebase")
        UISegmentedControl.appearance().selectedSegmentTintColor = .brown
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
