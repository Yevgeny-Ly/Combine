//
//  FruitsViewModel.swift
//  Combine_SwiftUI
//

import Foundation
import Combine

final class FruitsViewModel: ObservableObject {
    
    var arrayFruites = ["Яблоко", "Банан", "Апельсин"]
    var arrayFruitesSet = ["Фрукт 3", "Фрукт 4", "Фрукт 5"]
    
    @Published var dataToView: [String] = []
    
    func fetch() {
        Just(arrayFruites)
            .flatMap{ $0.publisher }
            .collect()
            .assign(to: &$dataToView)
    }
    
    func addFruit() {
        _ = arrayFruitesSet.publisher
            .first()
            .sink(receiveCompletion: { completion in
            }, receiveValue: { [unowned self] value in
                dataToView.append(value)
                arrayFruitesSet.removeFirst()
                return
            })
    }
    
    func deleteFruit() {
        dataToView.removeLast()
    }
}
