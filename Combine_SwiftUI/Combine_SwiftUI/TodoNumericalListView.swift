//
//  TodoNumericalListView.swift
//  Combine_SwiftUI
//

import SwiftUI
import Combine

struct TodoNumericalListView: View {
    var body: some View {
        VStack {
            textFieldView
            errorMessageView
            HStack {
                addButtonView
                clearButtonView
            }
            listView
            Spacer()
        }
    }
    
    @StateObject var viewModel = TodoNumericalListViewModel()

    
    private var textFieldView: some View {
        TextField("Введите число", text: Binding(get: {
            "\(viewModel.text)"
        }, set: { newValue in
                viewModel.text = newValue
        }))
        .textFieldStyle(.roundedBorder)
        .padding()
    }
    
    private var errorMessageView: some View {
        VStack {
            if let error = viewModel.error?.rawValue {
                Text(error)
                    .font(.body)
                    .foregroundColor(.red)
            }
        }
    }
    
    private var addButtonView: some View {
        Button(action: {
            viewModel.save()
        }, label: {
            Text("Добавить")
                .padding()
        })
        .disabled(viewModel.text.isEmpty)
    }

    private var clearButtonView: some View {
        Button(action: {
            viewModel.removeValue()
        }, label: {
            Text("Отменить")
        })
        .padding()
        .foregroundColor(.blue)
    }
    
    private var listView: some View {
        List(viewModel.dataToList, id: \.self) { item in
            Text(String(item))
        }
    }
}

enum InvalidationNumericError: String, Error, Identifiable {
    var id: String { rawValue }
    case nonNumericValue = "Не числовое значение"
}

final class TodoNumericalListViewModel: ObservableObject {
    @Published var dataToList: [Int] = []
    @Published var value = 0
    @Published var text = ""
    @Published var error: InvalidationNumericError?
    
    func save() {
        _ = validationPublisher(value: Int(text))
            .sink { [unowned self] completion in
                switch completion {
                case.failure(let error):
                    self.error = error
                case.finished:
                    break
                }
            } receiveValue: { [unowned self] value in
                self.value = value
            }
    }
    
    
    func validationPublisher(value: Int?) -> AnyPublisher<Int, InvalidationNumericError> {
        if let value = value {
            dataToList.append(value)
            return Just(value)
                .setFailureType(to: InvalidationNumericError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: InvalidationNumericError.nonNumericValue)
                .eraseToAnyPublisher()
        }
    }
    
    func removeValue() {
        dataToList.removeAll()
        error = nil
    }
}
    
    #Preview {
        TodoNumericalListView()
    }
