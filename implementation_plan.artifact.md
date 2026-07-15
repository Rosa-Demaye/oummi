# Implementation Plan - OUMMI Phase 3 & Beyond

This plan covers the finalization of the Authentication flow and the implementation of role-based dashboards, appointment booking, and community features, strictly following the OUMMI premium design system.

## Proposed Changes

### [Phase 3] Firebase Auth & User Management
#### [MODIFY] [login_page.dart](file:///C:/Users/Neradel/StudioProjects/oummi/lib/features/auth/presentation/pages/login_page.dart)
- Integrate real sign-in logic using `authNotifierProvider`.
- Add error handling (SnackBars for invalid credentials).
- Implement "Sign in with Google" placeholder logic.

#### [NEW] [register_page.dart](file:///C:/Users/Neradel/StudioProjects/oummi/lib/features/auth/presentation/pages/register_page.dart)
- Multi-step registration flow:
    - **Step 1**: Role Selection (Beautiful cards for Girl, Pregnant, Father, Doctor, Hospital).
    - **Step 2**: Primary Details (Email, Phone, Full Name).
    - **Step 3**: Role-specific details (Specialty for Doctors, Facility type for Hospitals).
- Use **Soft Rose** for Primary buttons and **Medical Blue** for trust elements.

#### [MODIFY] [app_router.dart](file:///C:/Users/Neradel/StudioProjects/oummi/lib/core/routing/app_router.dart)
- Implement `redirect` logic to ensure unauthenticated users stay on the Login page.

---

### [Phase 4] Role-Based Dashboards
#### [NEW] [doctor_dashboard.dart](file:///C:/Users/Neradel/StudioProjects/oummi/lib/features/dashboard/presentation/pages/doctor_dashboard.dart)
- **Primary Color**: Medical Blue (#4A90E2).
- Features: Patient queue, urgent alerts, consultation calendar.

#### [NEW] [hospital_dashboard.dart](file:///C:/Users/Neradel/StudioProjects/oummi/lib/features/dashboard/presentation/pages/hospital_dashboard.dart)
- Overview of bed capacity, available ambulances, and emergency calls.

#### [NEW] [father_dashboard.dart](file:///C:/Users/Neradel/StudioProjects/oummi/lib/features/dashboard/presentation/pages/father_dashboard.dart)
- Focus on "How to support my partner," baby growth updates, and shared health records.

---

### [Phase 5] Appointment Booking System
#### [NEW] Feature Components
- `DoctorSearchPage`: Filter by specialty (Gynecologist, Pediatrician, etc.) and location.
- `BookingCalendar`: Select date/time using a premium, rounded UI.
- `AppointmentRepository`: Firestore integration for real-time booking status.

---

### [Phase 6] Community Hub
#### [NEW] Feature Components
- `CommunityFeed`: Scrollable feed with categories (e.g., "General", "Nutrition", "Post-partum").
- `CommunityGroupCard`: Soft Lavender (#C7B6FF) design for groups.
- Firestore integration for posts and comments.

## Verification Plan

### Automated Tests
- Run `flutter analyze` after each phase.
- Unit tests for `AuthRepository` and `AppointmentRepository`.

### Manual Verification
- Test registration flow for all 5 roles.
- Verify that a logged-in Doctor sees the Medical Blue dashboard.
- Verify that a Father sees the partner support dashboard.
- Test the full booking loop (from search to confirmation).
