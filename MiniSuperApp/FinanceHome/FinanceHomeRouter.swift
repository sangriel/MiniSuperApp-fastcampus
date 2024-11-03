import ModernRIBs

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener, AddPaymentMethodListener, TopupListener {
    var router: FinanceHomeRouting? { get set }
    var listener: FinanceHomeListener? { get set }
    var presentationDelegateProxy : AdaptivePresentationControllerDelegateProxy { get set }
}

protocol FinanceHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func addDashboard(_ view : ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
    
    private let superPayDashboradBuilder : SuperPayDashboardBuildable
    private var superPayRouting : Routing?
    private let cardOnFileDashboardBuilder : CardOnFileDashboardBuildable
    private var cardOnFileDashboardRouting : Routing?
    private let addPaymentMethodBulilder : AddPaymentMethodBuildable
    private var addPaymentMethodRouting : Routing?
    private let topupBulilder : TopupBuildable
    private var topupRouting : Routing?
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: FinanceHomeInteractable,
         viewController: FinanceHomeViewControllable,
         superpayDashboardBuildable: SuperPayDashboardBuildable,
         cardOnFileDashboardBuildable: CardOnFileDashboardBuildable,
         addPaymentMethodBuildable : AddPaymentMethodBuildable,
         topupBuildable : TopupBuildable
    ) {
        self.superPayDashboradBuilder = superpayDashboardBuildable
        self.cardOnFileDashboardBuilder = cardOnFileDashboardBuildable
        self.addPaymentMethodBulilder = addPaymentMethodBuildable
        self.topupBulilder = topupBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachSuperPayDashboard() {
        if superPayRouting != nil { return }
        let router = superPayDashboradBuilder.build(withListener: interactor)
        let dashboard = router.viewControllable
        self.superPayRouting = router
        viewController.addDashboard(dashboard)
        attachChild(router)
    }
    
    func attachCardOnFileDashboard() {
        if cardOnFileDashboardRouting != nil { return }
        let router = cardOnFileDashboardBuilder.build(withListener: interactor)
        let dashboard = router.viewControllable
        self.cardOnFileDashboardRouting = router
        viewController.addDashboard(dashboard)
        attachChild(router)
    }
    
    func attachAddPaymentMethodDashboard() {
        if addPaymentMethodRouting != nil { return }
        let router = addPaymentMethodBulilder.build(withListener: interactor)
        addPaymentMethodRouting = router
        let view = NavigationControllerable(root: router.viewControllable)
        view.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        viewControllable.present(view, animated: true, completion: nil)
        attachChild(router)
    }
    
    func detachAddPaymentMethodDashboard() {
        guard let router = addPaymentMethodRouting else { return }
        viewControllable.dismiss(completion: nil)
        detachChild(router)
        addPaymentMethodRouting = nil
    }
    
    func attachTopup() {
        if topupRouting != nil { return }
        let router = topupBulilder.build(withListener: interactor)
        topupRouting = router
        attachChild(router)
    }
    
    func detachTopup() {
        guard let router = topupRouting else { return }
        detachChild(router)
        topupRouting = nil
    }
}
