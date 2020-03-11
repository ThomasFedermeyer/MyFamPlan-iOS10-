//
//  ViewController.swift
//  Final-MyFamPlan
//
//  Created by Tommy on 2/23/20.
//  Copyright © 2020 conant. All rights reserved.
//

import UIKit
import Firebase




class Login: UIViewController {
    
    @IBOutlet weak var Familyinput: UITextField!
    @IBOutlet weak var Nameinput: UITextField!
    @IBOutlet weak var ChoresToDo: UILabel!
    var name = ""
    var WeeklyNumber = "NA"
    
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
    var WeeklyNumber = 0
    var ChoresCompleted  = 0
    @IBOutlet weak var LableName: UILabel!
    @IBOutlet weak var LableWeeklyPercent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Testing --- Screen post")
        print(FamilyName)
        print(AccountName)
        print("--End--")
        LableName.text = AccountName
        DisplayWeeklyPercent()
                
 
               
        

        
        
    }
    
    
    @IBAction func Exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func DisplayWeeklyPercent()  {
        
        let db = Firestore.firestore()
                db.collection("Family").document(FamilyName).collection(AccountName).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            self.role = document.get("Role") as! String
                            print(self.role)
                            if self.role == "Child"{
                                self.LableWeeklyPercent.text = "%" + String(document.get("Chores-Completed") as! Int) + " / " + String(document.get("Weekly-Number") as! Int)
                            }
                            else if self.role == "Adult"{
                                self.LableWeeklyPercent.text = "NA"
                            }
                        }
                        
                    }
        }
        
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
    var Chores = [String]()
    @IBOutlet weak var ChoreLable: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Testing --- Screen post")
        print(FamilyName)
        print(AccountName)
        print(role)
        print("--End--")
        Display()
    }
    
    func Display()  {
        let db = Firestore.firestore()
        db.collection("Family").document(FamilyName).collection(AccountName).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.Chores = document.get("Chores-Not-Completed") as! [String]
                    print(self.Chores)
                }
                
                var out = ""
                for stuff in self.Chores{
                    out += stuff
                }
                self.ChoreLable.text = out
            }
        }
    }
    
    
    
    @IBAction func ViewChoreStuff(_ sender: Any) {
        var test = false
        for stuff in Chores{
            if (ChoreLable.text == stuff){
                test = true
            }
        }
        if test {
            self.performSegue(withIdentifier: "ToChoreDetails", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC : ChoreDetail = segue.destination as! ChoreDetail
        destVC.modalPresentationStyle = .fullScreen
        destVC.FamilyName = FamilyName
        destVC.AccountName = AccountName
        destVC.ChoreName = ChoreLable.text!
        
    }
    
    
    
    @IBAction func Exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}


class ChoreDetail: UIViewController{
    
    var FamilyName = ""
    var AccountName = ""
    var ChoreName = ""
    
    
    @IBOutlet weak var NameLable: UILabel!
    
    @IBOutlet weak var DetailLable: UILabel!
    
    @IBOutlet weak var DateLable: UILabel!
    
    @IBOutlet weak var CompletedLable: UILabel!
    
    
    
    override func viewDidLoad() {
        print(ChoreName)
        super.viewDidLoad()
        
        
        
        
        let db = Firestore.firestore()
        db.collection("Family").document(FamilyName).collection("Chores").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if(document.get("Name") as! String == self.ChoreName){
                        self.NameLable.text = self.ChoreName
                        self.DateLable.text = document.get("Date") as! String
                        self.DetailLable.text = document.get("Description") as! String
                        if(document.get("Done") as! Bool){
                            self.CompletedLable.text = "Done"
                        }
                        else{
                            self.CompletedLable.text = "Work In Progress"
                        }
                    }
                    
                }
                
               
            }
        }
        
        
        
        
        
        
        
        
        
    }
    
    @IBAction func Exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}



class AdultChoreView: UIViewController {
    var role = ""
    var FamilyName = ""
    var AccountName = ""
    var Chores = String()
    @IBOutlet weak var ChoreList: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Testing --- Screen post")
        print(FamilyName)
        print(AccountName)
        print(role)
        print("--End--")
        Display()
    }
    
    func Display() {
       
        let db = Firestore.firestore()
        db.collection("Family").document(FamilyName).collection("Chores").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.Chores += document.get("Name") as! String
                    
                }
               
                self.ChoreList.text = self.Chores

            }
        }
    }
    
    @IBAction func Exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ToAddChore(_ sender: Any) {
        performSegue(withIdentifier: "ToAddChores", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC : AddChores = segue.destination as! AddChores
        destVC.modalPresentationStyle = .fullScreen
        destVC.FamilyName = FamilyName
        destVC.AccountName = AccountName
        destVC.role = role
    }
}





class AddChores: UIViewController {
   
   var FamilyName = ""
   var AccountName = ""
   var role = ""
   var WeeklyNumber = 0
   var ChoresCompleted  = 0
   @IBOutlet weak var NameChoreInput: UITextField!
   @IBOutlet weak var DateChoreInput: UITextField!
   @IBOutlet weak var DescriptionChoreInput: UITextField!
   @IBOutlet weak var AssignedChoreInput: UITextField!
   
    
    
    
    
   override func viewDidLoad() {
       super.viewDidLoad()
       print("Testing --- Screen post")
       print(FamilyName)
       print(AccountName)
       print("Add Chores")
       print("--End--")
   }
    
    let db = Firestore.firestore()
    
    func AddData() {
        
        
        // fix this part its wrong i just copied it
        db.collection("Family").document(FamilyName).collection("Chores").document(NameChoreInput.text!).setData([
            "Name": NameChoreInput.text!,
            "Date": DateChoreInput.text!,
            "Description": DescriptionChoreInput.text!,
            "Assigned": AssignedChoreInput.text!
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    
   @IBAction func Exit(_ sender: Any) {
       AddData()
       dismiss(animated: true, completion: nil)
   }
    
}
















