//
//  DonationViewController.swift
//  
//
//  .
//

import UIKit
import Firebase
import FirebaseFirestore

class DonationViewController: UIViewController {
    var db: Firestore!
    let organizationID = CategorySelect.organizationID
    var serviceFee = 0
    var sum: Int = 0
    

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblServiceFee: UILabel!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblOrgName: UILabel!
    @IBOutlet weak var imgOrg: UIImageView!
    
    let boldAttribute = [
          NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 18.0)!
       ]
    let regularAttribute = [
          NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 18.0)!
       ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isScrollEnabled = true
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        getOrganizationDetails()
        self.lblStatus.text = " "
        
    }
    
    
    func getOrganizationDetails() {
        db.collection("organizations").whereField("organizationID", isEqualTo: self.organizationID)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    print(err?.localizedDescription ?? "error in getting organization's details")
                    return
                }
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let imageURL = data["image"] as? String ?? "None"
                    var url = NSURL(string: imageURL)
                    var urlData = NSData(contentsOf : url as! URL)
                    self.imgOrg.image = UIImage(data : urlData as! Data)
                    let name = data["name"] as? String ?? "None"
                    let nameBold = NSAttributedString(string: "Name: ", attributes: self.boldAttribute)
                    let nameRegular = NSAttributedString(string: name, attributes: self.regularAttribute)
                    let nameString = NSMutableAttributedString()
                    nameString.append(nameBold)
                    nameString.append(nameRegular)
                    self.lblOrgName.attributedText = nameString
                    CategorySelect.orgName = name
                    let organizationID = data["organizationID"] as? String ?? "None"
                    let address = data["address"] as? String ?? "None"
                    CategorySelect.address = address
                    
                    let description = data["description"] as? String ?? "None"
                    let descBold = NSAttributedString(string: "Description: ", attributes: self.boldAttribute)
                    let desc = NSAttributedString(string: description, attributes: self.regularAttribute)
                    let descString = NSMutableAttributedString()
                    descString.append(descBold)
                    descString.append(desc)
                    self.lblDescription.attributedText = descString
                    let serviceFee = data["serviceFee"] as? Int ?? 0
                    let feeBold = NSAttributedString(string: "Service Fee: ", attributes: self.boldAttribute)
                    let feeRegular = NSAttributedString(string: String(serviceFee), attributes: self.regularAttribute)
                    let feeString = NSMutableAttributedString()
                    feeString.append(feeBold)
                    feeString.append(feeRegular)
                    self.lblServiceFee.attributedText = feeString
                    self.serviceFee = serviceFee
                    
                }
        }
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
    
    
    @IBAction func submitAction(_ sender: Any) {
        if self.txtAmount.text == "" || Int(self.txtAmount.text!) == nil {
            self.lblStatus.text = "Enter a valid number"
            return
        }
        self.sum = Int(self.txtAmount.text!) ?? 0
        CategorySelect.total = serviceFee + self.sum
        self.performSegue(withIdentifier: "ReviewSegue", sender: self)
        self.txtAmount.text = ""
        self.lblStatus.text = " "
    }
}
