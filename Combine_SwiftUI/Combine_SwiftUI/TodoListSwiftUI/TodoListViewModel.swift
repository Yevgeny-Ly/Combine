//
//  TodoListViewModel.swift
//  Combine_SwiftUI
//

import SwiftUI
import Combine

final class TodoListViewModel: ObservableObject {
    @Published var dataToList: [String] = []
    @Published var value = ""
    @Published var isHidden = false
    
    var selection = CurrentValueSubject<String, Never>("")
    var cancellable: Set<AnyCancellable> = []
    
    init() {
        selection
            .flatMap({ item -> AnyPublisher<String, Never> in
                if !item.isEmpty {
                    return Just(item)
                        .eraseToAnyPublisher()
                } else {
                    return Empty(completeImmediately: true)
                        .eraseToAnyPublisher()
                }
            })
            .sink { [unowned self] item in
                dataToList.append(item)
                value = ""
                objectWillChange.send()
            }
            .store(in: &cancellable)
    }
    
    func removeValue() {
        dataToList.removeAll()
        value = ""
    }
}
