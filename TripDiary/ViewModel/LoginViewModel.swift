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

class LoginViewModel: NSObject {
    
    weak var delegate: LoginDelegate?
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    
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

extension LoginViewModel: NaverThirdPartyLoginConnectionDelegate {
    
    // 로그인 성공
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("naver, Success login")
        delegate?.loginSuccess()
        getInfo()
    }
    
    // 토큰 갱신
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        
    }
    
    // 로그아웃
    func oauth20ConnectionDidFinishDeleteToken() {
        
    }
    
    // 에러처리
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        
        delegate?.loginFailed(err: "DEBUG == 네이버 로그인 실패")
    }
    
    func getInfo() {

        guard let _ = naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }

        guard let tokenType = naverLoginInstance?.tokenType else { return }
        guard let accessToken = naverLoginInstance?.accessToken else { return }

        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!

        let authorization = "\(tokenType) \(accessToken)"

        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])

        req.responseJSON { response in
            guard let result = response.value as? [String: Any] else { return }
            guard let object = result["response"] as? [String: Any] else { return }
            guard let name = object["name"] as? String else { return }
            guard let email = object["email"] as? String else { return }
            guard let id = object["id"] as? String else {return}

            print(email)
            print(name)
            print(id)

        }
    }
}

extension LoginViewModel: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        // 사용자 정보 가져오기
        if let userId = user.userID,                  // For client-side use only!
           let idToken = user.authentication.idToken, // Safe to send to the server
           let fullName = user.profile.name,
           let email = user.profile.email {
            
            print("Token : \(idToken)")
            print("User ID : \(userId)")
            print("User Email : \(email)")
            print("User Name : \((fullName))")
            
            delegate?.loginSuccess()
            
        } else {
            print("Error : User Data Not Found")
        }
    }
}
