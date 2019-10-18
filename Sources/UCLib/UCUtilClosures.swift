//
//  UtilClosures.swift
//
//  Created by Guy Umbright on 7/9/19.
//  Copyright © 2019 Guy Umbright. All rights reserved.
//

import Foundation

public typealias VoidClosure = () -> Void
public typealias SingleParamVoidClosure<T> = (_ param:T) -> Void
public typealias SingleParamReturnClosure<T,R> = (_ param:T) -> R
