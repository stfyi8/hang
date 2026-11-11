//
//  ContentView.swift
//  Hang
//
//  Created by Lim Shi Hui Serene     on 11/11/26.
//

import SwiftUI
import FirebaseSignInWithApple

struct ContentView: View {
    @State private var showingAlert : Bool = false
    @Environment(\.firebaseSignInWithApple) private var firebaseSignInWithApple
    var body: some View {
        VStack {
            
            Button {
                showingAlert = true
            } label: {
                Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    .foregroundStyle(.red)
            }.alert(isPresented: $showingAlert){
                Alert(
                    title: Text("Are you sure?"),
                    message: Text("Are you sure you want to sign out?"),
                    primaryButton:.default(Text("Confirm")){                 firebaseSignInWithApple.signOut()
                    },
                    secondaryButton: .cancel()
                )
                
            }
            
                
            
//            FirebaseDeleteAccountWithAppleButton{
//                FirebaseSignInWithAppleLabel(.deleteAccount)
//            }
// best use with delete data extension in firebase but need upgrade firebase to paid plan
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
