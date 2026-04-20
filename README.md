# ClearPay — Mobile Banking QA Framework

## About This Project
This repository contains a complete QA framework for ClearPay, a fictional Canadian mobile payments application. It demonstrates risk-based test strategy, compliance-aware test design, SQL validation, and API testing — applied to a regulated fintech context.

## About ClearPay (System Under Test)
**Platform:** iOS and Android mobile app  
**Target users:** Canadian residents 18+  
**Core features:**
- User registration with KYC (Know Your Customer) identity verification
- E-transfers (send, receive, cancel)
- Transaction history and statements
- Account limits and alerts
- Fraud detection and suspicious activity flagging

**Data handled:**
- Government-issued ID (driver's licence, passport)
- Partial SIN (last 3 digits for identity confirmation)
- Banking information (account + transit number)
- Personal information (name, DOB, address)

**Regulatory context:**
- PIPEDA — governs collection and use of personal data
- FINTRAC — requires reporting of transactions over $10,000 and suspicious activity
- PCI-DSS awareness — card and banking data handling

## Repository Structure
| Folder | Contents |
|---|---|
| `/test-strategy` | Test strategy document and risk register |
| `/test-cases` | Test cases with traceability matrix |
| `/api-tests` | Postman collection and documentation |
| `/sql-validation` | Schema and validation queries |
| `/defect-reports` | Sample defect reports with RCA |
| `/bug-bash-report` | Bug bash session summary |

## What This Demonstrates
- Risk-based test strategy for a regulated mobile application
- PIPEDA and FINTRAC compliance mapping to test coverage
- KYC onboarding and e-transfer flow test design
- SQL fraud and transaction integrity validation
- API contract testing with Postman
- Audit-ready defect documentation with root cause analysis
