//
//  AdvancedSearchViewController.swift
//  Docxone
//
//  Created by Apple on 16/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SKActivityIndicatorView
class getClient {
    var id: String
    var title :String
    var path : String
    init(id : String,title: String,path: String) {
        self.id = id
        self.title = title
        self.path = path
        
    }
}
class AdvancedSearchViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate,UISearchBarDelegate{

    //MARK: IBOutlet and Variables
    @IBOutlet var tableView: UITableView!
     @IBOutlet var textDocument: UITextField!
     @IBOutlet var textSearch: UITextField!
     @IBOutlet var textClient: UITextField!
    @IBOutlet var textDateFrom: UITextField!
    @IBOutlet var textDateTo: UITextField!
     @IBOutlet weak var searchBar: UISearchBar!
    let kCellIdentifier = "cell"
    var getClientArr = NSArray()
    var arrFilterData  = NSArray()
    var pathStr = String()
     var pathStrFinal = String()
    var pathSelected:[String] = []
    let document = ["All","Word Documents","Excel Documents", "Powerpoint","Presentations","Email"]
     var pickerView : UIPickerView!
     var datePicker : UIDatePicker!
     var selectedTag = NSInteger()
    var isSearch : Bool!
     var clientArr = [getClient]()
    var filteredData = [getClient]()
    var searchActive : Bool = false
      @IBOutlet var shadowView: UIView!
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchActive = false
        searchBar.barTintColor = .white
        searchBar.delegate = self
        searchBar.backgroundColor = .green
         getClientAPI()
        shadowView.layer.cornerRadius = 2.0
        shadowView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)
        print("kjdgfhjsdgfsdgfhjds")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
     }
    
    //MARK: getClientAPI Methods
    func getClientAPI(){
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "username":  Model.sharedInstance.username,
            "password":  Model.sharedInstance.password,
            "domain": Model.sharedInstance.domain
        ]
        print(parameters)
        Webservice.apiPost(serviceName: "getclients", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
            if error != nil {
                print(error?.localizedDescription as Any)
                DispatchQueue.main.async(execute: {
                    SKActivityIndicator.dismiss()
                })
                //Alert.showAlertMessage(vc: self, titleStr: "Alert!", messageStr: "Login Failed.Try Again..")
                return
            }
            print(response!)
            self.getClientArr =  (response?.value(forKey: "data") as! NSArray)
            
            for item in (response!.value(forKey: "data") as! NSArray) {
                
                self.clientArr.append(getClient.init(id: ((item as! NSDictionary).value(forKey: "Id") as! String), title: ((item as! NSDictionary).value(forKey: "Title") as! String), path: ((item as! NSDictionary).value(forKey: "rootFolderPath") as! String)))
            }
            DispatchQueue.main.async(execute: {
                SKActivityIndicator.dismiss()
                self.tableView.reloadData()
            })
        }
    }

    //MARK: Set PickerView
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.backgroundColor = UIColor.lightGray
        textField.inputView = self.pickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AdvancedSearchViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(AdvancedSearchViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    //MARK:- PickerView Delegate & DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.document.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.document[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textDocument.text = self.document[row]
    }
    //MARK:- TextFiled Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            selectedTag = textField.tag
            self.pickUp(self.textDocument)
        }
        else  if textField.tag == 2 {
             selectedTag = textField.tag
          self.pickUpDate()
        }
        else  if textField.tag == 3 {
            selectedTag = textField.tag
           self.pickUpDate()
        }
    }
    
    //MARK:- Button
    @objc func doneClick() {
        self.textDocument.resignFirstResponder()
    }
    @objc func cancelClick() {
         self.textDocument.resignFirstResponder()
    }
    //MARK:- Function of datePicker
    func pickUpDate(){
        
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y:0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.gray
        self.datePicker.datePickerMode = UIDatePickerMode.date
        textDateFrom.inputView = self.datePicker
        textDateTo.inputView = self.datePicker
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AdvancedSearchViewController.done1Click))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(AdvancedSearchViewController.cancel1Click))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textDateFrom.inputAccessoryView = toolBar
        textDateTo.inputAccessoryView = toolBar
    }
    // MARK:- Button Done and Cancel
    @objc func done1Click() {
        let dateFormatter1 = DateFormatter()
        //dateFormatter1.dateStyle = .medium
        //dateFormatter1.timeStyle = .none
         dateFormatter1.dateFormat = "MM/dd/yyyy"
        if selectedTag == 2 {
            textDateFrom.text = dateFormatter1.string(from: datePicker.date)
            textDateFrom.resignFirstResponder()
        }
        else if selectedTag == 3{
            textDateTo.text = dateFormatter1.string(from: datePicker.date)
            textDateTo.resignFirstResponder()
        }
    }
    @objc func cancel1Click() {
        if selectedTag == 2 {
            textDateFrom.resignFirstResponder()
        }
        else if selectedTag == 3 {
            textDateTo.resignFirstResponder()
        }
    }
    @IBAction func btnSearch(_ sender: UIButton) {
        pathStr1()
        searchAPIMethod()
    }
    //MARK: searchAPIMethod
    func searchAPIMethod(){
        
        SKActivityIndicator.spinnerColor(UIColor.darkGray)
        SKActivityIndicator.show("Loading...")
        let parameters: Parameters = [
            "username": "demo@docxone.onmicrosoft.com",
            "password": "Docxone@150",
            "domain": "https://docxone.sharepoint.com",
            "txtsearch":self.textSearch.text!,
            "selItems":pathStrFinal,
            "documenttype": self.textDocument.text!,
            "from": self.textDateFrom.text!,
            "to":self.textDateTo.text!
        ]
        print(parameters)
        Webservice.apiPost(serviceName: "advancedsearch", parameters: parameters, headers: nil) { (response:NSDictionary?, error:NSError?) in
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
                let addProductVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController
                addProductVC.searchResultArr = (response?.value(forKey: "data") as? NSArray)!
                self.navigationController?.pushViewController(addProductVC, animated: true)
            }
            else{
                
            }
        }
    }
    //MARK: SearchBar Delegate Methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filteredData = self.clientArr.filter { $0.title.lowercased().contains(searchBar.text!.lowercased())}
        if(filteredData.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
}
// MARK: - Extension
extension AdvancedSearchViewController: UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredData.count
        }
        else{
           return self.clientArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath) as! ClientTableViewCell
        if searchActive {
            cell.lblName.text  = self.filteredData[indexPath.row].title
        }
        else{
            
             cell.lblName.text = self.clientArr[indexPath.row].title
        }
        return cell
    }
    
}

extension AdvancedSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)! as! ClientTableViewCell
        selectedCell.imgBtn.setImage(UIImage(named: "select"), for: .normal)
       // selectedCell.contentView.backgroundColor = UIColor.blue
        if searchActive {
            pathStr = self.filteredData[indexPath.row].title
        }
        else{
            pathStr = self.clientArr[indexPath.row].title
        }
        pathSelected.append(pathStr)
        print(pathSelected)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedCell1 = tableView.cellForRow(at: indexPath)! as! ClientTableViewCell
        selectedCell1.imgBtn.setImage(UIImage(named: "calender"), for: .normal) 
        selectedCell1.contentView.backgroundColor = UIColor.white
    }
    func pathStr1(){
        
         pathStr = pathSelected[0]
        for index in 0..<pathSelected.count{
            if index == 0 {
               pathStrFinal = pathStr
                print(pathStrFinal)
            }
            else{
                 pathStrFinal = pathStrFinal + "," + pathSelected[index]
            }
        }
         print(pathStrFinal)
    }
    
    
}
