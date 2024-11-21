//
//  SportsViewModel.swift
//  Kaizen
//
//  Created by Filip Igrutinovic on 20.11.24..
//

import Foundation

protocol SportsViewModelProtocol {
    var numberOfSections: Int { get }
    func isCollapse(at index: Int) -> Bool
    func events(of sectionIndex: Int) -> [SectionEvent]
    func name(of sectionIndex: Int) -> String
    func collapse(of sectionIndex: Int)
    func favoritize(of id: String)
}

class SportsViewModel: SportsViewModelProtocol {
    
    private let networkService: NetworkService
    private var sections: [Section] = [] {
        didSet {
            self.updateSportsList?()
        }
    }
    
    private var errorMessage: String? {
        didSet {
            if let errorMessage = errorMessage {
                self.showError?(errorMessage)
            }
        }
    }
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    // Closures for binding
    var updateSportsList: (() -> Void)?
    var showError: ((String) -> Void)?
    
    var numberOfSections: Int {
        return sections.count
    }
    
    func isCollapse(at index: Int) -> Bool {
        return sections[index].isCollapsed
    }
    
    func events(of sectionIndex: Int) -> [SectionEvent] {
        return sections[sectionIndex].events
    }
    
    func name(of sectionIndex: Int) -> String {
        return sections[sectionIndex].name
    }
    
    func collapse(of sectionIndex: Int) {
        sections[sectionIndex].isCollapsed.toggle()
    }
    
    func favoritize(of id: String) {
        for sectionsIndex in 0..<sections.count {
            for eventIndex in 0..<sections[sectionsIndex].events.count {
                if sections[sectionsIndex].events[eventIndex].id == id {
                    sections[sectionsIndex].events[eventIndex].isFavourite.toggle()
                    
                    let sortedSection = sort(at: sections[sectionsIndex].events)
                    sections[sectionsIndex].events = sortedSection
                    return
                }
            }
        }
    }
    
    private func sort(at section: [SectionEvent]) -> [SectionEvent] {
        return section.sorted { (item1, item2) -> Bool in
            return item1.isFavourite && !item2.isFavourite
        }
    }
    
    func fetchSports() {
        networkService.fetchSports { [weak self] result in
            switch result {
            case .success(let sports):
                var sections: [Section] = []
                for sport in sports {
                    sections.append(Section(sport: sport, isCollapsed: false))
                }
                self?.sections = sections
                self?.errorMessage = nil
            case .failure(let error):
                self?.errorMessage = self?.mapErrorToMessage(error)
            }
        }
    }
    
    private func mapErrorToMessage(_ error: NetworkError) -> String {
        switch error {
        case .badURL:
            return "The URL is not valid."
        case .requestFailed:
            return "The network request failed."
        case .decodingError:
            return "Failed to decode the data."
        }
    }
}
