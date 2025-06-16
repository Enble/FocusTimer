# FocusTimer: 뽀모도로 타이머 iOS 앱

**FocusTimer**는 생산성 향상을 위한 **뽀모도로 기법** 기반의 iOS 타이머 애플리케이션입니다. SwiftUI를 사용하여 현대적이고 직관적인 사용자 인터페이스를 제공하며, 사용자가 집중 시간을 효과적으로 관리하고 자신의 학습 및 작업 패턴을 분석할 수 있도록 돕습니다.

## 🎥 3분 소개 영상

프로젝트의 주요 기능과 사용법을 소개하는 3분 길이의 영상입니다.

[](https://www.google.com/search?q=https://www.youtube.com/watch%3Fv%3DYOUTUBE_VIDEO_ID)

> **참고**: 위 이미지를 클릭하여 YouTube 영상을 시청하세요. (현재는 플레이스홀더이며, 실제 영상 ID로 교체해야 합니다.)

<br>

## ✨ 주요 기능 (Features)

FocusTimer는 사용자의 생산성을 극대화하기 위한 다양한 기능을 제공합니다.

  * **🧠 스마트 타이머**:

      * 집중 및 휴식 세션을 번갈아 실행하는 뽀모도로 타이머를 제공합니다.
      * 원형 프로그레스 바를 통해 남은 시간을 시각적으로 확인할 수 있습니다.
      * 세션 시작 전, 현재 진행할 작업의 제목을 선택적으로 입력할 수 있습니다.
      * 타이머 상태(실행, 일시정지, 대기)에 따라 컨트롤 버튼이 동적으로 변경됩니다.

  * **📊 상세 통계 분석**:

      * 일간, 주간, 월간 단위로 집중 시간을 분석하고 시각화된 차트를 제공합니다.
      * **일간**: 시간대별 집중 시간을 막대 차트로 보여줍니다.
      * **주간**: 요일별 집중 시간과 가장 생산성이 높았던 작업을 분석해 줍니다.
      * **월간**: 일별 집중 시간 추이를 라인 차트로 확인할 수 있습니다.
      * 설정한 일일/주간 목표 대비 달성률을 시각적으로 추적할 수 있습니다.

  * **🗓️ 세션 기록 및 관리**:

      * 모든 집중 및 휴식 세션이 자동으로 기록되고, 날짜별로 그룹화되어 표시됩니다.
      * 완료, 중단 등 세션 상태에 따라 기록을 필터링할 수 있습니다.
      * 각 세션 기록에 메모를 추가하거나 수정하여 상세 내용을 관리할 수 있습니다.
      * 기록된 세션을 개별적으로 삭제할 수 있습니다.

  * **⚙️ 사용자 맞춤 설정**:

      * 집중 시간과 휴식 시간의 길이를 1분 단위로 자유롭게 설정할 수 있습니다.
      * 일일 및 주간 집중 목표 시간을 설정하여 동기를 부여받을 수 있습니다.
      * 세션 완료 시 푸시 알림 및 소리 활성화 여부를 제어할 수 있습니다.
      * 시스템 설정에 맞추거나 라이트/다크 모드를 직접 선택할 수 있는 테마 기능을 제공합니다.
      * 모든 설정 및 기록 데이터를 초기화하는 옵션을 제공합니다.

  * **🚀 편리한 사용자 경험**:

      * 앱 최초 실행 시, 주요 기능을 안내하는 온보딩 화면을 제공합니다.
      * `@AppStorage`를 활용하여 사용자의 설정이 앱 재시작 후에도 유지됩니다.
      * 모든 세션 기록은 **Core Data**를 통해 기기 내에 안전하게 저장됩니다.

<br>

## 📸 스크린샷 (Screenshots)

| 타이머 | 기록 | 통계 | 설정 |
|:---:|:---:|:---:|:---:|
| \<img src="URL\_TO\_TIMER\_SCREENSHOT" width="200"\> | \<img src="URL\_TO\_HISTORY\_SCREENSHOT" width="200"\> | \<img src="URL\_TO\_STATS\_SCREENSHOT" width="200"\> | \<img src="URL\_TO\_SETTINGS\_SCREENSHOT" width="200"\> |

> **참고**: 위 이미지는 실제 스크린샷 URL로 교체해야 합니다.

<br>

## 🛠️ 기술 스택 및 아키텍처 (Tech Stack & Architecture)

이 프로젝트는 다음과 같은 기술과 아키텍처 패턴을 기반으로 구축되었습니다.

  * **UI Framework**: **SwiftUI**를 사용하여 선언적이고 반응형인 사용자 인터페이스를 구현했습니다.
  * **Architecture**: **MVVM (Model-View-ViewModel)** 패턴을 적용하여 UI와 비즈니스 로직을 분리했습니다.
      * **View**: `TimerView`, `HistoryView` 등 UI를 구성하고 사용자 입력을 받습니다.
      * **ViewModel**: `TimerViewModel`, `StatsViewModel` 등이 View를 위한 데이터를 가공하고 비즈니스 로직을 처리합니다.
      * **Model**: Core Data의 `SessionLog` 엔티티가 모델 역할을 수행합니다.
  * **Data Persistence**: **Core Data**를 사용하여 사용자의 세션 기록을 영속적으로 저장하고 관리합니다.
  * **State Management**: `@State`, `@StateObject`, `@EnvironmentObject`, `@AppStorage` 등 SwiftUI의 내장 프로퍼티 래퍼를 적극 활용하여 상태를 관리합니다.
  * **Asynchronous Programming**: **Combine** 프레임워크(`PassthroughSubject`, `ObservableObject`)를 사용하여 비동기적인 데이터 흐름을 처리하고 View와 ViewModel 간의 통신을 구현했습니다.

## 📂 코드 구조 (Code Structure)

프로젝트의 소스 코드는 기능별로 명확하게 분리되어 있습니다.

```
FocusTimer/
├── Application/
│   ├── FocusTimerApp.swift   # 앱의 진입점(Entry Point), EnvironmentObject 설정
│   └── ContentView.swift       # Onboarding 또는 메인 TabView를 표시하는 루트 뷰
│
├── Views/
│   ├── TimerView.swift         # 메인 타이머 화면 UI
│   ├── HistoryView.swift       # 세션 기록 목록 UI
│   ├── StatsView.swift         # 통계 차트 및 데이터 시각화 UI
│   ├── SettingsView.swift      # 앱 설정 UI
│   └── OnboardingView.swift    # 신규 사용자를 위한 온보딩 UI
│
├── ViewModels/
│   ├── TimerViewModel.swift    # 타이머 로직 및 상태 관리
│   ├── HistoryViewModel.swift  # 기록 데이터 필터링 및 그룹화
│   └── StatsViewModel.swift    # 통계 데이터 계산 및 가공
│
├── Managers/
│   ├── PersistenceManager.swift # Core Data 관리 (저장, 조회, 삭제)
│   ├── TimerManager.swift      # 실제 Timer 객체 관리
│   ├── NotificationManager.swift # User Notification 관리
│   └── SettingsManager.swift   # @AppStorage를 이용한 사용자 설정 관리
│
└── CoreData/
    └── FocusTimer.xcdatamodeld # SessionLog 엔티티 모델
```

## 🚀 시작하기 (Getting Started)

프로젝트를 로컬 환경에서 빌드하고 실행하는 방법입니다.

### 사전 요구사항

  * macOS Monterey 12.0 이상
  * Xcode 13.0 이상
  * iOS 15.0 이상을 타겟으로 하는 시뮬레이터 또는 실제 기기

### 설치 및 실행

1.  이 저장소를 클론합니다.
    ```bash
    git clone https://github.com/YOUR_USERNAME/FocusTimer.git
    ```
2.  Xcode에서 `FocusTimer.xcodeproj` 파일을 엽니다.
3.  원하는 시뮬레이터 또는 연결된 기기를 선택합니다.
4.  `Cmd + R`을 눌러 프로젝트를 빌드하고 실행합니다.

## 📜 라이선스 (License)

이 프로젝트는 **MIT License**에 따라 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참고하세요.

-----
