//
//  BaseInteractor.swift
//  AisleTest
//
//  Created by Rajat Verma on 18/08/23.
//

import Foundation

class BaseInteractor {
    
    func request(isToken: Bool,
                 params: [String: Any]? = nil,
                 endpoint: EndPoints,
                 requestType: RequestType,
                 postData: Data?,
                 _ success: @escaping (Data?) -> Void,
                 _ failure: @escaping (Error?, Bool) -> Void) {
        
        guard let url = URL(string: endpoint.description) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let params = params {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        }
        
        if isToken {
            guard let token = LocalStorage.shared.authToken,
                  !token.isEmpty else {
                DispatchQueue.main.async {
                    failure(nil, true)
                    print("Token Expired")
                }
                return
            }
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        if let data = postData {
            request.httpBody = data
        }
        
        print("Request START ----------------------------------")
        print(request.cURL(pretty: true))
        print("Request END ------------------------------------")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                
                /// If error is due to 401
                /// Then is this case we've to renew the token
                /// Phone API will be called and then the OTP screen be pushed.
                if httpResponse.statusCode == 401,
                   isToken {
                    DispatchQueue.main.async {
                        failure(nil, true)
                        return
                    }
                }
            }
            
            DispatchQueue.main.async {
                if error != nil {
                    failure(error, false)
                } else {
                    success(data)
                }
            }
        })
        
        task.resume()
    }
}
