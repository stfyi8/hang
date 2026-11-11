//
//  HangApp.swift
//  Hang
//
//  Created by Lim Shi Hui Serene     on 11/11/26.
//

import SwiftUI
import FirebaseCore


@main
struct SwiftChallenge2App: App {
    init(){
        FirebaseApp.configure()
        print("configured Firebase")
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
