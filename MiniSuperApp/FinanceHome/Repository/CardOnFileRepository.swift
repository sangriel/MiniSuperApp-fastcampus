//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by sangmin han on 10/20/24.
//

import Foundation


protocol CardOnFileRepository {
    var cardOnFile : ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }
}

final class CardOnFileRepositoryImp : CardOnFileRepository {
    
    private let paymentMethodSubject = CurrentValuePublisher<[PaymentMethod]>(initialValue: [
        .init(id: "0", name: "우리은행", digits: "0123", color: "#f19a38ff", isPrimary: true),
        .init(id: "1", name: "신한카드", digits: "0748", color: "#f3478f6ff", isPrimary: false),
        .init(id: "2", name: "현대카드", digits: "2323", color: "#78c5f5ff", isPrimary: false),
        .init(id: "3", name: "국민은행", digits: "2313", color: "#65c466ff", isPrimary: false),
        .init(id: "4", name: "카카오뱅크", digits: "8494", color: "#ffcc00ff", isPrimary: false),
    ])
    
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { paymentMethodSubject }
    
    
    
    
}