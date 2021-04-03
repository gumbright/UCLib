//
//  UCStateMachine.swift
//  Stoppage
//
//  Created by Guy Umbright on 10/5/20.
//  Copyright © 2020 Umbright Consulting, Inc. All rights reserved.
//


import Foundation

public class UCState<T:Hashable> {
    
    public typealias EnterBlock = () -> Void
    public typealias WillExitBlock = (_ nextStateTag:T) -> Void

    var tag : T!

    public var enterBlock : EnterBlock?
    public var exitBlock : WillExitBlock?
    public var validNextStateTags : [T] = []
    
    var stateName : String
    {
        get {
            return String(describing: type(of: self))
        }
    }
        
    public init(_ stateTag:T, validNextStateTags:[T] = [], didEnterBlock:EnterBlock?=nil,willExitBlock:WillExitBlock?=nil)
    {
        tag = stateTag
        self.validNextStateTags = validNextStateTags
        self.enterBlock = didEnterBlock
        self.exitBlock = willExitBlock
    }
}

public class UCStateMachine<T:Hashable> {
    
    public typealias InvalidTransitionBlock = (_ currentTag:T, _ currentState:UCState<T>, _ newTag:T) -> Void

    private(set) var currentState: UCState<T>?
    public private(set) var currentStateTag : T?
    
    private var stateMap : [T:UCState<T>] = [:]
    private var nextMap : [T : [T]] = [:]
    
    public var verbose = false;
    
    public var invalidTransitionBlock : InvalidTransitionBlock?
    public var invalidTransitionIsFatal = true
    
    public init()
    {
        //statesMap = []
    }
    
    public init(states: [UCState<T>]) {
        addNewStates(states)
    }

    public func addState(_ state:UCState<T>)
    {
        stateMap[state.tag] = state
        nextMap[state.tag] = state.validNextStateTags
    }
    
    public func addStates(_ states:[UCState<T>])
    {
        addNewStates(states)
    }

    func addNewStates(_ states:[UCState<T>])
    {
        for s in states
        {
            stateMap[s.tag] = s
            nextMap[s.tag] = s.validNextStateTags
        }
    }
    
    public func enter(_ nextStateTag : T) -> Bool
    {
        if !stateMap.keys.contains(nextStateTag)
        {
            return false;
        }
        guard let nextState = stateMap[nextStateTag] else {return false}
        
        if (verbose)
        {
            print("---->>> attempting transition from \(currentState?.stateName ?? "no state") to \(nextState)")
        }
        
        if currentState == nil
        {
            currentState = nextState
            currentStateTag = nextStateTag
            return true
        }
        else if !checkIfNextStateIsValid(nextStateTag: nextStateTag)
        {
            if let block = invalidTransitionBlock
            {
                block(currentStateTag!, currentState!, nextStateTag)
            }
            
            if (invalidTransitionIsFatal)
            {
                fatalError("invalid transition from \(currentStateTag ?? "no state") to \(nextStateTag)")
            }
            return false
        }
        
        if let exBlk = currentState?.exitBlock
        {
            exBlk(currentStateTag!)
        }
        
        currentState = nextState
        currentStateTag = nextStateTag

        if let enterBlk = currentState?.enterBlock
        {
            enterBlk()
        }
        return true
    }
    
    func checkIfNextStateIsValid(nextStateTag : T) -> Bool
    {
        var result = false;
        
        guard let currTag = currentStateTag else {return true}
        
        if let validNextTags = nextMap[currTag]
        {
            if validNextTags.contains(nextStateTag)
            {
                result = true
            }
        }
        return result;
    }
}
