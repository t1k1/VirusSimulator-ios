//
//  CollectionViewCell.swift
//  VirusSimulator-ios
//
//  Created by Aleksey Kolesnikov on 23.03.2024.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    static let cellName = "humanCell"
    weak var delegate: SimulateDelegate?
    
    private lazy var button = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        
        button.addTarget(self, action: #selector(infect), for: .touchUpInside)
        return button
    }()
    
    private var isInfected: Bool?
    private var index: Int?
    
    func configureCell(isInfected: Bool, index: Int) {
        self.isInfected = isInfected
        self.index = index
        
        button.setTitle("\(index)", for: .normal)
        
        if isInfected {
            button.backgroundColor = .red
        } else {
            button.backgroundColor = .white
        }
        addSubViews()
        configureConstraints()
    }
}

private extension CollectionViewCell {
    func addSubViews() {
        contentView.addSubview(button)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    @objc
    func infect() {
        self.isInfected = true
        guard let delegate = delegate,
              let isInfected = isInfected,
              let index = index else {
            return
        }
        button.backgroundColor = .red
        delegate.update(isInfected: isInfected, index: index)
    }
}
