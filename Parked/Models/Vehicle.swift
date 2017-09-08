//
//  Vehicle.swift
//  Parked
//
//  Created by Kevin Chen on 9/7/17.
//  Copyright © 2017 Kevin Chen. All rights reserved.
//

import Foundation
import CoreLocation

struct Vehicle
{
    var name: String = ""
    var users: [String]
    var location: CLLocation

    init(name: String, users: [String], location: CLLocation)
    {
        self.name = name
        self.users = users
        self.location = location
    }
}

