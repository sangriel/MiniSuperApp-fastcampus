//
//  EnterAmountInteractor.swift
//  MiniSuperApp
//
//  Created by sangmin han on 11/3/24.
//

import ModernRIBs
import Combine
import Foundation

protocol EnterAmountRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EnterAmountPresentable: Presentable {
    var listener: EnterAmountPresentableListener? { get set }
    func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel)
    func startLoading()
    func stopLoading()
}

protocol EnterAmountListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func enterAmountDidTapClose()
    func enterAmountDidTapAddPaymentMethod()
    func enterAmountDidFinishTopup()
}

protocol EnterAmountInteractorDependency : AnyObject {
    var selectedPayments : ReadOnlyCurrentValuePublisher<PaymentMethod> { get }
    var superPayRepository : SuperPayRepository { get }
}

final class EnterAmountInteractor: PresentableInteractor<EnterAmountPresentable>, EnterAmountInteractable, EnterAmountPresentableListener {
    
    weak var router: EnterAmountRouting?
    weak var listener: EnterAmountListener?
    
    private let dependency : EnterAmountInteractorDependency
    private var cancellables : Set<AnyCancellable> = .init()
    
    init(presenter: EnterAmountPresentable,
         dependency : EnterAmountInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        dependency.selectedPayments.sink { [weak self] method in
            self?.presenter.updateSelectedPaymentMethod(with: .init(method))
        }.store(in: &cancellables)
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
extension EnterAmountInteractor {
    func didTapClose() {
        listener?.enterAmountDidTapClose()
    }
    
    func didTapPaymentMethod() {
        listener?.enterAmountDidTapAddPaymentMethod()
    }
    
    func didTapTopup(with amount: Double) {
        presenter.startLoading()
        dependency.superPayRepository
            .topup(amount: amount, paymentId: dependency.selectedPayments.value.id)
            .receive(on:DispatchQueue.main)
            .sink { [weak self] _ in
                self?.presenter.stopLoading()
            } receiveValue: { [weak self] _ in
                self?.listener?.enterAmountDidFinishTopup()
            }
            .store(in: &cancellables)

    }
}
