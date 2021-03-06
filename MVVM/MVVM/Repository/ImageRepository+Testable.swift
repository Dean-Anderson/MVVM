//
//  ImageRepository+Testable.swift
//  MVVM
//
//  Created by dean.anderson on 2020/08/10.
//  Copyright © 2020 Practice. All rights reserved.
//

import RxSwift

protocol ImageRepositoryMockProviding {
    var mock: ImagePack { get }
}

struct ImageSuccessRepository: ImageRepository, ImageRepositoryMockProviding {
    private let model: ImagePack = ImagePack.mock()
    var mock: ImagePack { return model }
    
    func images(query: String?) -> Observable<Swift.Result<[ImagePack], CustomError>> {
        return Observable.just(.success([model]))
    }
}

struct ImageFailureRepository: ImageRepository {
    func images(query: String?) -> Observable<Swift.Result<[ImagePack], CustomError>> {
        return Observable.just(.failure(CustomError.unknown))
    }
}

private extension ImagePack {
    static func mock() -> ImagePack {
        ImagePack(thumbnailLink: "http://google.com", link: "http://google.com")
    }
}

extension ImagePack: Equatable {
    static func == (lhs: ImagePack, rhs: ImagePack) -> Bool { lhs.link == rhs.link && lhs.thumbnailLink == rhs.thumbnailLink }
}
