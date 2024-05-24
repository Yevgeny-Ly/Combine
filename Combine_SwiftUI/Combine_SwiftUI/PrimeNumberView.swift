//
//  PrimeNumberView.swift
//  Combine_SwiftUI
//

import SwiftUI
import Combine

struct PrimeNumberView: View {
        var body: some View {
            VStack{
                TextField("Введите число", text: $viewModel.numberValue)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                Button("Проверить простоту числа") {
                    viewModel.fetch()
                }
                Text(viewModel.result)
                    .foregroundColor(viewModel.isPrime ? .green : .red)
            }
            .padding()
        }
    
    @StateObject private var viewModel = PrimeNumberViewModel()
}

#Preview {
    PrimeNumberView()
}

