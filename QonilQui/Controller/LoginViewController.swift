//
//  LoginViewController.swift
//  QonilQui
//
//  Created by Alisher Sattarbek on 7/15/20.
//  Copyright © 2020 AlisherSattarbek. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        proceedButton.roundAllCorners(cornerRadius: Double(proceedButton.frame.height/2))
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        backgroundView.roundCorners(.bottomLeft, radius: 80)
        db = Firestore.firestore()
    }
    
    @IBAction func proceed(_ sender: UIButton) {
        sender.titleLabel?.text == "Sign up" ? checkTextFieldsAndSignUp() : checkTextFieldsAndSignIn()
    }
    
//    private func navigateToMainMenu() {
//        let storyBoard = UIStoryboard(name: "Topics", bundle:nil)
//        let topicsVC = storyBoard.instantiateViewController(withIdentifier: "TopicsTableViewController") as! TopicsTableViewController
//        navigationController?.pushViewController(topicsVC, animated: true)
//    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize =
            (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    private func checkTextFieldsAndSignUp() {
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text else { return }
        
        if name.isEmpty {
            nameTextField.layer.borderColor = UIColor.red.cgColor
            show(errorLabel: nameErrorLabel, with: "This field can't be empty")
            return
        } else {
            hide(label: nameErrorLabel)
        }
        
        if password != confirmPassword {
            confirmPasswordTextField.layer.borderColor = UIColor.red.cgColor
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            show(errorLabel: passwordErrorLabel, with: "Passwords does not match")
            show(errorLabel: confirmPasswordErrorLabel, with: "Passwords does not match")
            return
        } else {
            hide(label: passwordErrorLabel)
            hide(label: confirmPasswordErrorLabel)
        }
        
        if !email.isEmail() {
            emailTextField.layer.borderColor = UIColor.red.cgColor
            show(errorLabel: emailErrorLabel, with: "Invalid format of email")
            return
        } else {
            hide(label: emailErrorLabel)
        }
        
        if email.isEmpty {
            emailTextField.layer.borderColor = UIColor.red.cgColor
            show(errorLabel: emailErrorLabel, with: "This field can't be empty")
            return
        } else {
            hide(label: emailErrorLabel)
        }
        
        if password.isEmpty {
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            show(errorLabel: passwordErrorLabel, with: "This field can't be empty")
            return
        } else {
            hide(label: passwordErrorLabel)
        }
        
        if confirmPassword.isEmpty {
            confirmPasswordTextField.layer.borderColor = UIColor.red.cgColor
            show(errorLabel: confirmPasswordErrorLabel, with: "This field can't be empty")
            return
        } else {
            hide(label: confirmPasswordErrorLabel)
        }
        
        createUser(name: name, email: email, password: password)
        //navigateToMainMenu()
    }
    
    private func checkTextFieldsAndSignIn() {
        guard let email = emailTextField.text, let password = passwordTextField.text else  {
                // MARK: Show label
                return
        }
        
        if email.isEmpty {
            emailTextField.layer.borderColor = UIColor.red.cgColor
            show(errorLabel: emailErrorLabel, with: "This field can't be empty")
            return
        }
        
        if password.isEmpty {
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            show(errorLabel: passwordErrorLabel, with: "This field can't be empty")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let _ = error {
                let alertController = UIAlertController(title: "Login Failed", message: "Entered email or password is incorrect", preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
            } else {
//                self.navigateToMainMenu()
            }
        }
    }
    
    private func createUser(name: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password, completion: nil)
        
        db.document("users").collection("names").addDocument(data: [
            "name": name,
            "email": email,
        ])
    }
    
    private func show(errorLabel label: UILabel, with message: String) {
        UIView.animate(withDuration: 0.3) {
            label.text = message
            label.isHidden = false
        }
    }
    
    private func hide(label: UILabel) {
        UIView.animate(withDuration: 0.3) {
            label.isHidden = true
        }
    }
    
    private func showSignUpTextFields() {
        UIView.animate(withDuration: 0.3) {
            self.confirmPasswordTextField.isHidden = false
            self.nameTextField.isHidden = false
        }
    }
    
    private func hideSignUpTextFields() {
        UIView.animate(withDuration: 0.3) {
            self.confirmPasswordTextField.isHidden = true
            self.nameTextField.isHidden = true
        }
    }
    
    private func hideErrorLabels() {
        [nameErrorLabel, emailErrorLabel, passwordErrorLabel, confirmPasswordErrorLabel].forEach({
            hide(label: $0)
        })
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        hideSignUpTextFields()
        hideErrorLabels()
        setHighlighted(signInButton)
        showForgotPasswordButton()
        proceedButton.setTitle("Sign in", for: .normal)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        showSignUpTextFields()
        setHighlighted(signUpButton)
        hideForgotPasswordButton()
        proceedButton.setTitle("Sign up", for: .normal)
    }
    
    private func setHighlighted(_ button: UIButton) {
        button == signUpButton ? signUpButton.setTitleColor(.white, for: .normal) : signUpButton.setTitleColor(.lightGray, for: .normal)
        button == signInButton ? signInButton.setTitleColor(.white, for: .normal) : signInButton.setTitleColor(.lightGray, for: .normal)
    }
    
    private func showForgotPasswordButton() {
        UIView.animate(withDuration: 0.3) {
            self.forgotPasswordButton.isHidden = false
        }
    }
    
    private func hideForgotPasswordButton() {
        UIView.animate(withDuration: 0.3) {
            self.forgotPasswordButton.isHidden = true
        }
    }
    
}
