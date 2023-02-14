//
//  TVGuideDateScreenViewController.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 14.02.2023.
//

import UIKit

protocol TVGuideDateScreenViewControllerProtocol: AnyObject {
    func didGetError(message: String?)
    func didGetPrograms()
}

class TVGuideDateScreenViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var contentTableView: UITableView!
    
    // MARK: - Properties
    var presenter: TVGuideDateScreenPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseAppearance()
        setupTableView()
        setupDataSource()
        loadPrograms()
    }
}

extension TVGuideDateScreenViewController: TVGuideDateScreenViewControllerProtocol {
    func didGetError(message: String?) {
        ProgressHud.dismiss()
        presentError(message: message)
    }
    
    func didGetPrograms() {
        ProgressHud.dismiss()
    }
}

// MARK: - Private
private extension TVGuideDateScreenViewController {
    func setupBaseAppearance() {
        title = "Available EPG Dates"
    }
    
    func setupTableView() {
        contentTableView.delegate = self
    }
    
    func setupDataSource() {
        presenter?.neededConfigureCells(tableView: contentTableView)
    }
    
    func loadPrograms() {
        ProgressHud.show()
        presenter?.neededToGetProgramList()
    }
}

// MARK: - UITableViewDelegate
extension TVGuideDateScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.neededToShowTVGuide(indexPath: indexPath)
    }
}
