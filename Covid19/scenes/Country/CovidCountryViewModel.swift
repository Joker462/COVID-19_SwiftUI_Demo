//
//  CovidCountryViewModel.swift
//  Covid19
//
//  Created by Hung Thai Minh on 4/2/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation
import Combine

final class CovidCountryViewModel: ObservableObject {
    
    private let provider = URLSessionProvider<CovidEndPoint>()
    @Published private(set) var state: State
    private var bag = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    @Published var isLoading: Bool = true
    @Published var cases = [CaseConfirmed]()
    private var recovered = [String: Int]()
    private var deaths = [String: Int]()
    private let covidCountry: CovidCountry
    
    init(_ covidCountry: CovidCountry) {
        state = .idle(covidCountry.country)
        self.covidCountry = covidCountry
        
        Publishers.system(initial: state,
                          reduce: Self.reduce,
                          scheduler: RunLoop.main,
                          feedbacks: [
                            self.fetchCountryHistoricalData(),
                            self.userInput(input: input.eraseToAnyPublisher())
                        ])
            .assign(to: \.state, on: self)
            .store(in: &bag)
    }
    
    deinit {
        bag.removeAll()
    }
    
    func send(event: Event) {
        input.send(event)
    }
    
    
    func fetchCountryHistoricalData() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading(let countryName) = state else {
                return Empty().eraseToAnyPublisher()
            }
            
            return self.provider.request(.historicalDataOfCountry(countryName: countryName))
                .map(self.localDataCreate)
                .map(Event.onLoaded)
                .catch{ Just(Event.onFailedToLoad($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
    
    func localDataCreate(_ data: Data) -> [CaseConfirmed] {
        guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            return []
        }
        let timeLine = jsonData["timeline"] as? [String: Any] ?? [:]
        recovered = timeLine[TimelineType.recovered.rawValue] as? [String: Int] ?? [:]
        recovered[self.covidCountry.getDate(dateFormat: "MM/dd/yy")] = self.covidCountry.recovered
        deaths = timeLine[TimelineType.deaths.rawValue] as? [String: Int] ?? [:]
        deaths[self.covidCountry.getDate(dateFormat: "MM/dd/yy")] = self.covidCountry.deaths
        return casesSorted(timeLine)
    }
    
//    func fetchCountryHistoricalData() {
//        provider.request(.historicalDataOfCountry(countryName: covidCountry.country)) { (response) in
//            DispatchQueue.main.async { self.isLoading = false }
//            switch response {
//            case let .success(data):
//                let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
//                let timeLine = jsonData?["timeline"] as? [String: Any] ?? [:]
//                self.recovered = timeLine[TimelineType.recovered.rawValue] as? [String: Int] ?? [:]
//                self.recovered[self.covidCountry.getDate(dateFormat: "MM/dd/yy")] = self.covidCountry.recovered
//                self.deaths = timeLine[TimelineType.deaths.rawValue] as? [String: Int] ?? [:]
//                self.deaths[self.covidCountry.getDate(dateFormat: "MM/dd/yy")] = self.covidCountry.deaths
//                DispatchQueue.main.async {
//                    self.cases = self.casesSorted(timeLine)
//                }
//                break
//            case let .failure(error):
//                print(error)
//                break
//            }
//        }
//    }
    
    func findValue(from key: String, timelineType: TimelineType) -> Int {
        switch timelineType {
        case .recovered:
            return recovered[key] ?? 0
        case .deaths:
            return deaths[key] ?? 0
        default:
            return 0
        }
    }
    
    private func casesSorted(_ timeLine: [String: Any]) -> [CaseConfirmed] {
        guard let dictionary = timeLine[TimelineType.cases.rawValue] as? [String: Int] else { return [] }
        var casesConfirmed = dictionary.compactMap { CaseConfirmed(daily: $0.key, value: $0.value) }
        casesConfirmed.insert(CaseConfirmed(daily: covidCountry.getDate(dateFormat: "MM/dd/yy"), value: covidCountry[.cases]), at: 0)
        return casesConfirmed.sorted(by: { self.convertStringToDate($0.daily).compare(self.convertStringToDate($1.daily)) == .orderedDescending})
    }
    
    private func convertStringToDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        return dateFormatter.date(from: dateString) ?? Date()
    }
}

extension CovidCountryViewModel {
    enum State {
        case idle(String)
        case loading(String)
        case loaded([CaseConfirmed])
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onLoaded([CaseConfirmed])
        case onFailedToLoad(Error)
    }
    
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle(let countryName):
            switch event {
            case .onAppear:
                return .loading(countryName)
            default:
                return state
            }
        case .loading:
            switch event {
            case .onFailedToLoad(let error):
                return .error(error)
            case .onLoaded(let timeline):
                return .loaded(timeline)
            default:
                return state
            }
        default:
            return state
        }
    }
}

enum TimelineType: String {
    case cases      = "cases"
    case deaths     = "deaths"
    case recovered  = "recovered"
}

struct CaseConfirmed: Identifiable {
    let id = UUID()
    let daily: String
    let value: Int
}
