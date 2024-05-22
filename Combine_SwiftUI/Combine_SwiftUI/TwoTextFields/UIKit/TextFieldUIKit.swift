//
//  TextFieldUIKit.swift
//  Combine_SwiftUI
//

import UIKit
import Combine

class TextFieldUIKitViewController: UIViewController {
    
    private enum Constants {
        static var titleName = "Ваше имя"
        static var titleLastName = "Ваша фамилия"
    }
    
    var viewMoadel = TextFieldUIKitViewModel()
    
    let nameLabel = UILabel()
    let nameTextField = UITextField()
    
    let secondNameLabel = UILabel()
    let secondNameTextField = UITextField()
    
    var anyCancellableName: AnyCancellable?
    var anyCancellableSecondName: AnyCancellable?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.frame = CGRect(x: 250, y: 100, width: 100, height: 50)
        nameTextField.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        nameTextField.placeholder = Constants.titleName
        
        secondNameLabel.frame = CGRect(x: 250, y: 150, width: 100, height: 50)
        secondNameTextField.frame = CGRect(x: 100, y: 150, width: 100, height: 50)
        secondNameTextField.placeholder = Constants.titleLastName
        
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        
        view.addSubview(secondNameLabel)
        view.addSubview(secondNameTextField)
        
        nameTextField.delegate = self
        secondNameTextField.delegate = self
        
        anyCancellableName = viewMoadel.$validationName.receive(on: DispatchQueue.main)
            .assign(to: \.text, on: nameLabel)
        
        anyCancellableSecondName = viewMoadel.$validationSecondName.receive(on: DispatchQueue.main)
            .assign(to: \.text, on: secondNameLabel)
    }
}

extension TextFieldUIKitViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameTextField {
            let nameNew = (nameTextField.text ?? "") + string
            let secondNameNew = (secondNameTextField.text ?? "")
            viewMoadel.name = nameNew
            viewMoadel.secondName = secondNameNew
        } else if textField == secondNameTextField {
            let secondNameNew = (secondNameTextField.text ?? "") + string
            let nameNew = (nameTextField.text ?? "")
            viewMoadel.secondName = secondNameNew
            viewMoadel.name = nameNew
        }
        return true
    }
}
