//
//  TaxiViewController.swift
//  Combine_SwiftUI
//

import UIKit
import Combine

class TaxiViewController: UIViewController {
    
    var viewVodel = TaxiUIKitViewModel()

    lazy private var dataLabel: UILabel = {
        let label = UILabel()
        label.text = (viewVodel.data)
        label.font = UIFont(name: "Verdana", size: 28)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .systemGreen
        return label
    }()
    
    lazy private var statusLabel: UILabel = {
        let label = UILabel()
        label.text = (viewVodel.status)
        label.font = UIFont(name: "Verdana", size: 20)
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()
    
    lazy private var orderTaxiButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.layer.cornerRadius = 20
        button.setTitle("Заказать другой автомобиль", for: .normal)
        button.addTarget(self, action: #selector(tappedOrderButton), for: .touchUpInside)
        return button
    }()
    
    lazy private var cancelTaxiButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemMint
        button.layer.cornerRadius = 20
        button.setTitle("Отменить такси", for: .normal)
        button.addTarget(self, action: #selector(tappedCancelButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let subscribersOne = Subscribers.Assign(object: dataLabel, keyPath: \.text)
        viewVodel.$data.subscribe(subscribersOne)
        
        let subscribersTwo = Subscribers.Assign(object: statusLabel, keyPath: \.text)
        viewVodel.$status.subscribe(subscribersTwo)
        
        dataLabel.frame = CGRect(x: 45, y: 300, width: 300, height: 80)
        statusLabel.frame = CGRect(x: 100, y: 380, width: 200, height: 40)
        
        orderTaxiButton.frame = CGRect(x: 50, y: 670, width: 280, height: 50)
        cancelTaxiButton.frame = CGRect(x: 110, y: 730, width: 180, height: 50)
        
        view.addSubview(dataLabel)
        view.addSubview(statusLabel)
        
        view.addSubview(orderTaxiButton)
        view.addSubview(cancelTaxiButton)
    }

    
    @objc private func tappedOrderButton() {
        viewVodel.refresh()
    }
    
    @objc private func tappedCancelButton() {
        viewVodel.cancel()
    }
}

