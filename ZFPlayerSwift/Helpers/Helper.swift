//
//  Helper.swift
//  ZFPlayerSwift
//
//  Created by Radwa Khaled on 12/24/19.
//

import Foundation

struct Helper {
    
    // Total folder of downloaded files
    let BASE = "ZFDownLoad"
    
    // Full file path
    let TARGET = "CacheList"
    
    // Temp folder name
    let TEMP = "Temp"
    
    // Cache home directory
    let CACHES_DIRECTORY = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
    
    // Path to the temporary folder
    func TEMP_FOLDER() -> String {
        return "\(String(describing: CACHES_DIRECTORY))/\(BASE)/\(TEMP)"
    }
    // Path to temporary files
    func TEMP_PATH(_ name: String) -> String {
        return "\(String(describing: ZFCommonHelper.createFolder(TEMP_FOLDER())))/\(name)"
    }
    // Download folder path
    func FILE_FOLDER () -> String {
        if let str = CACHES_DIRECTORY {
             return "\(str)/\(BASE)/\(TARGET)"
        }
       return ""
    }
    
    // Download file path
    func FILE_PATH(_ name: String) -> String {
        
        if let s =  ZFCommonHelper.createFolder(FILE_FOLDER()) {
             return  "\(s)/\(name)"
        }
        return  ""
       
    }

}
