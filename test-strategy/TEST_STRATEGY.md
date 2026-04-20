# ClearPay — Test Strategy Document

**Version:** 1.0  
**Prepared by:** Sugandha Arora  
**Date:** April 2026  
**Status:** Final

---

## 1. Objective

This document defines the test strategy for ClearPay, a Canadian mobile payments application. It establishes the approach, scope, risk priorities, and compliance coverage for all testing activities. The strategy is designed to ensure ClearPay meets functional requirements, regulatory obligations under PIPEDA and FINTRAC, and security expectations for a financial application handling sensitive personal and banking data.

---

## 2. Scope

### In Scope
- User registration and KYC identity verification
- E-transfer flows (send, receive, cancel, limits)
- Transaction history and statement generation
- Session management and authentication
- Account limit enforcement
- Fraud detection triggers and suspicious activity alerts
- PIPEDA consent and data handling flows
- FINTRAC threshold reporting (transactions ≥ $10,000)

### Out of Scope
- Backend infrastructure and server configuration
- Third-party KYC provider internal logic (e.g. Persona, Jumio)
- iOS/Android OS-level security
- Performance and load testing (separate engagement)

---

## 3. Test Approach

### Risk-Based Testing
Test effort is prioritized by risk. High-likelihood, high-impact areas (KYC accuracy, transaction integrity, fraud detection) receive the most coverage. Lower-risk areas (UI cosmetics, non-sensitive preferences) receive minimal coverage.

### Test Types
| Test Type | Purpose |
|---|---|
| Functional Testing | Validate features work per requirements |
| Integration Testing | Validate data flow across app, API, and database layers |
| Regression Testing | Ensure new builds do not break existing functionality |
| Negative Testing | Validate system behaviour under invalid, boundary, and edge inputs |
| Security-Adjacent Testing | Session handling, auth flows, data exposure checks |
| Compliance Testing | Validate PIPEDA and FINTRAC requirements are met |

---

## 4. Risk Register

| # | Risk | Likelihood | Impact | Mitigation | Test Coverage |
|---|---|---|---|---|---|
| R01 | KYC approves user with expired government ID | Medium | High | Validate expiry_date field check in onboarding flow | TC-KYC-005, TC-KYC-006 |
| R02 | E-transfer sent to wrong recipient with no reversal path | Low | High | Test recipient validation and cancellation window | TC-ETR-008, TC-ETR-009 |
| R03 | Duplicate e-transfer processed within 60-second window | Medium | High | Test duplicate detection logic at submission | TC-ETR-012 |
| R04 | Transaction over $10,000 not flagged for FINTRAC reporting | Low | High | Validate threshold trigger at $9,999 / $10,000 / $10,001 | TC-TXN-003, TC-TXN-004 |
| R05 | Session remains active beyond inactivity timeout | Medium | Medium | Test session expiry at 5, 10, 15-minute marks | TC-SEC-003 |
| R06 | PII exposed in API response beyond what is required | Low | High | Validate API responses return only necessary fields | TC-API-005 |
| R07 | User under 18 successfully completes registration | Low | High | Test DOB validation at boundary (17y 364d, 18y 0d) | TC-KYC-009 |
| R08 | Daily transfer limit bypassed through multiple rapid transfers | Medium | High | Test cumulative limit enforcement across same-day transfers | TC-ETR-015, TC-ETR-016 |
| R09 | PIPEDA consent not recorded before data collection begins | Medium | High | Validate consent flag stored before any PII is accepted | TC-KYC-001 |
| R10 | Fraud alert not triggered on 5+ transactions within 10 minutes | Medium | Medium | Test velocity detection logic with rapid transaction simulation | TC-FRD-002 |

---

## 5. PIPEDA and FINTRAC Compliance Mapping

| Regulatory Requirement | Obligation | Test Coverage |
|---|---|---|
| PIPEDA — Consent (s.4.3) | User must provide informed consent before PII is collected | TC-KYC-001 |
| PIPEDA — Limiting Collection (s.4.4) | Only collect data necessary for the stated purpose | TC-KYC-002, TC-API-005 |
| PIPEDA — Safeguards (s.4.7) | Personal data must be protected against loss, theft, unauthorized access | TC-SEC-001, TC-SEC-002 |
| PIPEDA — Individual Access (s.4.9) | Users must be able to access their own personal information | TC-PRF-001 |
| FINTRAC — Large Cash Transaction (s.12) | Transactions ≥ $10,000 must be reported | TC-TXN-003, TC-TXN-004 |
| FINTRAC — Suspicious Transaction (s.7) | Unusual patterns must trigger internal suspicious activity flag | TC-FRD-001, TC-FRD-002 |
| FINTRAC — KYC Obligations | Identity must be verified before account activation | TC-KYC-003, TC-KYC-004 |

---

## 6. Entry and Exit Criteria

### Entry Criteria
- Stable build deployed to test environment
- API contracts and endpoint documentation available
- Test data seeded (valid and invalid user profiles, transaction records)
- Access to all test environments confirmed

### Exit Criteria
- Zero open Sev-1 or Sev-2 defects
- Minimum 95% test case execution completed
- 100% of compliance-mapped test cases executed and passed
- Test summary report reviewed and signed off

---

## 7. Defect Severity Definitions

| Severity | Definition | Example |
|---|---|---|
| Sev-1 | System unusable or regulatory violation | KYC approves expired ID, FINTRAC threshold not triggered |
| Sev-2 | Major feature broken, workaround unavailable | E-transfer fails for valid recipient |
| Sev-3 | Feature impaired, workaround exists | Session timeout 2 minutes late |
| Sev-4 | Minor issue, cosmetic or low impact | Button label truncated on small screen |

---

## 8. Assumptions and Dependencies
- ClearPay uses a third-party KYC provider; internal logic of that provider is out of scope
- Test environment data does not contain real personal information
- Regulatory mapping is based on publicly available PIPEDA and FINTRAC guidelines
- All defects logged in a defect tracking system (Jira or equivalent)
