# Implementation Plan - Recovery & System Restoration

The project recently underwent a GitHub pull that appears to have overwritten numerous files with empty placeholders or outdated versions, resulting in 31 analysis errors and significant loss of functionality. This plan details the systematic restoration of the OUMMI platform.

## User Review Required

> [!CAUTION]
> **Data Loss Warning**: Approximately 38 files in the `lib/` directory are currently empty (0 bytes). I will restore these files based on the established architecture and requirements. If you have any recent local changes that were NOT committed or pushed, please back them up before I proceed.

## Proposed Changes

### 1. Structural Restoration
#### [MODIFY] [main.dart](file:///C:/Users/Neradel/StudioProjects/oummi/lib/main.dart)
- Restore Hive initialization.
- Restore `NotificationService.initialize()`.

#### [MODIFY] [app_router.dart](file:///C:/Users/Neradel/StudioProjects/oummi/lib/core/routing/app_router.dart)
- Restore all feature routes (Appointments, Risk Assessment, Health Records, Chat, Labor Declaration, etc.).

#### [MODIFY] [MainWrapper](file:///C:/Users/Neradel/StudioProjects/oummi/lib/features/dashboard/presentation/pages/main_wrapper.dart)
- Fix broken imports (using same directory for dashboards).

---

### 2. Feature-by-Feature Content Restoration
I will restore the following empty files with their respective professional implementations:

#### [RESTORE] Core & Dashboards
- `notification_service.dart`
- `doctor_dashboard.dart`, `father_dashboard.dart`, `young_woman_dashboard.dart`

#### [RESTORE] Community Module
- `post.dart`, `comment.dart`, `group.dart`
- `community_repository.dart`, `community_repository_impl.dart`
- `community_provider.dart`, `create_post_page.dart`, `group_discovery_page.dart`

#### [RESTORE] Risk Assessment & Health
- `risk_engine.dart` (Weighted scoring logic)
- `risk_provider.dart`, `vitals.dart`, `risk_repository.dart`, `risk_repository_impl.dart`
- `health_provider.dart`, `medical_entry.dart`, `health_repository.dart`, `health_repository_impl.dart`

#### [RESTORE] Appointments & Teleconsultation
- `appointment_provider.dart`, `appointment.dart`, `appointment_repository.dart`, `appointment_repository_impl.dart`
- `chat_provider.dart`, `message.dart`, `chat_repository.dart`, `chat_repository_impl.dart`

#### [RESTORE] Emergencies & Admin
- `emergency_provider.dart`, `emergency_alert.dart`, `emergency_repository.dart`, `emergency_repository_impl.dart`
- `admin_provider.dart`, `national_stats.dart`, `admin_repository.dart`, `admin_repository_impl.dart`, `admin_dashboard_page.dart`

---

### 3. Verification & Build
#### [FIX] Android Build
- Re-apply necessary Gradle/AGP/SDK 36 fixes if they were reverted by the pull.

## Verification Plan

### Automated Tests
- Run `flutter analyze` after every feature restoration block.
- Target: 0 errors, 0 warnings.

### Manual Verification
- Launch the app to verify the Splash -> Onboarding -> Login flow.
- Verify role-based dashboard redirection.
- Test real-time features (Risk Assessment results, Chat bubbles).
