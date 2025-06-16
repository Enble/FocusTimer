import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var notificationManager: NotificationManager
    @State private var showingResetAlert = false
    @State private var showingAbout = false
    @State private var showingDeleteDataAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                // 알림 설정
                Section(header: Text("알림 설정")) {
                    Toggle(isOn: $settingsManager.enableNotifications) {
                        Label("알림 활성화", systemImage: "bell")
                    }
                    .onChange(of: settingsManager.enableNotifications) { enabled in
                        if enabled && !notificationManager.isAuthorized {
                            notificationManager.requestAuthorization()
                        }
                    }
                    
                    Toggle(isOn: $settingsManager.enableSound) {
                        Label("알림음", systemImage: "speaker.wave.2")
                    }
                    .disabled(!settingsManager.enableNotifications)
                }
                
                // 목표 설정
                Section(header: Text("목표 설정")) {
                    HStack {
                        Label("일일 목표", systemImage: "target")
                        Spacer()
                        Text("\(Int(settingsManager.dailyGoal))분")
                            .foregroundColor(.secondary)
                    }
                    Slider(
                        value: $settingsManager.dailyGoal,
                        in: 30...480,
                        step: 30
                    )
                    
                    HStack {
                        Label("주간 목표", systemImage: "calendar")
                        Spacer()
                        Text("\(Int(settingsManager.weeklyGoal))분")
                            .foregroundColor(.secondary)
                    }
                    Slider(
                        value: $settingsManager.weeklyGoal,
                        in: 120...2400,
                        step: 60
                    )
                }
                
                // 일반 설정
                Section(header: Text("일반")) {
                    Picker(selection: $settingsManager.selectedTheme) {
                        Text("시스템").tag("system")
                        Text("라이트").tag("light")
                        Text("다크").tag("dark")
                    } label: {
                        Label("테마 설정", systemImage: "moon.circle")
                    }
                    
                    Button(action: {
                        showingAbout = true
                    }) {
                        Label("뽀모도로 기법 안내", systemImage: "info.circle")
                    }
                    
                    Button(action: {
                        // 온보딩 다시 보기
                        UserDefaults.standard.set(false, forKey: "hasSeenOnboarding")
                    }) {
                        Label("온보딩 다시 보기", systemImage: "arrow.clockwise")
                    }
                }
                
                // 데이터 관리
                Section(header: Text("데이터")) {
                    #if DEBUG
                    Button(action: {
                        PersistenceManager.shared.generateSampleData()
                    }) {
                        Label("샘플 데이터 생성", systemImage: "wand.and.stars")
                    }
                    #endif
                    
                    Button(action: {
                        showingDeleteDataAlert = true
                    }) {
                        Label("모든 기록 삭제", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        showingResetAlert = true
                    }) {
                        Label("설정 초기화", systemImage: "arrow.counterclockwise")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("설정")
            .alert("설정 초기화", isPresented: $showingResetAlert) {
                Button("취소", role: .cancel) { }
                Button("초기화", role: .destructive) {
                    settingsManager.resetToDefaults()
                }
            } message: {
                Text("모든 설정을 기본값으로 되돌리시겠습니까?")
            }
            .alert("모든 기록 삭제", isPresented: $showingDeleteDataAlert) {
                Button("취소", role: .cancel) { }
                Button("삭제", role: .destructive) {
                    PersistenceManager.shared.deleteAllSessions()
                }
            } message: {
                Text("모든 세션 기록이 영구적으로 삭제됩니다. 이 작업은 되돌릴 수 없습니다.")
            }
            .sheet(isPresented: $showingAbout) {
                AboutPomodoroView()
            }
        }
    }
}

struct AboutPomodoroView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("뽀모도로 기법이란?")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("뽀모도로 기법은 1980년대 후반 프란체스코 시릴로가 개발한 시간 관리 방법입니다. '뽀모도로'는 이탈리아어로 토마토를 의미하며, 토마토 모양의 타이머에서 이름을 따왔습니다.")
                            .font(.body)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("기본 원칙")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Label("25분간 집중해서 작업", systemImage: "1.circle.fill")
                            Label("5분간 짧은 휴식", systemImage: "2.circle.fill")
                            Label("4회 반복 후 15-30분 긴 휴식", systemImage: "3.circle.fill")
                            Label("타이머가 울릴 때까지 한 가지 작업에만 집중", systemImage: "4.circle.fill")
                        }
                        .font(.subheadline)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("장점")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("집중력 향상: 짧은 시간 동안 완전히 몰입")
                            }
                            
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("번아웃 방지: 규칙적인 휴식으로 피로 감소")
                            }
                            
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("시간 추적: 작업에 필요한 시간 파악 가능")
                            }
                            
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("동기 부여: 완료된 뽀모도로로 성취감 증가")
                            }
                        }
                        .font(.subheadline)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("활용 팁")
                            .font(.headline)
                        
                        Text("• 작업 시작 전 목표를 명확히 설정하세요\n• 방해 요소를 미리 제거하세요\n• 타이머가 울리면 즉시 휴식을 취하세요\n• 본인에게 맞게 시간을 조정해도 좋습니다")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle("뽀모도로 기법")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        dismiss()
                    }
                }
            }
        }
    }
}
