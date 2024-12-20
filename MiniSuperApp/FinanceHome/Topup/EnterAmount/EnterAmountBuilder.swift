//
//  EnterAmountBuilder.swift
//  MiniSuperApp
//
//  Created by sangmin han on 11/3/24.
//

import ModernRIBs

protocol EnterAmountDependency: Dependency {
    var selectedPayments: ReadOnlyCurrentValuePublisher<PaymentMethod> { get }
    var superPayRepository : SuperPayRepository { get }
}

final class EnterAmountComponent: Component<EnterAmountDependency>, EnterAmountInteractorDependency {
    var selectedPayments: ReadOnlyCurrentValuePublisher<PaymentMethod> {
        dependency.selectedPayments
    }
    
    var superPayRepository: SuperPayRepository {
        dependency.superPayRepository
    }
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol EnterAmountBuildable: Buildable {
    func build(withListener listener: EnterAmountListener) -> EnterAmountRouting
}

final class EnterAmountBuilder: Builder<EnterAmountDependency>, EnterAmountBuildable {

    override init(dependency: EnterAmountDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: EnterAmountListener) -> EnterAmountRouting {
        let component = EnterAmountComponent(dependency: dependency)
        let viewController = EnterAmountViewController()
        
        let interactor = EnterAmountInteractor(presenter: viewController,
                                               dependency: component)
        interactor.listener = listener
        return EnterAmountRouter(interactor: interactor, viewController: viewController)
    }
}
