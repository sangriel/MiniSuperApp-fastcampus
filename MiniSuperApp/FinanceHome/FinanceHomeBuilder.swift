import ModernRIBs
import Foundation

protocol FinanceHomeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency{
    var cardsOnFileRepository:  CardOnFileRepository
    
    var balance : ReadOnlyCurrentValuePublisher<Double> { balancePublisher }
    
    private let balancePublisher : CurrentValuePublisher<Double>
    
    init(dependency: FinanceHomeDependency,
         balance: CurrentValuePublisher<Double>,
         cardOnFileRepository: CardOnFileRepository
    ) {
        self.cardsOnFileRepository = cardOnFileRepository
        self.balancePublisher = balance
        super.init(dependency: dependency)
    }
    
}

// MARK: - Builder

protocol FinanceHomeBuildable: Buildable {
    func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting
}

final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
    
    override init(dependency: FinanceHomeDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting {
        let balancePublisher = CurrentValuePublisher<Double>(initialValue: 0)
        
        let component  = FinanceHomeComponent(dependency: dependency,
                                              balance: balancePublisher,
                                              cardOnFileRepository: CardOnFileRepositoryImp())
        
        let viewController = FinanceHomeViewController()
        let interactor = FinanceHomeInteractor(presenter: viewController)
        interactor.listener = listener
        
        let superPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
        let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
        
        return FinanceHomeRouter(interactor: interactor,
                                 viewController: viewController,
                                 superpayDashboardBuildable: superPayDashboardBuilder,
                                 cardOnFileDashboardBuildable: cardOnFileDashboardBuilder)
    }
}
