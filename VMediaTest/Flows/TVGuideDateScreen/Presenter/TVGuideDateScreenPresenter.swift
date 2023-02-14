//
//  TVGuideDateScreenPresenter.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 14.02.2023.
//

import Foundation
import SwiftUI

protocol TVGuideDateScreenPresenterProtocol: AnyObject {
    func neededToGetProgramList()
    func neededConfigureCells(tableView: UITableView)
    func neededToShowTVGuide(indexPath: IndexPath)
}

final class TVGuideDateScreenPresenter {
    // MARK: - Properties
    private var view: TVGuideDateScreenViewControllerProtocol
    private var router: TVGuideDateScreenRouter
    private var interactor: TVGuideDateScreenIteractor!
    private var dataSource: UITableViewDiffableDataSource<Int, String>!
    private var programs: [ProgramItem] = []
    
    init(with view: TVGuideDateScreenViewControllerProtocol, router: TVGuideDateScreenRouter) {
        self.view = view
        self.router = router
        interactor = TVGuideDateScreenIteractor(delegate: self)
    }
}

// MARK: - TVGuideDateScreenIteractorDelegate
extension TVGuideDateScreenPresenter: TVGuideDateScreenIteractorDelegate {
    func didGetError(message: String?) {
        view.didGetError(message: message)
    }
    
    func didGetPrograms(response: [ProgramItem]) {
        programs.appendDistinct(contentsOf: response, where: { $0.id != $1.id })
        updateSnapshot()
        view.didGetPrograms()
    }
}

// MARK: - TVGuideDateScreenPresenterProtocol
extension TVGuideDateScreenPresenter: TVGuideDateScreenPresenterProtocol {
    func neededToGetProgramList() {
        interactor.loadProgramList()
    }
    
    func neededToShowTVGuide(indexPath: IndexPath) {
        let date = dataSource.itemIdentifier(for: indexPath)?.toDate(withFormat: "dd.MM.yyyy")
        let progs = programs.filter { $0.startTime.toDate?.startOfDay == date?.startOfDay }

        router.showTVGuide(programs: progs)
    }
    
    func neededConfigureCells(tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource<Int, String>(tableView: tableView) { (tableView, indexPath, time) -> UITableViewCell? in
            let cell = UITableViewCell()
            var conf = UIListContentConfiguration.subtitleCell()
            
            conf.text = time
            cell.contentConfiguration = conf
            
            return cell
        }
    }
}

// MARK: - Private
private extension TVGuideDateScreenPresenter {
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        var uniqueDates = Set<String>()

        for program in programs {
            if let dateString = program.startTime.toDate?.stingWithoutTime {
                uniqueDates.insert(dateString)
            }
        }

        let dateArray = Array(uniqueDates.sorted(by: { $0 > $1 }))
        
        snapshot.appendSections([0])
        snapshot.appendItems(dateArray, toSection: 0)
        
        dataSource.applySnapshotUsingReloadData(snapshot)
    }
}
