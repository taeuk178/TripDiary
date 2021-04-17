//
//  SignUpAPI.swift
//  TripDiary
//
//  Created by taeuk on 2021/04/14.
//

import Foundation
import Alamofire

struct LoginAPIManager {
    
    let header: HTTPHeaders = [.contentType("application/json")]
    
    
    func requestSignUp(email: String, password: String) {
        
        let signUpAPI = SignUpModel(email: email, password: password, provider: "N", token: "test", nickname: email)
        
        AF.request("https://azanghs.cafe24.com/itstudy/signup.php", method: .post, parameters: signUpAPI, encoder: JSONParameterEncoder.default, headers: header)
            .response { response in
                guard let result = try? JSONDecoder().decode(GetSignUpModel.self, from: response.data!) else { return }
                guard result.data != nil else { return }
                print(result.data)
            }
    }
    
    func requestSignIn(email: String, password: String) {
        let loginModel = LoginModel(email: email, password: password)
        
        AF.request("https://azanghs.cafe24.com/itstudy/login.php", method: .post, parameters: loginModel, encoder: JSONParameterEncoder.default, headers: header)
            .response { response in
                guard let result = try? JSONDecoder().decode(SignInModel.self, from: response.data ?? Data()) else { return }
                guard result.data != nil else { return }
                print(result.data)
            }
    }
}
//tes123@naver.com
//1234
