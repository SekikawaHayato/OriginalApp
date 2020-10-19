//
//  CreateDataViewController.swift
//  OriginalApp
//
//  Created by 関川隼人 on 2020/10/01.
//  Copyright © 2020 関川隼人. All rights reserved.
//

import UIKit
import RealmSwift

class WriteDataViewController: UIViewController,UIPickerViewDelegate ,UIPickerViewDataSource,UITextFieldDelegate{
    
    var type: String!
    var dataGroup: VariableDataGroup!
    var data: VariableData!
    
    var realmService: RealmService!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var moldTextField: UITextField!
    @IBOutlet var valueTextField: UITextField!
    
    var pickerView:UIPickerView = UIPickerView()
    let idToShow: [String:String] = ["STRING":"文字","FLOAT":"数字"]//,"ARRAY":"配列"]
    let showToID:[String:String] = ["文字":"STRING","数字":"FLOAT"]//,"配列":"ARRAY"]
    let list = ["数字","文字"]//,"配列"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(WriteDataViewController.done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(WriteDataViewController.cancel))
        toolbar.setItems([cancelItem, doneItem], animated: true)
        
        self.moldTextField.inputView = pickerView
        self.moldTextField.inputAccessoryView = toolbar
        nameTextField.delegate = self
        moldTextField.delegate = self
        valueTextField.delegate = self
        if type == "Top"{
            moldTextField.isHidden = true
            valueTextField.isHidden = true
            nameTextField.text = dataGroup.fileName
        }else if type == "During"{
            nameTextField.text = data.variableName
            if data.mold == .OBJECT{
                moldTextField.isHidden = true
                valueTextField.isHidden = true
                
            }else{
                moldTextField.text = idToShow[data.mold.rawValue]
                valueTextField.text = data.variableValue
            }
        }
        
        realmService = RealmService.shared
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.moldTextField.text = list[row]
    }
    
    @objc func cancel() {
        self.moldTextField.text = ""
        self.moldTextField.endEditing(true)
    }
    
    @objc func done() {
        self.moldTextField.endEditing(true)
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteData(){
        if type == "Top"{
            realmService.delete(dataGroup)
        }else{
            realmService.delete(data)
        }
        back()
    }
    
    @IBAction func updateData(){
        if type == "Top"{
            if nameTextField.text != ""{
                realmService.updateTopData(dataGroup,nameTextField.text!)
                back()
            }
        }else if type == "During"{
            if data.mold == .OBJECT{
                if nameTextField.text != ""{
                    realmService.updateObjectData(data,nameTextField.text!)
                    back()
                }
            }else {
                if nameTextField.text != "" && moldTextField.text != "" && valueTextField.text != "" {
                    realmService.updateVariableData(data, nameTextField.text!, showToID[moldTextField.text!]!, valueTextField.text!)
                    back()
                }
            }
        }
    }
    
    @IBAction func backMainController(){
        back()
    }
    
    func back(){
        dismiss(animated: true, completion: nil)
        let parentVC = self.presentingViewController as! ViewController
        parentVC.updateView()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
