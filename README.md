#  SwiftUI Drag-and-Drop

Drag-and-drop is an intuitive gesture and can improve the UX of an app. 

| Chess | Emoji Art | Card Game | To Do List |
| :---: | :---: | :---: | :---: |
| ![Chess Drag-And-Drop Demo](/assets/media/documentation-dragdrop-chess-demo.gif) | ![Emoji Art Drag-And-Drop Demo](/assets/media/documentation-dragdrop-emoji-art-vertical-demo.gif) | ![Card Game Drag-And-Drop Demo](/assets/media/documentation-dragdrop-card-game-demo.gif) | ![To Do List Drag-And-Drop Demo](/assets/media/documentation-dragdrop-todo-demo.gif) |
| [Documentation](https://www.joelhuber.com/documentation/documentation-chess-drag-and-drop/) | [Documentation](https://www.joelhuber.com/documentation/documentation-emoji-art/) | [Documentation](https://www.joelhuber.com/documentation/documentation-drag-and-drop-card-game/) | [Documentation](https://www.joelhuber.com/documentation/documentation-todo-list/) |


## Purpose of this library. 

This library supports drag-and-drop in SwiftUI code. This is a replacement for the native `onDrag` / `onDrop` and their limitations. 

## Which Use Cases Does This Library Fit?

This library is a good fit if your use case falls into one or more of the following:
* If you need or want to support drag-and-drop below iOS 16 (namely, iOS 13 or higher).
* If you are drag-and-dropping non-NSObjects.
* If you are not drag-and-dropping between apps (e.g., dragging URL from Safari to your app on an iPad).
* If you are not (for whatever reason) enchanted with Apple's implementation.
* If you like the way this library organizes drop logic on the draggable object rather than the drop-receiving object. 

## Getting Started. 

The following steps will get your project compiling with a basic implementation of the library. 


1. Choose a type to conform to `DropReceiver` and conform the struct to it:
```swift
protocol DropReceiver {
    var dropArea: CGRect? { get set }
}
```

For example:
```swift
struct MyDropReceiver: DropReceiver {
    var dropArea: CGRect? = nil
}
```


2. Conform your ViewModel to `DropReceivableObservableObject` & Add a variable in the ViewModel referencing the `DropReceiver` struct.
```swift
protocol DropReceivableObservableObject: ObservableObject {
    associatedtype DropReceivable: DropReceiver
    
    func setDropArea(_ dropArea: CGRect, on dropReceiver: DropReceivable)
}
```

For example:
```swift
class DragAndDropViewModel: DropReceivableObservableObject {
    typealias DropReceivable = MyDropReceiver
    
    var dropReceiver = MyDropReceiver()
        
    func setDropArea(_ dropArea: CGRect, on dropReceiver: DropReceivable) {
        dropReceiver.updateDropArea(with: dropArea)
    }
}
```

3. Add the ViewModifier `.dropArea(for:model:)` to an element in your View which represents the `DropReceiver` struct. The `for:` should be an element of the type of the `DropReceiver` struct and the `model:` should be a reference to the `DropReceivableObservableObject` ViewModel.

For example:
```swift
struct MyDragAndDropView: View {
    @State var model = DragAndDropViewModel()
    
    var body: some View {
        VStack {
            Rectangle()
                .dropReceiver(for: model.dropReceiver, model: model)
        }
    }
}
```

4. Add the ViewModifier `.dragable()` to any other element in the View. The code can now run and the View is draggable. It will show a blue shadow while dragging.

For example:
```swift
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: 150, height: 150)
                .dropReceiver(for: model.dropReceiver, model: model)
                
            Spacer()
            
            Circle()
                .frame(width: 50, height: 50)
                .dragable()
        }
        .padding()
    }
```

5. To see the dragged object and drop receiver interact, add these two function definitions to the View and assign them to `.dragable(onDragged:onDropped:)`, respectively.
```swift
    func onDragged(position: CGPoint) -> DragState {
        if model.dropReceiver.getDropArea()!.contains(position) {
            return .accepted
        } else {
            return .rejected
        }
    }
    
    func onDropped(position: CGPoint) -> Bool {
        model.dropReceiver.getDropArea()!.contains(position)
    }
```

This code will allow a user to drag the object marked `dragable` and the shadow will now be green if the drop receiver is below the drag gesture or red if it is not.

#  In-Depth Examples of Implementation. 

These examples are intended to showcase various implementations of drag-and-drop and are not intended to be full apps. Since drag-and-drop is a means of signaling user intent, these examples show various ways to capture that intent. 

**Emoji Art.**

[View the code.](https://github.com/hellojoelhuber/drag-and-drop-emoji-art) | [Read the Documentation.](https://www.joelhuber.com/documentation/documentation-emoji-art/)

This example shows a single drop receiver (the canvas) and multiple drag-and-drop objects (the emoji on the palette & the emoji on the canvas). 

**To Do App.**

[View the code.](https://github.com/hellojoelhuber/drag-and-drop-todo-list) | [Read the Documentation.](https://www.joelhuber.com/documentation/documentation-todo-list/)

A todo list where each list object can be dragged on top of a "Complete" box or a "Trash" box. The "Add New" button is draggable on top of the list to add a new object.

**Chess Board.**

[View the code.](https://github.com/hellojoelhuber/drag-and-drop-chess) | [Read the Documentation.](https://www.joelhuber.com/documentation/documentation-chess-drag-and-drop/)

This example shows how to implement drag-and-drop chess pieces on the chess board. The only movement rules are basic directional rules. The movement rules do not enforce check, checkmate, turn order, or board-wrapping (that is, a bishop on a3 can move to h3 [as described here](https://www.joelhuber.com/posts/2022-05-16-modeling-the-chess-board)). 

**Card Game.**

[View the code.](https://github.com/hellojoelhuber/drag-and-drop-card-game) | [Read the Documentation.](https://www.joelhuber.com/documentation/documentation-drag-and-drop-card-game/)

In this game, players can play a card in one of three playable areas: here, there, or yonder. Each card can be played in 1 or more of these areas. 

**Working with Non-Rectangular Drop Areas.**

[Read the tutorial.](https://www.joelhuber.com/posts/2022-07-18-drag-and-drop-with-irregular-shapes)

This tutorial covers working with non-rectangular drop areas on a map or in a non-rectangular grid.
