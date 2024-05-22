//
//  GuessNumberViewModel.swift
//  Combine_SwiftUI
//

import SwiftUI
import Combine

final class GuessNumberViewModel: ObservableObject {
    private enum Constants {
        static var titleVerification = "Идет проверка..."
        static var titleLess = "Введенное число меньше загаданного"
        static var titleMore = "Введенное число больше загаданного"
        static var titleGuessed = "Угадали"
    }
    
    var selectionNumber = CurrentValueSubject<Int, Never>(Int.random(in: 1...100))
    var selection = CurrentValueSubject<Int, Never>(0)
    var message = CurrentValueSubject<String, Never>("")
    
    var cancellable: AnyCancellable?
    @Published var isShowNumber = false
    
    init() {
        cancellable = selection
            .map { _ in
                self.message.value = Constants.titleVerification
            }
            .delay(for: 0.8, scheduler: DispatchQueue.main)
            .sink { [unowned self] newValue in
                if selection.value < selectionNumber.value {
                    self.message.value = Constants.titleLess
                    objectWillChange.send()
                } else if selection.value > selectionNumber.value {
                    self.message.value = Constants.titleMore
                    objectWillChange.send()
                } else {
                    self.message.value = Constants.titleGuessed
                    objectWillChange.send()
                }
            }
    }
    
    func cancel() {
        cancellable?.cancel()
        isShowNumber = true
    }
}
