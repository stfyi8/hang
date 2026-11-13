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
    @State private var userName = ""
    @State private var showNamePrompt = false
    @StateObject private var saveManager = SaveManager()
    
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
        }
        .onChange(of: saveManager.hasLoadedProfile) { _, loaded in
            guard loaded else { return }
            // Only accounts without a username get the prompt.
            let trimmedName = saveManager.profile?.username.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            showNamePrompt = trimmedName.isEmpty

        }
        .alert("Enter your username", isPresented: $showNamePrompt) {
            TextField("Your name", text: $userName) // saves to @AppStorage as they type
            Button("Done") {
                saveManager.addNote( name: userName)
                showNamePrompt = false
            }// comes up with a name prompt to add a username and saves it to firebase

                let trimmedName = userName.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmedName.isEmpty else { return }
                saveManager.addNote(username: trimmedName)
                userName = ""
            }// comes up with a name prompt to add a username and saves it to firebase
           

        }
    }


#Preview {
    ContentView()
}


//            FirebaseDeleteAccountWithAppleButton{
//                FirebaseSignInWithAppleLabel(.deleteAccount)
//            }
// best use with delete data extension in firebase but need upgrade firebase to paid plan

