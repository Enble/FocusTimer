# FocusTimer: 뽀모도로 타이머 iOS 앱

**FocusTimer**는 생산성 향상을 위한 **뽀모도로 기법** 기반의 iOS 타이머 애플리케이션입니다. SwiftUI를 사용하여 현대적이고 직관적인 사용자 인터페이스를 제공하며, 사용자가 집중 시간을 효과적으로 관리하고 자신의 학습 및 작업 패턴을 분석할 수 있도록 돕습니다.

## 🎥 3분 소개 영상

프로젝트의 주요 기능과 사용법을 소개하는 3분 길이의 영상입니다.

[유튜브_소개_영상]([https://www.google.com/search?q=https://www.youtube.com/watch%3Fv%3DYOUTUBE_VIDEO_ID](https://www.youtube.com/watch?v=1HejJSJOkuo))

> 위 이미지를 클릭하여 YouTube 영상을 시청하세요.

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
| <img src="https://github.com/user-attachments/assets/74f30632-0f9e-44fd-a72d-0e9f64e918c1" width="200"> | <img src="https://github.com/user-attachments/assets/3393606d-1fbc-49c7-998a-34848a5ec94f" width="200"> | <img src="https://github.com/user-attachments/assets/342d6df9-67b9-4752-bb63-b6a3d2a5c9f7" width="200"> | <img src="https://github.com/user-attachments/assets/f3cfec05-06ec-452a-b291-5c75954a9c0b" width="200"> |

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

<br>

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

<br>

## 🛠️ 구현 심층 분석 (Technical Deep Dive)

이 프로젝트는 최신 iOS 기술을 활용하여 효율적이고 확장 가능하게 설계되었습니다. 주요 기술 구현 방식은 다음과 같습니다.

### 1\. 통계 데이터 처리 및 시각화 (Statistics Processing & Visualization)

통계 기능은 `StatsViewModel`을 중심으로 구현되었으며, 데이터 처리와 UI 렌더링을 명확히 분리했습니다.

  * **데이터 로딩 및 가공**: `StatsViewModel`의 `loadData(for:)` 메서드는 선택된 기간(일간/주간/월간)에 따라 `PersistenceManager`를 통해 Core Data에서 관련 세션들을 가져옵니다.
  * **차트 데이터 변환**: 가져온 `SessionLog` 객체들은 Swift `Charts` 프레임워크에 적합한 `Identifiable` 구조체(`HourlyData`, `WeeklyData`, `DailyData`)로 변환됩니다. 예를 들어, 일간 데이터의 경우 24시간 루프를 돌며 시간대별 집중 시간을 `hourlyMinutes` 딕셔너리에 집계한 후, 이를 `HourlyData` 배열로 매핑합니다.
  * **동적 차트 렌더링**: `StatsView`에서는 선택된 기간에 따라 `DailyChartView`, `WeeklyChartView`, `MonthlyChartView`를 조건부로 렌더링합니다. 각 차트 뷰는 `Charts` 프레임워크의 `BarMark` 또는 `LineMark`를 사용하여 데이터를 시각화합니다.
  * **계산 로직 분리**: 복잡한 통계 계산 로직(예: 가장 생산적인 시간대)은 `FocusStatisticsCalculator` 클래스로 분리하여 `ViewModel`의 책임을 줄이고 코드 재사용성을 높였습니다.

### 2\. 상태 관리 및 데이터 흐름 (State Management & Data Flow)

SwiftUI와 Combine을 적극적으로 활용하여 앱의 상태를 관리하고 데이터 흐름을 제어합니다.

  * **타이머 상태 전파**: `TimerManager`는 실제 `Timer`를 관리하며, 타이머 종료 시 Combine의 `PassthroughSubject`인 `sessionCompleted`를 통해 이벤트를 방출합니다. `TimerViewModel`은 이 이벤트를 구독(`sink`)하여 세션 저장, 알림 전송, 세션 타입 전환 등의 후속 작업을 트리거합니다.
  * **설정 실시간 반영**: `SettingsManager`는 `@AppStorage`를 사용하여 사용자 설정을 UserDefaults에 자동으로 저장합니다. `TimerView`에서는 `.onChange(of: settingsManager.focusDuration)` 수정자를 사용하여 설정 값의 변경을 감지하고, 즉시 `viewModel.updateTimerDuration()`을 호출하여 타이머에 반영합니다.
  * **환경 객체 주입**: 앱의 최상위(`FocusTimerApp`)에서 `settingsManager`와 `notificationManager`를 `@StateObject`로 생성하고, `.environmentObject()`를 통해 하위 모든 뷰에 공유하여 어디서든 설정 값에 접근할 수 있도록 합니다.

### 3\. 데이터 영속성 관리 (Data Persistence with Core Data)

`PersistenceManager`는 Core Data 스택을 캡슐화하는 싱글톤 클래스로, 데이터 관련 작업을 중앙에서 관리합니다.

  * **조건부 데이터 조회**: `fetchSessions(from:to:)` 메서드는 `NSPredicate`를 사용하여 특정 날짜 범위 내의 세션만 효율적으로 조회합니다. 이는 통계 기능에서 필수적입니다.
  * **효율적인 대량 삭제**: `deleteAllSessions()` 메서드는 `NSBatchDeleteRequest`를 사용하여 모든 세션 기록을 한 번의 트랜잭션으로 삭제합니다. 이는 많은 양의 데이터를 삭제할 때 메모리 사용량을 최소화하고 성능을 향상시키는 방법입니다.
  * **개발용 샘플 데이터**: `#if DEBUG` 전처리기 매크로를 사용하여 디버그 빌드에서만 `generateSampleData()` 메서드를 포함시켰습니다. 이를 통해 실제 앱에는 영향을 주지 않으면서 개발 및 테스트 단계에서 손쉽게 목업 데이터를 생성할 수 있습니다.

### 4\. 핵심 UI 구현 기법 (Key UI Implementation)

  * **원형 프로그레스 바**: `TimerView`의 원형 타이머는 `ZStack` 내에 두 개의 `Circle` 뷰를 겹쳐서 구현했습니다. 배경원은 회색 테두리를, 전경원은 `.trim(from: 0, to: viewModel.progress)` 수정자를 사용하여 남은 시간 비율에 따라 채워지는 효과를 동적으로 보여줍니다.
  * **날짜별 기록 그룹화**: `HistoryViewModel`에서는 `Dictionary(grouping:by:)` 이니셜라이저를 사용하여 `SessionLog` 배열을 `Date`를 키로 하는 딕셔너리로 변환합니다. 이를 통해 `HistoryView`에서 `List`의 `Section`을 사용하여 날짜별로 그룹화된 UI를 쉽게 구현할 수 있습니다.

<br>

## 🚀 시작하기 (Getting Started)

프로젝트를 로컬 환경에서 빌드하고 실행하는 방법입니다.

### 사전 요구사항

  * macOS Big Sur 11.0 이상
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

<br>

## 📜 라이선스 (License)

이 프로젝트는 **MIT License**에 따라 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참고하세요.
