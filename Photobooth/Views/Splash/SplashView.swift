//
//  SplashView.swift
//  Photobooth
//

import SwiftUI

struct SplashView: View {
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Image("catrainbow")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: Constants.splashImageSize, height: Constants.splashImageSize)
                    .clipShape(Circle())
                    .accessibilityIdentifier(Constants.splashImageIdentifier)
                
                Text(L10n.catsApp)
                    .font(.system(.title3))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding()
                    .accessibilityIdentifier(Constants.splashTitleIdentifier)
                
                Text(L10n.appName)
                    .foregroundColor(.primary)
                
                Text(L10n.homeAssesment)
                    .foregroundColor(.primary)
                    .accessibilityIdentifier(Constants.splashDescriptionIdentifier)
                
                NavigationLink(destination: HomeView()) {
                    
                    Text(L10n.tapMe)
                        .font(.system(.title3))
                        .fontWeight(.bold)
                        .padding(
                            EdgeInsets(
                                top: Constants.splashTopBottomPaddingButton,
                                leading: Constants.splashLeadingTrailingPaddingButton,
                                bottom: Constants.splashTopBottomPaddingButton,
                                trailing: Constants.splashLeadingTrailingPaddingButton
                            )
                        )
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(Constants.splashButtonCornerRadius)
                        .accessibilityIdentifier(Constants.splashButtonIdentifier)
                }
                .navigationBarTitle(Constants.empty)
                .navigationBarHidden(true)
            }
        }
    }
}
