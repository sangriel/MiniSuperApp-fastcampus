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
    
    func attachCardOnFile(paymentMethods : [PaymentMethod])
    func detachCardOnFile()
    
}

protocol TopupListener: AnyObject {
    func topupDidClose()
}

protocol TopupInteractorDependency : AnyObject {
    var cardsOnFileRepository: CardOnFileRepository { get }
    var paymentMethodStreams : CurrentValuePublisher<PaymentMethod> { get }
    
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
        
        if let card = dependency?.cardsOnFileRepository.cardOnFile.value.first {
            dependency?.paymentMethodStreams.send(card)
            router?.attachEnterAmount()
        }
        else {
            router?.attachAddPaymentMethod()
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
    
    func enterAmountDidTapAddPaymentMethod() {
        let paymentMethods: [PaymentMethod] = dependency?.cardsOnFileRepository.cardOnFile.value ?? []
        router?.attachCardOnFile(paymentMethods: paymentMethods )
    }
}
extension TopupInteractor {
    func cardOnFileDidTapClose() {
        router?.detachCardOnFile()
    }
    
    func cardOnFileDidTappAddCard() {
        
    }
    
    func cardOnFileDidSelect(at index: Int) {
        if let card = dependency?.cardsOnFileRepository.cardOnFile.value[safe : index] {
            dependency?.paymentMethodStreams.send(card)
        }
        router?.detachCardOnFile()
    }
}
extension TopupInteractor : AdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss() {
        listener?.topupDidClose()
    }
}
