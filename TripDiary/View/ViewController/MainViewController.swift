//
//  MainViewController.swift
//  TripDiary
//
//  Created by taeuk on 2021/03/20.
//

import AuthenticationServices
import Alamofire
import FBSDKLoginKit
import GoogleSignIn
import KakaoSDKUser
import NaverThirdPartyLogin
import Security
import UIKit



class MainViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var LoginStackView: UIStackView!
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    
    
    private let naverLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Naver", for: .normal)
        button.addTarget(self, action: #selector(naverLogin(_:)), for: .touchUpInside)
        return button
    }()
    
    var googleButton = GIDSignInButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.naviGreenColor
        
        navigationSetting()
        setAppleAuth()
        LoginStackView.addArrangedSubview(naverLoginButton)
        
        //naver
        naverLoginInstance?.requestDeleteToken()
        
        //google
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        LoginStackView.addArrangedSubview(googleButton)
        googleButton.style = .standard
        
        
        //Facebook
        let loginButton = FBLoginButton()
        loginButton.center = view.center
        loginButton.delegate = self
        LoginStackView.addArrangedSubview(loginButton)
        
        // kakao logout
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
            }
        }
        
        //Facebook logOut
        let fbLoginMange = LoginManager()
        fbLoginMange.logOut()
        
        
        
        // facebook
        if let token = AccessToken.current, !token.isExpired {

            
        }
        
        
        // Swift // // Extend the code sample from 6a. Add Facebook Login to Your Code // Add to your viewDidLoad method: loginButton.permissions = ["public_profile", "email"]
            
    }
    
    func navigationSetting() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @objc func naverLogin(_ sender: UIButton) {
        
        // kakao login
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")
                
                //do something
                _ = oauthToken
            }
            
            UserApi.shared.me() {(user, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("me() success.")

                    //do something
                    let userEmail = user?.kakaoAccount?.email
                    print(userEmail)
                }
            }
        }
        
//        naverLoginInstance?.delegate = self
//        naverLoginInstance?.requestThirdPartyLogin()
    }
    
}

extension MainViewController: GIDSignInDelegate {
    //MARK: Google Login
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
            
        } else {
            print("Error : User Data Not Found")
        }
    }
}
//MARK: - Apple Login
extension MainViewController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    func setAppleAuth() {
        
        //애플 로그인 버튼 생성
        let authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
        authorizationButton.addTarget(self, action: #selector(appleSignInButtonPress), for: .touchUpInside)
        LoginStackView.addArrangedSubview(authorizationButton)
        
    }
    
    @objc func appleSignInButtonPress() {
        let appleIDProvier = ASAuthorizationAppleIDProvider()
        let request = appleIDProvier.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
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
                print(Keychain.save(key: "id", data: idData))
            }
            if let idData = Keychain.load(key: "id") {
                if let id = String(data: idData, encoding: .utf8) {
                    print("id: \(id)")
                }
            }
            // 계정 정보 가져오기
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Tabbar")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        default:
            break
        }
    }
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}

//MARK: - Naver Login
extension MainViewController: NaverThirdPartyLoginConnectionDelegate {
    
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("Success naver login")
        getInfo()
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        naverLoginInstance?.requestDeleteToken()
    }
    
    //에러처리
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        
        print("naver err", error.localizedDescription)
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

// MARK:- LoginButtonDelegate
extension MainViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print("Facebook login with error: \(error.localizedDescription)")
        } else if let result = result {
            let declinedPermissionSet = result.declinedPermissions
            let grantedPermissionSet = result.grantedPermissions
            let isCancelled = result.isCancelled
            let facebookToken = result.token?.tokenString ?? ""

        }
        print(result?.token?.tokenString) //YOUR FB TOKEN
        let req = GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: result?.token?.tokenString, version: nil, httpMethod: .get)
        
        req.start(completionHandler: { (connection, result, err) -> Void in
            if(error == nil)
            {
                print("result \(String(describing: result))")
            }
            else
            {
                print("error \(error)")
            }
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User has logged out Facebook")
    }
}
