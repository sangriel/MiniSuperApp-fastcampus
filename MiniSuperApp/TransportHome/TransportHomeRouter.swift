import ModernRIBs

protocol TransportHomeInteractable: Interactable, TopupListener {
    var router: TransportHomeRouting? { get set }
    var listener: TransportHomeListener? { get set }
}

protocol TransportHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TransportHomeRouter: ViewableRouter<TransportHomeInteractable, TransportHomeViewControllable>, TransportHomeRouting {
    
    private let topupBuilder : TopupBuildable
    private var topupRouting : Routing?
    
    init(
        interactor: TransportHomeInteractable,
        viewController: TransportHomeViewControllable,
        topupBuilder : TopupBuildable
    ) {
        self.topupBuilder = topupBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
extension TransportHomeRouter {
    func attachTopup() {
        if topupRouting != nil { return }
        let router = topupBuilder.build(withListener: interactor)
        topupRouting = router
        attachChild(router)
    }
    
    func detachTopup() {
        guard let topupRouting = self.topupRouting else { return }
        detachChild(topupRouting)
        self.topupRouting = nil
    }
}
