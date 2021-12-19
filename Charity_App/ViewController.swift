//
//  ViewController.swift
//
//
//  .
//

import UIKit
import Firebase
import SwiftSpinner

class ViewController: UIViewController {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStatus.text = ""
        self.imgLogo.image = UIImage(named: "logo")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let keyChain = KeychainService().keyChain
        if  keyChain.get("uid") != nil {
            performSegue(withIdentifier: "DashboardSegue", sender: self)
        }
        txtPassword.text = ""
        self.lblStatus.text = ""
    }
    
    func addKeychainAfterLogin(_ uid: String) {
        let keyChain = KeychainService().keyChain
        keyChain.set(uid, forKey: "uid")
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        let email = txtEmail.text!
        let password = txtPassword.text!
        
        if email == "" || password == "" || password.count < 6{
            lblStatus.text = "Please enter valid Email/Password"
            return
        }
        
        if email.isEmail == false {
            lblStatus.text = "Please enter valid Email"
            return
        }
        
        SwiftSpinner.show("Logging in...")
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] authResult, error in
            SwiftSpinner.hide()
            guard let self = self else { return }
            if error != nil {
                self.lblStatus.text = error?.localizedDescription
                return
            }
            
            let uid = Auth.auth().currentUser?.uid
            self.addKeychainAfterLogin(uid!)
            self.performSegue(withIdentifier: "DashboardSegue", sender: self)
        }
    }
}

