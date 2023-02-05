//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Fatih Sağlam on 22.12.2022.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    ///The completion handler can be inovoked in any thread.
    ///Clients are responsible to dispatch to appropriate threads, if needed.
    func get(from: URL, completion: @escaping (Result) -> Void)
}
