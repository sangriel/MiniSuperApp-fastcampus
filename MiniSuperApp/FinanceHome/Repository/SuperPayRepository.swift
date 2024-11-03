//
//  SuperPayRepository.swift
//  MiniSuperApp
//
//  Created by sangmin han on 11/3/24.
//

import Foundation
import Combine

protocol SuperPayRepository {
    var balance : ReadOnlyCurrentValuePublisher<Double> { get }
    func topup(amount : Double, paymentId : String) -> AnyPublisher<Void,Error>
}

final class SuperPaymentRepositoryImp: SuperPayRepository {
    var balance: ReadOnlyCurrentValuePublisher<Double> {
        balanceSubject
    }
    
    private let balanceSubject : CurrentValuePublisher<Double> = . init(initialValue: 0)
    private let backgroundQueue : DispatchQueue = DispatchQueue(label: "com.minisup.superpay.background",qos: .background)
    
    func topup(amount: Double, paymentId: String) -> AnyPublisher<Void, any Error> {
        return Future<Void,Error> { [weak self] promise in 
            self?.backgroundQueue.async {
                Thread.sleep(forTimeInterval: 2)
                promise(.success(()))
                self?.balanceSubject.send((self?.balanceSubject.value ?? 0) + amount)
            }
        }.eraseToAnyPublisher()
    }
}
