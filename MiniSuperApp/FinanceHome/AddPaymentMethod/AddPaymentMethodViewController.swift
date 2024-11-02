//
//  AddPaymentMethodViewController.swift
//  MiniSuperApp
//
//  Created by sangmin han on 11/2/24.
//

import ModernRIBs
import UIKit

protocol AddPaymentMethodPresentableListener: AnyObject {
    func didTapClose()
}

final class AddPaymentMethodViewController: UIViewController, AddPaymentMethodPresentable, AddPaymentMethodViewControllable {

    weak var listener: AddPaymentMethodPresentableListener?
    
    private let cardNumberTextField : UITextField = {
        let textField = makeTextField()
        textField.placeholder = "cardNumber"
        return textField
    }()
    
    private let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 14
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let securityTextField : UITextField = {
        let textField = makeTextField()
        textField.placeholder = "CVC"
        return textField
    }()
    
    private let expirationTextField : UITextField = {
        let textField = makeTextField()
        textField.placeholder = "요효기간"
        return textField
    }()
    
    private lazy var addCardButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.roundCorners()
        button.backgroundColor = .primaryRed
        button.setTitle("Add Card", for: .normal)
        button.addTarget(self, action: #selector(addCardButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private static func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }
    
    
    init(){
        super.init(nibName: nil, bundle: nil)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func addCardButtonTapped() {
        
    }
    
    @objc
    private func didTapClose() {
        listener?.didTapClose()
    }
}
extension AddPaymentMethodViewController {
    private func setUpViews() {
        title = "Add Card"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark",
                           withConfiguration:
                            UIImage.SymbolConfiguration(pointSize: 18,weight: .semibold)),
            style: .plain,
            target: self,
            action: #selector(didTapClose))
        
        view.backgroundColor = .backgroundColor
        view.addSubview(cardNumberTextField)
        view.addSubview(stackView)
        view.addSubview(addCardButton)
        
        stackView.addArrangedSubview(securityTextField)
        stackView.addArrangedSubview(expirationTextField)
        
        NSLayoutConstraint.activate([
            cardNumberTextField.topAnchor.constraint(equalTo: view.topAnchor,constant: 40),
            cardNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 40),
            cardNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            cardNumberTextField.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            stackView.bottomAnchor.constraint(equalTo: addCardButton.topAnchor, constant: -20),
            addCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            addCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            cardNumberTextField.heightAnchor.constraint(equalToConstant: 60),
            securityTextField.heightAnchor.constraint(equalToConstant: 60),
            expirationTextField.heightAnchor.constraint(equalToConstant: 60),
            addCardButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        
    }
}
