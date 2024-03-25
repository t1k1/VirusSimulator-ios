//
//  CustomLabel.swift
//  VirusSimulator-ios
//
//  Created by Aleksey Kolesnikov on 25.03.2024.
//

import UIKit

final class CustomLabel: UILabel {
    init(text: String = "", fontSize: CGFloat = 20, numberOfLines: Int = 1) {
        super.init(frame: .zero)
        setupLabel(text: text, fontSize: fontSize, numberOfLines: numberOfLines)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel(text: String, fontSize: CGFloat, numberOfLines: Int) {
        translatesAutoresizingMaskIntoConstraints = false
        
        textColor = .black
        self.text = text
        font = .systemFont(ofSize: fontSize)
        self.numberOfLines = numberOfLines
    }
}
