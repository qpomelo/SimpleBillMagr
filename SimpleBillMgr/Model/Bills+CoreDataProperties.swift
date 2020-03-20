//
//  Bills+CoreDataProperties.swift
//  
//
//  Created by QPomelo on 2019/1/30.
//
//

import Foundation
import CoreData


extension Bills {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bills> {
        return NSFetchRequest<Bills>(entityName: "Bills")
    }

    @NSManaged public var billId: Int64

}
