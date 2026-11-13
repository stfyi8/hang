//
//  FireFunc.swift
//  Hang
//
//  Created by Lim Shi Hui Serene on 12/11/26.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Combine

class SaveManager: ObservableObject {
    private var db = Firestore.firestore()
    @Published var profile: ProfileData?
    // True once the first snapshot has come back (or failed), so views know the
    // difference between "still loading" and "this account really has no username".
    @Published var hasLoadedProfile = false
    private var listener: ListenerRegistration?

    // Each Apple account gets its own document: Profiles/<firebase uid>
    private var profileDocument: DocumentReference? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return db.collection(Path.Firestore.profiles).document(uid)
    }

    // Create / update the signed-in user's own profile
    func saveUsername(_ username: String) {
        guard let profileDocument else { return }
        do {
            // merge: true keeps the userId field written by FirebaseSignInWithApple
            try profileDocument.setData(from: ProfileData(username: username), merge: true)
        } catch {
            print("Error saving profile: \(error)")
        }
    }

    // Read the signed-in user's own profile
    func loadProfile() {
        listener?.remove()
        hasLoadedProfile = false
        guard let profileDocument else {
            profile = nil
            hasLoadedProfile = true
            return
        }

        // Same document ID as the one FirebaseSignInWithApple created on sign in,
        // so this only ever listens to the current user's data.
        listener = profileDocument.addSnapshotListener { [weak self] snapshot, error in
            guard let self else { return }
            Task { @MainActor in
                // Every path below finishes the load, including errors, so the UI
                // doesn't sit waiting forever.
                self.hasLoadedProfile = true

                if let error {
                    print("Error getting profile: \(error)")
                    return
                }
                guard let snapshot, snapshot.exists else {
                    self.profile = nil  // no profile saved for this account yet
                    return
                }
                self.profile = try? snapshot.data(as: ProfileData.self)
            }
        }
    }

    // Delete the signed-in user's profile
    func deleteProfile(_ profile: ProfileData) {
        guard let profileID = profile.id else { return }

        db.collection(Path.Firestore.profiles).document(profileID).delete { error in
            if let error {
                print("Error deleting profile: \(error)")
            }
        }
    }
}
