//
//  OTPInteractor.swift
//  AisleTest
//
//  Created by Rajat Verma on 17/08/23.
//

import Foundation

protocol OTPInteractorProtocol: AnyObject {
    func verifyOTP(otp: String)
}

final class OTPInteractor: BaseInteractor {
    weak var presenter: OTPPresenterProtocol?
    var isRenewFlow = false
    
    init(isRenewFlow: Bool) {
        self.isRenewFlow = isRenewFlow
    }
}

extension OTPInteractor: OTPInteractorProtocol {
    func verifyOTP(otp: String) {
        guard let countryCode = LocalStorage.shared.countryCode,
              let number = LocalStorage.shared.userNumber else { return }
        
        let postData: [String: Any] = [
            "number": "\(countryCode)\(number)",
            "otp": otp
        ]
        
        presenter?.showLoading()
        request(isToken: false, params: postData, endpoint: .verifyOtp, requestType: .post, postData: nil) { [weak self] data in
            self?.presenter?.hideLoading()
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(OtpResponseModel.self, from: data)
                    self?.processData(data: result)
                    dump(result)
                    return
                } catch let error {
                    print(error)
                }
            }
            self?.presenter?.showGenericAlert()
        } _: { [weak self] error, _ in
            self?.presenter?.hideLoading()
            self?.presenter?.showGenericAlert()
        }
    }
    
    private func processData(data: OtpResponseModel) {
        if let token = data.token,
           !token.isEmpty {
            LocalStorage.shared.authToken = token
            
            if isRenewFlow {
                presenter?.popViewController()
            } else {
                presenter?.gotoTabBar()
            }
        } else {
            presenter?.showGenericAlert()
        }
    }
}
