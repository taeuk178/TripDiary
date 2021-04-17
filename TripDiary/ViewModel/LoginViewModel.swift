//
//  LoginViewModel.swift
//  TripDiary
//
//  Created by taeuk on 2021/04/17.
//

import AuthenticationServices
import Alamofire
import FBSDKLoginKit
import GoogleSignIn
import KakaoSDKUser
import NaverThirdPartyLogin
import Security
import UIKit

class LoginViewModel {
    
    
    func kakaoLogin(complition: @escaping () -> ()) {
        
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }else {
                print("loginWithKakaoAccount() success.")
                
                UserApi.shared.me() {(user, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("kakao, me() success.")
                        complition()
                        //do something
                        guard let userEmail = user?.kakaoAccount?.email else { return }
                        print(userEmail)
                    }
                }
            }
        }
    }
}
