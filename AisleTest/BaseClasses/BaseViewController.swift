//
//  BaseViewController.swift
//  AisleTest
//
//  Created by Rajat Verma on 18/08/23.
//

import UIKit

class BaseViewController: UIViewController {

    var activityView: UIActivityIndicatorView?
    
    func startLoading() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.hidesWhenStopped = true
        activityView?.center = view.center
        view.addSubview(activityView!)
        activityView?.startAnimating()
    }
    
    func stopLoading() {
        activityView?.removeFromSuperview()
        activityView?.stopAnimating()
    }
    
    func tokenExpired() {
        startLoading()
        getOTP() { [weak self] response in
            self?.stopLoading()
            if let data = response {
                do {
                    let result = try JSONDecoder().decode(PhoneResponseModel.self, from: data)
                    if result.status == true {
                        self?.gotoOTPScreen()
                    }
                    dump(result)
                } catch let error {
                    print(error)
                }
            }
        } _: { [weak self] error in
            self?.stopLoading()
            self?.showGenericErrorAlert()
        }
    }
    
    func showGenericUIAlert(title: String = "Aisle", message: String, completion: @escaping (() -> Void), buttonTitle: String = "Ok") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: {_ in
            completion()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showGenericErrorAlert() {
        let alert = UIAlertController(title: "Alert", message: "Something went wrong, please try again later", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getOTP(_ success: @escaping (Data?) -> Void,
                _ failure: @escaping (Error?) -> Void) {
        guard let url = URL(string: EndPoints.phoneLogin.description),
              let code = LocalStorage.shared.countryCode,
              let number = LocalStorage.shared.userNumber else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let postData: [String: Any] = [
            "number": "\(code)\(number)"
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: postData, options: [])
        
        print("Request START ----------------------------------")
        print(request.cURL(pretty: true))
        print("Request END ------------------------------------")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
            }
            
            DispatchQueue.main.async {
                if error != nil {
                    failure(error)
                } else {
                    success(data)
                }
            }
        })
        
        task.resume()
    }
    
    func gotoOTPScreen() {
        if let vc = OTPRouter.createModule(isRenewFlow: true) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}
