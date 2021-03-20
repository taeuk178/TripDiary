//
//  SignUpViewController.swift
//  TripDiary
//
//  Created by taeuk on 2021/03/20.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwConfirmTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userIdTextField.delegate = self
        pwTextField.delegate = self
        pwConfirmTextfield.delegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        guard let userText = userIdTextField.text else { return }
        guard let pwText = pwTextField.text else { return }
        guard let pwcomfirmText = pwConfirmTextfield.text else { return }
        
        
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

