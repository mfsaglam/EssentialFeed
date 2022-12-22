//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Fatih Sağlam on 22.12.2022.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from: URL, completion: @escaping (HTTPClientResult) -> Void)
}
