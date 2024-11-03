//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by sangmin han on 11/3/24.
//

import ModernRIBs

protocol TopupDependency: Dependency {
    var  topupBaseViewController: ViewControllable { get }
}

final class TopupComponent: Component<TopupDependency> {

    fileprivate var topupBaseViewController: ViewControllable {
        return dependency.topupBaseViewController
    }
}

// MARK: - Builder

protocol TopupBuildable: Buildable {
    func build(withListener listener: TopupListener) -> TopupRouting
}

final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {

    override init(dependency: TopupDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TopupListener) -> TopupRouting {
        let component = TopupComponent(dependency: dependency)
        let interactor = TopupInteractor()
        interactor.listener = listener
        return TopupRouter(interactor: interactor, viewController: component.topupBaseViewController)
    }
}
