//
//  TodoListView.swift
//  Combine_SwiftUI
//

import SwiftUI
import Combine

struct TodoListView: View {
    var body: some View {
        VStack {
            textFieldView
            HStack {
                addButtonView
                clearButtonView
            }
            listView
            Spacer()
        }
    }
    
    @StateObject var viewModel = TodoListViewModel()
    
    private var textFieldView: some View {
        TextField("Введите задачу", text: $viewModel.value)
            .textFieldStyle(.roundedBorder)
            .padding()
    }
    
    private var addButtonView: some View {
        Button(action: {
            viewModel.selection.send(viewModel.value)
        }, label: {
            Text("Добавить")
                .padding()
                .foregroundColor(viewModel.value.isEmpty ? .gray : .blue)
        })
        .disabled(viewModel.value.isEmpty)
    }
    
    private var clearButtonView: some View {
        Button(action: {
            viewModel.removeValue()
        }, label: {
            Text("Очистить список")
        })
        .padding()
        .foregroundColor(.blue)
    }
    
    private var listView: some View {
        List(viewModel.dataToList, id: \.self) { item in
            Text(item)
        }
        .font(.title)
    }
}
    
#Preview {
    TodoListView()
}
