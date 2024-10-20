import ModernRIBs

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener {
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
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: FinanceHomeInteractable,
         viewController: FinanceHomeViewControllable,
         superpayDashboardBuildable: SuperPayDashboardBuildable,
         cardOnFileDashboardBuildable: CardOnFileDashboardBuildable
    ) {
        self.superPayDashboradBuilder = superpayDashboardBuildable
        self.cardOnFileDashboardBuilder = cardOnFileDashboardBuildable
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
}
