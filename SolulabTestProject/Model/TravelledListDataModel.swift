//
//  TravelledListDataModel.swift
//  SolulabTestProject
//
//  Created by Suraj on 05/01/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

import Foundation

class TravelledListDataModel:NSObject,NSCoding{
    
    var distance:String = ""
    var time:String = ""
    
    init(_ distance:String, _ time:String) {
        self.distance = distance
        self.time = time
    }
    
    required init(coder decoder: NSCoder)
    {
        self.distance = decoder.decodeObject(forKey: "distance") as! String
        self.time = decoder.decodeObject(forKey: "time") as! String
    }
    func encode(with coder: NSCoder) {
        coder.encode(distance, forKey: "distance")
        coder.encode(time, forKey: "time")
    }
    
}
