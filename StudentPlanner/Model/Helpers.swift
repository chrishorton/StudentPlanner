//
//  Helpers.swift
//  StudentPlanner
//
//  Created by Christopher Horton on 1/8/18.
//  Copyright © 2018 Christopher Horton. All rights reserved.
//

import Foundation
import TKSubmitTransition

struct Helpers {
    let btn: TKTransitionSubmitButton!
    
    func didStartYourLoading(){
        btn?.startLoadingAnimation()
    }
    

}
