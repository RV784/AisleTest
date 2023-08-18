//
//  LoginViewInteractor.swift
//  AisleTest
//
//  Created by Rajat Verma on 17/08/23.
//

import Foundation

protocol LoginViewInteractorProtocol: AnyObject {
    func sendPhoneRequest()
}

final class LoginViewInteractor: BaseInteractor, LoginViewInteractorProtocol {
    weak var presenter: LoginViewPresenterProtocol?
    
    
    func sendPhoneRequest() {
        guard let code = LocalStorage.shared.countryCode,
              let number = LocalStorage.shared.userNumber else { return }
        
        let postData = [
            "number": "\(code)\(number)"
        ] as Dictionary<String, Any>
        
        presenter?.showLoading()
        request(isToken: false, params: postData, endpoint: .phoneLogin, requestType: .post, postData: nil) { [weak self] response in
            self?.presenter?.hideLoading()
            if let data = response {
                do {
                    let result = try JSONDecoder().decode(PhoneResponseModel.self, from: data)
                    self?.processData(data: result)
                    dump(result)
                } catch let error {
                    print(error)
                }
            }
        } _: { [weak self] error, _ in
            self?.presenter?.hideLoading()
        }
    }
    
    private func processData(data: PhoneResponseModel) {
        if data.status == true {
            presenter?.gotoOTPScreen()
        } else {
            presenter?.showGenericAlert()
        }
    }
}
