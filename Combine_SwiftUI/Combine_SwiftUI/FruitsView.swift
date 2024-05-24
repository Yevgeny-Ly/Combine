//
//  FruitsView.swift
//  Combine_SwiftUI
//

import SwiftUI
import Combine

struct FruitsView: View {
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Фрукты").padding()) {
                    List(viewModel.dataToView, id: \.self) { item in
                        Text(item)
                    }
                }
                .font(.headline)
            }
            HStack {
                addButtonView
                Spacer()
                deleteButtonView
            }
            .padding()
        }
        .onAppear(){
            viewModel.fetch()
        }
    }
    
    @StateObject var viewModel = FruitsViewModel()
    
    private var addButtonView: some View {
        Button("Добавить") {
            viewModel.addFruit()
        }
    }
    
    private var deleteButtonView: some View {
        Button("Удалить") {
            viewModel.deleteFruit()
        }
    }
}

#Preview {
    FruitsView()
}
