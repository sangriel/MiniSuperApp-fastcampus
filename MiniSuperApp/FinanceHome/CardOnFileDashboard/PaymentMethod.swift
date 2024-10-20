//
//  PaymentModel.swift
//  MiniSuperApp
//
//  Created by sangmin han on 10/20/24.
//

import Foundation

struct PaymentMethod: Decodable {
    let id : String
    let name : String
    let digits : String
    let color : String
    let isPrimary : Bool
}
