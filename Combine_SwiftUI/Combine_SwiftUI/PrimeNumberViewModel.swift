//
//  PrimeNumberViewModel.swift
//  Combine_SwiftUI
//

import SwiftUI
import Combine

final class PrimeNumberViewModel: ObservableObject {
    @Published var numberValue = ""
    @Published var result = ""
    @Published var isPrime = false
    
    func fetch() {
        _ = validateNumber()
            .sink { complition in
                self.result = complition
            }
    }
    
    func validateNumber() -> AnyPublisher<String, Never> {
        Deferred {
            Future<String, Never> { promise in
                if let number = Int(self.numberValue){
                    if number > 1 && !(2..<number).contains(where: { number % $0 == 0 }){
                        promise(.success("\(number) - простое число"))
                        self.isPrime = true
                    } else {
                        promise(.success("\(number) - Не простое число"))
                        self.isPrime = false
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
