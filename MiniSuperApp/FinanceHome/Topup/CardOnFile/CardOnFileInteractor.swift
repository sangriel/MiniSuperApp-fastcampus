//
//  CardOnFileInteractor.swift
//  MiniSuperApp
//
//  Created by sangmin han on 11/3/24.
//

import ModernRIBs

protocol CardOnFileRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFilePresentable: Presentable {
    var listener: CardOnFilePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func update(with viewModel : [PaymentMethodViewModel])
}

protocol CardOnFileListener: AnyObject {
    func cardOnFileDidTapClose()
}

final class CardOnFileInteractor: PresentableInteractor<CardOnFilePresentable>, CardOnFileInteractable, CardOnFilePresentableListener {
 

    weak var router: CardOnFileRouting?
    weak var listener: CardOnFileListener?
    
    private var paymentMethods : [PaymentMethod] = []

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: CardOnFilePresentable, paymentMethods : [PaymentMethod]) {
        super.init(presenter: presenter)
        self.paymentMethods = paymentMethods
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        presenter.update(with: paymentMethods.map{ PaymentMethodViewModel.init($0) })

    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
extension CardOnFileInteractor {
    func didTapClose() {
        listener?.cardOnFileDidTapClose()
        
    }
    
    func didSelectItem(at: Int) {
        
    }
}
