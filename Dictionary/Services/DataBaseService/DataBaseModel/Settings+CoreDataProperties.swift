//
//  Settings+CoreDataProperties.swift
//  Dictionary
//
//  Created by Артур on 07/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//
//

import Foundation
import CoreData


extension Settings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings")
    }

    @NSManaged public var lastLanguageFromTranslate: String?
    @NSManaged public var lastLanguageToTranslate: String?
    @NSManaged public var id: String?

}
