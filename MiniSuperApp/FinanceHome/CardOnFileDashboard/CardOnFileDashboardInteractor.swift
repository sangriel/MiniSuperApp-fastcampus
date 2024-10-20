//
//  CardOnFileDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by sangmin han on 10/20/24.
//

import ModernRIBs
import Combine

protocol CardOnFileDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFileDashboardPresentable: Presentable {
    var listener: CardOnFileDashboardPresentableListener? { get set }
    
    func update(with models: [PaymentMethodViewModel])
}

protocol CardOnFileDashboardListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol CardOnFileDashboardInteractorDependency {
    var cardsOnFileDependency : CardOnFileRepository { get }
}

final class CardOnFileDashboardInteractor: PresentableInteractor<CardOnFileDashboardPresentable>, CardOnFileDashboardInteractable, CardOnFileDashboardPresentableListener {

    weak var router: CardOnFileDashboardRouting?
    weak var listener: CardOnFileDashboardListener?
    
    private let dependency : CardOnFileDashboardInteractorDependency

    private var cancellable : Set<AnyCancellable>
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: CardOnFileDashboardPresentable,
                  dependency: CardOnFileDashboardInteractorDependency) {
        self.dependency = dependency
        self.cancellable = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        dependency.cardsOnFileDependency.cardOnFile.sink { [weak self] methods in
            let result = methods.prefix(5).map({ PaymentMethodViewModel.init($0) })
            self?.presenter.update(with: result )
        }.store(in: &cancellable)
        
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
