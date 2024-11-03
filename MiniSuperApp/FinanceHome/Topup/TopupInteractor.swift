//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by sangmin han on 11/3/24.
//

import ModernRIBs

protocol TopupRouting: Routing {
    func cleanupViews()
    func attachAddPaymentMethod(closeButtonType : DismissButtonType)
    func detachAddPaymentMethod()
    
    func attachEnterAmount()
    func detachEnterAmount()
    
    func attachCardOnFile(paymentMethods : [PaymentMethod])
    func detachCardOnFile()
    
    func popToRoot()
    
}

protocol TopupListener: AnyObject {
    func topupDidClose()
    func topupDidFinish()
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
    
    private var isEnterAmountPresent : Bool = false
    
    init(dependency : TopupInteractorDependency) {
        self.dependency = dependency
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        super.init()
        self.presentationDelegateProxy.delegate = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        if let card = dependency?.cardsOnFileRepository.cardOnFile.value.first {
            isEnterAmountPresent = true
            dependency?.paymentMethodStreams.send(card)
            router?.attachEnterAmount()
        }
        else {
            isEnterAmountPresent = false
            router?.attachAddPaymentMethod(closeButtonType: .close)
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
        if isEnterAmountPresent == false {
            listener?.topupDidClose()
        }
    }
    
    func addPaymentMethodDidAddCard(method: PaymentMethod) {
        dependency?.paymentMethodStreams.send(method)
        if isEnterAmountPresent {
            router?.popToRoot()
        }
        else {
            isEnterAmountPresent = true
            router?.attachEnterAmount()
        }
        
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
    
    func enterAmountDidFinishTopup() {
        listener?.topupDidFinish()
    }
}
extension TopupInteractor {
    func cardOnFileDidTapClose() {
        router?.detachCardOnFile()
    }
    
    func cardOnFileDidTappAddCard() {
        router?.attachAddPaymentMethod(closeButtonType: .back)
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
