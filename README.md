# ClearPay — Mobile Banking QA Framework

## About This Project
This repository contains a complete QA framework for ClearPay, a fictional Canadian mobile payments application. It demonstrates risk-based test strategy, AML and compliance-aware test design, SQL validation, and API testing — applied to a regulated fintech context.

The project is designed to reflect the QA standards expected in Canadian financial services, with explicit coverage of FINTRAC, PIPEDA, and PCMLTFA obligations.

## About ClearPay (System Under Test)
**Platform:** iOS and Android mobile app  
**Target users:** Canadian residents 18+  
**Core features:**
- User registration with KYC identity verification
- E-transfers (send, receive, cancel)
- Transaction history and statements
- Account limits and alerts
- AML fraud detection and suspicious activity flagging

**Data handled:**
- Government-issued ID (driver's licence, passport)
- Partial SIN (last 3 digits for identity confirmation)
- Banking information (account + transit number)
- Personal information (name, DOB, address)

**Regulatory context:**
- PIPEDA — governs collection and use of personal data
- FINTRAC — requires reporting of transactions over $10,000 and suspicious activity
- PCMLTFA — primary Canadian AML legislation governing money services businesses
- PCI-DSS awareness — card and banking data handling

---

## Repository Structure

| Folder | Contents |
|---|---|
| `/test-strategy` | Main test strategy, risk register, AML test strategy |
| `/test-cases` | 64 test cases with full traceability matrix |
| `/api-tests` | Postman collection with 39 API tests |
| `/sql-validation` | Core and AML SQL validation queries |
| `/defect-reports` | 3 sample defect reports with root cause analysis |
| `/bug-bash-report` | Bug bash session summary (coming soon) |

---

## Deliverables

### 1. Test Strategy
- Risk-based test strategy covering KYC, e-transfer, session security, and fraud detection
- 10-item risk register with likelihood, impact, and mitigation
- PIPEDA and FINTRAC compliance mapping to test coverage
- Entry and exit criteria, defect severity definitions

### 2. AML Test Strategy
- Dedicated AML strategy covering FINTRAC, PCMLTFA, and OSFI obligations
- AML risk register covering structuring, PEP screening, sanctions, dormant accounts, and high-risk jurisdictions
- Full FINTRAC compliance mapping

### 3. Test Cases — 64 total
- 12 KYC onboarding test cases
- 16 e-transfer flow test cases
- 5 transaction and FINTRAC threshold test cases
- 2 fraud detection test cases
- 10 security and session test cases
- 14 AML-specific test cases
- Full traceability matrix mapping every test case to a requirement and regulatory reference

### 4. API Tests — Postman
- 7 requests, 39 assertions
- Covers valid and invalid currency codes, rate range validation, schema validation, timestamp freshness, and sensitive field exposure
- Collection exported as JSON — importable and runnable by anyone

### 5. SQL Validation
- 10 core validation queries: KYC status, age validation, daily limit breach, duplicate detection, session expiry, orphaned transactions, NULL field checks
- 10 AML validation queries: structuring detection, FINTRAC threshold coverage, PEP gaps, sanctions gaps, dormant account activity, round-number patterns, high-risk jurisdiction transfers, STR coverage, alert closure documentation

### 6. Defect Reports
- DEF-001 (Sev-1): KYC approves expired government ID — FINTRAC violation with full RCA
- DEF-002 (Sev-2): Duplicate e-transfer processed within 60-second window
- DEF-003 (Sev-3): Session active 45 minutes beyond inactivity threshold — PIPEDA safeguards gap

---

## What This Demonstrates
- Risk-based test strategy for a regulated mobile payments application
- AML compliance testing covering FINTRAC, PCMLTFA, PEP screening, and sanctions
- PIPEDA and FINTRAC requirement mapping to test coverage
- KYC onboarding and e-transfer flow test design with boundary and negative cases
- SQL fraud and transaction integrity validation
- API contract testing with Postman including schema and security checks
- Audit-ready defect documentation with root cause analysis
- Full traceability from regulatory requirement to test case

---

## Tools Used
- Postman (API testing)
- DB Fiddle (SQL validation)
- GitHub (version control and portfolio hosting)
- ExchangeRate API free tier (API test target)

## Author
**Sugandha Arora** — Senior QA Engineer  
Hamilton, Ontario | Open Work Permit  
[LinkedIn](https://www.linkedin.com/in/sugandhaarora)
