//
//  CreateDataViewController.swift
//  OriginalApp
//
//  Created by 関川隼人 on 2020/10/01.
//  Copyright © 2020 関川隼人. All rights reserved.
//

import UIKit
import RealmSwift

class CreateDataViewController: UIViewController {
    
    var realmService: RealmService!
    var hierarchy: String!
    var parentObject: VariableData!
    var topParentObject: VariableDataGroup!
    
    var createVariableType: String!
    
    @IBOutlet var objectButton: UIButton!
    @IBOutlet var dataButton: UIButton!
    @IBOutlet var createButton: UIButton!
    @IBOutlet var inputTextField: UITextField!
    
    override func viewDidLoad() {
        realmService = RealmService.shared
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    
    @IBAction func backMainController(){
        back()
    }
    
    @IBAction func createObject(){
        changeInputUI()
        createVariableType = "Object"
    }
    
    @IBAction func createData(){
        changeInputUI()
        createVariableType = "Data"
    }
    
    @IBAction func createFile(){
        let variableData = VariableData()
        variableData.variableName = inputTextField.text!
        if createVariableType == "Object"{
            variableData.mold = .OBJECT
            
            let childData = VariableData()
            childData.variableName = "newData"
            childData.mold = .STRING
            
            variableData.variableDataList.append(childData)
        }else if createVariableType == "Data"{
            variableData.mold = .STRING
            variableData.variableValue = "newData"
        }
        
        if hierarchy == "Top"{
            realmService.updateParentList(topParentObject, variableData)
            // topParentObject.variableDataList.append(variableData)
        }else{
            realmService.updateDuringList(parentObject, variableData)
            //parentObject.variableDataList.append(variableData)
            //realmService.create()
        }
        updateViewController()
        back()
    }
    
    func changeInputUI(){
        objectButton.isHidden = true
        dataButton.isHidden = true
        createButton.isHidden = false
        inputTextField.isHidden = false
    }
    
    func back(){
        dismiss(animated: true ,completion: nil)
    }
    
    func updateViewController(){
        let parentVC = self.presentingViewController as! ViewController
        parentVC.updateView()
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
