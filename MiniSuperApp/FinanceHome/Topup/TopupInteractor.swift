//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by sangmin han on 11/3/24.
//

import ModernRIBs

protocol TopupRouting: Routing {
    func cleanupViews()
    func attachAddPaymentMethod()
    func detachAddPaymentMethod()
    
    
    func attachEnterAmount()
    func detachEnterAmount()
    
}

protocol TopupListener: AnyObject {
    func topupDidClose()
}

protocol TopupInteractorDependency : AnyObject {
    var cardsOnFileRepository: CardOnFileRepository { get }
    
}

final class TopupInteractor: Interactor, TopupInteractable {
    
    weak var router: TopupRouting?
    weak var listener: TopupListener?
    weak var dependency : TopupInteractorDependency?
    let presentationDelegateProxy : AdaptivePresentationControllerDelegateProxy
    
    init(dependency : TopupInteractorDependency) {
        self.dependency = dependency
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        super.init()
        self.presentationDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        if dependency?.cardsOnFileRepository.cardOnFile.value.count == 0 {
            router?.attachAddPaymentMethod()
        }
        else {
            router?.attachEnterAmount()
        }
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
}

extension TopupInteractor {
    func addPaymentMethodDidTapClose() {
        router?.detachAddPaymentMethod()
        listener?.topupDidClose()
    }
    
    func addPaymentMethodDidAddCard(method: PaymentMethod) {
        
    }
}
extension TopupInteractor {
    func enterAmountDidTapClose() {
        router?.detachEnterAmount()
        listener?.topupDidClose()
    }
}
extension TopupInteractor : AdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss() {
        listener?.topupDidClose()
    }
}