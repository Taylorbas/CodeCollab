//
//  BlockchainServices.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 12/5/24.
//

//import Foundation
//import web3swift
//
//class BlockchainServices {
//    // Function to generate a private key
//    func generateEthereumKey() -> String {
//        let privateKey = Data.randomOfLength(32).toHexString()
//        return privateKey
//    }
//
//    // Function to derive an Ethereum address from the private key
//    func getEthereumAddress(privateKey: String) -> String? {
//        guard let privateKeyData = Data.fromHex(privateKey) else { return nil }
//        do {
//            let keystore = try EthereumKeystoreV3(privateKey: privateKeyData)
//            return keystore?.addresses?.first?.address
//        } catch {
//            print("Error deriving Ethereum address: \(error)")
//            return nil
//        }
//    }
//
//    // Function to send Ethereum address to an email
//    func sendEthereumAddress(ethereumAddress: String, email: String, completion: @escaping (Result<String, Error>) -> Void) {
//        // Simulate sending the Ethereum address via email
//        let payload = [
//            "ethereumAddress": ethereumAddress,
//            "email": email
//        ]
//        print("Preparing to send: \(payload)")
//        
//        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
//            completion(.success("Ethereum address sent successfully to \(email)"))
//        }
//    }
//}
//
