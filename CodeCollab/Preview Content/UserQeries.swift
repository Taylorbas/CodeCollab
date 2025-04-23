//
//  UserQeries.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 3/9/25.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import Security
class UserQueries: FirestoreBase {
    private let blockchainServices = BlockchainServices()
    // Top-level collections
    var users: CollectionReference { db.collection("Users") }
    var studyGroups: CollectionReference { db.collection("StudyGroups") }
    var tutors: CollectionReference { db.collection("Tutors") }
    var userDiscussions: CollectionReference { db.collection("user-discussions") }
    var userMessages: CollectionReference { db.collection("user-messages") }
    var userMaterials: CollectionReference { db.collection("user-materials") }
    var analytics: CollectionReference { db.collection("Analytics and Reporting") }
    var categories: CollectionReference { db.collection("Categories") }
    var materials: CollectionReference { db.collection("Material") }
    var materialHistory: CollectionReference { db.collection("Material History") }
    var materialVersions: CollectionReference { db.collection("Material Version") }
    var tradeNegotiations: CollectionReference { db.collection("Trade Negotiations") }
    var tradeRequests: CollectionReference { db.collection("Trade Requests") }
    var activityLogs: CollectionReference { db.collection("Activity Logs") }
    override init(firestore: Firestore? = nil) {
        super.init(firestore: firestore)
    }
    // User Methods
    func getUserByEmail(email: String) async throws -> [String: Any]? {
        let query = try await users.whereField("email", isEqualTo: email).getDocuments()
        if let document = query.documents.first {
            return document.data()
        }
        return nil
    }
    func registerUser(
        parksideID: String,
        email: String,
        username: String,
        role: String,
        bio: String? = nil,
        profilePicture: String? = nil,
        location: String? = nil
    ) async throws {
        try await executeQuery {
            let privateKey = self.blockchainServices.generateEthereumKey()
            let ethereumAddress = self.blockchainServices.getEthereumAddress(privateKey: privateKey)
            // Store private key in Keychain
            let keychainQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: "\(email)-privateKey",
                kSecValueData as String: privateKey.data(using: .utf8)!
            ]
            SecItemDelete(keychainQuery as CFDictionary) // Remove existing key if any
            let status = SecItemAdd(keychainQuery as CFDictionary, nil)
            if status != errSecSuccess {
                throw KeychainError(status: status)
            }
            // Add user to Firestore
            let userData: [String: Any] = [
                "username": username,
                "email": email,
                "ethereumAddress": ethereumAddress,
                "role": role,
                "bio": bio ?? "",
                "profilePicture": profilePicture ?? "",
                "parksideID": parksideID,
                "location": location ?? "",
                "createdAt": FieldValue.serverTimestamp()
            ]
            try await self.users.addDocument(data: userData)
            // Send Ethereum address
            _ = await self.blockchainServices.sendEthereumAddress(rangerEmail: email, ethereumAddress: ethereumAddress)
        }
    }
    func getPrivateKey(email: String) async -> String? {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "\(email)-privateKey",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &item)
        if status == errSecSuccess, let data = item as? Data, let key = String(data: data, encoding: .utf8) {
            return key
        }
        return nil
    }
    func setPassword(userId: String, password: String) async throws {
        try await executeQuery {
            let hashedPassword = self.hashPassword(password)
            try await self.users.document(userId).updateData(["password": hashedPassword])
        }
    }
    func getUsers() -> AnyPublisher<[[String: Any]], Error> {
        Future { promise in
            self.users.addSnapshotListener { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else if let snapshot = snapshot {
                    let data = snapshot.documents.map { $0.data() }
                    promise(.success(data))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    func updateUser(userId: String, updatedData: [String: Any]) async throws {
        try await executeQuery {
            try await self.users.document(userId).updateData(updatedData)
        }
    }
}
// Custom error for Keychain operations
struct KeychainError: Error {
    let status: OSStatus
}
