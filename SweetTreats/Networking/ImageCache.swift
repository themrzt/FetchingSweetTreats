//
//  ImageCache.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 7/26/23.
//
// Inspired and adapted from Tunde Adegoroye's great video on this topic: https://www.youtube.com/watch?v=VZMNNaMjLyM

import Foundation

class ImageCache{
    typealias CacheType = NSCache<NSString, NSData>
    
    static let shared = ImageCache()
    
    private init(){}
    
    private lazy var cache: CacheType = {
       let cache = CacheType()
        //Establish a number of items limit. 300 here is arbitrary, but is higher than the current MealDB recipe count (relevant to the project).
        cache.countLimit = 300
        
        //Set total storage limit to about 50MB
        cache.totalCostLimit = 50 * 1024 * 1024
        
        return cache
    }()
    
    func object(for key: NSString) -> Data?{
        cache.object(forKey: key) as? Data
    }
    
    func set(object: NSData, for key: NSString){
        cache.setObject(object, forKey: key)
    }
}
