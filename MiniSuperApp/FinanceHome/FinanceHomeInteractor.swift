import ModernRIBs

protocol FinanceHomeRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func attachSuperPayDashboard()
    func attachCardOnFileDashboard()
    func attachAddPaymentMethodDashboard()
    func detachAddPaymentMethodDashboard()
    
    
    func attachTopup()
    func detachTopup()
}

protocol FinanceHomePresentable: Presentable {
    var listener: FinanceHomePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol FinanceHomeListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class FinanceHomeInteractor: PresentableInteractor<FinanceHomePresentable>, FinanceHomeInteractable, FinanceHomePresentableListener {
    weak var router: FinanceHomeRouting?
    weak var listener: FinanceHomeListener?
    
    var presentationDelegateProxy : AdaptivePresentationControllerDelegateProxy
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: FinanceHomePresentable) {
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        super.init(presenter: presenter)
        presenter.listener = self
        self.presentationDelegateProxy.delegate = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        router?.attachSuperPayDashboard()
        router?.attachCardOnFileDashboard()
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func cardOnFileDashboardDidTapAddPaymentMethod() {
        router?.attachAddPaymentMethodDashboard()
    }
}
extension FinanceHomeInteractor {
    func superPayDashboardDidTapTopupButton() {
        router?.attachTopup()
    }
}
extension FinanceHomeInteractor {
    func addPaymentMethodDidTapClose() {
        router?.detachAddPaymentMethodDashboard()
    }
    
    func addPaymentMethodDidAddCard(method: PaymentMethod) {
        router?.detachAddPaymentMethodDashboard()
    }
}
extension FinanceHomeInteractor : AdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss() {
        router?.detachAddPaymentMethodDashboard()
    }
}
