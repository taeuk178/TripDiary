//
//  SignUpViewController.swift
//  TripDiary
//
//  Created by taeuk on 2021/03/20.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController {

    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwConfirmTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userIdTextField.delegate = self
        pwTextField.delegate = self
        pwConfirmTextfield.delegate = self
        
        navigationItem.title = "회원가입"
        navigationController?.navigationBar.topItem?.title = ""
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
        if userIdTextField.text != "" && pwTextField.text != "" && pwConfirmTextfield.text != "" {
            if pwTextField.text == pwConfirmTextfield.text {
                
            }else {
                confirmAlert(title: "알림", message: "비밀번호가 일치하지 않습니다.")
            }
        }else{
            confirmAlert(title: "알림", message: "아이디 혹은 비밀번호를 적어주세요")
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

extension UIViewController {
    
    func confirmAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}
