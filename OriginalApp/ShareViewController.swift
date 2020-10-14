//
//  ShareViewController.swift
//  OriginalApp
//
//  Created by 関川隼人 on 2020/10/13.
//  Copyright © 2020 関川隼人. All rights reserved.
//

import UIKit
import RealmSwift

class ShareViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    var realmService: RealmService!
    var result: Results<VariableDataGroup>!
    
    @IBOutlet var table: UITableView!
    
    //ファイルの書き出しなどを管理
    let dir = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask
    ).first!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        
        table.delegate = self
        
        table.rowHeight = 100
        
        realmService = RealmService.shared
        
        result = realmService.resultGroup()
        
        // Do any additional setup after loading the view.
    }
    
    
    // ファイルの書き出し / 上書き保存
    func createFile(fileName: String,text: String){
        // ファイルURLを作成
        let fileUrl = dir.appendingPathComponent(fileName + ".json")
        // ファイルが存在するならば
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            // ファイルの上書き
            do {
                try text.write(to: fileUrl, atomically: false, encoding: String.Encoding.utf8)
            } catch {
                print("Error: \(error)")
            }
        }else{
            // 新しいファイルを作成
            FileManager.default.createFile(
                atPath: fileUrl.path,
                contents: text.data(using: String.Encoding.utf8),
                attributes: nil
            )
            print(fileUrl.path)
        }
        sendFile(fileURL: fileUrl,text: fileName)
    }
    
    func sendFile(fileURL: URL,text: String) {
        //        let image = UIImage(named: "item.png")!
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    // テーブルのセル数を指定する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    // テーブルの読み込み処理
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ObjectTableViewCell") as! ObjectTableViewCell
        cell.contentTextLabel.text = result[indexPath.row].fileName
        cell.backgroundColor = UIColor(red: 0, green: 0,blue: 0,alpha: 0)
        return cell
    }
    
    // セルが押された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let valueText = createText(result[indexPath.row])
        createFile(fileName: result[indexPath.row].fileName,text: valueText)
        // 後でアラート追加したい
        //back()
    }
    
    func createText(_ object: VariableDataGroup) -> String{
        var objectArray = Array<VariableData>() // Array型
        objectArray.append(contentsOf: Array(object.variableDataList)) // Array()でListを変換
        var jsonText = "{"
        for (i,object) in objectArray.enumerated(){
            jsonText += "\"\(object.variableName)\":"
            switch object.mold.rawValue{
            case "INT":
                jsonText += object.variableValue
            case "FLOAT":
                jsonText += object.variableValue
            case "STRING":
                jsonText += "\"\(object.variableValue)\""
            case "OBJECT":
                jsonText += addText(object)
            default:
                break;
            }
            if i != objectArray.count - 1{
                jsonText += ","
            }
        }
        jsonText += "}"
        return jsonText
    }
    
    func addText(_ object: VariableData) -> String{
        var objectArray = Array<VariableData>() // Array型
        objectArray.append(contentsOf: Array(object.variableDataList)) // Array()でListを変換
        var addText = "{"
        for (i,object) in objectArray.enumerated(){
            addText += "\"\(object.variableName)\":"
            switch object.mold.rawValue{
            case "INT":
                addText += object.variableValue
            case "FLOAT":
                addText += object.variableValue
            case "STRING":
                addText += "\"\(object.variableValue)\""
            case "OBJECT":
                addText += self.addText(object)
            default:
                break;
            }
            if i != objectArray.count - 1{
                addText += ","
            }
        }
        addText += "}"
        return addText
    }
    
    @IBAction func backMainController(){
        back()
    }
    
    func back(){
        dismiss(animated: true, completion: nil)
        let parentVC = self.presentingViewController as! ViewController
        parentVC.updateView()
    }
    
}
