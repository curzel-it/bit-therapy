import Dialogs
import Schwifty
import SwiftUI

struct IntroDialog: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State var showIntro: Bool = !UserDefaults.standard.bool(forKey: kDidShowIntro)
    
    var body: some View {
        if showIntro {
            Dialog(
                contents: [
                    .text(text: viewModel.lang.intro),
                    .text(text: ""),
                    .text(text: viewModel.lang.desktopApp),
                    .text(text: ""),
                    .text(text: viewModel.lang.introComplete),
                    .action(title: viewModel.lang.close, action: {
                        withAnimation {
                            showIntro = false
                        }
                    })
                ]
            )
            .padding(.horizontal, .md)
            .padding(.bottom, .xxxl)
            .onAppear {
                UserDefaults.standard.set(true, forKey: kDidShowIntro)
            }
        }
    }
}

private let kDidShowIntro = "didShowIntro"
