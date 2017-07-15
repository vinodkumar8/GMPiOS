//
//  Model.swift
//  LinkeSaver
//
//  Created by Vinod Kumar Prajapati on 15/07/17.
//  Copyright © 2017 vinod. All rights reserved.
//

import Foundation
import SwiftLinkPreview

struct GroupedUrlPreview {
    var baseUrl: String?
    var Urls: [String]
}

struct UrlPreview {
    var baseUrl = ""
    var title: String?
    var imageUrl: String?
    var description: String?
    var url: URL?
    var validImageUrl: String?{
        if let imgUrl = imageUrl, imgUrl.hasPrefix("http"){
            return imgUrl
        }else{
            return "\(baseUrl)\(imageUrl ?? "")"
        }
    }
    var isSaved: Bool = false
    
    init(with urlPreview: SwiftLinkPreview.Response) {
        for item in urlPreview {
            let stringMirror = Mirror(reflecting: item.value)
            print(stringMirror.subjectType)
            if item.key.rawValue == "canonicalUrl", let value = item.value as? String{
                baseUrl = value
            }
            if item.key.rawValue == LinkerConstants.titleKey, let title = item.value as? String{
                self.title = title
            }
            else if item.key.rawValue == LinkerConstants.imageKey, let img = item.value as? String{
                if img.hasPrefix("http"){
                    imageUrl = img
                }else if img.hasPrefix("."){
                    let index = img.index(img.startIndex, offsetBy: 1)
                    imageUrl =  img.substring(from: index)
                }else if img.hasPrefix("/"){
                    imageUrl = img
                }
            }else if item.key.rawValue == LinkerConstants.urlKey, let url = item.value as? URL{
                self.url = url
            }else if item.key.rawValue == LinkerConstants.descriptionKey, let desc = item.value as? String{
                self.description = desc
            }
        }
    }
}
