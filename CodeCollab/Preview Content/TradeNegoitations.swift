//
//  File.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 12/5/24.
//

import Foundation
import Firebase
import Combine

class TradeRequestViewModel: ObservableObject {
    @Published var tradeRequests: [TradeRequest] = []
    @Published var alert: AlertMessage?

    private var db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchTradeRequests()
    }

    func addTradeRequest(materialID: String, receiverID: String, requesterID: String) {
        let tradeRequestData: [String: Any] = [
            "materialID": materialID,
            "receiverID": receiverID,
            "requesterID": requesterID,
            "status": "pending",
            "timestamp": Timestamp(date: Date())
        ]

        db.collection("tradeRequests").addDocument(data: tradeRequestData) { error in
            if let error = error {
                self.showAlert(message: "Error adding trade request: \(error.localizedDescription)")
            } else {
                self.fetchTradeRequests()
            }
        }
    }

    func fetchTradeRequests() {
        db.collection("tradeRequests").order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            if let error = error {
                self.showAlert(message: "Error fetching trade requests: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else {
                self.tradeRequests = []
                return
            }
            self.tradeRequests = documents.compactMap { doc in
                let data = doc.data()
                return TradeRequest(
                    id: doc.documentID,
                    materialID: data["materialID"] as? String ?? "",
                    receiverID: data["receiverID"] as? String ?? "",
                    requesterID: data["requesterID"] as? String ?? "",
                    status: data["status"] as? String ?? "pending"
                )
            }
        }
    }

    func showAlert(message: String) {
        alert = AlertMessage(message: message)
    }
}

struct AlertMessage: Identifiable {
    let id = UUID()
    let message: String
}


struct TradeRequest: Identifiable {
    let id: String
    let materialID: String
    let receiverID: String
    let requesterID: String
    let status: String
}

