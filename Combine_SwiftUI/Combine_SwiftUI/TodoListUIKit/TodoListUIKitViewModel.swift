//
//  TodoListUIKitViewModel.swift
//  Combine_SwiftUI
//

import UIKit
import Combine

final class TodoListUIKitViewModel: ObservableObject {
    @Published var value = ""
    @Published var dataToList: [String] = []
    
    var selection = CurrentValueSubject<String, Never>("")
    var cancellable: Set<AnyCancellable> = []
    
    init() {
        selection
            .flatMap({ item -> AnyPublisher<String, Never>  in
                if !item.isEmpty {
                    return Just(item)
                        .eraseToAnyPublisher()
                } else {
                    return Empty(completeImmediately: true)
                        .eraseToAnyPublisher()
                }
            })
            .sink { [unowned self] values in
                dataToList.append(values)
                value = ""
                objectWillChange.send()
            }
            .store(in: &cancellable)
    }
    
    func removeItem() {
        dataToList.removeAll()
        value = ""
    }
}
