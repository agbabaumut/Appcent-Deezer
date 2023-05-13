//
//  LikedSongs+CoreDataProperties.swift
//  Appcent-Deezer
//
//  Created by Umut Ağbaba on 13.05.2023.
//
//

import Foundation
import CoreData


extension LikedSongs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikedSongs> {
        return NSFetchRequest<LikedSongs>(entityName: "LikedSongs")
    }

    @NSManaged public var songName: String?
    @NSManaged public var songImage: Data?
    @NSManaged public var songDuration: String?

}

extension LikedSongs : Identifiable {

}
