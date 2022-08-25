// 
// Pet Therapy.
// 

import DesktopKit
import Schwifty
import SwiftUI

struct RightClickMenu: View {
    
    @State var opacity: CGFloat = 0
    
    var body: some View {
        Image(systemName: "xmark")
            .font(.bold, .xl)
            .foregroundColor(.accent)
            .onTapGesture {
                OnScreen.hide()
                fadeOut()
            }
        .onAppear { fadeIn() }
        .opacity(opacity)
    }
    
    func fadeIn() {
        withAnimation {
            opacity = 1
        }
    }
    
    func fadeOut() {
        withAnimation(.easeInOut(duration: 0.1)) {
            opacity = 0
        }
    }
}

class ShowsMenuOnRightClick: RightClickable {
    
    weak var menu: NSView?
    
    override func onRightClick(with event: NSEvent) {
        guard isEnabled else { return }
        
        let menu = RightClickMenu().hosted()
        menu.translatesAutoresizingMaskIntoConstraints = false
        event.window?.contentView?.addSubview(menu)
        
        menu.constrain(.height, to: 100)
        menu.constrain(.width, to: 200)
        menu.constrainToCenterInParent()
        self.menu = menu
        
        DispatchQueue.main.asyncAfter(deadline: .now()+5) { [weak self] in
            self?.menu?.removeFromSuperview()
            self?.menu = nil
        }
    }
}
