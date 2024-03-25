//
//  ParamsViewController.swift
//  VirusSimulator-ios
//
//  Created by Aleksey Kolesnikov on 22.03.2024.
//

import UIKit

final class ParamsViewController: UIViewController {

    // MARK: - Layout variables
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Ввод параметров"
        label.font = .systemFont(ofSize: 30)
        
        return label
    }()
    private lazy var sizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Количество людей в моделируемой группе"
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 2
        
        return label
    }()
    private lazy var infectionFactorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Количество людей, которое может быть заражено одним человеком при контакте"
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 3
        
        return label
    }()
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Период перерасчёта количетсва зараженных людей"
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 2
        
        return label
    }()
    private lazy var sizeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = "100"
        textField.font = .systemFont(ofSize: 20)
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.leftView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 10,
                height: textField.frame.height
            )
        )
        textField.rightView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 10,
                height: textField.frame.height
            )
        )
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        
        return textField
    }()
    private lazy var infectionFactorTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = "3"
        textField.font = .systemFont(ofSize: 20)
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        
        return textField
    }()
    private lazy var timeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = "1"
        textField.font = .systemFont(ofSize: 20)
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        
        return textField
    }()
    private lazy var simulateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .black
        button.setTitle("Запустить моделирование", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(simulate), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
}

private extension ParamsViewController {
    func setupView() {
        view.backgroundColor = .white
        addSubViews()
        configureConstraints()
    }
    
    func addSubViews() {
        view.addSubview(headerLabel)
        view.addSubview(sizeLabel)
        view.addSubview(sizeTextField)
        view.addSubview(infectionFactorLabel)
        view.addSubview(infectionFactorTextField)
        view.addSubview(timeLabel)
        view.addSubview(timeTextField)
        view.addSubview(simulateButton)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            sizeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            sizeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            sizeLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16),
            
            sizeTextField.leadingAnchor.constraint(equalTo: sizeLabel.leadingAnchor),
            sizeTextField.trailingAnchor.constraint(equalTo: sizeLabel.trailingAnchor),
            sizeTextField.topAnchor.constraint(equalTo: sizeLabel.bottomAnchor, constant: 4),
            sizeTextField.heightAnchor.constraint(equalToConstant: 40),
            
            infectionFactorLabel.leadingAnchor.constraint(equalTo: sizeLabel.leadingAnchor),
            infectionFactorLabel.trailingAnchor.constraint(equalTo: sizeLabel.trailingAnchor),
            infectionFactorLabel.topAnchor.constraint(equalTo: sizeTextField.bottomAnchor, constant: 30),
            
            infectionFactorTextField.leadingAnchor.constraint(equalTo: sizeLabel.leadingAnchor),
            infectionFactorTextField.trailingAnchor.constraint(equalTo: sizeLabel.trailingAnchor),
            infectionFactorTextField.topAnchor.constraint(equalTo: infectionFactorLabel.bottomAnchor, constant: 4),
            infectionFactorTextField.heightAnchor.constraint(equalToConstant: 40),
            
            timeLabel.leadingAnchor.constraint(equalTo: sizeLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: sizeLabel.trailingAnchor),
            timeLabel.topAnchor.constraint(equalTo: infectionFactorTextField.bottomAnchor, constant: 30),
            
            timeTextField.leadingAnchor.constraint(equalTo: sizeLabel.leadingAnchor),
            timeTextField.trailingAnchor.constraint(equalTo: sizeLabel.trailingAnchor),
            timeTextField.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            timeTextField.heightAnchor.constraint(equalToConstant: 40),
            
            simulateButton.leadingAnchor.constraint(equalTo: sizeLabel.leadingAnchor),
            simulateButton.trailingAnchor.constraint(equalTo: sizeLabel.trailingAnchor),
            simulateButton.heightAnchor.constraint(equalToConstant: 60),
            simulateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc
    func simulate() {
        if let sizeTextFieldText = sizeTextField.text,
              let infectionFactorText = infectionFactorTextField.text,
              let timeOfIterationText = timeTextField.text,
              let groupSize = Int(sizeTextFieldText),
              let infectionFactor = Int(infectionFactorText),
              let timeOfIteration = Int(timeOfIterationText) {
            
            let simulateViewController = SimulateViewController(
                groupSize: groupSize,
                infectionFactor: infectionFactor,
                timeOfIteration: timeOfIteration
            )
            navigationController?.pushViewController(simulateViewController, animated: true)
        } else {
            let simulateViewController = SimulateViewController(
                groupSize: 100,
                infectionFactor: 3,
                timeOfIteration: 1
            )
            navigationController?.pushViewController(simulateViewController, animated: true)
        }
    }
}
