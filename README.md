# Night Copilot

A calm-first SwiftUI app that helps people navigate difficult nights with fast, structured, and emotionally safe support.

Night Copilot is designed for moments like:
- not being able to fall asleep,
- feeling wired after work,
- emotional overload,
- needing a quick nervous-system reset.

The product combines guided plans, simple reset timers, and an AI chat copilot with crisis escalation safeguards.

---

## Product Brief (for ChatGPT or any collaborator)

### Core Promise
Night Copilot gives users immediate, low-friction actions that reduce overwhelm within seconds, not hours. It favors tiny, practical steps over long content and keeps tone gentle, private, and non-judgmental.

### User Problems It Solves
- **Sleep resistance at night:** user can’t “switch off” and spirals.
- **Post-work physiological activation:** body remains in high-alert mode.
- **Mental/emotional overload:** too many thoughts or sensations at once.
- **Decision fatigue:** user needs one clear next step, not a full program.

### Functional Pillars
1. **Night-state triage** – user chooses current state from four targeted scenarios.
2. **State-specific guidance plans** – each state maps to short, practical recovery steps.
3. **Fast regulation tools** – built-in timer-based resets (60s to 10m).
4. **Calm AI chat** – conversational support with immediate response.
5. **Safety escalation** – critical keyword detection routes to emergency guidance.
6. **Tiered value framing** – free essentials + premium previews for deeper sessions.

---

## Current Functionality

### 1) Home Experience
- Presents app positioning (“calm nighttime support companion”).
- Shows value proposition and trust-oriented copy.
- Displays a rotating daily grounding line (anchor prompt).
- Lets users pick one of four night states and navigate into a tailored plan.
- Offers a premium preview sheet without blocking core free flows.

### 2) Night States (Entry Points)
The app currently supports:
- **Can’t fall asleep**
- **Still wired**
- **Feeling overloaded**
- **Need a reset**

Each state includes:
- title + subtitle,
- icon,
- opening reassurance line,
- dedicated action plan.

### 3) Guidance Plan Screen
For each night state, the user gets:
- a “Plan for right now” framing card,
- 3 concise steps focused on immediate relief,
- horizontal quick-action shortcuts,
- one prominent primary CTA that launches the recommended reset tool,
- ability to open the AI Copilot chat.

Quick actions can:
- launch a reset timer,
- show a grounding prompt,
- open a premium feature preview.

### 4) Reset Timer Tools
Built-in tools:
- **60-second pause**
- **1-minute breathing**
- **5-minute quiet**
- **10-minute wind-down**

Timer UX includes:
- circular animated progress ring,
- mm:ss countdown,
- begin/pause/reset controls,
- subtle haptic feedback on start and completion (UIKit-capable platforms).

### 5) AI Copilot Chat
- Starts with a supportive welcome message.
- Supports user typing + one-tap quick replies.
- Uses contextual response generation based on selected night state.
- Keeps responses short, practical, and step-oriented.
- Includes visual chat role differentiation (user, assistant, safety).

### 6) Safety Escalation
Before generating assistant guidance, the app scans user input for high-risk terms (for example: self-harm, suicide, overdose, breathing difficulty, chest pain, emergency cues).

If triggered, the app posts a dedicated safety message instructing urgent real-world support (e.g., 911 and 988 in the U.S.) and does not continue normal assistant advice for that turn.

### 7) Free vs Plus Positioning
The app includes a **non-blocking premium preview model**:
- Free tier remains useful and complete for core nightly stabilization.
- Premium is framed as optional deeper sessions and insights.
- Premium UI appears in quick-action chips and informational sheets.

---

## UX / Visual System

Night Copilot’s current UI direction emphasizes:
- dark, low-stimulation gradients for nighttime comfort,
- high legibility with rounded typography,
- soft, elevated cards with glow + subtle strokes,
- calm accent palette (indigo/blue) for trust and focus,
- predictable spacing and reusable components for consistency.

### Design Tokens
- **Colors:** centralized in `Color+NightCopilot.swift`
- **Typography:** centralized in `Typography.swift`
- **Spacing scale:** centralized in `Spacing.swift`

### Reusable UI Components
- `NightCard`
- `AnchorCardView`
- `QuickActionChip`
- `ProgressRingView`
- `PremiumTierSheet`

---

## Architecture Overview

Pattern: **SwiftUI + MVVM + service layer**

- **Views** render state and user interaction.
- **ViewModels** own UI state, orchestration, and async operations.
- **Models** define domain entities and app state mapping.
- **Services** encapsulate prompt logic, chat behavior, safety logic, and haptics.
- **Theme/Utilities** centralize design tokens and format helpers.

### Data/Interaction Flow (high level)
1. User selects `NightState` from Home.
2. `GuidanceViewModel` creates a `GuidancePlan` for that state.
3. User launches tools/prompts/chat from quick actions or primary CTA.
4. `ResetTimerViewModel` controls timer lifecycle and progress.
5. `AIChatViewModel` sends user input through safety check, then mock chat service.
6. `PromptBuilder` returns state-aware tactical suggestions.

---

## Repository Map

```text
App/
  NightCopilotApp.swift
Models/
  AIChatMessage.swift
  CalmPrompt.swift
  CopilotContext.swift
  GuidancePlan.swift
  NightState.swift
  ResetTool.swift
  TierAccess.swift
Services/
  AIChatService.swift
  MockAIChatService.swift
  PromptBuilder.swift
  PromptLibrary.swift
  SafetyEscalationService.swift
  TimerHapticsService.swift
Theme/
  Color+NightCopilot.swift
  Spacing.swift
  Typography.swift
Utilities/
  TimeFormatter.swift
ViewModels/
  AIChatViewModel.swift
  GuidanceViewModel.swift
  HomeViewModel.swift
  ResetTimerViewModel.swift
Views/
  HomeView.swift
  GuidanceView.swift
  AIChatView.swift
  ResetTimerView.swift
  Components/
```

---

## Running and Extending

### Local Run
1. Open the project in Xcode.
2. Build and run on iOS simulator/device.
3. Start from Home and test each night-state branch.

### Easy Extension Points
- Add a new user scenario by extending `NightState` + `GuidancePlan.makePlan`.
- Expand calm content via `PromptLibrary`.
- Replace `MockAIChatService` with production LLM integration behind `AIChatService`.
- Enrich safety behavior in `SafetyEscalationService` (locale-aware emergency pathways, broader detection).
- Add persistence/analytics modules while preserving privacy-first defaults.

---

## Product Quality Targets (Recommended Next)

To make the app more robust, professional, and polished:

1. **Production AI integration**
   - streaming responses,
   - retries/timeouts,
   - observability and content safety instrumentation.
2. **Offline-resilient mode**
   - local fallback scripts and prompts if network/AI is unavailable.
3. **Accessibility hardening**
   - Dynamic Type validation,
   - VoiceOver labels/hints,
   - stronger contrast checks.
4. **State persistence**
   - restore active timer and recent session context.
5. **Trust and compliance**
   - privacy disclosure, crisis disclaimer, and data handling policy surfaces.
6. **UI polish**
   - micro-interactions, reduced-motion variants, richer transitions, and haptic tuning.

---

## Important Safety Note
Night Copilot provides supportive guidance and is **not** a substitute for medical care, diagnosis, or emergency services.

For immediate danger or possible medical emergency, contact local emergency services immediately (911 in the U.S.) or call/text 988 for crisis support in the U.S.
