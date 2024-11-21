//
//  Section.swift
//  Kaizen
//
//  Created by Filip Igrutinovic on 21.11.24..
//

import Foundation

struct Section {
    let name: String
    var events: [SectionEvent]
    var isCollapsed: Bool
    
    init(sport: Sport, isCollapsed: Bool) {
        self.name = sport.d
        self.events = []
        for event in sport.e {
            let e = SectionEvent(event: event, isFavourite: false)
            self.events.append(e)
        }
        self.isCollapsed = isCollapsed
    }
}

struct SectionEvent {
    let id: String
    let sportId: String
    let name: String
    let time: Int
    var isFavourite: Bool
    
    init(event: Event, isFavourite: Bool) {
        self.id = event.i
        self.sportId = event.si
        self.name = event.d
        self.time = event.tt
        self.isFavourite = isFavourite
    }
}
