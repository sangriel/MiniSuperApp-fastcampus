//
//  CardOnFileDashboardViewController.swift
//  MiniSuperApp
//
//  Created by sangmin han on 10/20/24.
//

import ModernRIBs
import UIKit

protocol CardOnFileDashboardPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class CardOnFileDashboardViewController: UIViewController, CardOnFileDashboardPresentable, CardOnFileDashboardViewControllable {

    weak var listener: CardOnFileDashboardPresentableListener?
    
    private let headerStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.text = "슈퍼페이 잔고"
        return label
    }()
    
    lazy private var seeAllButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("충전하기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(seeAllButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let cardOnFileStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    lazy private var addMethodButton : AddPaymentMethodButton = {
        let btn = AddPaymentMethodButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.roundCorners()
        btn.backgroundColor = .gray
        btn.addTarget(self, action: #selector(addMethodButtonDidTap), for: .touchUpInside)
        return btn
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setUpViews()
    }
    
    required init?(coder : NSCoder) {
        fatalError()
    }
    
    @objc private func seeAllButtonDidTap() {
        
    }
    
    @objc private func addMethodButtonDidTap() {
        
    }
    
    func update(with models: [PaymentMethodViewModel]) {
        cardOnFileStackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
        
        let methodViews = models.map { viewmodel -> PaymentMethodView in
            return .init(viewmodel)
        }
        
        for methodView in methodViews {
            methodView.translatesAutoresizingMaskIntoConstraints = false
            methodView.roundCorners()
            cardOnFileStackView.addArrangedSubview(methodView)
        }
        
        cardOnFileStackView.addArrangedSubview(addMethodButton)
        let heightConstraints =  methodViews.map({ $0.heightAnchor }).map({ $0.constraint(equalToConstant: 60) })
        NSLayoutConstraint.activate(heightConstraints)
    }
    
    
    private func setUpViews() {
        view.addSubview(headerStackView)
        view.addSubview(cardOnFileStackView)
                
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(seeAllButton)
        
        cardOnFileStackView.addArrangedSubview(addMethodButton)
        
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 10),
            headerStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20),
            headerStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            cardOnFileStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor,constant: 20),
            cardOnFileStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            cardOnFileStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            cardOnFileStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            addMethodButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
