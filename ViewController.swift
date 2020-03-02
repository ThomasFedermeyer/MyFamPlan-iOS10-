//
//  ViewController.swift
//  Final-MyFamPlan
//
//  Created by Tommy on 2/23/20.
//  Copyright © 2020 conant. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController {
    
    @IBOutlet weak var Familyinput: UITextField!
    @IBOutlet weak var Nameinput: UITextField!
    @IBOutlet weak var ChoresToDo: UILabel!
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func ChangeScreen(_ sender: Any) {
        name = Nameinput.text!
        let db = Firestore.firestore()
        db.collection("Family").document(Familyinput.text! + "").collection(Nameinput.text! + "").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            var check: String
                            check = document.get("Name") as! String
                            print(check)
                            if check == self.name{
                                print("Name Exists")
                                self.performSegue(withIdentifier: "ToMainScreen", sender: self)
                            }
                        }
            }
        }
            
        
    }
    
    
    

    

    
    
    
    
    @IBAction func Login(_ sender: Any) {
        
//        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance().signIn()
        
        
//        var Kids = (Array<String>)();
//        var ChoresToDo = (Array<String>());
//
//        let db = Firestore.firestore()
//        db.collection("Family").document(Familyinput.text!).collection(Nameinput.text!).getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                    self.ChoresToDo.text = "\(document.data())"
//                    var Role: String
//                    Role = document.get("Role") as! String
//                    print(Role)
//                    if Role == "Adult"{
//                        print("BDSIDIUSBUIDGS")
//                        db.collection("Family").whereField("Name", isEqualTo: self.Familyinput.text!)
//                            .getDocuments() { (querySnapshot, err) in
//                                if let err = err {
//                                    print("Error getting documents: \(err)")
//                                } else {
//                                    for document in querySnapshot!.documents {
//                                        print(document.get("kids")!)
//                                        Kids = document.get("kids") as! (Array<String>)
//                                        var placeholder = ""
//                                        for Stuff in Kids{
//                                            placeholder += Stuff + " "
//                                        }
//                                        self.ChoresToDo.text = placeholder
//                                    }
//                                }
//                        }
//                    }
//                    else {
//                        ChoresToDo = document.get("Chores-Not-Completed") as! (Array<String>)
//                        var placeholder = ""
//                        for Stuff in ChoresToDo{
//                            placeholder += Stuff + " "
//                        }
//                        self.ChoresToDo.text = placeholder
//                    }
//
//                }
//
//            }
//        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destVC : ViewMainScreen = segue.destination as!
        ViewMainScreen
        destVC.modalPresentationStyle = .fullScreen
        name = Nameinput.text!
        destVC.FamilyName = Familyinput.text! + ""
        destVC.AccountName = Nameinput.text! + ""
    }

    
    
}




class ViewMainScreen: UIViewController {
    
    var FamilyName = ""
    var AccountName = ""
    var role = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Testing --- Screen post")
        print(FamilyName)
        print(AccountName)
        print("--End--")
    }
    
    
    @IBAction func Exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func ToChoreView(_ sender: Any) {
        
        let db = Firestore.firestore()
                db.collection("Family").document(FamilyName).collection(AccountName).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            self.role = document.get("Role") as! String
                            print(self.role)
                            if self.role == "Child"{
                                self.performSegue(withIdentifier: "ToChildView", sender: self)
                            }
                            else if self.role == "Adult"{
                                self.performSegue(withIdentifier: "ToAdultChoreView", sender: self)
                            }
                        }
                        
                    }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if role == "Child"{
            let destVC : ChildChoreView = segue.destination as! ChildChoreView
            destVC.modalPresentationStyle = .fullScreen
            destVC.FamilyName = FamilyName
            destVC.AccountName = AccountName
            destVC.role = role
        }
        
        else if role == "Adult"{
            let destVC : AdultChoreView = segue.destination as! AdultChoreView
            destVC.modalPresentationStyle = .fullScreen
            destVC.FamilyName = FamilyName
            destVC.AccountName = AccountName
            destVC.role = role
        }
        
    }
    
}


class ChildChoreView: UIViewController {
    var role = ""
    var FamilyName = ""
    var AccountName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Testing --- Screen post")
        print(FamilyName)
        print(AccountName)
        print(role)
        print("--End--")
    }
    
    
    
    @IBAction func Exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
class AdultChoreView: UIViewController {
    var role = ""
    var FamilyName = ""
    var AccountName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Testing --- Screen post")
        print(FamilyName)
        print(AccountName)
        print(role)
        print("--End--")
    }
    
    
    @IBAction func Exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
}






















