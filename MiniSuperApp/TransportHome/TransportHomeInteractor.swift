import ModernRIBs
import Combine
import Foundation

protocol TransportHomeRouting: ViewableRouting {
    func attachTopup()
    func detachTopup()
}

protocol TransportHomePresentable: Presentable {
    var listener: TransportHomePresentableListener? { get set }
    func setSuperPayBalance(_ balanceText: String)
    
}

protocol TransportHomeListener: AnyObject {
    func transportHomeDidTapClose()
}

protocol TransportHomeInteractorDependency {
    var superPayBalance : ReadOnlyCurrentValuePublisher<Double> { get }
}

final class TransportHomeInteractor: PresentableInteractor<TransportHomePresentable>, TransportHomeInteractable, TransportHomePresentableListener {
    
   
    weak var router: TransportHomeRouting?
    weak var listener: TransportHomeListener?
    
    private let dependency: TransportHomeInteractorDependency
    private var cancellables: Set<AnyCancellable> = []
    private let ridePrice : Double = 5000
    
    init(presenter: TransportHomePresentable,
         dependency : TransportHomeInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        dependency.superPayBalance
            .receive(on: DispatchQueue.main)
            .sink { [weak self] balance in
                guard let self = self else { return }
                if let balanceString = Formatter.balanceFormatter.string(from: NSNumber(value: balance)) {
                    self.presenter.setSuperPayBalance(balanceString)
                }
            }.store(in: &cancellables)
        
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapBack() {
        listener?.transportHomeDidTapClose()
    }
    
    func didTapRideConfirmButton() {
        if dependency.superPayBalance.value < ridePrice {
            router?.attachTopup()
        }
        else {
            //ride confirmed
        }
    }
}
//MARK: - TOPUP
extension TransportHomeInteractor {
    func topupDidClose() {
        router?.detachTopup()
    }
    
    func topupDidFinish() {
        router?.detachTopup()
    }
}
