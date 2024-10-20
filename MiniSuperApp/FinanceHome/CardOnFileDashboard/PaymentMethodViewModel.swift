//
//  PaymentMethodViewModel.swift
//  MiniSuperApp
//
//  Created by sangmin han on 10/20/24.
//

import Foundation
import UIKit

struct PaymentMethodViewModel {
    let name : String
    let digits : String
    let color : UIColor
    
    init(_ paymentMethod : PaymentMethod) {
        name = paymentMethod.name
        digits = "**** **** " + paymentMethod.digits
        color = UIColor.init(hex: paymentMethod.color) ?? .systemGray2
    }
}
