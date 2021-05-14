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
        
        
        loginVM.delegate = self
        
        view.backgroundColor = UIColor.naviGreenColor
        
        navigationSetting()
        setAppleAuth()
        
        // naver
        naverLoginInstance?.requestDeleteToken()
        
        // google
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = loginVM
        googleButton.style = .standard
        
        
        // Facebook
        let faceBookLoginButton = FBLoginButton()
        faceBookLoginButton.center = view.center
        faceBookLoginButton.delegate = loginVM

        
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
        
        // Facebook logOut
        let fbLoginMange = LoginManager()
        fbLoginMange.logOut()
        
        
        
//        // facebook
//        if let token = AccessToken.current, !token.isExpired {
//
//
//        }
            
    }
    
    func navigationSetting() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    // 로그인 성공시 메인화면 넘어가는 메소드
    func mainViewPresenter() {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Tabbar")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    // MARK: - Apple Login
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
        authorizationController.delegate = loginVM
        authorizationController.presentationContextProvider = loginVM
        authorizationController.performRequests()
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
}

extension MainViewController: LoginDelegate {
    func loginSuccess() {
        self.mainViewPresenter()
    }
    
    func loginFailed(err: String) {
        print(err)
    }
    
    
}
