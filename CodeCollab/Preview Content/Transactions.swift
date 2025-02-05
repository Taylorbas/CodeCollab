//
//  Transactions.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 11/5/24.
//

import FirebaseFirestore

func logTransactionToFirestore(transactionHash: String, status: String) {
    let db = Firestore.firestore()
    db.collection("transactions").addDocument(data: [
        "hash": transactionHash,
        "status": status,
        "timestamp": FieldValue.serverTimestamp()
    ]) { error in
        if let error = error {
            print("Error logging transaction: \(error)")
        } else {
            print("Transaction logged in Firestore.")
        }
    }
}
