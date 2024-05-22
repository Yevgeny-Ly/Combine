//
//  TaxiViewViewModel.swift
//  Combine_SwiftUI
//

import SwiftUI
import Combine

final class TaxiSwiftUIViewModel: ObservableObject {
    @Published var data = ""
    @Published var status = ""
    
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = $data
            .map { [unowned self] value -> String in
                status = "Ищем машину..."
                return value
            }
            .delay(for: 7, scheduler: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] value in
                data = "Водитель будет через 10 минут"
                status = "Машина найдена"
            })
    }
    
    func refresh() {
        data = "Уже ищем машину"
    }
    
    func cancel() {
        status = "Машина отменена"
        cancellable?.cancel()
        cancellable = nil
    }
}
