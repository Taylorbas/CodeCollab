//
//  SmartContractServices.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 12/5/24.
//

//import Foundation
////import web3swift
//
//class SmartContractService {
//    
//    private var web3: web3
//    private var contract: web3.web3contract?
//    private let rpcUrl = "http://127.0.0.1:8545" // Local network URL
//    private let contractAddress = EthereumAddress("YOUR_CONTRACT_ADDRESS_HERE")
//    
//    init?() {
//        guard let provider = Web3HttpProvider(URL(string: rpcUrl)!) else {
//            print("Error initializing web3 provider")
//            return nil
//        }
//        web3 = web3(provider: provider)
//        loadContract()
//    }
//    
//    private func loadContract() {
//        do {
//            // Load the ABI from a local file
//            guard let path = Bundle.main.path(forResource: "ParksideIDValidation", ofType: "json") else {
//                print("ABI file not found")
//                return
//            }
//            let abiString = try String(contentsOfFile: path, encoding: .utf8)
//            
//            // Initialize the contract
//            contract = web3.contract(abiString, at: contractAddress, abiVersion: 2)
//            print("Contract loaded successfully")
//        } catch {
//            print("Error loading contract: \(error.localizedDescription)")
//        }
//    }
//    
//    func registerStudent(parksideID: String, rangerEmail: String) {
//        do {
//            // Generate a temporary private key and address
//            let privateKey = try EthereumPrivateKey()
//            let fromAddress = privateKey.address
//            
//            // Prepare the transaction
//            guard let contract = contract,
//                  let transaction = contract.write(
//                    "registerStudent",
//                    parameters: [parksideID, rangerEmail] as [AnyObject],
//                    extraData: Data(),
//                    transactionOptions: nil
//                  ) else {
//                print("Error preparing the transaction")
//                return
//            }
//            
//            // Set transaction options
//            var options = TransactionOptions.defaultOptions
//            options.from = fromAddress
//            options.gasPrice = .automatic
//            options.gasLimit = .automatic
//            
//            // Send the transaction
//            let result = try transaction.send(password: "", options: options)
//            print("Transaction successful with hash: \(result.transaction.txhash)")
//            
//        } catch {
//            print("Error registering student: \(error.localizedDescription)")
//        }
//    }
//}
