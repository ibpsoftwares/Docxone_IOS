//
//  Model.swift
//  Docxone
//
//  Created by Apple on 09/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
final class Model {
    
    // Can't init is singleton
    public init() { }
    
    //MARK: Shared Instance
    
    static let sharedInstance: Model = Model()
    
    //MARK: Local Variable
    
    var username = String()
    var password = String()
    var domain = String()
    var baseUrl = "http://182.73.226.85:8091/api/"
}
