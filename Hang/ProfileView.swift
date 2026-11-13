//
//  ProfileView.swift
//  Hang
//
//  Created by Lim Shi Hui Serene on 13/11/26.
//

import SwiftUI
import FirebaseSignInWithApple

struct ProfileView: View {
    @State private var showingAlert = false
    @Environment(\.firebaseSignInWithApple) private var firebaseSignInWithApple
    @StateObject private var saveManager = SaveManager()

    var body: some View {
        VStack {
            Text(saveManager.profile?.username ?? "Loading…")

            Button {
                showingAlert = true
            } label: {
                Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    .foregroundStyle(.red)
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Are you sure?"),
                    message: Text("Are you sure you want to sign out?"),
                    primaryButton: .default(Text("Confirm")) {
                        firebaseSignInWithApple.signOut()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .task {
            saveManager.loadProfile()
        }
    }
}

#Preview {
    ProfileView()
}
