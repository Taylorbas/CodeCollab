//
//  Queries.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 11/26/24.
//

//import FirebaseFirestore
//import Foundation
//import CryptoKit
//
//class FirestoreQueries {
//    private let db: Firestore
//    private let smartContractService = SmartContractService()
//    private let blockchainServices = BlockchainServices()
//
//    init(firestore: Firestore? = nil) {
//        self.db = firestore ?? Firestore.firestore()
//    }
//
//    // Method to get user by email
//    func getUserByEmail(email: String, completion: @escaping (Result<[String: Any]?, Error>) -> Void) {
//        db.collection("users").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
//            if let error = error {
//                completion(.failure(error))
//            } else if let document = snapshot?.documents.first {
//                completion(.success(document.data()))
//            } else {
//                completion(.success(nil))
//            }
//        }
//    }
//
//    // Register a new user
//    func registerUser(
//        parksideID: String,
//        rangerEmail: String,
//        username: String,
//        role: String,
//        bio: String? = nil,
//        profilePicture: String? = nil,
//        completion: @escaping (Result<Void, Error>) -> Void
//    ) {
//        Task {
//            do {
//                // Step 1: Register the student on the blockchain
//                try await smartContractService.registerStudent(parksideID: parksideID, rangerEmail: rangerEmail)
//                
//                // Step 2: Generate Ethereum address
//                let privateKey = blockchainServices.generateEthereumKey()
//                let ethereumAddress = blockchainServices.getEthereumAddress(privateKey: privateKey)
//                
//                // Step 3: Add student details to Firestore
//                let newUser: [String: Any] = [
//                    "username": username,
//                    "email": rangerEmail,
//                    "ethereumAddress": ethereumAddress,
//                    "role": role,
//                    "bio": bio ?? "",
//                    "profilePicture": profilePicture ?? "",
//                    "parksideID": parksideID,
//                    "createdAt": FieldValue.serverTimestamp(),
//                    "isValidated": true
//                ]
//                _ = try await db.collection("students").addDocument(data: newUser)
//                
//                // Step 4: Notify user
//                try await blockchainServices.sendEthereumAddress(to: rangerEmail)
//                completion(.success(()))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//    }
//
//    // Helper function to hash passwords
//    func hashPassword(password: String) -> String {
//        let hashed = SHA256.hash(data: password.data(using: .utf8) ?? Data())
//        return hashed.compactMap { String(format: "%02x", $0) }.joined()
//    }
//
//    // Update a user's password
//    func setPassword(userId: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        let hashedPassword = hashPassword(password: password)
//        db.collection("users").document(userId).updateData(["password": hashedPassword]) { error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(()))
//            }
//        }
//    func addAnalyticsRecord(materialID: String, userID: String, type: String) async throws {
//            let data: [String: Any] = [
//                "material_ID": materialID,
//                "user_ID": userID,
//                "type": type,
//                "timeStamp": FieldValue.serverTimestamp()
//            ]
//            try await db.collection("analytics_reporting").addDocument(data: data)
//        }
//        
//        func getAnalyticsRecordsByMaterial(materialID: String) -> AsyncThrowingStream<[DocumentSnapshot], Error> {
//            return db.collection("analytics_reporting")
//                .whereField("material_ID", isEqualTo: materialID)
//                .stream()
//        }
//        
//        func getAnalyticsRecordsByUser(userID: String) -> AsyncThrowingStream<[DocumentSnapshot], Error> {
//            return db.collection("analytics_reporting")
//                .whereField("user_ID", isEqualTo: userID)
//                .stream()
//        }
//        
//        func updateAnalyticsRecord(analyticsID: String, updatedData: [String: Any]) async throws {
//            try await db.collection("analytics_reporting")
//                .document(analyticsID)
//                .updateData(updatedData)
//        }
//        
//        func deleteAnalyticsRecord(analyticsID: String) async throws {
//            try await db.collection("analytics_reporting")
//                .document(analyticsID)
//                .delete()
//        }
//        
//        // MARK: - Activity Logs
//        func addActivityLog(activityType: String, materialID: String, userID: String) async throws {
//            let data: [String: Any] = [
//                "activityType": activityType,
//                "material_ID": materialID,
//                "userID": userID,
//                "timeStamp": FieldValue.serverTimestamp()
//            ]
//            try await db.collection("activity_logs").addDocument(data: data)
//        }
//        
//        func getActivityLogsByMaterial(materialID: String) -> AsyncThrowingStream<[DocumentSnapshot], Error> {
//            return db.collection("activity_logs")
//                .whereField("material_ID", isEqualTo: materialID)
//                .stream()
//        }
//        
//        func getActivityLogsByUser(userID: String) -> AsyncThrowingStream<[DocumentSnapshot], Error> {
//            return db.collection("activity_logs")
//                .whereField("userID", isEqualTo: userID)
//                .stream()
//        }
//        
//        func getActivityLogsByType(activityType: String) -> AsyncThrowingStream<[DocumentSnapshot], Error> {
//            return db.collection("activity_logs")
//                .whereField("activityType", isEqualTo: activityType)
//                .stream()
//        }
//    }
//}
