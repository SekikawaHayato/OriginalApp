//
//  ViewController.swift
//  OriginalApp
//
//  Created by 関川隼人 on 2020/10/01.
//  Copyright © 2020 関川隼人. All rights reserved.
//

import UIKit
import RealmSwift


class ViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    var realmService: RealmService!
    var showVariableDataGroup: Results<VariableDataGroup>!
    var showVariableData: List<VariableData>!
    var topParentObject: VariableDataGroup!
    var parentObject: VariableData!
    
    var topWriteObject: VariableDataGroup!
    var writeObject: VariableData!
    
    var mode: String!
    
    var parentDataType: String!
    // Index番号を保存しておく？
    static var stackIndex: StackIndex!
    // 一旦一番最初に戻る実装にする
    static var isTop: Bool!
    
    @IBOutlet var table: UITableView!
    @IBOutlet var modeImage: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.dataSource = self
        
        table.delegate = self
        
        table.rowHeight = 100
        
        ViewController.isTop = true
        
        realmService = RealmService.shared
        //ViewController.stackIndex = StackIndex.shared
        
        if realmService.count(VariableDataGroup.self) == 0{
            let firstData = VariableDataGroup()
            firstData.fileName = "sample"
            let variableData = VariableData()
            variableData.variableName = "data01"
            variableData.mold = .STRING
            variableData.variableValue = "sample"
            firstData.variableDataList.append(variableData)
            realmService.create(firstData)
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        showVariableDataGroup = realmService.resultGroup()
        
        mode = "Move"
        //realmService.deleteAll(VariableDataGroup.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presentingViewController?.beginAppearanceTransition(false, animated: animated)
        super.viewWillAppear(animated)
        print("apper")
    }
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //
    //    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("Layout")
    }
    
    @IBAction func createButton(_ sender: Any) {
        //if ViewController.stackIndex.peek() == nil{
        if ViewController.isTop == true{
            performSegue(withIdentifier: "CreateFileSegue", sender: nil)
        }else{
            performSegue(withIdentifier: "CreateDataSegue", sender: nil)
        }
    }
    @IBAction func changeModeButton(){
        if mode == "Write"{
            mode = "Move"
            modeImage?.image = UIImage(named: "Idou.png")
        } else{
            mode = "Write"
            modeImage?.image = UIImage(named: "Hensyu.png")
        }
    }
    
    @IBAction func moveTopButton(){
        ViewController.isTop = true
        updateView()
    }
    
    @IBAction func ShareButton(){
        performSegue(withIdentifier: "ShareSegue",sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateDataSegue" {
            let nextVC = segue.destination as! CreateDataViewController
            //if ViewController.stackIndex.peek()==nil{
            if parentDataType == "Top"{
                nextVC.hierarchy = "Top"
                nextVC.topParentObject = topParentObject
            }else{
                nextVC.hierarchy = "During"
                nextVC.parentObject = parentObject
            }
        }else if segue.identifier == "WriteDataSegue"{
            let nextVC = segue.destination as! WriteDataViewController
            
            if ViewController.isTop == true{
                nextVC.type = "Top"
                nextVC.dataGroup = topWriteObject
            }else{
                nextVC.type = "During"
                nextVC.data = writeObject
            }
        }
    }
    
    
    // テーブルのセル数を指定する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ViewController.isTop == true{
            return showVariableDataGroup.count
        }else{
            return showVariableData.count
        }
    }
    
    // テーブルの読み込み処理
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ObjectTableViewCell") as! ObjectTableViewCell
        if ViewController.isTop == true{
            cell.contentTextLabel.text = showVariableDataGroup[indexPath.row].fileName
        }else{
            cell.contentTextLabel.text = showVariableData[indexPath.row].variableName
        }
        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        return cell
    }
    
    // セルが押された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if mode == "Move"{
            if ViewController.isTop == true{
                ViewController.isTop = false
                parentDataType = "Top"
                topParentObject = showVariableDataGroup[indexPath.row]
                showVariableData = showVariableDataGroup[indexPath.row].variableDataList
                updateView()
            }else{
                if showVariableData[indexPath.row].mold.rawValue == "OBJECT"{
                    parentDataType = "During"
                    parentObject = showVariableData[indexPath.row]
                    showVariableData = showVariableData[indexPath.row].variableDataList
                    updateView()
                }else{
                    table.deselectRow(at: indexPath, animated: true)
                }
            }
        }else if mode == "Write"{
            if ViewController.isTop == true{
                topWriteObject = showVariableDataGroup[indexPath.row]
            }else {
                writeObject = showVariableData[indexPath.row]
            }
            performSegue(withIdentifier: "WriteDataSegue", sender: nil)
        }
    }
    
    func updateView(){
        table.reloadData()
    }
}
