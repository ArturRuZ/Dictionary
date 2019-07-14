//
//  DictionaryHistory+CoreDataProperties.swift
//  Dictionary
//
//  Created by Артур on 13/07/2019.
//  Copyright © 2019 Артур. All rights reserved.
//
//

import Foundation
import CoreData

extension DictionaryHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DictionaryHistory> {
        return NSFetchRequest<DictionaryHistory>(entityName: "DictionaryHistory")
    }

    @NSManaged public var textForTranslate: String?
    @NSManaged public var time: NSDate?
    @NSManaged public var translatedText: String?

}
