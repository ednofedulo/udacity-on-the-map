//
//  SharedData.swift
//  udacity on the map
//
//  Created by Edno Fedulo on 21/05/18.
//  Copyright © 2018 Fedulo. All rights reserved.
//

import Foundation

class SharedData: NSObject {
    static let shared = SharedData()
    var studentsInformations = [StudentInformation]()
}
