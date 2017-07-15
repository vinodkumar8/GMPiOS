//
//  UrlPreviewTableViewCell.swift
//  LinkeSaver
//
//  Created by Vinod Kumar Prajapati on 15/07/17.
//  Copyright © 2017 vinod. All rights reserved.
//

import UIKit
import Nuke
import SwiftLinkPreview

class UrlPreviewTableViewCell: UITableViewCell {

    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var urlDescription: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!{
        didSet{
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped = true
        }
    }
    @IBOutlet weak var urlTitle: UILabel!
    
    @IBOutlet weak var urlImageView: UIImageView!
    
    var url: String?{
        didSet{
            if let url = url{
                loadUrlPreview(with: url)
            }
        }
    }
    
    fileprivate var model: UrlPreview?{
        didSet{
            updateUI()
        }
    }
      
    fileprivate func loadUrlPreview(with url: String?){
        if let text = url{
            let slp = SwiftLinkPreview()
            urlLabel.text = text
            slp.preview(
                text,
                onSuccess: { [weak self]result in
                    DispatchQueue.main.async {
                        guard let strongSelf = self else{
                            return
                        }
                        strongSelf.model = UrlPreview(with: result)
                        strongSelf.activityIndicator.stopAnimating()
                    }
                    //print(model)
                    
                },
                onError: { [weak self]error in
                    print("\(error)")
                    self?.activityIndicator.stopAnimating()
                }
            )
        }
    }
    
    private func updateUI(){
        if let model = model{
            urlLabel.text  = model.url?.absoluteString ?? ""
            urlTitle.text = model.title ?? ""
            urlDescription.text = model.description ?? ""
            //TO DO For image
            if let imgurl = model.validImageUrl, let url = URL(string: imgurl){
                Nuke.loadImage(with: url, into: urlImageView)
            }
        }
    }
}
