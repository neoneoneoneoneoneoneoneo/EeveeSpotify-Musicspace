import SwiftUI
import UIKit

struct EeveeSettingsView: View {
    let navigationController: UINavigationController
    
    // ★テーマカラー（#1db954）を確実なRGB指定に！
    static let spotifyAccentColor = Color(red: 29/255, green: 185/255, blue: 84/255)
    
    @State private var hasShownCommonIssuesTip = UserDefaults.hasShownCommonIssuesTip
    @State private var isClearingData = false
    
    private func pushSettingsController(with view: any View, title: String) {
        let viewController = EeveeSettingsViewController(
            navigationController.view.frame,
            settingsView: AnyView(view),
            navigationTitle: title
        )
        navigationController.pushViewController(viewController, animated: true)
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        UIView.appearance().tintColor = UIColor(red: 29/255, green: 185/255, blue: 84/255, alpha: 1.0)
    }

    var body: some View {
        List {
            EeveeSettingsVersionView()
                .listRowBackground(Color(red: 11/255, green: 12/255, blue: 16/255)) // #0b0c10
            
            if !hasShownCommonIssuesTip {
                CommonIssuesTipView(
                    onDismiss: {
                        hasShownCommonIssuesTip = true
                        UserDefaults.hasShownCommonIssuesTip = true
                    }
                )
                .listRowBackground(Color(red: 22/255, green: 27/255, blue: 34/255)) // #161b22
            }
            
            // パッチ設定
            Button {
                pushSettingsController(
                    with: EeveePatchingSettingsView(),
                    title: "patching".localized
                )
            } label: {
                NavigationSectionView(
                    color: Color(red: 29/255, green: 185/255, blue: 84/255),
                    title: "patching".localized,
                    imageSystemName: "hammer.fill"
                )
            }
            .listRowBackground(Color(red: 22/255, green: 27/255, blue: 34/255))
            
            // 歌詞設定
            Button {
                pushSettingsController(
                    with: EeveeLyricsSettingsView(),
                    title: "lyrics".localized
                )
            } label: {
                NavigationSectionView(
                    color: Color(red: 29/255, green: 185/255, blue: 84/255),
                    title: "lyrics".localized,
                    imageSystemName: "quote.bubble.fill"
                )
            }
            .listRowBackground(Color(red: 22/255, green: 27/255, blue: 34/255))
            
            // カスタム設定
            Button {
                pushSettingsController(
                    with: EeveeUISettingsView(),
                    title: "customization".localized
                )
            } label: {
                NavigationSectionView(
                    color: Color(red: 29/255, green: 185/255, blue: 84/255),
                    title: "customization".localized,
                    imageSystemName: "paintpalette.fill"
                )
            }
            .listRowBackground(Color(red: 22/255, green: 27/255, blue: 34/255))
            
            // 実験機能
            Button {
                pushSettingsController(
                    with: EeveeExperimentsSettingsView(),
                    title: "experiments".localized
                )
            } label: {
                NavigationSectionView(
                    color: Color(red: 29/255, green: 185/255, blue: 84/255),
                    title: "experiments".localized,
                    imageSystemName: "sparkle"
                )
            }
            .listRowBackground(Color(red: 22/255, green: 27/255, blue: 34/255))
            
            // データリセット
            Section(footer: Text("reset_data_description".localized).foregroundColor(Color(red: 143/255, green: 148/255, blue: 153/255))) { // #8f9499
                Button {
                    isClearingData = true
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        OfflineHelper.resetData(clearCaches: true)
                        
                        DispatchQueue.main.async {
                            exitApplication()
                        }
                    }
                } label: {
                    if isClearingData {
                        ProgressView()
                    }
                    else {
                        Text("reset_data".localized)
                            .foregroundColor(.red)
                    }
                }
            }
            .listRowBackground(Color(red: 22/255, green: 27/255, blue: 34/255))
        }
        .listStyle(GroupedListStyle())
        .background(Color(red: 11/255, green: 12/255, blue: 16/255)) // #0b0c10
        //.scrollContentBackground(.hidden)
        
        .animation(.default, value: isClearingData)
        .animation(.default, value: hasShownCommonIssuesTip)
        
        .onAppear {
            WindowHelper.shared.overrideUserInterfaceStyle(.dark)
        }
    }
}
