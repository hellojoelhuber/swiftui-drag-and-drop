
import SwiftUI

struct DropAreaOverlay<T: DropReceivableObservableObject>: ViewModifier {
    @EnvironmentObject var model: T
    let dropReceiver: T.DropReceivable
    
    public func body(content: Content) -> some View {
        content
            .overlay(
/*
 https://fatbobman.com/en/posts/geometryreader-blessing-or-curse/
 This may be an alternative fix to the onRotate task patch. Here, fatbobman says that instead of
 
 .onAppear {
     width = proxy.size.width
 }
 
 use this
 
 .task(id: proxy.size.width) {
     width = proxy.size.width
 }
 
 "In this way, even if the data changes, we can keep updating the data. Some developers have reported that they are unable to retrieve new information when the screen orientation changes. This is why. task(id:) covers both onAppear and onChange scenarios and is the most reliable way to get data."
 
 Also look into onGeometryChange as another alternative.
 */
                GeometryReader { geo in
                if #available(macOS 12.0, *) {
                    Color.clear
                        .task(id: geo.size.width) {
                            model.setDropArea(geo.frame(in: .global), on: dropReceiver)
                            print(geo.frame(in: .global))
                        }
                } else {
                    Color.clear
                        .onAppear {
                            model.setDropArea(geo.frame(in: .global), on: dropReceiver)
                        }
                        #if os(iOS)
                        .onRotate { _ in
                            model.setDropArea(geo.frame(in: .global), on: dropReceiver)
                        }
                        #endif
                }
                }
            )
    }
}

extension View {
    public func dropReceiver<T: DropReceivableObservableObject>(for dropReceiver: T.DropReceivable, model: T) -> some View {
        modifier(DropAreaOverlay<T>(dropReceiver: dropReceiver))
            .environmentObject(model)
    }
}
