//
//  NetworkRouter.swift
//  WeatherApp
//
//  Created by Bohdan Datskiv on 6/15/19.
//  Copyright © 2019 Дацьків Богдан. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

//----------------------------------------
// MARK: - NetworkRouter
//----------------------------------------
protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}
