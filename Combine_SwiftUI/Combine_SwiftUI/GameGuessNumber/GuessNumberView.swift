//
//  GuessNumberView.swift
//  Combine_SwiftUI
//

import SwiftUI
import Combine

struct GuessNumberView: View {
    
    private enum Constants {
        static var titleNumber = "Введите число от 1 до 100"
        static var titleGameOver = "Завершить игру"
    }
    
    var body: some View {
        VStack {
            TextField(Constants.titleNumber, text: Binding(get: {
                "\(viewModel.selection.value)"
            }, set: { value in
                viewModel.selection.value = Int(value) ?? 0
            }))
            .frame(width: 100)
            .multilineTextAlignment(.center)
            .padding()
            Button {
                viewModel.cancel()
            } label: {
                Text(Constants.titleGameOver)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            Text("\(viewModel.selectionNumber.value)")
                .opacity(viewModel.isShowNumber ? 1 : 0)
            Text("\(viewModel.message.value)")
        }
    }
    
    @StateObject var viewModel = GuessNumberViewModel()
}

    #Preview {
        GuessNumberView()
    }
