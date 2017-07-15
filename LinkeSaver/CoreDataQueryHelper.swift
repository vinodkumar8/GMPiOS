//
//  CoreDataQueryHelper.swift
//  LinkeSaver
//
//  Created by Vinod Kumar Prajapati on 15/07/17.
//  Copyright © 2017 vinod. All rights reserved.
//
import UIKit
import Foundation
import CoreData

class CoreDataQueryHelper {
    class func getSavedResult(completionBlock: @escaping ([String])-> Void) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Urls")
        DispatchQueue.global(qos: .default).async {
            let response = try? managedContext.fetch(request)
            if let recentResult = response{
                var result = [String]()
                for item in  recentResult{
                    if let sItem = item as? Urls, let url = sItem.url{
                        result.append(url)
                    }
                }
                DispatchQueue.main.async(execute: {
                    completionBlock(result)
                })
            }else{
                DispatchQueue.main.async(execute: {
                    
                })
            }
            
        }
    }
    
    class func saveUrlToDB(with url : String, baseURl: String ,completion: ((Bool)-> Void)?)  {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        
        //Process here
        if let entity =
            NSEntityDescription.entity(forEntityName: "Urls",
                                       in: managedContext){
            let recent = Urls(entity: entity, insertInto: managedContext)
            recent.url = url
            recent.baseURl = baseURl
        }
        // 4
        DispatchQueue.global(qos: .default).async(execute: {
            do {
                try? managedContext.save()
                DispatchQueue.main.async {
                    completion?(false)
                }
            } catch let error as NSError {
                DispatchQueue.main.async(execute: {
                    print("Could not save. \(error), \(error.userInfo)")
                    completion?(false)
                })
            }
        })
        
    }
}
