//
//  MyDate.swift
//  Kuramin
//
//  Created by MD. Zahed on 15/03/2023.
//

import Foundation

struct MyDate {
    
    func getTime() -> String {
        let currentTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        return dateFormatter.string(from: currentTime)

    }
    
    
    func isEarlier(earlierTime: String, laterTime: String) -> Bool {
        
        if earlierTime.compare(laterTime) == .orderedAscending {
            return true
        }
        
        
        if earlierTime.compare(laterTime) == .orderedDescending {
            return false
        }

        return true
        
    }
}
