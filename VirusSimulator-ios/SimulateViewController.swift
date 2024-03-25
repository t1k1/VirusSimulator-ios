//
//  SimulateViewController.swift
//  VirusSimulator-ios
//
//  Created by Aleksey Kolesnikov on 23.03.2024.
//

import UIKit

protocol SimulateDelegate: AnyObject {
    func update(isInfected: Bool, index: Int)
}

protocol SimulateViewControllerDelegate: AnyObject {
    func updateCollectionView(with newGroup: [Bool])
    func getGroup() -> [Bool]
}

final class SimulateViewController: UIViewController {

    private lazy var infectedCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private lazy var healthyCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        collectionViewLayout.itemSize = CGSize(width: 20, height: 20)
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        
        return collectionView
    }()
    
    private var group: [Bool] = []
    private var infectionFactor: Int?
    private var timeOfIteration: Int?
    private var queueRecalculation: VirusSimulationQueue?
    
    init(groupSize: Int, infectionFactor: Int, timeOfIteration: Int) {
        super.init(nibName: nil, bundle: nil)
        
        self.infectionFactor = infectionFactor
        self.timeOfIteration = timeOfIteration
        
        for _ in 1...groupSize {
            self.group.append(false)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let timeOfIteration = timeOfIteration,
              let infectionFactor = infectionFactor else {
            return
        }
        queueRecalculation = VirusSimulationQueue(
            delegate: self,
            timeOfIteration: timeOfIteration,
            infectionFactor: infectionFactor
        )
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queueRecalculation?.startRecalculation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        queueRecalculation?.stopRecalculation()
    }
}

extension SimulateViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return group.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCell.cellName,
            for: indexPath
        ) as? CollectionViewCell
        
        guard let cell = cell else { return UICollectionViewCell() }
        
        cell.delegate = self
        cell.configureCell(isInfected: group[indexPath.row], index: indexPath.row)
        
        return cell
    }
}

extension SimulateViewController: SimulateViewControllerDelegate {
    func getGroup() -> [Bool] {
        return group
    }
    
    func updateCollectionView(with newGroup: [Bool]) {
        if !group.contains(false) {
            queueRecalculation?.stopRecalculation()
            return
        }
    
        DispatchQueue.main.async { [self] in
            
            let infectedCount = newGroup.filter { $0 == true }.count
            updateLabels(healthyCount: newGroup.count - infectedCount, infectedCount: infectedCount)
            
            self.group = newGroup
            self.collectionView.reloadData()
        }
    }
}

extension SimulateViewController: SimulateDelegate {
    func update(isInfected: Bool, index: Int) {
        DispatchQueue.main.async {
            self.group[index] = isInfected
            self.updateCollectionView(with: self.group)
        }
    }
}

private extension SimulateViewController {
    func setupView() {
        view.backgroundColor = .white
        
        updateLabels(healthyCount: group.count, infectedCount: 0)
        
        collectionView.register(
            CollectionViewCell.self,
            forCellWithReuseIdentifier: CollectionViewCell.cellName
        )
        addSubViews()
        configureConstraints()
    }
    
    func addSubViews() {
        view.addSubview(infectedCountLabel)
        view.addSubview(healthyCountLabel)
        view.addSubview(collectionView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            infectedCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            infectedCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            infectedCountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            healthyCountLabel.leadingAnchor.constraint(equalTo: infectedCountLabel.leadingAnchor),
            healthyCountLabel.trailingAnchor.constraint(equalTo: infectedCountLabel.trailingAnchor),
            healthyCountLabel.topAnchor.constraint(equalTo: infectedCountLabel.bottomAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: healthyCountLabel.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func updateLabels(healthyCount: Int, infectedCount: Int) {
        infectedCountLabel.text = "Количество больных: \(infectedCount)"
        healthyCountLabel.text = "Количество здоровых: \(healthyCount)"
    }
}
