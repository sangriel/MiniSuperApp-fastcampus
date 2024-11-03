//
//  AddPaymentMethodBuilder.swift
//  MiniSuperApp
//
//  Created by sangmin han on 11/2/24.
//

import ModernRIBs

protocol AddPaymentMethodDependency: Dependency {
    var cardsOnFileRepository : CardOnFileRepository { get }
}

final class AddPaymentMethodComponent: Component<AddPaymentMethodDependency>, AddPaymentMethodInteractorDependency {
    var cardOnFileRepository: any CardOnFileRepository { dependency.cardsOnFileRepository }
}

// MARK: - Builder

protocol AddPaymentMethodBuildable: Buildable {
    func build(withListener listener: AddPaymentMethodListener,closeButtonType : DismissButtonType) -> AddPaymentMethodRouting
}

final class AddPaymentMethodBuilder: Builder<AddPaymentMethodDependency>, AddPaymentMethodBuildable {

    override init(dependency: AddPaymentMethodDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AddPaymentMethodListener,closeButtonType : DismissButtonType) -> AddPaymentMethodRouting {
        let component = AddPaymentMethodComponent(dependency: dependency)
        let viewController = AddPaymentMethodViewController(buttonType: closeButtonType)
        let interactor = AddPaymentMethodInteractor(presenter: viewController,
                                                    dependency: component)
        interactor.listener = listener
        return AddPaymentMethodRouter(interactor: interactor, viewController: viewController)
    }
}
