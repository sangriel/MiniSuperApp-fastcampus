//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by sangmin han on 11/3/24.
//

import ModernRIBs

protocol TopupInteractable: Interactable {
    var router: TopupRouting? { get set }
    var listener: TopupListener? { get set }
}

protocol TopupViewControllable: ViewControllable {
}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: TopupInteractable, viewController: ViewControllable) {
        self.viewController = viewController
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() {
        // TODO: Since this router does not own its view, it needs to cleanup the views
        // it may have added to the view hierarchy, when its interactor is deactivated.
    }

    // MARK: - Private

    private let viewController: ViewControllable
}
