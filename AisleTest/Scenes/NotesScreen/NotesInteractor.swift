//
//  NotesInteractor.swift
//  AisleTest
//
//  Created by Rajat Verma on 17/08/23.
//

import Foundation

protocol NotesInteractorProtocol: AnyObject {
    func getNotesData()
}

final class NotesInteractor: BaseInteractor {
    weak var presenter: NotesPresenterProtocol?
}

// MARK: NotesInteractorProtocol
extension NotesInteractor: NotesInteractorProtocol {
    
    func getNotesData() {
        presenter?.showLoading()
        request(isToken: true, endpoint: .getNotes, requestType: .get, postData: nil) { [weak self] response in
            self?.presenter?.hideLoading()
            if let data = response {
                do  {
                    let result = try JSONDecoder().decode(NotesAPIModel.self, from: data)
                    dump(result)
                    self?.processData(data: result)
                    return
                } catch let error {
                    print(error)
                }
            }
            self?.presenter?.updateViewModel(with: [])
        } _: { [weak self] error, tokenExpError in
            self?.presenter?.hideLoading()
            self?.presenter?.updateViewModel(with: [])
            if tokenExpError {
                self?.presenter?.showTokenExpError()
            } else {
                self?.presenter?.showGenericAlert()
            }
        }
    }
    
    private func processData(data: NotesAPIModel) {
        func transformToIntrestedCellData(data: [NotesAPIModel.Likes.Profiles], canSeeProfile: Bool) -> [MainNoteCollectionViewCell.ViewModel] {
            var cellData = [MainNoteCollectionViewCell.ViewModel]()
            cellData = data.compactMap({
                if let name = $0.firstName,
                   let imageUrlStr = $0.avatar {
                    return .init(
                        name: name,
                        age: -1,
                        imageURLStr: imageUrlStr,
                        imageIsBlur: !canSeeProfile
                    )
                } else {
                    return nil
                }
            })
            return cellData
        }
        
        func transformToMainNotesData(data: [NotesAPIModel.Invites.Profiles]) -> [MainNoteCollectionViewCell.ViewModel] {
            var cellData = [MainNoteCollectionViewCell.ViewModel]()
            
            cellData = data.compactMap({
                if let name = $0.generalInformation?.firstName,
                   let imageUrlStr = $0.photos?.first(where: { $0.selected == true })?.photo {
                    return .init(
                        name: name,
                        age: $0.generalInformation?.age ?? -1,
                        imageURLStr: imageUrlStr,
                        imageIsBlur: false
                    )
                } else {
                    return nil
                }
            })
            
            return cellData
        }
        
        var viewModel: [NotesViewModel] = []
        
        if let profiles = data.invites?.profiles,
           !profiles.isEmpty {
            viewModel.append(.init(
                headerData: MainNotesHeaderView.ViewModel(heading: "Notes", subHeading: "Personal messages for you"),
                widgetType: .mainNotes,
                cellData: transformToMainNotesData(data: profiles))
            )
        }
        
        if let profiles = data.likes?.profiles,
           !profiles.isEmpty {
            viewModel.append(.init(
                headerData: InterestedInYouHeaderView.ViewModel(heading: "Intrested In You", subHeading: "Premium Members can view all their likes at once"),
                widgetType: .intrestedInYou,
                cellData: transformToIntrestedCellData(data: profiles, canSeeProfile: data.likes?.canSeeProfile ?? false))
            )
        }
        
        presenter?.updateViewModel(with: viewModel)
    }
}
