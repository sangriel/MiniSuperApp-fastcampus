//
//  SuperPayDashboardViewController.swift
//  MiniSuperApp
//
//  Created by sangmin han on 10/19/24.
//

import ModernRIBs
import UIKit

protocol SuperPayDashboardPresentableListener: AnyObject {
    func superPayDashboardDidTapTopupButton()
}

final class SuperPayDashboardViewController: UIViewController, SuperPayDashboardPresentable, SuperPayDashboardViewControllable {
    
    weak var listener: SuperPayDashboardPresentableListener?
    
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
    
    lazy private var topupButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("충전하기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(topupButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let cardView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.backgroundColor = .systemIndigo
        return view
    }()
    
    private let currencyLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.text = "원"
        label.textColor = .white
        return label
    }()
    
    private let balanceAmountLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.textColor = .white
        label.text = "10,000"
        return label
    }()
    
    private let balanceStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        return stackView
    }()
    
    init(){
        super.init(nibName: nil, bundle: nil)
       setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        view.addSubview(headerStackView)
        view.addSubview(cardView)
                
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(topupButton)
        
        cardView.addSubview(balanceStackView)
        balanceStackView.addArrangedSubview(balanceAmountLabel)
        balanceStackView.addArrangedSubview(currencyLabel)
        
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 10),
            headerStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 20),
            headerStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            cardView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 10),
            cardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            cardView.heightAnchor.constraint(equalToConstant: 180),
            cardView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -20),
            
            balanceStackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            balanceStackView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
        ])
    }
    
    @objc private func topupButtonDidTap() {
        listener?.superPayDashboardDidTapTopupButton()
    }
    
    func updateBalance(_ balance: String) {
        self.balanceAmountLabel.text = balance
    }
}
