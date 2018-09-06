//
//  LoginViewController.swift
//  Docxone
//
//  Created by Apple on 08/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView

class LoginViewController: UIViewController {

    //MARK: IBOUTLET
    @IBOutlet var textEmail: UITextField!
    @IBOutlet var textPassword: UITextField!
     @IBOutlet var usernameView: UIView!
     @IBOutlet var passwordView: UIView!
     @IBOutlet var loginBtn: UIButton!
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
          self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.usernameView.layer.borderColor = UIColor(red: 28.0/255.0, green: 115.0/255.0, blue: 186.0/255.0, alpha: 1).cgColor
        self.usernameView.layer.borderWidth = 1.0
        self.usernameView.layer.cornerRadius = 20.0
        self.passwordView.layer.borderColor = UIColor(red: 28.0/255.0, green: 115.0/255.0, blue: 186.0/255.0, alpha: 1).cgColor
        self.passwordView.layer.borderWidth = 1.0
        self.passwordView.layer.cornerRadius = 20.0
        self.loginBtn.layer.borderColor = UIColor(red: 28.0/255.0, green: 115.0/255.0, blue: 186.0/255.0, alpha: 1).cgColor
        //self.loginBtn.layer.borderWidth = 1.0
        self.loginBtn.layer.cornerRadius = 20.0
        self.loginBtn.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnForgotPassword(_ sender: UIButton) {
        let addressVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(addressVC, animated: true)
    }
    //MARK: ButtonAction Method
    @IBAction func btnLogin(_ sender: UIButton) {
        textFieldValidation()
    }
    
    //MARK: textFieldValidation Method
    func textFieldValidation()
    {
        if (self.textEmail.text?.isEmpty)! {
            Webservice.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Email")
        }
        else if (self.textEmail.text?.isEmpty)! {
            Webservice.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Enter Password")
        }
        else{
            //loginMethodAPI()
            loginMethod()
        }
    }
    
    //MARK: loginAPI Methods
    func loginMethod(){
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "username": self.textEmail.text!,
            "password": self.textPassword.text!,
            "domain": Model.sharedInstance.domain
        ]
        print(parameters)
        Webservice.apiPost(serviceName: "docxone", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                let addProductVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ClientViewController") as! ClientViewController
                Model.sharedInstance.username = self.textEmail.text!
                Model.sharedInstance.password = self.textPassword.text!
               // Model.sharedInstance.domain = "https://docxone.sharepoint.com"
                self.navigationController?.pushViewController(addProductVC, animated: true)
            }
            else{
               
            }
        }
    }
    
    //MARK: loginAPI Methods
    func loginMethodAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "username": self.textEmail.text!,
            "password": self.textPassword.text!,
            "domain":"https://docxone.sharepoint.com"
        ]
        
        print(parameters)
        let url = "\(Model.sharedInstance.baseUrl)\("docxone")"
        print(url)
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil)
            .responseJSON { response in
                DispatchQueue.main.async(execute: {
                    SKActivityIndicator.dismiss()
                })
                //  print(response.request as Any)  // original URL request
                //  print(response.response as Any) // URL response
                //  print(response.result.value as Any)   // result of response serialization
                
                let dict = response.result.value
                print(dict!)
                if String((dict as! NSDictionary).value(forKey: "status") as! NSInteger) == "0"{
                    Webservice.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: ((dict as! NSDictionary).value(forKey: "message") as! String))
                }
                else{
                    let addProductVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectClientViewController") as! SelectClientViewController
                     Model.sharedInstance.username = self.textEmail.text!
                    Model.sharedInstance.password = self.textPassword.text!
                     Model.sharedInstance.domain = "https://docxone.sharepoint.com"
                    self.navigationController?.pushViewController(addProductVC, animated: true)
                }
        }
    }
}

