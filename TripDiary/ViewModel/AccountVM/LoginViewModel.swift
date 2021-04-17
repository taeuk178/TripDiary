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
    
    
    func kakaoLogin(completion: @escaping () -> ()) {
        
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }else {
                print("loginWithKakaoAccount() success.")
                
                UserApi.shared.me() {(user, error) in
                    if let error = error {
                        self.delegate?.loginFailed(err: error.localizedDescription)
                    }
                    else {
                        print("kakao, me() success.")
                        completion()
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
                delegate?.loginFailed(err: error.localizedDescription)
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

// MARK:- LoginButtonDelegate
extension LoginViewModel: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print("Facebook login with error: \(error.localizedDescription)")
//        } else if let result = result {
//            let declinedPermissionSet = result.declinedPermissions
//            let grantedPermissionSet = result.grantedPermissions
//            let isCancelled = result.isCancelled
//            let facebookToken = result.token?.tokenString ?? ""
//
        }
        print(result?.token?.tokenString) //YOUR FB TOKEN
        let req = GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: result?.token?.tokenString, version: nil, httpMethod: .get)
        
        req.start(completionHandler: { (connection, result, err) -> Void in
            if(error == nil)
            {
                self.delegate?.loginSuccess()
                print("result \(String(describing: result))")
            }
            else
            {
                self.delegate?.loginFailed(err: error?.localizedDescription ?? "")
            }
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User has logged out Facebook")
    }
}

//MARK: - Apple Login
extension LoginViewModel: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let mainVC = MainViewController()
        return mainVC.view.window!
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let appleIDCredetial as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredetial.user
            let fullName = appleIDCredetial.fullName
            let email = appleIDCredetial.email
            
            // "id" 더 상세하게
            if let idData = userIdentifier.data(using: String.Encoding.utf8) {
                print(Keychain.save(key: "AppleID", data: idData))
            }
            if let idData = Keychain.load(key: "AppleID") {
                if let id = String(data: idData, encoding: .utf8) {
                    print("AppleID: \(id)")
                }
            }
            // 계정 정보 가져오기
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            
            delegate?.loginSuccess()
            
        default:
            break
        }
    }
    
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        delegate?.loginFailed(err: error.localizedDescription)
    }
}
