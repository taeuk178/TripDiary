//
//  SIgnInViewController.swift
//  TripDiary
//
//  Created by taeuk on 2021/04/17.
//

import UIKit

class SIgnInViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loginButton(_ sender: UIButton) {
        let signupVM = LoginAPIManager()
        signupVM.requestSignIn(email: emailTextfield.text ?? "", password: passwordTextfield.text ?? "", completion: { 
            self.mainViewPresenter()
        })
    }
    
    func mainViewPresenter() {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Tabbar")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
}
