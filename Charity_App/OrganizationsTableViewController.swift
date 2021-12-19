//
//  OrganizationsTableViewController.swift
//  
//
//  .
//

import UIKit
import Firebase
import FirebaseFirestore

class OrganizationsTableViewController: UITableViewController {
    let categoryID = CategorySelect.catID
    var db: Firestore!
    @IBOutlet var tblOrganizations: UITableView!
    
    var organizationsArr: [OrgNameModel] = [OrgNameModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        getOrganizations()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organizationsArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = organizationsArr[indexPath.row].orgName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CategorySelect.organizationID = self.organizationsArr[indexPath.row].organizationID
        CategorySelect.orgName = self.organizationsArr[indexPath.row].orgName
        CategorySelect.address = self.organizationsArr[indexPath.row].address
        self.performSegue(withIdentifier: "questionnaire", sender: self)
    }
    
    func getOrganizations() {
        db.collection("organizations").whereField("categoryID", isEqualTo: self.categoryID)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    print(err?.localizedDescription ?? "error in getting organizations")
                    return
                }
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let name = data["name"] as? String ?? "None"
                    let categoryID = data["categoryID"] as? String ?? "None"
                    let organizationID = data["organizationID"] as? String ?? "None"
                    let address = data["address"] as? String ?? "None"
                    if categoryID == self.categoryID {
                        let out = OrgNameModel(orgName: name, categoryID: categoryID, organizationID: organizationID, address: address)
                        self.organizationsArr.append(out)
                    }
                }
                self.tblOrganizations.reloadData()
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
}
