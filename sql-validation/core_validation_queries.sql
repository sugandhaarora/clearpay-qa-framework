-- ClearPay Core Validation Queries
-- Author: Sugandha Arora
-- Purpose: Validate transaction integrity, KYC status, account limits,
--          and data quality across ClearPay's core functional areas
-- Note: Designed for use against synthetic test data only. No real PII.

-- ============================================================
-- SCHEMA REFERENCE
-- users: user_id, name, email, dob, kyc_status, pep_flag,
--        sanctions_flag, created_at, last_active_at
-- transactions: txn_id, sender_id, recipient_id, amount,
--               type, status, jurisdiction, created_at
-- account_limits: limit_id, user_id, daily_limit, remaining_limit,
--                 last_reset_at
-- sessions: session_id, user_id, created_at, last_active_at,
--           expired_at, status
-- aml_alerts: alert_id, user_id, txn_id, alert_type,
--             status, review_notes, created_at
-- ============================================================


-- Query 1: KYC status check
-- Identifies users who are transacting without completed KYC
-- Any row returned is a critical compliance gap
SELECT
    u.user_id,
    u.name,
    u.kyc_status,
    COUNT(t.txn_id) AS transaction_count,
    SUM(t.amount) AS total_transacted
FROM users u
JOIN transactions t ON u.user_id = t.sender_id
WHERE
    u.kyc_status != 'approved'
    AND t.status = 'completed'
GROUP BY u.user_id, u.name, u.kyc_status
ORDER BY total_transacted DESC;


-- Query 2: Under-age user detection
-- Identifies users who registered under age 18
-- Validates REQ-KYC-07 age restriction enforcement
SELECT
    user_id,
    name,
    dob,
    DATEDIFF(CURDATE(), dob) / 365.25 AS age_at_check,
    created_at
FROM users
WHERE
    DATEDIFF(created_at, dob) / 365.25 < 18
ORDER BY dob DESC;


-- Query 3: Daily transfer limit breach detection
-- Identifies users whose completed transactions exceed the $3000 daily limit
-- Validates REQ-ETR-04 daily limit enforcement
SELECT
    sender_id,
    DATE(created_at) AS transaction_date,
    SUM(amount) AS daily_total,
    COUNT(*) AS transaction_count
FROM transactions
WHERE
    type = 'e-transfer'
    AND status = 'completed'
GROUP BY sender_id, DATE(created_at)
HAVING SUM(amount) > 3000
ORDER BY daily_total DESC;


-- Query 4: Duplicate transaction detection
-- Identifies potential duplicate e-transfers — same sender, recipient,
-- and amount within a 60-second window
-- Validates REQ-ETR-08 duplicate detection logic
SELECT
    t1.txn_id AS original_txn,
    t2.txn_id AS duplicate_txn,
    t1.sender_id,
    t1.recipient_id,
    t1.amount,
    t1.created_at AS original_time,
    t2.created_at AS duplicate_time,
    TIMESTAMPDIFF(SECOND, t1.created_at, t2.created_at) AS seconds_apart
FROM transactions t1
JOIN transactions t2
    ON t1.sender_id = t2.sender_id
    AND t1.recipient_id = t2.recipient_id
    AND t1.amount = t2.amount
    AND t1.txn_id != t2.txn_id
    AND TIMESTAMPDIFF(SECOND, t1.created_at, t2.created_at) BETWEEN 1 AND 60
WHERE
    t1.type = 'e-transfer'
    AND t1.status = 'completed'
ORDER BY original_time DESC;


-- Query 5: Session expiry validation
-- Identifies sessions that remained active beyond the 10-minute inactivity threshold
-- Validates REQ-SEC-01 session timeout enforcement
SELECT
    session_id,
    user_id,
    created_at,
    last_active_at,
    expired_at,
    TIMESTAMPDIFF(MINUTE, last_active_at, expired_at) AS minutes_active_after_last_action
FROM sessions
WHERE
    status = 'expired'
    AND TIMESTAMPDIFF(MINUTE, last_active_at, expired_at) > 10
ORDER BY minutes_active_after_last_action DESC;


-- Query 6: Orphaned transactions
-- Identifies transactions with no matching user record
-- Indicates data integrity failure in user-transaction relationship
SELECT
    t.txn_id,
    t.sender_id,
    t.amount,
    t.status,
    t.created_at
FROM transactions t
LEFT JOIN users u ON t.sender_id = u.user_id
WHERE u.user_id IS NULL;


-- Query 7: Account limit reset validation
-- Confirms daily limits were reset at midnight for all active users
-- Validates REQ-ETR-04 daily limit reset logic
SELECT
    u.user_id,
    u.name,
    al.daily_limit,
    al.remaining_limit,
    al.last_reset_at,
    DATE(al.last_reset_at) AS reset_date
FROM users u
JOIN account_limits al ON u.user_id = al.user_id
WHERE
    DATE(al.last_reset_at) < CURDATE()
    AND al.remaining_limit != al.daily_limit
ORDER BY al.last_reset_at ASC;


-- Query 8: NULL mandatory field check
-- Identifies user records with missing mandatory fields
-- Validates data completeness and registration flow integrity
SELECT
    user_id,
    name,
    email,
    dob,
    kyc_status,
    created_at
FROM users
WHERE
    name IS NULL
    OR email IS NULL
    OR dob IS NULL
    OR kyc_status IS NULL
ORDER BY created_at DESC;


-- Query 9: Transaction status summary
-- Provides a count of transactions by status for current test cycle
-- Use to verify expected transaction states after test execution
SELECT
    status,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_amount,
    MIN(amount) AS min_amount,
    MAX(amount) AS max_amount,
    AVG(amount) AS avg_amount
FROM transactions
GROUP BY status
ORDER BY transaction_count DESC;


-- Query 10: Full audit trail check
-- Confirms every completed transaction has a corresponding audit log entry
-- Validates audit readiness and traceability requirements
SELECT
    t.txn_id,
    t.sender_id,
    t.amount,
    t.status,
    t.created_at,
    a.alert_id,
    a.alert_type
FROM transactions t
LEFT JOIN aml_alerts a ON t.txn_id = a.txn_id
WHERE
    t.status = 'completed'
    AND t.amount >= 1000
    AND a.alert_id IS NULL
ORDER BY t.amount DESC;
