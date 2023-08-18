//
//  LoginViewController.swift
//  AisleTest
//
//  Created by Rajat Verma on 17/08/23.
//

import UIKit

protocol LoginViewProtocol: AnyObject {
    func showAlert(with message: String)
    func showLoading()
    func hideLoading()
    func showGenericAlert()
}

class LoginViewController: BaseViewController {
    var presenter: LoginViewPresenterProtocol?
    
    @IBOutlet private weak var getOtpLabel: UILabel!
    @IBOutlet private weak var enterYourNumberLabel: UILabel!
    @IBOutlet private weak var countryCodeField: UITextField!
    @IBOutlet private weak var mobileNumberField: UITextField!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAppearance()
    }
    
    private func initAppearance() {
        submitButton.layer.cornerRadius = submitButton.frame.height/2
        submitButton.setTitle("Continue", for: .normal)
        submitButton.setTitle("Continue", for: .selected)
        submitButton.backgroundColor = .aisleYellow
        submitButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        
        mobileNumberField.layer.cornerRadius = 8
        mobileNumberField.layer.borderWidth = 0.5
        mobileNumberField.keyboardType = .phonePad
        mobileNumberField.becomeFirstResponder()
        mobileNumberField.delegate = self
        
        countryCodeField.layer.cornerRadius = 8
        countryCodeField.layer.borderWidth = 0.5
        countryCodeField.keyboardType = .phonePad
        countryCodeField.delegate = self
        
        loader.hidesWhenStopped = true
    }
    
    override func startLoading() {
        submitButton.setTitle("", for: .normal)
        submitButton.setTitle("", for: .selected)
        submitButton.isUserInteractionEnabled = false
        loader.startAnimating()
    }
    
    override func stopLoading() {
        submitButton.setTitle("Continue", for: .normal)
        submitButton.setTitle("Continue", for: .selected)
        submitButton.isUserInteractionEnabled = true
        loader.stopAnimating()
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        presenter?.checkForError(code: countryCodeField.text, number: mobileNumberField.text)
    }
}

// MARK: LoginViewProtocol
extension LoginViewController: LoginViewProtocol {
    func showAlert(with message: String) {
        showGenericUIAlert(message: message, completion: {}, buttonTitle: "Ok")
    }
    
    func showLoading() {
        startLoading()
    }
    
    func hideLoading() {
        stopLoading()
    }
    
    func showGenericAlert() {
        showGenericUIAlert(message: "Something went wrong, please try again later", completion: {})
    }
}

// MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.rangeOfCharacter(from: .letters) != nil {
            return false
        }
        return true
    }
}
