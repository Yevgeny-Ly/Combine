//
//  TextFieldUIKitViewModel.swift
//  Combine_SwiftUI
//

import SwiftUI
import Combine

final class TextFieldUIKitViewModel: ObservableObject {
    
    private enum Constants {
        static var titleClose = "❌"
        static var titleDone = "✅"
    }
    
    @Published var name = ""
    @Published var secondName = ""
    @Published var validationName: String? = ""
    @Published var validationSecondName: String? = ""
    
    init() {
        $name
            .map { $0.isEmpty ? Constants.titleClose : Constants.titleDone }
            .assign(to: &$validationName)
        $secondName
            .map { $0.isEmpty ? Constants.titleClose : Constants.titleDone }
            .assign(to: &$validationSecondName)
        
    }
}
