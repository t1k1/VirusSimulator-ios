//
//  SimulateViewController.swift
//  VirusSimulator-ios
//
//  Created by Aleksey Kolesnikov on 23.03.2024.
//

import UIKit

//MARK: - Protocols

protocol SimulateDelegate: AnyObject {
    func update(isInfected: Bool, index: Int)
}

protocol SimulateViewControllerDelegate: AnyObject {
    func updateCollectionView(with newGroup: [Bool])
    func getGroup() -> [Bool]
}

//MARK: - SimulateViewController

final class SimulateViewController: UIViewController {
    
    //MARK: - Layout variables
    
    private lazy var infectedCountLabel: UILabel = CustomLabel(fontSize: 16)
    private lazy var healthyCountLabel: UILabel = CustomLabel(fontSize: 16)
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionViewLayout.itemSize = CGSize(width: 24, height: 24)
        
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
    
    //MARK: - Private variables
    
    private var group: [Bool] = []
    private var infectionFactor: Int?
    private var timeOfIteration: Int?
    private var queueRecalculation: VirusSimulationQueue?
    
    //MARK: - Initialization
    
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
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let timeOfIteration = timeOfIteration,
              let infectionFactor = infectionFactor else {
            return
        }
        
        queueRecalculation = VirusSimulationQueue(
            delegate: self,
            timeOfIteration: timeOfIteration,
            infectionFactor: infectionFactor,
            elementsInRow: numberOfCellsInRow()
        )
        
        queueRecalculation?.startRecalculation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        queueRecalculation?.stopRecalculation()
    }
}

//MARK: - UICollectionViewDataSource

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

//MARK: - SimulateViewControllerDelegate

extension SimulateViewController: SimulateViewControllerDelegate {
    func getGroup() -> [Bool] {
        return group
    }
    
    func updateCollectionView(with newGroup: [Bool]) {
        if !group.contains(false) {
            queueRecalculation?.stopRecalculation()
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let infectedCount = newGroup.filter { $0 == true }.count
            self.updateLabels(healthyCount: newGroup.count - infectedCount, infectedCount: infectedCount)
            
            self.group = newGroup
            self.collectionView.reloadData()
        }
    }
}

//MARK: - SimulateDelegate

extension SimulateViewController: SimulateDelegate {
    func update(isInfected: Bool, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.group[index] = isInfected
            let infectedCount = self.group.filter { $0 == true }.count
            self.updateLabels(healthyCount: self.group.count - infectedCount, infectedCount: infectedCount)
            self.collectionView.reloadData()
        }
    }
}

//MARK: - Private functions

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
            
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: healthyCountLabel.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func updateLabels(healthyCount: Int, infectedCount: Int) {
        infectedCountLabel.text = "Количество больных: \(infectedCount)"
        healthyCountLabel.text = "Количество здоровых: \(healthyCount)"
    }
    
    func numberOfCellsInRow() -> Int {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return 0
        }
        
        let width = collectionView.frame.width
        let cellWidthWithSpacing = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
        let numberOfCellsInRow = Int(floor(width / cellWidthWithSpacing))
        
        return numberOfCellsInRow
    }
}
