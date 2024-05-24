//
//  TodoListUIKitViewController.swift
//  Combine_SwiftUI
//

import SwiftUI
import Combine

class TodoListUIKitViewController: UIViewController {
    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите строку"
        textField.frame = CGRect(x: 20, y: 90, width: 230, height: 50)
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(changeValue), for: .editingChanged)
        return textField
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить", for: .normal)
        button.frame = CGRect(x: 40, y: 150, width: 150, height: 50)
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(addValue), for: .touchUpInside)
        return button
    }()
    
    private lazy var cleanButton: UIButton = {
        let button = UIButton()
        button.setTitle("Очистить", for: .normal)
        button.frame = CGRect(x: 190, y: 150, width: 150, height: 50)
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(removeValue), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 400, width: UIScreen.main.bounds.width, height: 300)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        return tableView
    }()
    
    private let viewModel = TodoListUIKitViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateStateAddButton()
    }

    private func setupUI() {
        view.addSubview(taskTextField)
        view.addSubview(addButton)
        view.addSubview(cleanButton)
        view.addSubview(tableView)
    }
    
    private func updateStateAddButton() {
        let text = taskTextField.text ?? ""
        addButton.isEnabled = !text.isEmpty
        let titleColor = addButton.isEnabled ? UIColor.blue : UIColor.systemGray4
        addButton.setTitleColor(titleColor, for: .normal)
        addButton.setTitleColor(titleColor, for: .disabled)
    }
    
    @objc private func addValue() {
        viewModel.selection.send(taskTextField.text ?? "")
        taskTextField.text = ""
        updateStateAddButton()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc private func removeValue() {
        viewModel.removeItem()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc private func changeValue() {
        updateStateAddButton()
    }
}

extension TodoListUIKitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataToList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .gray
        cell.textLabel?.text = viewModel.dataToList[indexPath.row]
        return cell
    }
}
