import SwiftUI

@propertyWrapper
public struct GestureVelocity: DynamicProperty {
  
  @State private var previous: DragGesture.Value?
  @State private var current: DragGesture.Value?
  
  func update(_ value: DragGesture.Value) {
    
    if current != nil {
      previous = current
    }
    
    current = value
    
  }
  
  func reset() {
    previous = nil
    current = nil
  }
  
  public init() {
    
  }
  
  public var projectedValue: GestureVelocity {
    return self
  }
  
  public var wrappedValue: CGVector {
    value
  }
  
  private var value: CGVector {
    
    guard
      let previous,
      let current
    else {
      return .zero
    }
    
    let timeDelta = current.time.timeIntervalSince(previous.time)
    
    let speedY = Double(
      current.translation.height - previous.translation.height
    ) / timeDelta
    
    let speedX = Double(
      current.translation.width - previous.translation.width
    ) / timeDelta
    
    return .init(dx: speedX, dy: speedY)
    
  }
  
}

extension Gesture where Value == DragGesture.Value {
  
  public func updatingVelocity(_ velocity: GestureVelocity) -> _EndedGesture<_ChangedGesture<Self>> {
    
    onChanged { value in
      velocity.update(value)
    }
    .onEnded { _ in
      velocity.reset()
    }
    
  }
  
}
