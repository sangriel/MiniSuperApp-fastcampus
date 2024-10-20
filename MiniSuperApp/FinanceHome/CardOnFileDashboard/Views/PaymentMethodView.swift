//
//  PaymentMethodView.swift
//  MiniSuperApp
//
//  Created by sangmin han on 10/20/24.
//

import Foundation
import UIKit

final class PaymentMethodView : UIView {
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let subtitleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    init(_ viewModel : PaymentMethodViewModel) {
        super.init(frame: .zero)
        setUpViews()
        nameLabel.text = viewModel.name
        subtitleLabel.text = viewModel.digits
        backgroundColor = viewModel.color
    }
    
    init(){
        super.init(frame: .zero)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpViews() {
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 24),
            
            subtitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -24),
            subtitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
