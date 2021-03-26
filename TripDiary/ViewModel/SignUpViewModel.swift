//
//  SignUpViewModel.swift
//  TripDiary
//
//  Created by taeuk on 2021/03/20.
//

import Foundation
import Alamofire
import AuthenticationServices

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
//        var request = URLRequest(url: url)
//        request.method = .post
//
//        let header: HTTPHeaders = [
//            "Content-Type":"application/json"
//        ]
////        request.setValue("application/json", forHTTPHeaderField: "Content-type")
//        let body: Parameters = [
//            "email": email,
//            "password": password
//        ]
//        let data = AF.request(url,
//                              method: .post,
//                              parameters: body,
//                              encoding: JSONEncoding.default,
//                              headers: header)
//        data.response { (response) in
//            switch response.result {
//            case .success(_):
//
//                guard let statusCode = response.response?.statusCode else { return }
//                guard let data = response.value else { return }
//
//                print("statusCode: ", statusCode)
//                print("data: ", data ?? Data())
//                let decoder = JSONDecoder()
//                guard let decodedData = try? decoder.decode(SignUpModel.self, from: data!) else { return }
//                print(decodedData)
//            case .failure(let err):
//                print(err.localizedDescription)
//            }
//        }
    }
}
