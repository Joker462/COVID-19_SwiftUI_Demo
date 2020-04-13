//
//  CovidCountriesViewModel.swift
//  Covid19
//
//  Created by Hung Thai Minh on 3/30/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation
import Combine

final class CovidCountriesViewModel: ObservableObject {
    @Published private(set) var state = State.idle
       
    private var bag = Set<AnyCancellable>()
    private let provider = URLSessionProvider<CovidEndPoint>()
    private let input = PassthroughSubject<Event, Never>()
    
    init() {
        Publishers.system(initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                self.fetchCovidCountries(),
                self.userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }
    
    deinit {
        bag.removeAll()
    }
    
    func send(event: Event) {
        input.send(event)
    }
    
    func fetchCovidCountries() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state else {
                return Empty().eraseToAnyPublisher()
            }
            
            return self.provider.request(.allCountries(.cases), with: [CovidCountry].self)
                .map(Event.onCovidCountriesLoaded)
                .catch {Just(Event.onFailedToLoadCovidCountries($0))}
                .eraseToAnyPublisher()
        }
    }
    
    func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}

extension CovidCountriesViewModel {
    enum State {
        case idle, loading
        case loaded([CovidCountry])
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onCovidCountriesLoaded([CovidCountry])
        case onFailedToLoadCovidCountries(Error)
    }
    
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle:
            switch event {
            case .onAppear:
                return .loading
            default:
                return state
            }
        case .loading:
            switch event {
            case .onFailedToLoadCovidCountries(let error):
                return .error(error)
            case .onCovidCountriesLoaded(let covidCountries):
                return .loaded(covidCountries)
            default:
                return state
            }
        default:
            return state
        }
    }
}
