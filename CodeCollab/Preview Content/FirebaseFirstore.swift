//
//  FirebaseFirstore.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 3/9/25.
//

//import FirebaseFirestore
//import CryptoKit
//class FirestoreBase {
//    let db: Firestore
//    init(firestore: Firestore? = nil) {
//        self.db = firestore ?? Firestore.firestore()
//    }
//    func hashPassword(_ password: String) -> String {
//        let data = Data(password.utf8)
//        let digest = SHA256.hash(data: data)
//        return digest.map { String(format: "%02hhx", $0) }.joined()
//    }
//    func executeQuery(_ query: @escaping () async throws -> Void) async throws {
//        do {
//            try await query()
//        } catch {
//            print("Firestore error: \(error)")
//            throw error
//        }
//    }
//}
