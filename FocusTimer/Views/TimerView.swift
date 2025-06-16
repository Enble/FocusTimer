import SwiftUI

struct TimerView: View {
    @StateObject private var viewModel = TimerViewModel()
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var showingTaskInput = false
    @State private var showingTimeEditor = false
    @State private var tempFocusMinutes = ""
    @State private var tempBreakMinutes = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    // 세션 타입 및 시간 설정
                    VStack(spacing: 12) {
                        Text(viewModel.isWorkSession ? "집중 시간" : "휴식 시간")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(viewModel.isWorkSession ? .blue : .green)
                        
                        // 시간 설정 버튼
                        if viewModel.timerState == .idle {
                            Button(action: {
                                tempFocusMinutes = String(Int(settingsManager.focusDuration))
                                tempBreakMinutes = String(Int(settingsManager.breakDuration))
                                showingTimeEditor = true
                            }) {
                                HStack {
                                    Image(systemName: "clock")
                                        .font(.caption)
                                    Text("\(Int(viewModel.isWorkSession ? settingsManager.focusDuration : settingsManager.breakDuration))분")
                                        .font(.subheadline)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .foregroundColor(.primary)
                            }
                        }
                    }
                    
                    // 타이머 디스플레이
                    ZStack {
                        // 배경 원
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                            .frame(width: 250, height: 250)
                        
                        // 진행 원
                        Circle()
                            .trim(from: 0, to: viewModel.progress)
                            .stroke(
                                viewModel.isWorkSession ? Color.blue : Color.green,
                                style: StrokeStyle(lineWidth: 20, lineCap: .round)
                            )
                            .frame(width: 250, height: 250)
                            .rotationEffect(Angle(degrees: -90))
                            .animation(.linear(duration: 0.5), value: viewModel.progress)
                        
                        // 시간 표시
                        VStack {
                            Text(viewModel.timeString)
                                .font(.system(size: 60, weight: .light, design: .rounded))
                                .monospacedDigit()
                            
                            if !viewModel.currentTaskTitle.isEmpty {
                                Text(viewModel.currentTaskTitle)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                        }
                    }
                    
                    // 컨트롤 버튼
                    HStack(spacing: 30) {
                        // 리셋 버튼
                        Button(action: {
                            viewModel.reset()
                        }) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.title2)
                                .foregroundColor(.secondary)
                                .frame(width: 60, height: 60)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(Circle())
                        }
                        .disabled(viewModel.timerState == .idle)
                        
                        // 시작/일시정지 버튼
                        Button(action: {
                            if viewModel.timerState == .idle {
                                if viewModel.isWorkSession {
                                    showingTaskInput = true
                                } else {
                                    viewModel.start()
                                }
                            } else if viewModel.timerState == .running {
                                viewModel.pause()
                            } else {
                                viewModel.resume()
                            }
                        }) {
                            Image(systemName: viewModel.timerState == .running ? "pause.fill" : "play.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 80, height: 80)
                                .background(viewModel.isWorkSession ? Color.blue : Color.green)
                                .clipShape(Circle())
                        }
                        
                        // 스킵 버튼
                        Button(action: {
                            viewModel.skipSession()
                        }) {
                            Image(systemName: "forward.end")
                                .font(.title2)
                                .foregroundColor(.secondary)
                                .frame(width: 60, height: 60)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(Circle())
                        }
                        .disabled(viewModel.timerState == .idle)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("포커스타이머")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingTaskInput) {
                TaskInputView(taskTitle: $viewModel.currentTaskTitle) {
                    viewModel.start()
                }
            }
            .sheet(isPresented: $showingTimeEditor) {
                TimeEditorView(
                    focusMinutes: $tempFocusMinutes,
                    breakMinutes: $tempBreakMinutes,
                    onSave: {
                        if let focus = Int(tempFocusMinutes),
                           let breakTime = Int(tempBreakMinutes),
                           focus >= 1 && focus <= 60,
                           breakTime >= 1 && breakTime <= 30 {
                            settingsManager.focusDuration = Double(focus)
                            settingsManager.breakDuration = Double(breakTime)
                            viewModel.updateTimerDuration()
                        }
                    }
                )
            }
            .onChange(of: settingsManager.focusDuration) { _ in
                viewModel.updateTimerDuration()
            }
            .onChange(of: settingsManager.breakDuration) { _ in
                viewModel.updateTimerDuration()
            }
        }
    }
}

struct TaskInputView: View {
    @Binding var taskTitle: String
    let onStart: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("무엇을 하시나요?")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                TextField("작업 제목 (선택사항)", text: $taskTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: {
                    onStart()
                    dismiss()
                }) {
                    Text("시작하기")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 40)
            .navigationTitle("작업 설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct TimeEditorView: View {
    @Binding var focusMinutes: String
    @Binding var breakMinutes: String
    let onSave: () -> Void
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusField: Field?
    
    enum Field {
        case focus, breakTime
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                VStack(alignment: .leading, spacing: 20) {
                    // 집중 시간 설정
                    VStack(alignment: .leading, spacing: 8) {
                        Label("집중 시간", systemImage: "brain.head.profile")
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        HStack {
                            TextField("25", text: $focusMinutes)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 80)
                                .multilineTextAlignment(.center)
                                .focused($focusField, equals: .focus)
                                .onChange(of: focusMinutes) { newValue in
                                    // 숫자만 허용
                                    let filtered = newValue.filter { $0.isNumber }
                                    if filtered != newValue {
                                        focusMinutes = filtered
                                    }
                                }
                            
                            Text("분")
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("(1-60분)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // 휴식 시간 설정
                    VStack(alignment: .leading, spacing: 8) {
                        Label("휴식 시간", systemImage: "cup.and.saucer")
                            .font(.headline)
                            .foregroundColor(.green)
                        
                        HStack {
                            TextField("5", text: $breakMinutes)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 80)
                                .multilineTextAlignment(.center)
                                .focused($focusField, equals: .breakTime)
                                .onChange(of: breakMinutes) { newValue in
                                    // 숫자만 허용
                                    let filtered = newValue.filter { $0.isNumber }
                                    if filtered != newValue {
                                        breakMinutes = filtered
                                    }
                                }
                            
                            Text("분")
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("(1-30분)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.horizontal)
                
                // 프리셋 버튼들
                VStack(alignment: .leading, spacing: 12) {
                    Text("빠른 설정")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            PresetButton(title: "뽀모도로", focus: "25", breakTime: "5") {
                                focusMinutes = "25"
                                breakMinutes = "5"
                            }
                            
                            PresetButton(title: "짧은 집중", focus: "15", breakTime: "3") {
                                focusMinutes = "15"
                                breakMinutes = "3"
                            }
                            
                            PresetButton(title: "긴 집중", focus: "45", breakTime: "10") {
                                focusMinutes = "45"
                                breakMinutes = "10"
                            }
                            
                            PresetButton(title: "딥워크", focus: "60", breakTime: "15") {
                                focusMinutes = "60"
                                breakMinutes = "15"
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .padding(.top, 30)
            .navigationTitle("시간 설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        onSave()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(!isValidInput)
                }
            }
            .onTapGesture {
                focusField = nil
            }
        }
    }
    
    private var isValidInput: Bool {
        guard let focus = Int(focusMinutes),
              let breakTime = Int(breakMinutes) else { return false }
        return focus >= 1 && focus <= 60 && breakTime >= 1 && breakTime <= 30
    }
}

struct PresetButton: View {
    let title: String
    let focus: String
    let breakTime: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("\(focus)/\(breakTime)분")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
