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
    
    
    //MARK: - Properties
    let loginVM = LoginViewModel()
    
    @IBOutlet weak var LoginStackView: UIStackView!
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    private let naverLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Naver", for: .normal)
        button.addTarget(self, action: #selector(naverLogin(_:)), for: .touchUpInside)
        return button
    }()
    
    private let kakaoLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kakao", for: .normal)
        button.addTarget(self, action: #selector(kakaoLogin(_:)), for: .touchUpInside)
        return button
    }()
    
    var googleButton = GIDSignInButton()
    
    //MARK: - override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.naviGreenColor
        
        navigationSetting()
        setAppleAuth()
        
        loginVM.delegate = self
        
        //naver
        naverLoginInstance?.requestDeleteToken()
        
        //google
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = loginVM
        googleButton.style = .standard
        
        
        //Facebook
        let faceBookLoginButton = FBLoginButton()
        faceBookLoginButton.center = view.center
        faceBookLoginButton.delegate = self

        
        LoginStackView.addArrangedSubview(naverLoginButton)
        LoginStackView.addArrangedSubview(kakaoLoginButton)
        LoginStackView.addArrangedSubview(googleButton)
        LoginStackView.addArrangedSubview(faceBookLoginButton)
                
        
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
            
    }
    
    func navigationSetting() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    // MARK: - kakao login
    
    @objc func kakaoLogin(_ sender: UIButton) {
        
        loginVM.kakaoLogin {
            self.mainViewPresenter()
        }
    }
    
    // MARK: - naver login
    
    @objc func naverLogin(_ sender: UIButton) {
        
        naverLoginInstance?.delegate = loginVM
        naverLoginInstance?.requestThirdPartyLogin()
        
    }
    
    // 로그인 성공시 메인화면 넘어가는 메소드
    func mainViewPresenter() {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Tabbar")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
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
            
            mainViewPresenter()
            
        default:
            break
        }
    }
    
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
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
                self.mainViewPresenter()
                print("result \(String(describing: result))")
            }
            else
            {
                print("error \(error?.localizedDescription)")
            }
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User has logged out Facebook")
    }
}

extension MainViewController: LoginDelegate {
    func loginSuccess() {
        self.mainViewPresenter()
    }
    
    func loginFailed(err: String) {
        print(err)
    }
    
    
}
