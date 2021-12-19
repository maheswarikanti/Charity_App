//
//  QuestionnaireViewController.swift
//  
//
//  .
//

import UIKit
import Firebase

class QuestionnaireViewController: UIViewController {
    
    @IBOutlet weak var imgService: UIImageView!
    @IBOutlet weak var imgDonate: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgDonate.image = UIImage(named: "donatePic")
        self.imgService.image = UIImage(named: "servicePic")
    }

    @IBAction func logoutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            KeychainService().keyChain.delete("uid")
            self.navigationController?.popToRootViewController(animated: true)
        } catch {
            print(error)
        }
    }
}
