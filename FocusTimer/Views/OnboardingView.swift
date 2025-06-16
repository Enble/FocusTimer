//
//  OnboardingView.swift
//  FocusTimer
//
//  Created by apple on 2025/06/16.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                // 첫 번째 페이지
                OnboardingPageView(
                    imageName: "timer",
                    title: "집중력을 높여보세요",
                    description: "포커스타이머는 뽀모도로 기법을 활용해\n당신의 생산성을 향상시킵니다",
                    color: .blue
                )
                .tag(0)
                
                // 두 번째 페이지
                OnboardingPageView(
                    imageName: "chart.bar.xaxis",
                    title: "진행 상황을 추적하세요",
                    description: "상세한 통계와 분석으로\n당신의 집중 패턴을 파악할 수 있습니다",
                    color: .green
                )
                .tag(1)
                
                // 세 번째 페이지
                VStack(spacing: 40) {
                    Spacer()
                    
                    Image(systemName: "bell.badge")
                        .font(.system(size: 80))
                        .foregroundColor(.orange)
                    
                    VStack(spacing: 16) {
                        Text("알림을 받아보세요")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("세션이 완료되면 알림을 통해\n다음 단계를 안내해드립니다")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            NotificationManager().requestAuthorization()
                            hasSeenOnboarding = true
                        }) {
                            Text("알림 허용하고 시작하기")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            hasSeenOnboarding = true
                        }) {
                            Text("나중에 설정하기")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                }
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            
            // 하단 버튼
            if currentPage < 2 {
                HStack {
                    Button(action: {
                        hasSeenOnboarding = true
                    }) {
                        Text("건너뛰기")
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            currentPage += 1
                        }
                    }) {
                        Text("다음")
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
        }
    }
}

struct OnboardingPageView: View {
    let imageName: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 80))
                .foregroundColor(color)
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}
