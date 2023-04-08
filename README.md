# swiftui-GestureVelocity

In SwiftUI, a property-wrapper provides velocity in pt/s from gesture


## Instructions

```swift
@GestureVelocity private var velocity: CGVector
```

```swift
.gesture(
  DragGesture(...)
  ... some declarations
  .updatingVelocity($velocity)
```

## Example

![CleanShot 2023-04-08 at 16 32 28](https://user-images.githubusercontent.com/1888355/230709515-163918d7-5ef0-47b7-b394-77b18c0c3d54.gif)


```swift
struct Joystick: View {

  /**
   ???
   Use just State instead of GestureState to trigger animation on gesture ended.
   This approach is right?

   refs:
   https://stackoverflow.com/questions/72880712/animate-gesturestate-on-reset
   */
  @State private var position: CGSize = .zero

  @GestureVelocity private var velocity: CGVector

  var body: some View {
    stick
      .padding(10)
  }

  private var stick: some View {
    Circle()
      .fill(Color.blue)
      .frame(width: 100, height: 100)
      .offset(position)
      .gesture(
        DragGesture(
          minimumDistance: 0,
          coordinateSpace: .local
        )
        .onChanged({ value in
          withAnimation(.interactiveSpring()) {
            position = value.translation
          }
        })
        .onEnded({ value in

          let distance = CGSize(
            width: -position.width,
            height: -position.height
          )

          let mappedVelocity = CGVector(
            dx: velocity.dx / distance.width,
            dy: velocity.dy / distance.height
          )
          
          withAnimation(
            .interpolatingSpring(
              stiffness: 50,
              damping: 10,
              initialVelocity: mappedVelocity.dx
            )
          ) {
            position.width = 0
          }
          
          withAnimation(
            .interpolatingSpring(
              stiffness: 50,
              damping: 10,
              initialVelocity: mappedVelocity.dy
            )
          ) {
            position.height = 0
          }
        })
        .updatingVelocity($velocity)

      )

  }
}
```

## Example

![CleanShot 2023-04-08 at 16 30 53](https://user-images.githubusercontent.com/1888355/230709392-7b17fd9e-ee7b-4874-b523-c6677aa226bf.gif)


```swift
RoundedRectangle(cornerRadius: 16, style: .continuous)
  .fill(Color.blue)
  .frame(width: 100, height: 100)
  .modifier(VerticalDragModifier())
```


```swift
struct VerticalDragModifier: ViewModifier {
  
  /**
   ???
   Use just State instead of GestureState to trigger animation on gesture ended.
   This approach is right?
   
   refs:
   https://stackoverflow.com/questions/72880712/animate-gesturestate-on-reset
   */
  @State private var position: CGSize = .zero
  
  @GestureVelocity private var velocity: CGVector
  
  func body(content: Content) -> some View {
    content
      .offset(position)
      .gesture(
        DragGesture(
          minimumDistance: 0,
          coordinateSpace: .local
        )
        .onChanged({ value in
          withAnimation(.interactiveSpring()) {
            position.height = value.translation.height
          }
        })
        .onEnded({ value in
          
          let distance = CGSize(
            width: -position.width,
            height: -position.height
          )
          
          let mappedVelocity = CGVector(
            dx: velocity.dx / distance.width,
            dy: velocity.dy / distance.height
          )
          
          withAnimation(
            .interpolatingSpring(
              stiffness: 50,
              damping: 10,
              initialVelocity: mappedVelocity.dy
            )
          ) {
            position.width = 0
            position.height = 0
          }
        })
        .updatingVelocity($velocity)
        
      )
  }
  
}
```
