//
//  ImageReactor.swift
//  MVVM
//
//  Created by dean.anderson on 2020/02/20.
//  Copyright © 2020 Practice. All rights reserved.
//

import ReactorKit
import RxSwift

final class ImageReactor: Reactor {
    enum Action {
        case search(String?)
    }
    
    enum Mutation {
        case images([ImageCellCreatable])
        case error(CustomError)
    }
    
    struct State {
        var images: [ImageCellCreatable] = []
        var error: CustomError?
    }
    
    var initialState: State = State()
    
    private let useCase: ImageSearchUseCase
    
    init(useCase: ImageSearchUseCase) {
        self.useCase = useCase
    }
}

extension ImageReactor {
    func mutate(action: ImageReactor.Action) -> Observable<ImageReactor.Mutation> {
        switch action {
        case .search(let keyword):
            let result = useCase.search(text: keyword).share()
            let success = result.compactMap{ $0.success }.map{ Mutation.images($0) }
            let failure = result.compactMap{ $0.failure }.map{ Mutation.error($0) }
            return Observable.merge(success, failure)
        }
    }
    
    func reduce(state: ImageReactor.State, mutation: ImageReactor.Mutation) -> ImageReactor.State {
        var state = state
        
        switch mutation {
        case .images(let images):
            state.images = images
        case .error(let error):
            state.error = error
        }
        
        return state
    }
}
