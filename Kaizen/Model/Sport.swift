//
//  Sport.swift
//  Kaizen
//
//  Created by Filip Igrutinovic on 20.11.24..
//

import Foundation

struct Sport: Codable {
    let i: String // id
    let d: String // name
    let e: [Event] // events
}

struct Event: Codable {
    let i: String // id
    let si: String // sport id
    let d: String // name
    let tt: Int // time
}
