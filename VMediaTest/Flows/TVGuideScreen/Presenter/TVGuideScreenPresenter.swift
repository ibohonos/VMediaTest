//
//  TVGuideScreenPresenter.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 10.02.2023.
//

import Foundation
import UIKit

protocol TVGuideScreenPresenterProtocol: AnyObject {
    func setPrograms(_ value: [ProgramItem])
    func neededToGetChannelList()
    func neededConfigureCells(collectionView: UICollectionView)
    func neededToUpdateSnapshot()
}

final class TVGuideScreenPresenter {
    // MARK: - Properties
    private var view: TVGuideScreenViewControllerProtocol
    private var router: TVGuideScreenRouter
    private var interactor: TVGuideScreenIteractor!
    private var dataSource: UICollectionViewDiffableDataSource<Int, AnyHashable>!
    private var channels: [Channel] = []
    private var programs: [ProgramItem] = []
    private var sections: [ChannelSection] = [] {
        didSet {
            setupLayout()
        }
    }
    private var timeIntervals: [String] {
        var intervals: [String] = []// = ["Today"]
        
        for hour in 0 ..< 24 {
            for minute in [0, 30] {
                let time = String(format: "%02d:%02d", hour, minute)

                intervals.append(time)
            }
        }

        return intervals
    }
    
    init(with view: TVGuideScreenViewControllerProtocol, router: TVGuideScreenRouter) {
        self.view = view
        self.router = router
        interactor = TVGuideScreenIteractor(delegate: self)
    }
    
    func setPrograms(_ value: [ProgramItem]) {
        programs = value
    }
}

// MARK: - TVGuideScreenPresenterProtocol
extension TVGuideScreenPresenter: TVGuideScreenPresenterProtocol {
    func neededToGetChannelList() {
        interactor.loadChannelList()
    }
    
    func neededConfigureCells(collectionView: UICollectionView) {
        let timeCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, indexPath, time in
            var contentConfiguration = UIListContentConfiguration.subtitleCell()

            contentConfiguration.text = time

            cell.contentConfiguration = contentConfiguration
            cell.frame = cell.frame.insetBy(dx: 8, dy: 8)
            cell.backgroundColor = .placeholderText
        }
        
        let channelCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Channel> { cell, indexPath, channel in
            var contentConfiguration = UIListContentConfiguration.subtitleCell()
            
            contentConfiguration.textProperties.numberOfLines = 1
            contentConfiguration.secondaryTextProperties.numberOfLines = 1
            
            contentConfiguration.text = "\(channel.orderNum)"
            contentConfiguration.secondaryText = channel.CallSign
            
            cell.contentConfiguration = contentConfiguration
            cell.frame = cell.frame.insetBy(dx: 8, dy: 8)
            cell.backgroundColor = .placeholderText
        }
        
        let programCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ProgramItem> { cell, indexPath, programItem in
            var contentConfiguration = UIListContentConfiguration.subtitleCell()
            
            contentConfiguration.textProperties.numberOfLines = 1
            contentConfiguration.secondaryTextProperties.numberOfLines = 3

            contentConfiguration.text = programItem.name
            contentConfiguration.secondaryText = programItem.startTime.toDate?.stingWithoutDate

            cell.contentConfiguration = contentConfiguration
            cell.frame = cell.frame.insetBy(dx: 8, dy: 8)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, AnyHashable>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            switch item {
                case let timeInterval as String:
                    return collectionView.dequeueConfiguredReusableCell(using: timeCellRegistration, for: indexPath, item: timeInterval)
                case let channel as Channel:
                    return collectionView.dequeueConfiguredReusableCell(using: channelCellRegistration, for: indexPath, item: channel)
                case let program as ProgramItem:
                    return collectionView.dequeueConfiguredReusableCell(using: programCellRegistration, for: indexPath, item: program)
                default:
                    return nil
            }
        }
    }
    
    func neededToUpdateSnapshot() {
        let channelSections = channels.map { channel -> ChannelSection in
            let programs = programs.filter { $0.recentAirTime.channelID == channel.id }

            return ChannelSection(channel: channel, programs: programs)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, AnyHashable>()
        snapshot.appendSections([0])
        snapshot.appendItems([programs.first?.startTime.toDate?.stringFormated(format: "MMMM d") ?? ""], toSection: 0)
        snapshot.appendItems(timeIntervals, toSection: 0)

        for (sectionIndex, channelSection) in channelSections.enumerated() {
            snapshot.appendSections([sectionIndex + 1])
            snapshot.appendItems([channelSection.channel], toSection: sectionIndex + 1)

            let programItems = channelSection.programs
            snapshot.appendItems(programItems, toSection: sectionIndex + 1)
        }
        
        sections = channelSections
        dataSource.applySnapshotUsingReloadData(snapshot)
    }
}

// MARK: - TVGuideScreenIteractorDelegate
extension TVGuideScreenPresenter: TVGuideScreenIteractorDelegate {
    func didGetError(message: String?) {
        view.didGetError(message: message)
    }
    
    func didGetChannels(response: [Channel]) {
        channels.appendDistinct(contentsOf: response, where: { $0.id != $1.id })
        view.didGetChannels()
    }
}

// MARK: - Private
private extension TVGuideScreenPresenter {
    func setupLayout() {
        let layout = EPGCollectionViewLayout()

        layout.channels = sections
        layout.timeCount = timeIntervals.count

        view.didSetupLayout(layout)
    }
}
