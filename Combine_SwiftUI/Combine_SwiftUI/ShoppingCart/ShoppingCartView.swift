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

#Preview {
    ShoppingCartView()
}
