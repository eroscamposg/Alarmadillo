//
//  Helper.swift
//  Alarmadillo
//
//  Created by Eros Campos on 8/5/20.
//  Copyright © 2020 Eros Campos. All rights reserved.
//

import Foundation

struct Helper {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        let documentsDirectory = paths[0]
        
        return documentsDirectory
    }
    
    
}
