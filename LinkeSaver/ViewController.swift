//
//  ViewController.swift
//  LinkeSaver
//
//  Created by Vinod Kumar Prajapati on 15/07/17.
//  Copyright © 2017 vinod. All rights reserved.
//

import UIKit
import SwiftLinkPreview


class ViewController: UIViewController {
    fileprivate static let cellKey = "urlPreviewCell"
    fileprivate var urls = [String]()
    
    
    @IBOutlet weak var urlText: UITextField!
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBAction func sendTapped(_ sender: Any) {
        if let url = urlText.text{
            if let baseUrl = URL(string: url){
                urls.append(url)
                urlText.text = ""
                CoreDataQueryHelper.saveUrlToDB(with: url, baseURl: baseUrl.baseURL?.absoluteString ?? "", completion: nil)
            }
            tableView.reloadData()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { 
            self.tableView.scrollToRow(at: IndexPath(row: self.urls.count - 1, section: 0), at: .bottom, animated: true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        CoreDataQueryHelper.getSavedResult { [weak self](response) in
            self?.urls = response
            
            self?.tableView.reloadData()
        }
    }
    
    
    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return urls.count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellKey, for: indexPath) as? UrlPreviewTableViewCell{
            cell.url = urls[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
}
