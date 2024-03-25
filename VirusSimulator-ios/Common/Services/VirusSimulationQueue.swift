//
//  VirusSimulationQueue.swift
//  VirusSimulator-ios
//
//  Created by Aleksey Kolesnikov on 24.03.2024.
//

import Foundation

//MARK: - VirusSimulationQueue

final class VirusSimulationQueue {
    
    //MARK: - Private variables
    
    private weak var delegate: SimulateViewControllerDelegate?
    private let recalculationQueue: DispatchQueue
    private let updateUiQueue: DispatchQueue
    private let timeOfIteration: Int
    private let infectionFactor: Int
    private var timerEventMonitor: DispatchSourceTimer?
    private var elementsInRow: Int
    
    //MARK: - Initialization
    
    init(
        delegate: SimulateViewControllerDelegate? = nil,
        timeOfIteration: Int,
        infectionFactor: Int,
        elementsInRow: Int
    ) {
        updateUiQueue = DispatchQueue.main
        recalculationQueue = DispatchQueue.global()
        timerEventMonitor = DispatchSource.makeTimerSource(flags: [], queue: recalculationQueue)
        
        self.delegate = delegate
        self.timeOfIteration = timeOfIteration
        self.infectionFactor = infectionFactor
        self.elementsInRow = elementsInRow
    }
    
    //MARK: - Public functions
    
    func stopRecalculation() {
        delegate = nil
        timerEventMonitor?.cancel()
    }
    
    func startRecalculation() {
        guard timeOfIteration > 0 && infectionFactor > 0,
              let delegate = delegate,
              let timerEventMonitor = timerEventMonitor else {
            return
        }
        
        timerEventMonitor.schedule(
            deadline: .now() + DispatchTimeInterval.seconds(timeOfIteration),
            repeating: Double(timeOfIteration)
        )
        timerEventMonitor.setEventHandler { [weak self] in
            guard let self = self else { return }
            
            let recalculatedGroup = recalculate(group: delegate.getGroup())
            
            updateUiQueue.async {
                self.delegate?.updateCollectionView(with: recalculatedGroup)
            }
        }
        timerEventMonitor.resume()
    }
}

//MARK: - Private functions

private extension VirusSimulationQueue {
    func recalculate(group: [Bool]) -> [Bool] {
        var resultGroup = group
        let groupCount = group.count
        var infectedId: [Int] = []
        
        for i in 0..<groupCount  {
            if group[i] {
                infectedId.append(i)
            }
        }
        
        let idForInfection = getSetOfInfected(infectedId, elementsInRow: elementsInRow, groupSize: groupCount)
        idForInfection.forEach() { id in
            resultGroup[id] = true
        }
        
        return resultGroup
    }
    
    func getSetOfInfected(_ infectedIds: [Int], elementsInRow: Int, groupSize: Int) -> Set<Int> {
        var result: Set<Int> = []
        
        infectedIds.forEach() { id in
            let arrOfSimulatedInfection = getArrOfSimulatedInfection(
                groupSize: groupSize,
                elementsInRow: elementsInRow,
                infectedId: id
            )
            
            result.formUnion(arrOfSimulatedInfection)
        }
        
        return result
    }
    
    func getArrOfSimulatedInfection(groupSize: Int, elementsInRow: Int, infectedId: Int) -> [Int] {
        let row = infectedId / elementsInRow
        let col = infectedId % elementsInRow
        
        var neighbors: [Int] = []
        
        for r in max(0, row - 1)...min(row + 1, groupSize / elementsInRow) {
            for c in max(0, col - 1)...min(col + 1, elementsInRow) {
                let idNear = r * elementsInRow + c
                if idNear != infectedId && idNear >= 0 && idNear < groupSize {
                    neighbors.append(idNear)
                }
            }
        }
        
        return getRandomSubArr(neighbors)
    }
    
    func getRandomSubArr(_ arr: [Int]) -> [Int] {
        let arrCount = arr.count
        var randomSubArr: [Int] = []
        
        while randomSubArr.count < min(Int.random(in: 1...infectionFactor), arrCount) {
            let randomIndex = Int.random(in: 0..<arrCount)
            let randomElement = arr[randomIndex]
            
            if !randomSubArr.contains(randomElement) {
                randomSubArr.append(randomElement)
            }
        }
        randomSubArr.shuffle()
        
        return randomSubArr
    }
}

