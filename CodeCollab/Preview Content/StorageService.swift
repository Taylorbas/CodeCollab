//
//  StorageService.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 12/5/24.
//

import Foundation
import FirebaseStorage

class StorageService {
    private let storage: Storage

    // Constructor with default Firebase Storage instance
    init(storage: Storage = Storage.storage()) {
        self.storage = storage
    }

    // Method to upload a file to Firebase Storage
    func uploadFile(path: String, data: Data, completion: @escaping (Result<StorageMetadata, Error>) -> Void) {
        let storageRef = storage.reference(withPath: path)
        let uploadTask = storageRef.putData(data, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
            } else if let metadata = metadata {
                completion(.success(metadata))
            }
        }
        
        uploadTask.observe(.progress) { snapshot in
            if let progress = snapshot.progress {
                print("Upload progress: \(progress.fractionCompleted * 100)%")
            }
        }
    }

    // Method to download a file URL from Firebase Storage
    func downloadFileUrl(path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let storageRef = storage.reference(withPath: path)
        storageRef.downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
            } else if let url = url {
                completion(.success(url))
            }
        }
    }
}
