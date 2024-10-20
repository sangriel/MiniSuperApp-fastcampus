//
//  AddPaymentMethodButton.swift
//  MiniSuperApp
//
//  Created by sangmin han on 10/20/24.
//

import Foundation
import UIKit


final class AddPaymentMethodButton : UIControl {
    
    private let plusIcon : UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "plus",
                                                   withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold))
        )
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(){
        super.init(frame: .zero)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViews() {
        self.addSubview(plusIcon)
        
        NSLayoutConstraint.activate([
            plusIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            plusIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
}
