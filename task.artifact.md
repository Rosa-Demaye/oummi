# OUMMI System Restoration Task List

## 1. Structural Fixes
- [ ] Fix broken imports in `main_wrapper.dart`
- [ ] Restore missing routes in `app_router.dart`
- [ ] Restore missing initializations in `main.dart`

## 2. Feature Restoration - Tier 1 (Core & Dashboards)
- [ ] Restore `notification_service.dart`
- [ ] Restore `doctor_dashboard.dart`
- [ ] Restore `father_dashboard.dart`
- [ ] Restore `young_woman_dashboard.dart`

## 3. Feature Restoration - Tier 2 (Health & Risk)
- [ ] Restore `RiskAssessment` & `Vitals` entities
- [ ] Restore `RiskEngine` logic
- [ ] Restore `MedicalEntry` entities
- [ ] Restore Risk & Health Repositories/Providers

## 4. Feature Restoration - Tier 3 (Services & Community)
- [ ] Restore Community (Entities, Repo, Providers, Pages)
- [ ] Restore Appointments (Entities, Repo, Providers)
- [ ] Restore Teleconsultation (Entities, Repo, Providers)

## 5. Feature Restoration - Tier 4 (Emergencies & Admin)
- [ ] Restore Emergencies (Entities, Repo, Providers)
- [ ] Restore Admin Oversight (Entities, Repo, Providers, Page)

## 6. Final Verification
- [ ] Fix any remaining analysis errors
- [ ] Verify build system configuration (SDK 36)
- [ ] Final `flutter analyze` audit
