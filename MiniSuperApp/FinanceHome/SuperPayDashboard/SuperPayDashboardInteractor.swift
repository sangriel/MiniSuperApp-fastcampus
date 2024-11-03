//
//  SuperPayDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by sangmin han on 10/19/24.
//

import ModernRIBs
import Combine
import Foundation

protocol SuperPayDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SuperPayDashboardPresentable: Presentable {
    var listener: SuperPayDashboardPresentableListener? { get set }
    func updateBalance(_ balance : String)
}

protocol SuperPayDashboardListener: AnyObject {
   func superPayDashboardDidTapTopupButton()
}

protocol SuperPayDashboardInteractorDependency {
    var balance : ReadOnlyCurrentValuePublisher<Double> { get }
    var balanceFormatter : NumberFormatter { get } // 직접 사용할지 아니면 dependency에 사용할지 결정 필요, 개인적인 생각으로 모든 것을 이렇게 dependecy에 주입하게 되면 너무 비대해지고 자식 클래스에서도 이런 디펜덴시가 그대로 계속 내려가는게 아닌지?
}

final class SuperPayDashboardInteractor: PresentableInteractor<SuperPayDashboardPresentable>, SuperPayDashboardInteractable, SuperPayDashboardPresentableListener {
    
    weak var router: SuperPayDashboardRouting?
    weak var listener: SuperPayDashboardListener?
    //이렇게 따로 프로토콜을 만들어서 주입 받는 이유는 init을 직접적으로 바꾸면 수정해야 하는 코드가 많아짐
    private let dependency : SuperPayDashboardInteractorDependency
    
    private var cancellable : Set<AnyCancellable>
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: SuperPayDashboardPresentable,
         dependency : SuperPayDashboardInteractorDependency) {
        self.dependency = dependency
        self.cancellable = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        dependency.balance
            .receive(on: DispatchQueue.main)
            .sink { [weak self] balance in
            self?.dependency.balanceFormatter.string(from: NSNumber(value: balance)).map({ balance in
                self?.presenter.updateBalance(balance)
            })
            //interactor에서 ui를 업데이트 하려고 할때는 presenter를 사용
        }.store(in: &cancellable)
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    
    func superPayDashboardDidTapTopupButton() {
        listener?.superPayDashboardDidTapTopupButton()
    }
}
