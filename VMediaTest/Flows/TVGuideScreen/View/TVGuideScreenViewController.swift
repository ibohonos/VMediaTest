//
//  TVGuideScreenViewController.swift
//  VMediaTest
//
//  Created by Іван Богоносюк on 10.02.2023.
//

import UIKit
import TVUIKit

protocol TVGuideScreenViewControllerProtocol: AnyObject {
    func didGetError(message: String?)
    func didGetChannels()
    func didSetupLayout(_ layout: UICollectionViewLayout)
}

class TVGuideScreenViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var contentCollectionView: UICollectionView!
    
    // MARK: - Properties
    var presenter: TVGuideScreenPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseAppearance()
        setupCollectionView()
        setupDataSource()
        loadChannels()
    }
}

// MARK: - TVGuideScreenViewControllerProtocol
extension TVGuideScreenViewController: TVGuideScreenViewControllerProtocol {
    func didGetError(message: String?) {
        ProgressHud.dismiss()
        presentError(message: message)
    }
    
    func didGetChannels() {
        ProgressHud.dismiss()
        updateSnapshot()
    }
    
    func didSetupLayout(_ layout: UICollectionViewLayout) {
        contentCollectionView.setCollectionViewLayout(layout, animated: false)
    }
}

// MARK: - Private
private extension TVGuideScreenViewController {
    func setupBaseAppearance() {
        contentCollectionView.backgroundColor = .clear
    }
    
    func setupCollectionView() {
        contentCollectionView.delegate = self
    }
    
    func setupDataSource() {
        presenter?.neededConfigureCells(collectionView: contentCollectionView)
    }
    
    func updateSnapshot() {
        presenter?.neededToUpdateSnapshot()
    }
    
    func loadChannels() {
        ProgressHud.show()
        presenter?.neededToGetChannelList()
    }
}

extension TVGuideScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
