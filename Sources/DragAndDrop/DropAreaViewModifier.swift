
import SwiftUI

struct DropAreaOverlay<T: DropReceivableObservableObject>: ViewModifier {
    @EnvironmentObject var model: T
    let dropReceiver: T.DropReceivable
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    Color.clear
                    #if os(iOS)
                        .onRotate { _ in
                            model.setDropArea(geo.frame(in: .global), on: dropReceiver)
                        }
                    #else
                        .onAppear {
                            model.setDropArea(geo.frame(in: .global), on: dropReceiver)
                        }
                    #endif
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
