//
//  MainView.swift
//  Hang
//
//  Created by Lim Shi Hui Serene     on 11/11/26.
//

import SwiftUI
import FirebaseSignInWithApple

struct MainView: View {
    
    @Environment(\.firebaseSignInWithApple) private var firebaseSignInWithApple
    
    var body: some View {
        Group{
            switch firebaseSignInWithApple.state {
            case .loading:
                ProgressView()
            case .authenticating:
                ProgressView()
            case .notAuthenticated:
                AuthView()
            case .authenticated:
                ContentView()
            }
        }
        .onChange(of: firebaseSignInWithApple.state) { oldValue, newValue in print("FirebaseSignInWithApple state changed from \(oldValue) to \(newValue)")}
    }
}

#Preview {
    MainView()
}
