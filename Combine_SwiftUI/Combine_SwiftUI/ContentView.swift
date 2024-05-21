//
//  ContentView.swift
//  Combine_SwiftUI
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @StateObject var viewModel = FirstPipelineViewModel()
    
    var body: some View {
        VStack {
            HStack {
                TextField("Ваше имя", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(viewModel.nameValidation)
            }
            .padding()
            HStack {
                TextField("Ваша Фамилия", text: $viewModel.secondName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(viewModel.secondNameValidation)
            }
            .padding()
        }
    }
}

class FirstPipelineViewModel: ObservableObject {
    @Published var name = ""
    @Published var nameValidation = ""
    @Published var secondName = ""
    @Published var secondNameValidation = ""
    
    init() {
        $name
            .map { $0.isEmpty ? "❌" : "✅" }
            .assign(to: &$nameValidation)
        $secondName
            .map { $0.isEmpty ? "❌" : "✅" }
            .assign(to: &$secondNameValidation)
    }
}

#Preview {
    ContentView()
}
