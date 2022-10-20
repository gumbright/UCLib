//
//  File.swift
//  
//
//  Created by Guy Umbright on 10/20/22.
//

import Foundation

//extension for case where func whatever() -> Result<Void,Error>
//allows to just do return .success for success case 
public extension Result where Success == Void {
    
    /// A success, storing a Success value.
    ///
    /// Instead of `.success(())`, now  `.success`
    static var success: Result {
        return .success(())
    }
}
