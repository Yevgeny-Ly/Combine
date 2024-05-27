//
//  ContentView.swift
//  Combine_SwiftUI
//

import SwiftUI
import Combine

struct ProductLoadingView: View {
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                timerView
                if viewModel.isConnecting {
                    loadingProduct
                } else {
                    buttonStartView
                }
            case .data:
                timerView
                listView
                buttonStartView
            case .error(let error):
                Text(error.localizedDescription)
            }
        }
    }
    
    @StateObject var viewModel = ProductLoadingViewModel()
    
    private var timerView: some View {
        Text("time left \(viewModel.timerLeft)")
            .font(.title)
    }
    
    private var listView: some View {
        let filteredProducts = viewModel.filterByPrice(products: viewModel.dataToProducts)
        let finalProducts = viewModel.filterByImagePresence(products: filteredProducts)
        
        return List(finalProducts, id: \.self) { item in
            HStack {
                Image(systemName: item.imageName ?? "")
                Text(item.name)
                Text("\(item.price) руб")
            }
        }
    }
    
    private var buttonStartView: some View {
        Button(action: {
            viewModel.start()
            viewModel.performAnimation()
        }, label: {
            Text("Start")
                .font(.body)
                .padding()
                .foregroundColor(.white)
                .background(.green)
                .cornerRadius(8)
                .scaleEffect(viewModel.isAnimating ? 0.9 : 1)
        })
    }
    
    private var loadingProduct: some View {
        VStack {
            if viewModel.isLoadingProduct {
                Text("Загрузка товаров...")
                    .font(.body)
                    .foregroundColor(.green)
            }
        }
    }
}

final class ProductLoadingViewModel: ObservableObject {
    
    @Published var dataToProducts: [StoreMerchandise] = []
    @Published var state: ViewState<String> = .loading
    @Published var timerLeft: String = "00:00"
    @Published var isConnecting: Bool = false
    @Published var isLoadingProduct: Bool = false
    @Published var isAnimating = false
    
    let verificationState = PassthroughSubject<String, Never>()
    var cancellable: AnyCancellable?
    var cancellables = Set<AnyCancellable>()
    var timerCancellable: AnyCancellable?
    private var timerCount = 0
    
    init() {
        dataToProducts = [
            StoreMerchandise(imageName: "star.circle.fill", name: "Яблоко", price: "100"),
            StoreMerchandise(imageName: nil, name: "Груша", price: "200"),
            StoreMerchandise(imageName: "star.circle.fill", name: "Апельсин", price: "200"),
            StoreMerchandise(imageName: "star.circle.fill", name: "Киви", price: "150"),
            StoreMerchandise(imageName: nil, name: "Арбуз", price: "300"),
            StoreMerchandise(imageName: "star.circle.fill", name: "Ананас", price: "600"),
        ]
        bind()
    }
    
    func bind() {
        cancellable = verificationState
            .sink(receiveValue: { [unowned self] value in
                if !value.isEmpty {
                    state = .data(value)
                } else {
                    state = .error(NSError(domain: "Error time", code: 101))
                }
            })
    }
    
    func start() {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "00:ss"
        timerCancellable = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [unowned self] _ in
                let minutes = String(format: "%02d", self.timerCount / 60)
                let seconds = String(format: "%02d", self.timerCount % 60)
                self.timerLeft = "\(minutes):\(seconds)"
                self.timerCount += 1
            })
        withAnimation(Animation.easeInOut(duration: 0.3).repeatCount(13, autoreverses: true)) {
            isAnimating = true
        }
    }
    
    func performAnimation() {
        let cancellable = Just(())
            .delay(for: .seconds(3), scheduler: DispatchQueue.main)
            .map { _ in true }
            .handleEvents(receiveOutput: { [weak self] _ in
                withAnimation(Animation.easeInOut(duration: 3)) {
                    self?.isConnecting = true
                }
            })
            .delay(for: .seconds(2.5), scheduler: DispatchQueue.main)
            .map { _ in true }
            .handleEvents(receiveOutput: { [weak self] _ in
                withAnimation(Animation.easeInOut(duration: 3)) {
                    self?.isLoadingProduct = true
                }
            })
            .delay(for: .seconds(4), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.state = .data(String())
                self?.isAnimating = false
                self?.timerCancellable?.cancel()
            }
        cancellable.store(in: &cancellables)
    }
    
    func filterByPrice(products: [StoreMerchandise]) -> [StoreMerchandise] {
        return products.filter { $0.price > "100" }
    }
    
    func filterByImagePresence(products: [StoreMerchandise]) -> [StoreMerchandise] {
        return products.filter { $0.imageName != nil && !$0.imageName!.isEmpty }
    }
}

struct StoreMerchandise: Identifiable, Hashable {
    var id = UUID()
    var imageName: String?
    var name: String
    var price: String
}

enum ViewState<StoreMerchandise> {
    case loading
    case data(_ data: StoreMerchandise)
    case error(_ error: Error)
}


#Preview {
    ProductLoadingView()
}
