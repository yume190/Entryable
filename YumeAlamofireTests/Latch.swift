import Foundation

/**
 *  Simple countdown latch synchronization utility
 *  Commonly used to keep track of completion of background tasks
 */
struct CountdownLatch {
    
    /// Use dispatch group primitive
    let group:DispatchGroup
    
    /**
     Create new instance
     
     - returns: new CountdownLatch
     */
    init() {
        group = DispatchGroup()
    }
    
    /**
     Indicate that an item has started that we need to wait on
     */
    func enter() {
        group.enter()
    }
    
    /**
     Indicate that an item we are waiting on has finished
     */
    func leave() {
        group.leave()
    }
    
    /**
     Block current thread until all items are complete, may block forever
     */
    func wait() {
        group.wait()
    }
    
    /**
     Block current thread until all items are complete or timeout occurs
     
     - parameter secondTimeout: seconds to wait before timing out
     
     - returns: true if all items complete, false if timeout occurred
     */
    func wait(interval: DispatchTimeInterval) -> Bool {
        let result:DispatchTimeoutResult = group.wait(timeout: DispatchTime.now() + interval)
        if case DispatchTimeoutResult.success = result {
            return true
        } else {
            return false
        }
    }
}


