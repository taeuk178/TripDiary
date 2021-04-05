//
//  SignUpViewModel.swift
//  TripDiary
//
//  Created by taeuk on 2021/03/20.
//


import Alamofire
import AuthenticationServices
import Foundation

struct SignUpViewModel {
    
    
    init () {}
    
    func requestSignUp(email: String, password: String) {
        let signUpAPI = SignUpModel(email: email, password: password, provider: "N", token: "test", nickname: email)
        guard let uploadData = try? JSONEncoder().encode(signUpAPI) else { return }
        print(uploadData)
        
        guard let url = URL(string: "https://azanghs.cafe24.com/itstudy/signup.php") else { return }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        print(request)
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, err) in
            if let err = err{
                print(err.localizedDescription)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}
