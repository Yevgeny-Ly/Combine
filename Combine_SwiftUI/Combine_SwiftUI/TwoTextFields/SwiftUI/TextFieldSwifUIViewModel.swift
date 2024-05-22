//
//  TextFieldSwifUIViewModel.swift
//  Combine_SwiftUI
//

import SwiftUI
import Combine

final class TextFieldSwifUIViewModel: ObservableObject {
    
    private enum Constants {
        static var titleClose = "❌"
        static var titleDone = "✅"
    }
    
    @Published var name = ""
    @Published var nameValidation = ""
    @Published var secondName = ""
    @Published var secondNameValidation = ""
    
    init() {
        $name
            .map { $0.isEmpty ? Constants.titleClose : Constants.titleDone }
            .assign(to: &$nameValidation)
        $secondName
            .map { $0.isEmpty ? Constants.titleClose : Constants.titleDone }
            .assign(to: &$secondNameValidation)
    }
}
