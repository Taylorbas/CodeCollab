//
//  Storage.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 11/5/24.
//
import Foundation
import FirebaseStorage

class FirebaseStorageService {
    private let storage: Storage

    // Initialize with the default Firebase Storage instance
    init(storage: Storage = Storage.storage()) {
        self.storage = storage
    }

    // Method to upload a file
    func uploadFile(fileUrl: URL, filePath: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let storageRef = storage.reference(withPath: filePath)
        let uploadTask = storageRef.putFile(from: fileUrl, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
            } else {
                print("File uploaded successfully.")
                completion(.success(()))
            }
        }
        
        uploadTask.observe(.progress) { snapshot in
            if let progress = snapshot.progress {
                print("Upload progress: \(progress.fractionCompleted * 100)%")
            }
        }
    }

    // Method to download a file to local storage
    func downloadFile(filePath: String, localUrl: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        let storageRef = storage.reference(withPath: filePath)
        let downloadTask = storageRef.write(toFile: localUrl) { url, error in
            if let error = error {
                completion(.failure(error))
            } else {
                print("File downloaded successfully.")
                completion(.success(localUrl))
            }
        }

        downloadTask.observe(.progress) { snapshot in
            if let progress = snapshot.progress {
                print("Download progress: \(progress.fractionCompleted * 100)%")
            }
        }
    }

    // Method to delete a file
    func deleteFile(filePath: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let storageRef = storage.reference(withPath: filePath)
        storageRef.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                print("File deleted successfully.")
                completion(.success(()))
            }
        }
    }
}
