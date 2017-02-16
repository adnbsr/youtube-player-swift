import Foundation

public struct Observable<T> {
    typealias ValueType = T
    typealias SubscriptionType = Subscription<T>
    
    var value: ValueType {
        didSet {
            for subscription in subscriptions {
                let event = ValueChangeEvent(oldValue, value)
                subscription.notify(event: event)
            }
        }
    }
    
    fileprivate var subscriptions = Subscriptions<ValueType>()
    
    mutating func subscribe(handler: @escaping SubscriptionType.HandlerType) -> SubscriptionType {
        return subscriptions.add(handler: handler)
    }
    
    mutating func unsubscribe(subscription: SubscriptionType) {
        subscriptions.remove(subscription: subscription)
    }
    
    init(_ value: ValueType) {
        self.value = value
    }
}

struct ValueChangeEvent<T> {
    typealias ValueType = T
    
    let oldValue: ValueType
    let newValue: ValueType
    
    init(_ o: ValueType, _ n: ValueType) {
        oldValue = o
        newValue = n
    }
}

class Subscription<T> {
    typealias ValueType = T
    typealias HandlerType = (_ oldValue: ValueType, _ newValue: ValueType) -> ()
    
    let handler: HandlerType
    
    init(handler: @escaping HandlerType) {
        self.handler = handler
    }
    
    func notify(event: ValueChangeEvent<ValueType>) {
        self.handler(event.oldValue, event.newValue)
    }
}

struct Subscriptions<T>: Sequence {
    typealias ValueType = T
    typealias SubscriptionType = Subscription<T>
    
    private var subscriptions = Array<SubscriptionType>()
    
    mutating func add(handler: @escaping SubscriptionType.HandlerType) -> SubscriptionType {
        let subscription = Subscription(handler: handler)
        self.subscriptions.append(subscription)
        return subscription
    }
    
    mutating func remove(subscription: SubscriptionType) {
        var index = NSNotFound
        var i = 0
        for element in self.subscriptions as [SubscriptionType] {
            if element === subscription {
                index = i
                break
            }
            i += 1
        }
        
        if index != NSNotFound {
            self.subscriptions.remove(at: index)
        }
    }
    
    func makeIterator() ->  AnyIterator<Subscription<ValueType>> {
                var nextIndex = subscriptions.count-1
                return AnyIterator<Subscription<ValueType>> {
                    if (nextIndex < 0) {
                        return nil
                    }
                    
                    nextIndex -= 1
                    
                    return self.subscriptions[nextIndex]
                }
    }
    
    // MARK: SequenceType protocol
//    
//    func generate() -> AnyIterator<Subscription<ValueType>> {
//        var nextIndex = subscriptions.count-1
//        return anyGenerator<Subscription<ValueType>> {
//            if (nextIndex < 0) {
//                return nil
//            }
//            return self.subscriptions[nextIndex--]
//        }
//    }
}
