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
    
    override func viewDidLoad() {
        realmService = RealmService.shared
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    
    @IBAction func backMainController(){
        back()
    }
    
    @IBAction func createObject(){
        if hierarchy == "Top"{
            let variableDataGroup = VariableDataGroup()
            variableDataGroup.fileName = "newFile"
            let variableData = VariableData()
            variableData.variableName = "newObject"
            variableData.mold = .STRING
            variableData.variableValue = "newObject"
            variableDataGroup.variableDataList.append(variableData)
            realmService.create(variableDataGroup)
        }else if hierarchy == "During"{
            
        }
        updateViewController()
        back()
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
