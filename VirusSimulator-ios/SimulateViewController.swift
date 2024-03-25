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
        
        collectionView.register(
            CollectionViewCell.self,
            forCellWithReuseIdentifier: CollectionViewCell.cellName
        )
        addSubViews()
        configureConstraints()
    }
    
    func addSubViews() {
        view.addSubview(collectionView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
