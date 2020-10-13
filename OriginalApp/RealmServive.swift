//
//  RealmService.swift
//
//  Created by Kento Katsumata on 2020/02/12.
//  Copyright © 2020 Kento Katsumata. All rights reserved.
//
import Foundation
import RealmSwift

class RealmService {
    
    private init() {}
    static let shared = RealmService()
    var realm = try! Realm()
    
    func create<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            post(error)
        }
    }
    
    func update<T: Object>(_ object: T, with dictionary: [String:Any]) {
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
                print(object)
            }
        } catch {
            post(error)
        }
    }
    
    func updateParentList(_ object: VariableDataGroup,_ addObject: VariableData){
        try! realm.write{
            object.variableDataList.append(addObject)
        }
    }
    func updateTopData(_ object: VariableDataGroup,_ addText: String){
        try! realm.write{
            object.fileName = addText
        }
    }
    func updateDuringList(_ object: VariableData,_ addObject: VariableData){
        try! realm.write{
            object.variableDataList.append(addObject)
        }
    }
    func updateObjectData(_ object: VariableData,_ addText: String){
        try! realm.write{
            object.variableName = addText
        }
    }
    
    func updateVariableData(_ object: VariableData,_ nameText: String,_ moldText: String,_ valueText: String){
        try! realm.write{
            object.variableName = nameText
            switch moldText{
            case "INT":
                object.mold = .INT
                break
            case "STRING":
                object.mold = .STRING
                break
            case "FLOAT":
                object.mold = .FLOAT
                break
            case "ARRAY":
                object.mold = .ARRAY
                break
            default:
                break
            }
            object.variableValue = valueText
        }
    }
    
    //    func updateData(_ object: VariableData,value: VariableData){
    //        try! realm.write() {
    //        }
    //    }
    //
    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            post(error)
        }
    }
    
    func deleteAll<T: Object>(_ object: T.Type, _ filterString:String! = nil){
        do {
            if filterString == nil{
                let result = realm.objects(object)
                try realm.write{
                    realm.delete(result)
                }
            }else{
                let result = realm.objects(object).filter(filterString)
                try realm.write{
                    realm.delete(result)
                }
            }
            
        }catch{
            post(error)
        }
    }
    
    func count(_ object: Object.Type) -> Int{
        return realm.objects(object).count
    }
    
    func resultGroup() -> Results<VariableDataGroup> {
        return realm.objects(VariableDataGroup.self)
    }
    
    func resultData() -> Results<VariableData>{
        return realm.objects(VariableData.self)
    }
    
    //    func result<T:Object>(object: T.Type) -> Results<T>{
    //        return realm.objects(object)
    //    }
    
    func post(_ error: Error) {
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
    }
    
}
