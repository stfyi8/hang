//
//  FireFunc.swift
//  Hang
//
//  Created by Lim Shi Hui Serene     on 12/11/26.
//

import SwiftUI
import FirebaseFirestore
import Combine

class SaveManager: ObservableObject {
    private var db = Firestore.firestore()
    @Published var profiles = [ProfileData]()
    private var listener: ListenerRegistration? //
    
    // Create Note
    func addNote(name: String) {
        do {
            _ = try db.collection("Profiles").document(ProfileData.accountName).setData(from: ProfileData( username: name ))// saves usename data to aour respective apple account in theory
        } catch {
            print("Error saving score: \(error)") // in case got error this is a failsafe
        }
    }
    
    // Read Notes
    func getNotes() {
        listener?.remove()
        listener = db.collection("Profiles").order(by: "name", descending: true).addSnapshotListener { snapshot, error in
            //sorts in descending alphabetical (.order(by: "model var name", descending: true)) addSnapshotListener triggers when it detects an update
            if let error = error {
                print("Error getting scores: \(error)")
                return
            }
            self.profiles = snapshot?.documents.compactMap { document in // loops through the list of data
                try? document.data(as: ProfileData.self) // converts the raw text to the Swift note object
            } ?? [] //failsafe, incase got no data default note to blank
        }
    }
    
    
    // Delete Note
    func deleteNote(save: ProfileData) {
        guard let noteID = save.id else { return }
        
        db.collection("Profiles").document(noteID).delete { error in
            if let error = error {
                print("Error deleting score: \(error)")
            }
        }
    }
}

