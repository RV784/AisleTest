//
//  NotesPresenter.swift
//  AisleTest
//
//  Created by Rajat Verma on 17/08/23.
//

import UIKit

protocol NotesPresenterProtocol: AnyObject {
    func getNotesData()
    func showLoading()
    func hideLoading()
    func showGenericAlert()
    func showTokenExpError()
    func updateViewModel(with data: [NotesViewModel])
    func setCollectionLayout()
}

final class NotesPresenter {
    weak var view: NotesViewProtocol?
    var interactor: NotesInteractorProtocol?
    var router: NotesRouterProtocol?
    
    private var viewModel: [NotesViewModel] = [] {
        didSet {
            view?.updateCollection(with: viewModel)
        }
    }
    
    init(
        view: NotesViewProtocol,
        interactor: NotesInteractorProtocol,
        router: NotesRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: NotesPresenterProtocol
extension NotesPresenter: NotesPresenterProtocol {
    
    func getNotesData() {
        interactor?.getNotesData()
    }
    
    func showLoading() {
        view?.showLoading()
    }
    
    func hideLoading() {
        view?.hideLoading()
    }
    
    func showGenericAlert() {
        view?.showAlert(with: "Something went wrong, please try again later", completion: {})
    }
    
    func showTokenExpError() {
        view?.showAlert(with: "Seems like your token expired, You'll be redirected to OTP screen", completion: { [weak self] in
            self?.view?.startOTPFlow()
        })
    }
    
    func updateViewModel(with data: [NotesViewModel]) {
        viewModel = data
    }
    
    func setCollectionLayout() {
        setCompositionalLayout()
    }
    
    private func setCompositionalLayout() {
        let layout = UICollectionViewCompositionalLayout { sectionIdx, _ in
            switch self.viewModel[sectionIdx].widgetType {
                
            case .mainNotes:
                let headerLayout = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(70)
                    ),
                    elementKind: "MainNotesHeaderView.Header",
                    alignment: .top
                )
                headerLayout.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
                
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(1)
                )
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                if self.viewModel[sectionIdx].headerData != nil {
                    section.boundarySupplementaryItems = [headerLayout]
                }
                return section
            case .intrestedInYou:
                let headerLayout = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(80)
                    ),
                    elementKind: "InterestedInYouHeaderView.Header",
                    alignment: .top
                )
                headerLayout.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
                
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(0.5),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                
                item.contentInsets = .init(top: 4, leading: 8, bottom: 4, trailing: 8)
                
                let groupOne = NSCollectionLayoutGroup.horizontal (
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    ),
                    subitem: item,
                    count: 2
                )
                
                groupOne.contentInsets = .init(top: 8, leading: 0, bottom: 8, trailing: 0)
                
                let finalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(0.5)),
                    subitems: [groupOne])
                
                let section = NSCollectionLayoutSection(group: finalGroup)
                section.contentInsets = .init(top: 16, leading: 10, bottom: 16, trailing: 12)
                if self.viewModel[sectionIdx].headerData != nil {
                    section.boundarySupplementaryItems = [headerLayout]
                }
                return section
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 12
        layout.configuration = config
        
        view?.setCollectionViewLayout(layout)
    }
}
