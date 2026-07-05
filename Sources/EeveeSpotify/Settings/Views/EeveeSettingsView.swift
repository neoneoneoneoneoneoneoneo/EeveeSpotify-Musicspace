import SwiftUI
import UIKit

struct EeveeSettingsView: View {
    let navigationController: UINavigationController
    
    // ★テーマカラーを「Music space」の洗練されたSpotifyグリーン（#1db954）に！
    static let spotifyAccentColor = Color(hex: "#1db954")
    
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
        UIView.appearance().tintColor = UIColor(EeveeSettingsView.spotifyAccentColor)
    }

    var body: some View {
        List {
            EeveeSettingsVersionView()
                .listRowBackground(Color(hex: "#0b0c10")) // 漆黒背景
            
            if !hasShownCommonIssuesTip {
                CommonIssuesTipView(
                    onDismiss: {
                        hasShownCommonIssuesTip = true
                        UserDefaults.hasShownCommonIssuesTip = true
                    }
                )
                .listRowBackground(Color(hex: "#161b22")) // カード背景
            }
            
            // パッチ設定
            Button {
                pushSettingsController(
                    with: EeveePatchingSettingsView(),
                    title: "patching".localized
                )
            } label: {
                NavigationSectionView(
                    color: Color(hex: "#1db954"), // すべて統一感のあるグリーンへ
                    title: "patching".localized,
                    imageSystemName: "hammer.fill"
                )
            }
            .listRowBackground(Color(hex: "#161b22"))
            
            // 歌詞設定
            Button {
                pushSettingsController(
                    with: EeveeLyricsSettingsView(),
                    title: "lyrics".localized
                )
            } label: {
                NavigationSectionView(
                    color: Color(hex: "#1db954"),
                    title: "lyrics".localized,
                    imageSystemName: "quote.bubble.fill"
                )
            }
            .listRowBackground(Color(hex: "#161b22"))
            
            // カスタム設定
            Button {
                pushSettingsController(
                    with: EeveeUISettingsView(),
                    title: "customization".localized
                )
            } label: {
                NavigationSectionView(
                    color: Color(hex: "#1db954"),
                    title: "customization".localized,
                    imageSystemName: "paintpalette.fill"
                )
            }
            .listRowBackground(Color(hex: "#161b22"))
            
            // 実験機能
            Button {
                pushSettingsController(
                    with: EeveeExperimentsSettingsView(),
                    title: "experiments".localized
                )
            } label: {
                NavigationSectionView(
                    color: Color(hex: "#1db954"),
                    title: "experiments".localized,
                    imageSystemName: "sparkle"
                )
            }
            .listRowBackground(Color(hex: "#161b22"))
            
            // データリセット
            Section(footer: Text("reset_data_description".localized).foregroundColor(Color(hex: "#8f9499"))) {
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
                            .foregroundColor(.red) // 警告は赤で強調
                    }
                }
            }
            .listRowBackground(Color(hex: "#161b22"))
        }
        .listStyle(GroupedListStyle())
        .background(Color(hex: "#0b0c10")) // 全体背景を完全な漆黒に
        .scrollContentBackground(.hidden)
        
        .animation(.default, value: isClearingData)
        .animation(.default, value: hasShownCommonIssuesTip)
        
        .onAppear {
            WindowHelper.shared.overrideUserInterfaceStyle(.dark)
        }
    }
}
