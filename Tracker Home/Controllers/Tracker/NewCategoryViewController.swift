//
//  NewCategoryViewController.swift
//  Tracker Home
//
//  Created by Марат Хасанов on 05.01.2024.
//

import UIKit

protocol NewCategoryViewControllerDelegate: AnyObject {
    func categoryName(name: String)
}

//Категория
class NewCategoryViewController: UIViewController {
    
    weak var delegate: NewCategoryViewControllerDelegate?
    private var text = ""
    private var categorysName: [String] = []
    
    init(delegate: NewCategoryViewControllerDelegate?) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название категории"
        textField.clearButtonMode = .whileEditing
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.backgroundColor = .udBackground
        textField.layer.cornerRadius = 16
        textField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var readyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .udGray
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(addTracker), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новая категория"
        textField.delegate = self
        view.backgroundColor = .udWhiteDay
        textField.delegate = self
        setupAllViews()
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        self.text = text
        if text.count >= 1 {
            textField.rightViewMode = .always
            readyButton.backgroundColor = .udBlackDay
            readyButton.setTitle("Добавить категорию", for: .normal)
            readyButton.isEnabled = true
        } else {
            textField.rightViewMode = .never
            readyButton.backgroundColor = .udGray
            readyButton.isEnabled = false
        }
    }
    
    func setupCategoryName() {
        guard let category = categorysName.last else { return }
        self.delegate?.categoryName(name: category)
    }
    
    @objc
    private func addTracker() {
        self.delegate?.categoryName(name: text)
        categorysName.append(text)
        dismiss(animated: true)
    }
    
    private func setupAllViews() {
        view.addSubview(textField)
        view.addSubview(readyButton)
        
        NSLayoutConstraint.activate([
        
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)])
    }
}

extension NewCategoryViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

