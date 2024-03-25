//
//  CustomTextField.swift
//  VirusSimulator-ios
//
//  Created by Aleksey Kolesnikov on 25.03.2024.
//

import UIKit

final class CustomTextField: UITextField {
    private let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    init(placeholder: String) {
        super.init(frame: .zero)
        setupTextField(placeholder: placeholder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    private func setupTextField(placeholder: String) {
        translatesAutoresizingMaskIntoConstraints = false
        
        font = .systemFont(ofSize: 20)
        textColor = .black
        self.placeholder = placeholder
        layer.cornerRadius = 8
        layer.borderWidth = 1
        
    }
}
