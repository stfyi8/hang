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
    @AppStorage("username") private var userName = ""
    @State private var showNamePrompt = false
    @ObservedObject var saveManager: SaveManager
    
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
            
    }
        .onAppear {
            saveManager.getNotes()
            if userName.isEmpty {
                showNamePrompt = true
            }
        }
        .alert("Enter your username", isPresented: $showNamePrompt) {
            TextField("Your name", text: $userName) // saves to @AppStorage as they type
            Button("Done") {
                saveManager.addNote( name: userName)
                showNamePrompt = false
            }// comes up with a name prompt to add a username and saves it to firebase
        }
        .padding()
    }
}

#Preview {
    ContentView(saveManager: SaveManager())
}


//            FirebaseDeleteAccountWithAppleButton{
//                FirebaseSignInWithAppleLabel(.deleteAccount)
//            }
// best use with delete data extension in firebase but need upgrade firebase to paid plan

