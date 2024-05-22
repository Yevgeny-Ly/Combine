//
//  TextFieldSwifUIView.swift
//  Combine_SwiftUI
//

import SwiftUI
import Combine

struct TextFieldSwifUIView: View {
    
    private enum Constants {
        static var titleName = "Ваше имя"
        static var titleLastName = "Ваша фамилия"
    }
    
    @StateObject var viewModel = TextFieldSwifUIViewModel()
    
    var body: some View {
        VStack {
            HStack {
                TextField(Constants.titleName, text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(viewModel.nameValidation)
            }
            .padding()
            HStack {
                TextField(Constants.titleLastName, text: $viewModel.secondName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(viewModel.secondNameValidation)
            }
            .padding()
        }
    }
}

#Preview {
    TextFieldSwifUIView()
}
