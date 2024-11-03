//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by sangmin han on 11/3/24.
//

import ModernRIBs

protocol TopupInteractable: Interactable, AddPaymentMethodListener, EnterAmountListener {
    var router: TopupRouting? { get set }
    var listener: TopupListener? { get set }
    var presentationDelegateProxy : AdaptivePresentationControllerDelegateProxy { get }
}

protocol TopupViewControllable: ViewControllable {
}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {

    private var navigationControllerable : NavigationControllerable?
    
    private let addPaymentMethodBuilder : AddPaymentMethodBuildable
    private var addPaymentMethodRouter : Routing?
    
    private let enterAmountBuilder : EnterAmountBuildable
    private var enterAmountRouter : Routing?
    
    init(interactor: TopupInteractable,
         viewController: ViewControllable,
         addPaymentMethodBuilder: AddPaymentMethodBuildable,
         enterAmountBuilder: EnterAmountBuildable) {
        self.viewController = viewController
        self.addPaymentMethodBuilder = addPaymentMethodBuilder
        self.enterAmountBuilder = enterAmountBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    // viewless riblet의 경우는 본인이 만든 화면은 본인이 다 닫아줘야 하는 책임이 있다.
    // 그래서 이 함수가 존재하는 것, 보통은 부모 riblet이 관리함
    func cleanupViews() {
        if viewController.uiviewController.presentedViewController != nil, navigationControllerable != nil {
            navigationControllerable?.dismiss(completion: nil)
        }
    }

    // MARK: - Private

    private let viewController: ViewControllable
    
    
    func attachAddPaymentMethod() {
        if addPaymentMethodRouter != nil { return }
        let router = addPaymentMethodBuilder.build(withListener: interactor)
        let view = router.viewControllable
        addPaymentMethodRouter = router
        self.presentInsideNavigation(view)
        attachChild(router)
    }
    
    func detachAddPaymentMethod() {
        guard let router = addPaymentMethodRouter else { return }
        dismissPresentedNavigation()
        detachChild(router)
        addPaymentMethodRouter = nil
    }
    
    
    func attachEnterAmount() {
        guard enterAmountRouter == nil else { return }
        let router = enterAmountBuilder.build(withListener: interactor)
        let view = router.viewControllable
        enterAmountRouter = router
        self.presentInsideNavigation(view)
        attachChild(router)
    }
    
    func detachEnterAmount() {
        guard let router = enterAmountRouter else { return }
        dismissPresentedNavigation()
        detachChild(router)
        enterAmountRouter = nil
    }
    
}
extension TopupRouter {
    private func presentInsideNavigation(_ viewController : ViewControllable) {
        let navigation = NavigationControllerable(root: viewController)
        self.navigationControllerable = navigation
        self.navigationControllerable?.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        self.viewController.present(navigation, animated: true, completion: nil)
    }
    
    private func dismissPresentedNavigation(completion : (() -> ())? = nil ) {
        if self.navigationControllerable == nil { return }
        viewController.dismiss(completion: completion)
        self.navigationControllerable = nil
    }
}
