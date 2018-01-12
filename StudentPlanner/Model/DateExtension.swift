//
//  DateExtension.swift
//  StudentPlanner
//
//  Created by Christopher Horton on 1/12/18.
//  Copyright © 2018 Christopher Horton. All rights reserved.
//

import Foundation

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let myString = formatter.string(from: self)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = format
        
        return formatter.string(from: yourDate!)
    }
    
}
