//
//  OTPViewController.swift
//  AisleTest
//
//  Created by Rajat Verma on 17/08/23.
//

import UIKit

protocol OTPViewProtocol: AnyObject {
    func showAlert(with message: String)
    func showLoading()
    func hideLoading()
    func showGenericAlert()
}

class OTPViewController: BaseViewController {
    var presenter: OTPPresenterProtocol?

    @IBOutlet private weak var editNumberBtn: UIButton!
    @IBOutlet private weak var editOTPLabel: UILabel!
    @IBOutlet private weak var otpTextField: UITextField!
    @IBOutlet private weak var otpTimerBtn: UIButton!
    @IBOutlet private weak var submitBtn: UIButton!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    @IBOutlet private weak var resendBtnLabel: UILabel!
    
    private var counter = 10
    private var otpTimer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAppearance()
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func initAppearance() {
        submitBtn.layer.cornerRadius = submitBtn.frame.height/2
        submitBtn.setTitle("Continue", for: .normal)
        submitBtn.setTitle("Continue", for: .selected)
        submitBtn.backgroundColor = .aisleYellow
        submitBtn.titleLabel?.font = .boldSystemFont(ofSize: 14)
        
        otpTextField.layer.cornerRadius = 8
        otpTextField.layer.borderWidth = 0.5
        otpTextField.textContentType = .oneTimeCode
        otpTextField.keyboardType = .numberPad
        
        loader.hidesWhenStopped = true
        
        otpTimerBtn.isHidden = true
        otpTimerBtn.setTitle("Resend OTP", for: .normal)
        otpTimerBtn.setTitle("Resend OTP", for: .selected)
        resendBtnLabel.isHidden = true
        
        editNumberBtn.setTitle("\(LocalStorage.shared.countryCode ?? "") \(LocalStorage.shared.userNumber ?? "")", for: .normal)
        editNumberBtn.setTitle("\(LocalStorage.shared.countryCode ?? "") \(LocalStorage.shared.userNumber ?? "")", for: .selected)
    }
    
    private func startTimer() {
        otpTimer?.invalidate()
        counter = 10
        otpTimerBtn.isHidden = true
        resendBtnLabel.isHidden = false
        otpTimer = Timer.scheduledTimer(timeInterval: 1,
                                        target: self,
                                        selector: #selector(self.changeTitle),
                                        userInfo: nil,
                                        repeats: true)
    }
    
    private func stopTimer() {
        otpTimer?.invalidate()
        otpTimerBtn.isHidden = false
    }
    
    @objc
    func changeTitle() {
        if counter != 1 {
            counter -= 1
            resendBtnLabel.text = "Resend OTP in \(counter) Seconds"
        } else {
            otpTimer?.invalidate()
            resendBtnLabel.isHidden = true
            resendBtnLabel.text = ""
            otpTimerBtn.isHidden = false
        }
    }
    
    override func startLoading() {
        submitBtn.setTitle("", for: .normal)
        submitBtn.setTitle("", for: .selected)
        submitBtn.isUserInteractionEnabled = false
        loader.startAnimating()
    }
    
    override func stopLoading() {
        submitBtn.setTitle("Continue", for: .normal)
        submitBtn.setTitle("Continue", for: .selected)
        submitBtn.isUserInteractionEnabled = true
        loader.stopAnimating()
    }
    
    @IBAction func resentBtnClicked(_ sender: Any) {
        startTimer()
        // TODO: Make an API call to request new OTP here.
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        presenter?.verifyOTP(otp: otpTextField.text)
    }
    
    @IBAction func editBtnClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension OTPViewController: OTPViewProtocol {
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
