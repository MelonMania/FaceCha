//
//  ImageData.swift
//  FaceCha
//
//  Created by RooZin on 2021/03/10.
//

import Foundation

struct ImageData : Codable {
    let faces : [Faces]
}

struct Faces : Codable {
    let celebrity : CelebrityData
}

struct CelebrityData : Codable {
    let value : String
    let confidence : Float
}
