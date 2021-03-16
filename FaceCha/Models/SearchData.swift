//
//  SearchData.swift
//  FaceCha
//
//  Created by RooZin on 2021/03/14.
//

import UIKit

struct SearchData : Codable {
    let items : [Info]
    
}

struct Info : Codable {
    let link : String
}
