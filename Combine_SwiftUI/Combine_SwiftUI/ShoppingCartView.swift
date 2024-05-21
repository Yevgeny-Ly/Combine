//
//  ShoppingCartView.swift
//  Combine_SwiftUI
//

import SwiftUI
import Combine

struct ShoppingCartView: View {
    var body: some View {
        VStack {
            titleView
                .padding(.bottom, 20)
            headerListsView
                .padding(.bottom, 10)
            ForEach(viewModel.foodstuffs, id: \.id) { index in
                makeProductView(foodstuff: index)
            }
            Spacer()
            deleteCartView
            sumView
        }
        .padding()
    }
    
    @StateObject private var viewModel = ShoppingCartViewModel()
    
    private var titleView: some View {
        Text("Магазин")
            .font(.largeTitle)
            .bold()
    }
    
    private var headerListsView: some View {
        HStack {
            Text("Товар")
            Spacer()
            Text("Цена")
        }
        .font(.title)
        .foregroundColor(.gray)
    }
    
    private var sumView: some View {
        HStack {
            Text("Сумма:")
            Spacer()
            Text("\(viewModel.total)")
        }
        .font(.title)
        .foregroundColor(.black)
    }
    
    private var deleteCartView: some View {
        Button {
            for foodstuff in viewModel.cart {
                viewModel.deleteFromCard(foodstuff: foodstuff)
            }
        } label: {
            Text("Удалить все товары из чека")
                .padding()
                .background(.red)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }

    func makeProductView(foodstuff: Foodstuffs) -> some View {
        HStack {
            Text(foodstuff.name)
            Button {
                viewModel.deleteFoodstuffs = foodstuff
            } label: {
                Text("-")
                    .padding(.all , 5)
                    .background(.gray)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
            
            Button {
                viewModel.addFoodstuffs = foodstuff
            } label: {
                Text("+")
                    .padding(.all , 5)
                    .background(.green)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }

            Spacer()
            Text("\(foodstuff.cost)")
        }
        .font(.body)
        .foregroundColor(viewModel.total < 0 ? .red : .black)
    }
}

class ShoppingCartViewModel: ObservableObject {
    
    var foodstuffs: [Foodstuffs] = [
        .init(name: "Хлеб", cost: 70, id: 1),
        .init(name: "Масло сливочное 200 гр", cost: 200, id: 2),
        .init(name: "Бананы 2 кг", cost: 450, id: 3),
        .init(name: "Сыр 1 кг", cost: 1100, id: 4),
        .init(name: "Вода 5 л", cost: 100, id: 5)
    ]
    
    @Published var cart: [Foodstuffs] = []
    @Published var addFoodstuffs: Foodstuffs?
    @Published var deleteFoodstuffs: Foodstuffs?
    @Published var total = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $cart
            .map { $0.reduce(0) { $0 + $1.cost } }
            .scan(100) { total, newTotal in
                100 + newTotal
            }
            .assign(to: \.total, on: self)
            .store(in: &cancellables)
        
        $addFoodstuffs
            .filter { $0?.cost ?? 0 <= 1000 }
            .sink (receiveValue: { item in
                guard let item else { return }
                self.cart.append(item)
            })
            .store(in: &cancellables)
        
        $deleteFoodstuffs
            .sink(receiveValue: { value in
                guard let index = self.cart.firstIndex(where: { $0.id == value?.id }) else { return }
                self.cart.remove(at: index)
            })
            .store(in: &cancellables)
    }
    
    func deleteFromCard(foodstuff: Foodstuffs) {
        guard let index = cart.firstIndex(where: { $0.id == foodstuff.id }) else { return }
        cart.remove(at: index)
    }
}


struct Foodstuffs {
    var name: String
    var cost: Int
    var id: Int
}

#Preview {
    ShoppingCartView()
}
