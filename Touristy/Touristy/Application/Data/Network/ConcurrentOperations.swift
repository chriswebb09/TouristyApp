import Foundation

class ConcurrentOperation: Operation {
    
    enum State: String {
        case isReady, isExecuting, isFinished
        var keyPath: String {
            return "is" + rawValue
        }
    }
    
    var state = State.isReady {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    override public var isReady: Bool {
        return super.isReady && state == .isReady
    }
    
    override public var isExecuting: Bool {
        return state == .isExecuting
    }
    
    override public var isFinished: Bool {
        return state == .isFinished
    }
    
    override public var isAsynchronous: Bool {
        return true
    }
    
    override public func start() {
        if isCancelled {
            state = .isFinished
            return
        }
        main()
        state = .isExecuting
    }
    
    override public func cancel() {
        state = .isFinished
    }
}
