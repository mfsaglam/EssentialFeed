//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Fatih Sağlam on 17.01.2023.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://www.a-url.com")!
}

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}
