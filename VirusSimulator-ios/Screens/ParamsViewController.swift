//
//  ParamsViewController.swift
//  VirusSimulator-ios
//
//  Created by Aleksey Kolesnikov on 22.03.2024.
//

import UIKit

//MARK: - ParamsViewController

final class ParamsViewController: UIViewController {
    
    // MARK: - Layout variables
    
    private lazy var headerLabel: UILabel = CustomLabel(text: "Ввод параметров", fontSize: 30)
    private lazy var sizeLabel: UILabel = CustomLabel(
        text: "Количество людей в моделируемой группе",
        numberOfLines: 2
    )
    private lazy var infectionFactorLabel: UILabel = CustomLabel(
        text: "Количество людей, которое может быть заражено одним человеком при контакте",
        numberOfLines: 3
    )
    private lazy var timeLabel: UILabel = CustomLabel(
        text: "Период перерасчёта количетсва зараженных людей",
        numberOfLines: 2
    )
    private lazy var sizeTextField: UITextField = CustomTextField(placeholder: "100", delegate: self)
    private lazy var infectionFactorTextField: UITextField = CustomTextField(placeholder: "3", delegate: self)
    private lazy var timeTextField: UITextField = CustomTextField(placeholder: "1", delegate: self)
    private lazy var simulateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .gray
        button.setTitle("Запустить моделирование", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(simulate), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
}

// MARK: - UITextFieldDelegate

extension ParamsViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = textField.text else { return false }
        let newString = NSString(string: text).replacingCharacters(in: range, with: string)
        
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: newString)) else { return false }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let sizeTextFieldtext = sizeTextField.text,
              let infectionFactorTextFieldtext = infectionFactorTextField.text,
              let timeTextFieldtext = timeTextField.text else {
            return
        }
        if !sizeTextFieldtext.isEmpty && !infectionFactorTextFieldtext.isEmpty && !timeTextFieldtext.isEmpty {
            buttonAvailible()
            return
        }
        buttonNotAvailible()
    }
}

// MARK: - Private functions

private extension ParamsViewController {
    func setupView() {
        view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
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
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            
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
    
    func buttonNotAvailible() {
        simulateButton.backgroundColor = .gray
    }
    
    func buttonAvailible() {
        simulateButton.backgroundColor = .black
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
        }
    }
}
