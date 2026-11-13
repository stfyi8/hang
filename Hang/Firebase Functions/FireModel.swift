//
//  FireModel.swift
//  Hang
//
//  Created by Lim Shi Hui Serene     on 12/11/26.
//

import Foundation
import FirebaseFirestore

struct ProfileData: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
}
