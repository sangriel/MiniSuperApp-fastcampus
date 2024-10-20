//
//  NumberFormatter.swift
//  MiniSuperApp
//
//  Created by sangmin han on 10/20/24.
//

import Foundation

struct Formatter {
    
    static let balanceFormatter : NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
