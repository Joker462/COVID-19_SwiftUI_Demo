//
//  CovidNewsViewModel.swift
//  Covid19
//
//  Created by Hung Thai Minh on 4/4/20.
//  Copyright © 2020 Hung Thai Minh. All rights reserved.
//

import Foundation
import Combine

final class CovidNewsViewModel: ObservableObject {
    
    private let provider = URLSessionProvider<CovidEndPoint>()
    private var bag = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    @Published private(set) var state = State.idle
    
    init() {
        Publishers.system(initial: state,
                          reduce: Self.reduce,
                          scheduler: RunLoop.main,
                          feedbacks: [
                            self.loading(),
                            self.userInput(input: input.eraseToAnyPublisher())])
            .assign(to: \.state, on: self)
            .store(in: &bag)
    }
    
    deinit {
        bag.removeAll()
    }
    
    func send(event: Event) {
        input.send(event)
    }
}
 
extension CovidNewsViewModel {
    enum State {
        case idle
        case loading
        case loaded(News)
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onNewsLoaded(News)
        case onFailedToLoadNews(Error)
    }
    
    // MARK: - State Machine
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
            case .onNewsLoaded(let news):
                return .loaded(news)
            case .onFailedToLoadNews(let error):
                return .error(error)
            default:
                return state
            }
        default:
            return state
        }
    }
    
    func loading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            
            return self.provider.request(.news, with: News.self)
                .map(Event.onNewsLoaded)
                .catch{ Just(Event.onFailedToLoadNews($0))}
                .eraseToAnyPublisher()
        }
    }
    
    func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}
