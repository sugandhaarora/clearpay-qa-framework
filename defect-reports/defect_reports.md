# ClearPay — Defect Reports

**Project:** ClearPay Mobile Banking QA Framework  
**Prepared by:** Sugandha Arora  
**Environment:** Test  
**Status:** Sample defect reports for portfolio demonstration

---

## DEF-001 — KYC Approves User with Expired Government ID

| Field | Detail |
|---|---|
| **Defect ID** | DEF-001 |
| **Title** | KYC onboarding approves user presenting expired government ID |
| **Severity** | Sev-1 |
| **Priority** | High |
| **Status** | Open |
| **Module** | KYC Onboarding |
| **Test Case** | TC-KYC-005 |
| **Regulatory Ref** | FINTRAC KYC Obligations, PCMLTFA |
| **Environment** | Test — Build 2.1.4 |
| **Reported by** | Sugandha Arora |
| **Date** | April 2026 |

### Steps to Reproduce
1. Launch ClearPay app
2. Begin new user registration
3. Complete personal details form with valid name, DOB, and address
4. Upload a government-issued driver's licence expired 1 day ago
5. Submit KYC verification

### Expected Result
KYC verification fails. Error message displayed: "Your ID has expired. Please provide a valid, unexpired government-issued ID." Account is not activated.

### Actual Result
KYC verification passes. Account is activated and user is able to initiate e-transfers immediately despite presenting an expired ID.

### Impact
This defect constitutes a direct violation of FINTRAC KYC obligations under PCMLTFA. ClearPay is required to verify valid, current identity documents before activating any account. An expired ID is not acceptable proof of identity. If this defect reaches production, ClearPay is exposed to regulatory penalties, potential FINTRAC audit findings, and reputational risk. Any transactions completed by unverified users would also be non-compliant.

### Root Cause Analysis
Investigation of the onboarding validation logic revealed that the KYC service validates the format and presence of the ID document but does not check the `expiry_date` field against the current date. The expiry date is extracted from the uploaded document via OCR but is stored without being evaluated. The validation function contains the following gap:


