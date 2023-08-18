//
//  NotesViewController.swift
//  AisleTest
//
//  Created by Rajat Verma on 17/08/23.
//

import UIKit

protocol NotesViewProtocol: AnyObject {
    func showAlert(with message: String, completion: @escaping (() -> Void))
    func showLoading()
    func hideLoading()
    func startOTPFlow()
    func setCollectionViewLayout(_ layout: UICollectionViewCompositionalLayout)
    func updateCollection(with data: [NotesViewModel])
}

class NotesViewController: BaseViewController {
    var presenter: NotesPresenterProtocol?
    
    @IBOutlet private weak var notesCollectionView: UICollectionView! {
        didSet {
            notesCollectionView.dataSource = self
            notesCollectionView.register(UINib(nibName: "MainNoteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MainNoteCollectionViewCell")
            notesCollectionView.register(UINib(nibName: "MainNotesHeaderView", bundle: nil), forSupplementaryViewOfKind: "MainNotesHeaderView.Header", withReuseIdentifier: "MainNotesHeaderView")
            notesCollectionView.register(UINib(nibName: "InterestedInYouHeaderView", bundle: nil), forSupplementaryViewOfKind: "InterestedInYouHeaderView.Header", withReuseIdentifier: "InterestedInYouHeaderView")
            notesCollectionView.showsVerticalScrollIndicator = false
            notesCollectionView.showsHorizontalScrollIndicator = false
        }
    }
    
    private var viewModel = [NotesViewModel]() {
        didSet {
            if viewModel.isEmpty {
                notesCollectionView.refreshControl = nil
            } else {
                notesCollectionView.refreshControl = activityIndicator
            }
            notesCollectionView.reloadData()
        }
    }
    
    lazy private var activityIndicator: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = .aisleYellow
        refresher.addTarget(
            self,
            action: #selector(refreshNotesData),
            for: .valueChanged
        )
        return refresher
    }()
    
    lazy private var refreshButtonIcon: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(didTapRefresh))
        btn.title = "Refresh"
        btn.tintColor = .aisleYellow
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.getNotesData()
        presenter?.setCollectionLayout()
    }
    
    @objc
    func refreshNotesData() {
        activityIndicator.endRefreshing()
        presenter?.getNotesData()
    }
    
    @objc
    func didTapRefresh() {
        presenter?.getNotesData()
    }
}

// MARK: NotesViewProtocol
extension NotesViewController: NotesViewProtocol {
    func showAlert(with message: String, completion: @escaping (() -> Void)) {
        showGenericUIAlert(message: message, completion: {
            completion()
        }, buttonTitle: "Ok")
    }
    
    func showLoading() {
        startLoading()
    }
    
    func hideLoading() {
        stopLoading()
    }
    
    func startOTPFlow() {
        tokenExpired()
    }
    
    func setCollectionViewLayout(_ layout: UICollectionViewCompositionalLayout) {
        notesCollectionView.collectionViewLayout = layout
    }
    
    func updateCollection(with data: [NotesViewModel]) {
        viewModel = data
        self.navigationItem.rightBarButtonItem = viewModel.isEmpty ? refreshButtonIcon : nil
    }
}

// MARK: UICollectionViewDataSource
extension NotesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel[section].cellData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel[indexPath.section].widgetType {
            
        case .mainNotes:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainNoteCollectionViewCell", for: indexPath) as? MainNoteCollectionViewCell,
               let cellData = viewModel[indexPath.section].cellData[indexPath.row] as? MainNoteCollectionViewCell.ViewModel {
                cell.config(cellData)
                return cell
            }
            return UICollectionViewCell()
        case .intrestedInYou:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainNoteCollectionViewCell", for: indexPath) as? MainNoteCollectionViewCell,
               let cellData = viewModel[indexPath.section].cellData[indexPath.row] as? MainNoteCollectionViewCell.ViewModel {
                cell.config(cellData)
                return cell
            }
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch viewModel[indexPath.section].widgetType {
            
        case .mainNotes:
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MainNotesHeaderView", for: indexPath) as? MainNotesHeaderView,
               let headerData = viewModel[indexPath.section].headerData as? MainNotesHeaderView.ViewModel {
                header.config(headerData)
                return header
            }
            return UICollectionReusableView()
        case .intrestedInYou:
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "InterestedInYouHeaderView", for: indexPath) as? InterestedInYouHeaderView,
               let headerData = viewModel[indexPath.section].headerData as? InterestedInYouHeaderView.ViewModel {
                header.config(headerData)
                header.callBack = {
                    print(#function)
                }
                return header
            }
        }
        return UICollectionReusableView()
    }
}
