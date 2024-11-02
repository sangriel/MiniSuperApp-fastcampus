import ModernRIBs

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener, AddPaymentMethodListener {
    var router: FinanceHomeRouting? { get set }
    var listener: FinanceHomeListener? { get set }
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
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: FinanceHomeInteractable,
         viewController: FinanceHomeViewControllable,
         superpayDashboardBuildable: SuperPayDashboardBuildable,
         cardOnFileDashboardBuildable: CardOnFileDashboardBuildable,
         addPaymentMethodBuildable : AddPaymentMethodBuildable
    ) {
        self.superPayDashboradBuilder = superpayDashboardBuildable
        self.cardOnFileDashboardBuilder = cardOnFileDashboardBuildable
        self.addPaymentMethodBulilder = addPaymentMethodBuildable
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
        viewControllable.present(view, animated: true, completion: nil)
        attachChild(router)
    }
    
    func detachAddPaymentMethodDashboard() {
        guard let router = addPaymentMethodRouting else { return }
        viewControllable.dismiss(completion: nil)
        detachChild(router)
        addPaymentMethodRouting = nil
    }
}
