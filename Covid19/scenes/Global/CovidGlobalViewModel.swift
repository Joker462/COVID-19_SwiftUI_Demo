//
//  CovidGlobalViewModel.swift
//  Covid19
//
//  Created by Hung Thai Minh on 3/30/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation
import Combine

final class CovidGlobalViewModel: ObservableObject {
    @Published private(set) var state = State.idle
    
    private var bag = Set<AnyCancellable>()
    private let provider = URLSessionProvider<CovidEndPoint>()
    private let input = PassthroughSubject<Event, Never>()
    
    init() {
        Publishers.system(initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                self.fetchCovidGlobal(),
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
    
    func fetchCovidGlobal() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state else {
                return Empty().eraseToAnyPublisher()
            }
            
            return self.provider.request(.all, with: CovidGlobal.self)
                .map(Event.onCovidGlobalLoaded)
                .catch {Just(Event.onFailedToLoadCovidGlobal($0))}
                .eraseToAnyPublisher()
        }
    }
    
    func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}

extension CovidGlobalViewModel {
    
    enum State {
        case idle, loading
        case loaded(CovidGlobal)
        case error(Error)
    }

    enum Event {
        case onAppear
        case onCovidGlobalLoaded(CovidGlobal)
        case onFailedToLoadCovidGlobal(Error)
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
            case .onFailedToLoadCovidGlobal(let error):
                return .error(error)
            case .onCovidGlobalLoaded(let covidGlobal):
                return .loaded(covidGlobal)
            default:
                return state
            }
        case .loaded:
            return state
        case .error:
            return state
        }
    }
}
