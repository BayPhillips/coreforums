//
//  Image.swift
//  MediaContent
//
//  Created by Bay Phillips on 11/21/15.
//  Copyright © 2015 Bay Phillips. All rights reserved.
//

import Foundation
import CoreData
import Persistence

public class Image: ManagedObject {
    @NSManaged var imageName: String
    
    public static func insertIntoContext(moc: NSManagedObjectContext, imageName: String) -> Image {
        let image: Image = moc.insertObject()
        image.imageName = imageName
        return image
    }
}

extension Image: ManagedObjectType {
    public static var entityName: String {
        return "Image"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
}