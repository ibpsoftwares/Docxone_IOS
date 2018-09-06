//
//  ForgotPasswordViewController.swift
//  Docxone
//
//  Created by Apple on 09/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView
class ForgotPasswordViewController: UIViewController {
  @IBOutlet var usernameView: UIView!
     @IBOutlet var textDomain: UITextField!
       @IBOutlet var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.usernameView.layer.borderColor = UIColor(red: 28.0/255.0, green: 115.0/255.0, blue: 186.0/255.0, alpha: 1).cgColor
        self.usernameView.layer.borderWidth = 1.0
        self.usernameView.layer.cornerRadius = 20.0
     
        self.loginBtn.layer.borderColor = UIColor(red: 28.0/255.0, green: 115.0/255.0, blue: 186.0/255.0, alpha: 1).cgColor
        //self.loginBtn.layer.borderWidth = 1.0
        self.loginBtn.layer.cornerRadius = 20.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: ButtonAction Method
    @IBAction func btnNext(_ sender: UIButton) {
        textFieldValidation()
    }
    
    //MARK: textFieldValidation Method
    func textFieldValidation()
    {
        if (self.textDomain.text?.isEmpty)! {
            Webservice.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Office 365 Url.")
        }
        else{
            getDomainMethod()
        }
    }
    //MARK: getDomainMethod
    func getDomainMethod(){
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "Office365URL": self.textDomain.text!
        ]
        print(parameters)
        Webservice.apiPost(serviceName: "domain", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Login Failed.Try Again..")
                return
            }
            DispatchQueue.main.async(execute: {
                SKActivityIndicator.dismiss()
            })
            print(response!)
            if (response?.value(forKey: "status") as? Bool ?? true) {
                let addProductVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                Model.sharedInstance.domain = (response?.value(forKey: "data") as! String)
                self.navigationController?.pushViewController(addProductVC, animated: true)
            }
            else{
                 Webservice.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: (response?.value(forKey: "data") as! String))
            }
        }
    }

}
