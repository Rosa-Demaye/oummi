# OUMMI Rebuild Task List

## 1. Project Foundation & Structure
- [x] Update `pubspec.yaml` with new dependencies
- [x] Create Clean Architecture folder structure
- [x] Implement Design System (Colors, Typography, Theme)
- [x] Set up Core components (Router, Service Locator)

## 2. Authentication & User Management
- [ ] Implement Firebase Auth Repository
- [ ] Create Auth State Providers (Riverpod)
- [ ] Build Role Selection & Registration Flow
- [ ] Implement Login & Password Recovery

## 3. Core Features - Women
- [x] **Cycle Tracker Redesign**
    - [x] Calendar Dashboard (TableCalendar)
    - [x] Symptom & Mood Logging
    - [x] AI Insight Cards
    - [x] Add Symptom Bottom Sheet (Real-time data entry)
- [x] **Pregnancy Module**
    - [x] Implement `PregnancyRepository` (Firestore)
    - [x] Create `PregnancyDashboardPage` (Premium UI)
    - [x] Add Heartbeat Animation & Baby Size Visuals
    - [x] Build `WeekDetailsPage`
    - [ ] Implement Labor/Emergency Signal logic

## 4. Dashboards (Role-Based)
- [ ] Doctor Dashboard
- [ ] Father Dashboard
- [ ] Hospital Dashboard
- [ ] Admin Dashboard

## 5. Integration & Polish
- [x] Connect Firebase Firestore for data-driven UI
    - [x] Implement `CycleRepository` for Firestore
    - [x] Create Riverpod providers for Cycle data
    - [x] Update `CyclePage` to use real-time data
- [ ] Implement Push Notifications (FCM)
- [ ] Add Lottie animations and smooth transitions
- [ ] Final Analysis & Cleanup
