//
//  SuperPayDashboardBuilder.swift
//  MiniSuperApp
//
//  Created by sangmin han on 10/19/24.
//

import ModernRIBs
import Foundation

protocol SuperPayDashboardDependency: Dependency {
    var balance : ReadOnlyCurrentValuePublisher<Double> { get }
}
//부모에서 받고 싶은 dependency는 component에서 받도록
final class SuperPayDashboardComponent: Component<SuperPayDashboardDependency>, SuperPayDashboardInteractorDependency{
    var balance: ReadOnlyCurrentValuePublisher<Double> {
        dependency.balance
    }
    var balanceFormatter: NumberFormatter {
        Formatter.balanceFormatter
    }
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SuperPayDashboardBuildable: Buildable {
    func build(withListener listener: SuperPayDashboardListener) -> SuperPayDashboardRouting
}

final class SuperPayDashboardBuilder: Builder<SuperPayDashboardDependency>, SuperPayDashboardBuildable  {

    override init(dependency: SuperPayDashboardDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SuperPayDashboardListener) -> SuperPayDashboardRouting {
        let component = SuperPayDashboardComponent(dependency: dependency)
        let viewController = SuperPayDashboardViewController()
        let interactor = SuperPayDashboardInteractor(presenter: viewController,dependency: component)
        interactor.listener = listener
        return SuperPayDashboardRouter(interactor: interactor, viewController: viewController)
    }
}
