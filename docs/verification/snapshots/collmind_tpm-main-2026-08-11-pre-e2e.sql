--
-- PostgreSQL database dump
--

\restrict 8tgTntaYoU7Hunrfk6w8UarcJ6YiTTgLOW18fGos4xrdFPR3hp7O29mxbsJkrYy

-- Dumped from database version 16.13 (Debian 16.13-1.pgdg13+1)
-- Dumped by pg_dump version 16.13 (Debian 16.13-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: main; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA main;


--
-- Name: admin_audit_logs_result_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.admin_audit_logs_result_enum AS ENUM (
    'SUCCESS',
    'FAILURE'
);


--
-- Name: agreements_agreement_status_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.agreements_agreement_status_enum AS ENUM (
    'DRAFT',
    'PENDING',
    'APPROVED',
    'ACTIVE',
    'CLOSED',
    'REJECTED',
    'CANCELLED'
);


--
-- Name: agreements_agreement_type_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.agreements_agreement_type_enum AS ENUM (
    'STA',
    'LTA'
);


--
-- Name: agreements_mechanic_type_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.agreements_mechanic_type_enum AS ENUM (
    'PERCENT',
    'AMOUNT',
    'AMOUNT_PER_UNIT'
);


--
-- Name: agreements_reconciliation_period_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.agreements_reconciliation_period_enum AS ENUM (
    'WEEKLY',
    'MONTHLY',
    'QUARTERLY',
    'YEARLY'
);


--
-- Name: agreements_spend_type_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.agreements_spend_type_enum AS ENUM (
    'ON_INVOICE',
    'OFF_INVOICE',
    'BOTH'
);


--
-- Name: approval_requests_request_type_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.approval_requests_request_type_enum AS ENUM (
    'AGREEMENT',
    'BUDGET_TRANSFER',
    'IMPORT_BATCH',
    'OTHER',
    'PLAN'
);


--
-- Name: approval_requests_status_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.approval_requests_status_enum AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED',
    'CANCELLED'
);


--
-- Name: budget_alert_configurations_alert_level_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.budget_alert_configurations_alert_level_enum AS ENUM (
    'warning_80',
    'critical_95',
    'exceeded_100'
);


--
-- Name: budget_alert_configurations_notification_channel_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.budget_alert_configurations_notification_channel_enum AS ENUM (
    'email',
    'in_app',
    'sms'
);


--
-- Name: budget_allocations_period_type_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.budget_allocations_period_type_enum AS ENUM (
    'yearly',
    'quarterly',
    'monthly'
);


--
-- Name: budget_envelopes_status_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.budget_envelopes_status_enum AS ENUM (
    'DRAFT',
    'ACTIVE',
    'CLOSED',
    'ARCHIVED'
);


--
-- Name: budget_reservations_status_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.budget_reservations_status_enum AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED',
    'COMMITTED',
    'CANCELLED'
);


--
-- Name: budget_spend_type_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.budget_spend_type_enum AS ENUM (
    'ON_INVOICE',
    'OFF_INVOICE'
);


--
-- Name: budget_transaction_logs_transaction_type_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.budget_transaction_logs_transaction_type_enum AS ENUM (
    'allocation',
    'utilization',
    'release',
    'adjustment',
    'transfer',
    'reservation',
    'commit'
);


--
-- Name: budget_transactions_source_type_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.budget_transactions_source_type_enum AS ENUM (
    'AGREEMENT',
    'PLAN',
    'MANUAL',
    'TRANSFER',
    'ADJUSTMENT'
);


--
-- Name: budget_transactions_tx_status_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.budget_transactions_tx_status_enum AS ENUM (
    'PENDING',
    'POSTED',
    'CANCELLED'
);


--
-- Name: budget_transactions_tx_type_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.budget_transactions_tx_type_enum AS ENUM (
    'ALLOCATE',
    'COMMIT',
    'RESERVE',
    'RELEASE',
    'TRANSFER',
    'ADJUST'
);


--
-- Name: cpls_status_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.cpls_status_enum AS ENUM (
    'PENDING',
    'ACTIVE',
    'SUSPENDED',
    'DELETED'
);


--
-- Name: customers_channel_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.customers_channel_enum AS ENUM (
    'NKA',
    'TRADITIONAL_TRADE',
    'E_COMMERCE',
    'EXPORT',
    'WHOLESALE',
    'RETAIL',
    'HORECA',
    'DISTRIBUTOR'
);


--
-- Name: customers_status_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.customers_status_enum AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'PENDING',
    'SUSPENDED'
);


--
-- Name: customers_type_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.customers_type_enum AS ENUM (
    'DIRECT',
    'DISTRIBUTOR',
    'WHOLESALER',
    'RETAILER',
    'END_CUSTOMER'
);


--
-- Name: kpis_aggregation_method_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.kpis_aggregation_method_enum AS ENUM (
    'sum',
    'avg',
    'min',
    'max',
    'weighted_avg'
);


--
-- Name: kpis_calculation_level_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.kpis_calculation_level_enum AS ENUM (
    'sku',
    'fu',
    'plan'
);


--
-- Name: kpis_display_format_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.kpis_display_format_enum AS ENUM (
    'number',
    'currency',
    'percentage'
);


--
-- Name: kpis_formula_type_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.kpis_formula_type_enum AS ENUM (
    'expression',
    'conditional',
    'user_input',
    'external',
    'javascript'
);


--
-- Name: ledger_entries_entry_direction_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.ledger_entries_entry_direction_enum AS ENUM (
    'DEBIT',
    'CREDIT'
);


--
-- Name: ledger_entries_spend_type_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.ledger_entries_spend_type_enum AS ENUM (
    'ON_INVOICE',
    'OFF_INVOICE',
    'ADJUSTMENT',
    'ACCRUAL'
);


--
-- Name: lta_agreements_status_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.lta_agreements_status_enum AS ENUM (
    'draft',
    'active',
    'expired',
    'terminated'
);


--
-- Name: mechanic_spend_breakdown_distribution_basis_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.mechanic_spend_breakdown_distribution_basis_enum AS ENUM (
    'base_volume_ratio',
    'planned_volume_ratio',
    'equal'
);


--
-- Name: mechanics_budget_type_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.mechanics_budget_type_enum AS ENUM (
    'on_invoice',
    'off_invoice',
    'both',
    'none'
);


--
-- Name: mechanics_category_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.mechanics_category_enum AS ENUM (
    'on_invoice_discount',
    'off_invoice_discount',
    'per_unit_support',
    'lumpsum_spend',
    'long_term_agreement'
);


--
-- Name: mechanics_formula_validation_status_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.mechanics_formula_validation_status_enum AS ENUM (
    'pending',
    'valid',
    'invalid',
    'error'
);


--
-- Name: mechanics_input_type_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.mechanics_input_type_enum AS ENUM (
    'percentage',
    'currency',
    'units',
    'boolean'
);


--
-- Name: mechanics_mechanic_type_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.mechanics_mechanic_type_enum AS ENUM (
    'PERCENT',
    'AMOUNT',
    'AMOUNT_PER_UNIT'
);


--
-- Name: mechanics_spending_type_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.mechanics_spending_type_enum AS ENUM (
    'on_invoice',
    'off_invoice',
    'both'
);


--
-- Name: notifications_channel_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.notifications_channel_enum AS ENUM (
    'EMAIL',
    'IN_APP',
    'SMS'
);


--
-- Name: notifications_priority_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.notifications_priority_enum AS ENUM (
    'LOW',
    'MEDIUM',
    'HIGH'
);


--
-- Name: notifications_status_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.notifications_status_enum AS ENUM (
    'PENDING',
    'SENT',
    'DELIVERED',
    'FAILED',
    'READ'
);


--
-- Name: notifications_type_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.notifications_type_enum AS ENUM (
    'APPROVAL_REQUESTED',
    'APPROVAL_GRANTED',
    'APPROVAL_REJECTED',
    'BUDGET_ALERT_80',
    'BUDGET_ALERT_100',
    'AGREEMENT_EXPIRING'
);


--
-- Name: on_invoice_batch_status_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.on_invoice_batch_status_enum AS ENUM (
    'PENDING',
    'VALIDATING',
    'VALIDATED',
    'PROCESSING',
    'COMPLETED',
    'FAILED'
);


--
-- Name: on_invoice_discount_type_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.on_invoice_discount_type_enum AS ENUM (
    'CPP_ON',
    'LTA_ON',
    'PROMO_DISCOUNT'
);


--
-- Name: on_invoice_entry_status_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.on_invoice_entry_status_enum AS ENUM (
    'PENDING',
    'VALIDATED',
    'POSTED',
    'ERROR'
);


--
-- Name: plan_approval_history_action_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.plan_approval_history_action_enum AS ENUM (
    'SUBMITTED',
    'APPROVED',
    'REJECTED',
    'REQUEST_CHANGES',
    'ESCALATED',
    'RETURNED_TO_DRAFT',
    'BUDGET_RESERVED',
    'BUDGET_RELEASED',
    'BUDGET_COMMITTED'
);


--
-- Name: plan_mechanic_values_distribution_method_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.plan_mechanic_values_distribution_method_enum AS ENUM (
    'percentage',
    'per_unit',
    'lumpsum',
    'proportional'
);


--
-- Name: plans_plan_status_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.plans_plan_status_enum AS ENUM (
    'DRAFT',
    'PENDING_APPROVAL',
    'APPROVED',
    'REJECTED',
    'PENDING_FINANCE_REVIEW'
);


--
-- Name: sales_actual_batches_source_type_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.sales_actual_batches_source_type_enum AS ENUM (
    'FILE_UPLOAD',
    'SEED'
);


--
-- Name: sales_actual_batches_status_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.sales_actual_batches_status_enum AS ENUM (
    'ACTIVE',
    'REPLACED'
);


--
-- Name: tactics_spend_type_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.tactics_spend_type_enum AS ENUM (
    'ON_INVOICE',
    'OFF_INVOICE',
    'BOTH'
);


--
-- Name: tactics_tactic_type_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.tactics_tactic_type_enum AS ENUM (
    'DISCOUNT',
    'LUMP_SUM',
    'VOLUME_REBATE',
    'CO_OP',
    'LISTING_FEE',
    'OTHER'
);


--
-- Name: tenants_plan_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.tenants_plan_enum AS ENUM (
    'FREE',
    'BASIC',
    'PROFESSIONAL',
    'ENTERPRISE'
);


--
-- Name: tenants_status_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.tenants_status_enum AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'SUSPENDED',
    'TRIAL'
);


--
-- Name: users_role_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.users_role_enum AS ENUM (
    'ADMIN',
    'PLANNER',
    'APPROVER',
    'FINANCE',
    'FINANCE_MANAGER',
    'CATEGORY_MANAGER',
    'MANAGER',
    'READONLY'
);


--
-- Name: users_status_enum; Type: TYPE; Schema: main; Owner: -
--

CREATE TYPE main.users_status_enum AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'PENDING',
    'LOCKED'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _t019_backfilled_tx; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main._t019_backfilled_tx (
    tx_id uuid NOT NULL
);


--
-- Name: admin_audit_logs; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.admin_audit_logs (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    admin_id uuid NOT NULL,
    admin_email character varying(200) NOT NULL,
    action_type character varying(50) NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id uuid,
    ip_address character varying(45),
    result main.admin_audit_logs_result_enum NOT NULL,
    before_values jsonb,
    after_values jsonb,
    justification text,
    is_high_risk boolean DEFAULT false NOT NULL,
    alert_sent boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: agreement_transactions; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.agreement_transactions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    agreement_id uuid NOT NULL,
    invoice_no character varying(100) NOT NULL,
    invoice_date date NOT NULL,
    amount numeric(18,2) NOT NULL,
    currency character varying(3) DEFAULT 'TRY'::character varying NOT NULL,
    cpl_id uuid,
    batch_id uuid,
    row_number integer,
    idempotency_key character varying(200) NOT NULL,
    notes text,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid,
    fiscal_period character varying(7),
    is_reversed boolean DEFAULT false NOT NULL
);


--
-- Name: COLUMN agreement_transactions.fiscal_period; Type: COMMENT; Schema: main; Owner: -
--

COMMENT ON COLUMN main.agreement_transactions.fiscal_period IS 'Fiscal period in YYYY-MM format, used for budget deduction';


--
-- Name: agreements; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.agreements (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    agreement_code character varying(50) NOT NULL,
    agreement_name character varying(200),
    agreement_type main.agreements_agreement_type_enum NOT NULL,
    cpl_id uuid NOT NULL,
    region_id uuid,
    gu_id uuid,
    fu_id uuid,
    sku_scope character varying(20) DEFAULT 'FU'::character varying NOT NULL,
    tactic_id uuid NOT NULL,
    mechanic_id uuid NOT NULL,
    mechanic_value numeric(18,4),
    mechanic_type main.agreements_mechanic_type_enum,
    currency character varying(3) DEFAULT 'TRY'::character varying NOT NULL,
    cap_total_amount numeric(18,2) NOT NULL,
    spend_type main.agreements_spend_type_enum,
    start_date date NOT NULL,
    end_date date NOT NULL,
    period_month character varying(7) NOT NULL,
    justification text NOT NULL,
    status main.agreements_agreement_status_enum DEFAULT 'DRAFT'::main.agreements_agreement_status_enum NOT NULL,
    approval_request_id uuid,
    approved_at timestamp without time zone,
    approved_by uuid,
    rejected_at timestamp without time zone,
    rejected_by uuid,
    rejection_reason text,
    consumed_amount numeric(18,2) DEFAULT 0 NOT NULL,
    current_price numeric(18,2),
    expected_price numeric(18,2),
    competitor_price numeric(18,2),
    competitor_name character varying(200),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid,
    description text,
    category_id uuid,
    reconciliation_period main.agreements_reconciliation_period_enum,
    notes text,
    channel_id uuid,
    additional_params jsonb,
    kpi_results jsonb,
    closed_at timestamp without time zone,
    closed_by uuid,
    version integer DEFAULT 1 NOT NULL
);


--
-- Name: approval_requests; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.approval_requests (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    request_type main.approval_requests_request_type_enum NOT NULL,
    entity_type character varying(50) NOT NULL,
    entity_id uuid NOT NULL,
    requested_by_id uuid NOT NULL,
    requested_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    approval_policy_id uuid,
    approval_levels jsonb,
    current_level integer DEFAULT 1 NOT NULL,
    status main.approval_requests_status_enum DEFAULT 'PENDING'::main.approval_requests_status_enum NOT NULL,
    approved_at timestamp without time zone,
    approved_by_id uuid,
    rejected_at timestamp without time zone,
    rejected_by_id uuid,
    rejection_reason text,
    cancelled_at timestamp without time zone,
    cancelled_by_id uuid,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid
);


--
-- Name: brands; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.brands (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid
);


--
-- Name: budget_alert_configurations; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.budget_alert_configurations (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    alert_level main.budget_alert_configurations_alert_level_enum NOT NULL,
    notification_channels jsonb NOT NULL,
    escalation_rules jsonb,
    is_active boolean DEFAULT true NOT NULL,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid,
    threshold_percent numeric(5,2) NOT NULL,
    CONSTRAINT "CHK_BUDGET_ALERT_CONFIG_THRESHOLD_PERCENT_RANGE" CHECK (((threshold_percent > (0)::numeric) AND (threshold_percent <= (100)::numeric)))
);


--
-- Name: budget_allocations; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.budget_allocations (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid,
    period_type main.budget_allocations_period_type_enum NOT NULL,
    period_start date NOT NULL,
    period_end date NOT NULL,
    fiscal_year integer NOT NULL,
    cpl_id uuid,
    channel character varying(50),
    category character varying(100),
    on_invoice_budget numeric(15,2) DEFAULT 0 NOT NULL,
    off_invoice_budget numeric(15,2) DEFAULT 0 NOT NULL,
    on_invoice_utilized numeric(15,2) DEFAULT 0 NOT NULL,
    off_invoice_utilized numeric(15,2) DEFAULT 0 NOT NULL,
    on_invoice_reserved numeric(15,2) DEFAULT 0 NOT NULL,
    off_invoice_reserved numeric(15,2) DEFAULT 0 NOT NULL,
    alert_threshold_80 boolean DEFAULT true NOT NULL,
    alert_threshold_95 boolean DEFAULT true NOT NULL,
    alert_threshold_100 boolean DEFAULT true NOT NULL,
    alert_recipients jsonb,
    hard_limit_mode boolean DEFAULT false NOT NULL,
    allow_carry_forward boolean DEFAULT false NOT NULL,
    total_budget numeric(15,2) GENERATED ALWAYS AS ((on_invoice_budget + off_invoice_budget)) STORED NOT NULL,
    on_invoice_available numeric(15,2) GENERATED ALWAYS AS (((on_invoice_budget - on_invoice_utilized) - on_invoice_reserved)) STORED NOT NULL,
    off_invoice_available numeric(15,2) GENERATED ALWAYS AS (((off_invoice_budget - off_invoice_utilized) - off_invoice_reserved)) STORED NOT NULL,
    metadata jsonb
);


--
-- Name: budget_envelopes; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.budget_envelopes (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    code character varying(100) NOT NULL,
    name character varying(200) NOT NULL,
    fiscal_year character varying(10) NOT NULL,
    period character varying(50) NOT NULL,
    allocated_amount numeric(15,2) NOT NULL,
    consumed_amount numeric(15,2) DEFAULT 0 NOT NULL,
    available_amount numeric(15,2) NOT NULL,
    status main.budget_envelopes_status_enum DEFAULT 'DRAFT'::main.budget_envelopes_status_enum NOT NULL,
    budget_owner_id uuid,
    budget_owner_email character varying(200),
    budget_owner_name character varying(200),
    currency character varying(3) DEFAULT 'TRY'::character varying NOT NULL,
    description text,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid,
    channel character varying(50),
    category character varying(100),
    channel_id uuid,
    category_id uuid,
    spend_type main.budget_spend_type_enum
);


--
-- Name: budget_reservations; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.budget_reservations (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    envelope_id uuid NOT NULL,
    agreement_id uuid,
    agreement_name character varying(200),
    reserved_amount numeric(15,2) NOT NULL,
    status main.budget_reservations_status_enum DEFAULT 'PENDING'::main.budget_reservations_status_enum NOT NULL,
    requested_by_id uuid NOT NULL,
    requested_by_email character varying(200) NOT NULL,
    requested_by_name character varying(200) NOT NULL,
    approved_by_id uuid,
    approved_at timestamp without time zone,
    rejected_reason text,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid
);


--
-- Name: budget_transaction_logs; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.budget_transaction_logs (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    budget_allocation_id uuid NOT NULL,
    transaction_type main.budget_transaction_logs_transaction_type_enum NOT NULL,
    on_invoice_amount numeric(15,2) DEFAULT 0 NOT NULL,
    off_invoice_amount numeric(15,2) DEFAULT 0 NOT NULL,
    plan_id uuid,
    description text,
    created_by uuid,
    idempotency_key character varying(200),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    updated_by uuid
);


--
-- Name: budget_transactions; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.budget_transactions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    envelope_id uuid NOT NULL,
    tx_type main.budget_transactions_tx_type_enum NOT NULL,
    tx_status main.budget_transactions_tx_status_enum DEFAULT 'POSTED'::main.budget_transactions_tx_status_enum NOT NULL,
    source_type main.budget_transactions_source_type_enum,
    source_id uuid,
    amount numeric(18,2) NOT NULL,
    currency character varying(3) DEFAULT 'TRY'::character varying NOT NULL,
    idempotency_key character varying(200) NOT NULL,
    description text,
    notes text,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid,
    spend_type main.budget_spend_type_enum
);


--
-- Name: categories; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.categories (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    parent_category_id uuid,
    level integer DEFAULT 1 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid
);


--
-- Name: channels; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.channels (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    subchannel character varying(50),
    sort_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid
);


--
-- Name: cpls; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.cpls (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    channel_id uuid NOT NULL,
    region_id uuid,
    city character varying(100),
    country character varying(100),
    contact_person character varying(200),
    contact_email character varying(255),
    contact_phone character varying(50),
    customer_tier character varying(50),
    is_vip boolean DEFAULT false NOT NULL,
    annual_revenue numeric(15,2),
    status main.cpls_status_enum DEFAULT 'ACTIVE'::main.cpls_status_enum NOT NULL,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid
);


--
-- Name: customers; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.customers (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    channel main.customers_channel_enum NOT NULL,
    type main.customers_type_enum DEFAULT 'DIRECT'::main.customers_type_enum NOT NULL,
    status main.customers_status_enum DEFAULT 'ACTIVE'::main.customers_status_enum NOT NULL,
    city character varying(100),
    district character varying(100),
    region character varying(100),
    country character varying(100),
    address text,
    postal_code character varying(20),
    tax_number character varying(50),
    tax_office character varying(100),
    company_registration_number character varying(50),
    contact_person character varying(200),
    contact_email character varying(255),
    contact_phone character varying(50),
    contact_mobile character varying(50),
    payment_terms character varying(50),
    credit_limit numeric(15,2),
    currency character varying(3) DEFAULT 'TRY'::character varying NOT NULL,
    sales_representative character varying(200),
    account_manager character varying(200),
    customer_group character varying(100),
    customer_segment character varying(100),
    customer_tier character varying(50),
    business_size character varying(50),
    annual_revenue numeric(15,2),
    last_order_date date,
    first_order_date date,
    total_orders integer DEFAULT 0 NOT NULL,
    metadata jsonb,
    notes text,
    is_vip boolean DEFAULT false NOT NULL,
    contract_start_date date,
    contract_end_date date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid,
    number_of_branches integer,
    cpl_id uuid
);


--
-- Name: forecasting_units; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.forecasting_units (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    gu_id uuid NOT NULL,
    size character varying(20),
    segment character varying(50),
    is_plannable boolean DEFAULT true NOT NULL,
    default_base_volume numeric(18,3),
    base_price numeric(18,4),
    currency character varying(3) DEFAULT 'TRY'::character varying NOT NULL,
    unit_of_measure character varying(20),
    is_active boolean DEFAULT true NOT NULL,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid
);


--
-- Name: generic_units; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.generic_units (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    brand_id uuid NOT NULL,
    category_id uuid NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid
);


--
-- Name: kpis; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.kpis (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    kpi_code character varying(50) NOT NULL,
    kpi_name character varying(200) NOT NULL,
    kpi_group character varying(100) NOT NULL,
    kpi_description text,
    formula_type main.kpis_formula_type_enum NOT NULL,
    formula_text text NOT NULL,
    depends_on_kpis jsonb,
    calculation_order integer NOT NULL,
    calculation_level main.kpis_calculation_level_enum NOT NULL,
    display_format main.kpis_display_format_enum NOT NULL,
    decimal_places integer DEFAULT 2 NOT NULL,
    show_in_grid boolean DEFAULT true NOT NULL,
    column_order integer,
    aggregation_method_fu main.kpis_aggregation_method_enum,
    rag_green_threshold numeric(18,4),
    rag_amber_threshold numeric(18,4),
    is_active boolean DEFAULT true NOT NULL,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid,
    version integer DEFAULT 1 NOT NULL,
    CONSTRAINT "CHK_KPIS_CALCULATION_ORDER" CHECK (((calculation_order > 0) AND (calculation_order <= 50)))
);


--
-- Name: ledger_entries; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.ledger_entries (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    source_type character varying(50) NOT NULL,
    source_id uuid NOT NULL,
    agreement_id uuid,
    spend_type main.ledger_entries_spend_type_enum NOT NULL,
    entry_direction main.ledger_entries_entry_direction_enum DEFAULT 'DEBIT'::main.ledger_entries_entry_direction_enum NOT NULL,
    amount numeric(18,2) NOT NULL,
    currency character varying(3) DEFAULT 'TRY'::character varying NOT NULL,
    period_month character varying(7) NOT NULL,
    posting_date date NOT NULL,
    channel character varying(30),
    cpl_id uuid,
    fu_id uuid,
    tactic_id uuid,
    mechanic_id uuid,
    budget_envelope_id uuid,
    idempotency_key character varying(200) NOT NULL,
    description text,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid,
    reverses_entry_id uuid,
    is_reversed boolean DEFAULT false NOT NULL
);


--
-- Name: lta_agreements; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.lta_agreements (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    cpl_id uuid NOT NULL,
    effective_date date NOT NULL,
    expiry_date date,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid,
    agreement_name character varying(200) NOT NULL,
    agreement_code character varying(100) NOT NULL,
    status main.lta_agreements_status_enum DEFAULT 'draft'::main.lta_agreements_status_enum NOT NULL,
    total_agreement_value numeric(18,2),
    notes text
);


--
-- Name: lta_plan_overrides; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.lta_plan_overrides (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    plan_id uuid NOT NULL,
    lta_rate_id uuid NOT NULL,
    lta_agreement_id uuid NOT NULL,
    override_on_invoice_pct numeric(5,2),
    override_off_invoice_pct numeric(5,2),
    override_reason text,
    approved_by uuid,
    approved_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid
);


--
-- Name: lta_rates; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.lta_rates (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    lta_agreement_id uuid NOT NULL,
    channel_id uuid,
    channel character varying(100) NOT NULL,
    category_id uuid,
    category character varying(100) NOT NULL,
    on_invoice_percentage numeric(5,2) NOT NULL,
    off_invoice_percentage numeric(5,2) NOT NULL,
    minimum_volume_commitment numeric(18,3),
    maximum_discount_cap numeric(18,2),
    payment_terms character varying(50),
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid
);


--
-- Name: mechanic_spend_breakdown; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.mechanic_spend_breakdown (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    plan_sku_id uuid NOT NULL,
    mechanic_id uuid NOT NULL,
    plan_mechanic_value_id uuid NOT NULL,
    calculated_amount numeric(18,2) DEFAULT 0 NOT NULL,
    distribution_basis main.mechanic_spend_breakdown_distribution_basis_enum,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid
);


--
-- Name: mechanics; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.mechanics (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    tactic_id uuid NOT NULL,
    mechanic_type main.mechanics_mechanic_type_enum NOT NULL,
    calculation_rules jsonb,
    min_value numeric(18,4),
    max_value numeric(18,4),
    is_active boolean DEFAULT true NOT NULL,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid,
    spending_type main.mechanics_spending_type_enum,
    calculation_formula text,
    applicability_rules jsonb,
    input_constraints jsonb,
    category main.mechanics_category_enum,
    input_type main.mechanics_input_type_enum,
    default_value numeric(18,4),
    step_increment numeric(18,4),
    decimal_places integer,
    unit_symbol character varying(10),
    formula_variables jsonb,
    formula_validation_status main.mechanics_formula_validation_status_enum DEFAULT 'pending'::main.mechanics_formula_validation_status_enum NOT NULL,
    test_data jsonb,
    applicable_channels jsonb,
    applicable_categories jsonb,
    applicable_cpls uuid[],
    exclusion_rules jsonb,
    show_in_grid boolean DEFAULT true NOT NULL,
    grid_column_order integer,
    grid_column_width integer,
    group_header character varying(100),
    track_against_budget boolean DEFAULT true NOT NULL,
    budget_type main.mechanics_budget_type_enum,
    requires_approval_threshold numeric(18,2),
    approval_flow jsonb,
    mutually_exclusive_with text[],
    max_combined_discount_percentage numeric(5,2),
    combination_warnings jsonb
);


--
-- Name: migrations; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.migrations (
    id integer NOT NULL,
    "timestamp" bigint NOT NULL,
    name character varying NOT NULL
);


--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: main; Owner: -
--

CREATE SEQUENCE main.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: main; Owner: -
--

ALTER SEQUENCE main.migrations_id_seq OWNED BY main.migrations.id;


--
-- Name: notifications; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.notifications (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    type main.notifications_type_enum NOT NULL,
    recipient_id uuid NOT NULL,
    recipient_email character varying(200) NOT NULL,
    recipient_name character varying(200),
    channel main.notifications_channel_enum DEFAULT 'IN_APP'::main.notifications_channel_enum NOT NULL,
    priority main.notifications_priority_enum DEFAULT 'MEDIUM'::main.notifications_priority_enum NOT NULL,
    status main.notifications_status_enum DEFAULT 'PENDING'::main.notifications_status_enum NOT NULL,
    subject character varying(500) NOT NULL,
    body text NOT NULL,
    metadata jsonb,
    sent_at timestamp without time zone,
    read_at timestamp without time zone,
    expires_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid
);


--
-- Name: on_invoice_batches; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.on_invoice_batches (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    batch_code character varying(100) NOT NULL,
    status main.on_invoice_batch_status_enum DEFAULT 'PENDING'::main.on_invoice_batch_status_enum NOT NULL,
    fiscal_period character varying(7) NOT NULL,
    total_rows integer DEFAULT 0 NOT NULL,
    valid_rows integer DEFAULT 0 NOT NULL,
    error_rows integer DEFAULT 0 NOT NULL,
    total_discount_amount numeric(18,2) DEFAULT 0 NOT NULL,
    affected_envelopes_count integer DEFAULT 0 NOT NULL,
    file_name character varying(255),
    file_size integer,
    validation_summary jsonb,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid
);


--
-- Name: on_invoice_entries; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.on_invoice_entries (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    batch_id uuid NOT NULL,
    invoice_no character varying(100) NOT NULL,
    invoice_date date NOT NULL,
    fiscal_period character varying(7) NOT NULL,
    customer_id uuid NOT NULL,
    customer_code character varying(50) NOT NULL,
    sku_id uuid NOT NULL,
    sku_code character varying(50) NOT NULL,
    quantity numeric(18,3) NOT NULL,
    list_price numeric(18,4) NOT NULL,
    actual_price numeric(18,4) NOT NULL,
    discount numeric(18,2) NOT NULL,
    discount_type main.on_invoice_discount_type_enum NOT NULL,
    currency character varying(3) DEFAULT 'TRY'::character varying NOT NULL,
    status main.on_invoice_entry_status_enum DEFAULT 'PENDING'::main.on_invoice_entry_status_enum NOT NULL,
    validation_status character varying(20),
    validation_errors jsonb,
    row_number integer NOT NULL,
    budget_envelope_id uuid,
    idempotency_key character varying(200) NOT NULL,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid
);


--
-- Name: plan_approval_history; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.plan_approval_history (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    plan_id uuid NOT NULL,
    action main.plan_approval_history_action_enum NOT NULL,
    actioned_by uuid NOT NULL,
    comments text,
    rejection_reason text,
    escalation_reason text,
    specific_changes jsonb,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid
);


--
-- Name: plan_fus; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.plan_fus (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    plan_id uuid NOT NULL,
    fu_id uuid NOT NULL,
    tactics jsonb,
    total_planned_volume numeric(18,3) DEFAULT 0 NOT NULL,
    total_spend numeric(18,2) DEFAULT 0 NOT NULL,
    total_gp numeric(18,2) DEFAULT 0 NOT NULL,
    gp_roi numeric(18,4),
    rag_status character varying(10),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid NOT NULL,
    updated_by uuid,
    calculated_kpis jsonb,
    version integer DEFAULT 1 NOT NULL
);


--
-- Name: plan_mechanic_values; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.plan_mechanic_values (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    plan_fu_id uuid NOT NULL,
    mechanic_id uuid NOT NULL,
    calculated_spend numeric(18,2) DEFAULT 0 NOT NULL,
    on_invoice_amount numeric(18,2) DEFAULT 0 NOT NULL,
    off_invoice_amount numeric(18,2) DEFAULT 0 NOT NULL,
    distribution_method main.plan_mechanic_values_distribution_method_enum,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid,
    entered_rate_pct numeric(9,4),
    entered_unit_amount numeric(18,4),
    entered_total_amount numeric(18,2),
    CONSTRAINT chk_pmv_at_most_one_entered CHECK ((((((entered_rate_pct IS NOT NULL))::integer + ((entered_unit_amount IS NOT NULL))::integer) + ((entered_total_amount IS NOT NULL))::integer) <= 1)),
    CONSTRAINT chk_pmv_rate_range CHECK (((entered_rate_pct IS NULL) OR ((entered_rate_pct >= (0)::numeric) AND (entered_rate_pct <= (100)::numeric))))
);


--
-- Name: COLUMN plan_mechanic_values.entered_rate_pct; Type: COMMENT; Schema: main; Owner: -
--

COMMENT ON COLUMN main.plan_mechanic_values.entered_rate_pct IS 'Rate in percent notation (0-100), numeric(9,4). ADR 0007 Karar 5. Runtime type: RateMicro.';


--
-- Name: COLUMN plan_mechanic_values.entered_unit_amount; Type: COMMENT; Schema: main; Owner: -
--

COMMENT ON COLUMN main.plan_mechanic_values.entered_unit_amount IS 'TRY per unit (PER_UNIT_SUPPORT). Price scale, not money scale. ADR 0007 Karar 4.';


--
-- Name: COLUMN plan_mechanic_values.entered_total_amount; Type: COMMENT; Schema: main; Owner: -
--

COMMENT ON COLUMN main.plan_mechanic_values.entered_total_amount IS 'TRY total (LUMPSUM_SPEND). Money scale. ADR 0007 Karar 4. Runtime type: MoneyMinor.';


--
-- Name: plan_skus; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.plan_skus (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    plan_fu_id uuid NOT NULL,
    sku_id uuid NOT NULL,
    base_volume numeric(18,3),
    planned_volume numeric(18,3),
    incremental_volume numeric(18,3) DEFAULT 0 NOT NULL,
    planned_turnover numeric(18,2) DEFAULT 0,
    tactic_spend numeric(18,2) DEFAULT 0 NOT NULL,
    planned_gp numeric(18,2) DEFAULT 0,
    gp_roi numeric(18,4),
    rag_status character varying(10),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid NOT NULL,
    updated_by uuid,
    base_lta_on_invoice_spend numeric(18,2) DEFAULT 0 NOT NULL,
    base_lta_off_invoice_spend numeric(18,2) DEFAULT 0 NOT NULL,
    planned_lta_on_invoice_spend numeric(18,2) DEFAULT 0 NOT NULL,
    planned_lta_off_invoice_spend numeric(18,2) DEFAULT 0 NOT NULL,
    promo_on_invoice_spend numeric(18,2) DEFAULT 0 NOT NULL,
    promo_off_invoice_spend numeric(18,2) DEFAULT 0 NOT NULL,
    calculated_kpis jsonb,
    version integer DEFAULT 1 NOT NULL
);


--
-- Name: plans; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.plans (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    plan_code character varying(50) NOT NULL,
    plan_name character varying(200) NOT NULL,
    description text,
    cpl_id uuid NOT NULL,
    channel_id uuid NOT NULL,
    region_id uuid,
    category_id uuid NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    period_month character varying(7) NOT NULL,
    status main.plans_plan_status_enum DEFAULT 'DRAFT'::main.plans_plan_status_enum NOT NULL,
    approval_request_id uuid,
    approved_at timestamp without time zone,
    approved_by uuid,
    rejected_at timestamp without time zone,
    rejected_by uuid,
    rejection_reason text,
    comments text,
    total_planned_volume numeric(18,3) DEFAULT 0 NOT NULL,
    total_spend numeric(18,2) DEFAULT 0 NOT NULL,
    total_gp numeric(18,2) DEFAULT 0 NOT NULL,
    overall_roi numeric(18,4),
    rag_status character varying(10),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid NOT NULL,
    updated_by uuid,
    submission_notes text,
    submitted_at timestamp without time zone,
    submitted_by uuid,
    pending_finance_review boolean DEFAULT false NOT NULL,
    escalation_reason text,
    escalated_at timestamp without time zone,
    escalated_by uuid,
    on_invoice_spend numeric(18,2) DEFAULT 0 NOT NULL,
    off_invoice_spend numeric(18,2) DEFAULT 0 NOT NULL,
    version integer DEFAULT 1 NOT NULL
);


--
-- Name: regions; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.regions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    parent_region_id uuid,
    level integer DEFAULT 1 NOT NULL,
    country character varying(100),
    is_active boolean DEFAULT true NOT NULL,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid
);


--
-- Name: sales_actual_batches; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.sales_actual_batches (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    fiscal_period character varying(7) NOT NULL,
    cpl_id uuid NOT NULL,
    category_id uuid NOT NULL,
    channel_id uuid NOT NULL,
    status main.sales_actual_batches_status_enum DEFAULT 'ACTIVE'::main.sales_actual_batches_status_enum NOT NULL,
    source_type main.sales_actual_batches_source_type_enum DEFAULT 'FILE_UPLOAD'::main.sales_actual_batches_source_type_enum NOT NULL,
    file_name character varying(255),
    file_hash character(64) NOT NULL,
    total_rows integer DEFAULT 0 NOT NULL,
    valid_rows integer DEFAULT 0 NOT NULL,
    error_rows integer DEFAULT 0 NOT NULL,
    gross_total numeric(18,2) DEFAULT 0 NOT NULL,
    net_total numeric(18,2) DEFAULT 0 NOT NULL,
    discount_total numeric(18,2) DEFAULT 0 NOT NULL,
    replaced_by_batch_id uuid,
    replaced_at timestamp with time zone,
    validation_summary jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid
);


--
-- Name: sales_actuals; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.sales_actuals (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    batch_id uuid NOT NULL,
    fiscal_period character varying(7) NOT NULL,
    cpl_id uuid NOT NULL,
    category_id uuid NOT NULL,
    channel_id uuid NOT NULL,
    cpl_code character varying(50) NOT NULL,
    category_name character varying(200) NOT NULL,
    channel_code character varying(50) NOT NULL,
    gross_amount numeric(18,2) NOT NULL,
    net_amount numeric(18,2),
    discount_amount numeric(18,2),
    currency character varying(3) DEFAULT 'TRY'::character varying NOT NULL,
    source_row_number integer NOT NULL,
    raw_row jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid
);


--
-- Name: skus; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.skus (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    gu_id uuid NOT NULL,
    fu_id uuid,
    variant character varying(100),
    size character varying(20),
    barcode character varying(50),
    unit_price numeric(18,4),
    cogs numeric(18,4),
    currency character varying(3) DEFAULT 'TRY'::character varying NOT NULL,
    unit_of_measure character varying(20),
    is_active boolean DEFAULT true NOT NULL,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid
);


--
-- Name: tactics; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.tactics (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    tactic_type main.tactics_tactic_type_enum NOT NULL,
    spend_type main.tactics_spend_type_enum,
    applicable_channels jsonb,
    applicable_categories jsonb,
    is_active boolean DEFAULT true NOT NULL,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid
);


--
-- Name: tenants; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.tenants (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(200) NOT NULL,
    domain character varying(100),
    status main.tenants_status_enum DEFAULT 'TRIAL'::main.tenants_status_enum NOT NULL,
    plan main.tenants_plan_enum DEFAULT 'FREE'::main.tenants_plan_enum NOT NULL,
    contact_email character varying(255),
    contact_phone character varying(50),
    contact_person character varying(200),
    address character varying(255),
    city character varying(100),
    country character varying(100),
    postal_code character varying(20),
    tax_number character varying(50),
    company_registration_number character varying(50),
    industry character varying(100),
    settings jsonb,
    subscription_start_date date,
    subscription_end_date date,
    max_users integer DEFAULT 5 NOT NULL,
    max_storage_gb integer DEFAULT 10 NOT NULL,
    current_storage_gb numeric(10,2) DEFAULT 0 NOT NULL,
    metadata jsonb,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: typeorm_metadata; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.typeorm_metadata (
    type character varying NOT NULL,
    database character varying,
    schema character varying,
    "table" character varying,
    name character varying,
    value text
);


--
-- Name: user_scopes; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.user_scopes (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    user_id uuid NOT NULL,
    cpl_id uuid,
    category_id uuid,
    channel_id uuid,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid
);


--
-- Name: users; Type: TABLE; Schema: main; Owner: -
--

CREATE TABLE main.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    email character varying(200) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role main.users_role_enum DEFAULT 'PLANNER'::main.users_role_enum NOT NULL,
    status main.users_status_enum DEFAULT 'PENDING'::main.users_status_enum NOT NULL,
    full_name character varying(200) NOT NULL,
    first_name character varying(100),
    last_name character varying(100),
    phone_number character varying(50),
    department character varying(100),
    job_title character varying(100),
    avatar_url text,
    last_login_at timestamp without time zone,
    login_count integer DEFAULT 0 NOT NULL,
    failed_login_attempts integer DEFAULT 0 NOT NULL,
    locked_until timestamp without time zone,
    password_changed_at timestamp without time zone,
    must_change_password boolean DEFAULT false NOT NULL,
    refresh_token text,
    email_verified boolean DEFAULT false NOT NULL,
    email_verification_token text,
    email_verification_expires timestamp without time zone,
    password_reset_token text,
    password_reset_expires timestamp without time zone,
    preferences jsonb,
    permissions jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp without time zone,
    created_by uuid,
    updated_by uuid
);


--
-- Name: v_budget_summary; Type: VIEW; Schema: main; Owner: -
--

CREATE VIEW main.v_budget_summary AS
 SELECT id AS envelope_id,
    tenant_id,
    code,
    name,
    fiscal_year,
    period,
    allocated_amount,
    currency,
    status,
    COALESCE(( SELECT (sum(
                CASE
                    WHEN (bt.tx_type = ANY (ARRAY['RESERVE'::main.budget_transactions_tx_type_enum, 'COMMIT'::main.budget_transactions_tx_type_enum])) THEN bt.amount
                    ELSE (0)::numeric
                END) - sum(
                CASE
                    WHEN (bt.tx_type = 'RELEASE'::main.budget_transactions_tx_type_enum) THEN bt.amount
                    ELSE (0)::numeric
                END))
           FROM main.budget_transactions bt
          WHERE ((bt.envelope_id = be.id) AND (bt.tx_status = 'POSTED'::main.budget_transactions_tx_status_enum) AND (bt.deleted_at IS NULL))), (0)::numeric) AS reserved_amount,
    COALESCE(( SELECT sum(
                CASE
                    WHEN (le.entry_direction = 'DEBIT'::main.ledger_entries_entry_direction_enum) THEN le.amount
                    ELSE (- le.amount)
                END) AS sum
           FROM main.ledger_entries le
          WHERE ((le.budget_envelope_id = be.id) AND (le.deleted_at IS NULL))), (0)::numeric) AS consumed_amount,
    ((allocated_amount - COALESCE(( SELECT (sum(
                CASE
                    WHEN (bt.tx_type = ANY (ARRAY['RESERVE'::main.budget_transactions_tx_type_enum, 'COMMIT'::main.budget_transactions_tx_type_enum])) THEN bt.amount
                    ELSE (0)::numeric
                END) - sum(
                CASE
                    WHEN (bt.tx_type = 'RELEASE'::main.budget_transactions_tx_type_enum) THEN bt.amount
                    ELSE (0)::numeric
                END))
           FROM main.budget_transactions bt
          WHERE ((bt.envelope_id = be.id) AND (bt.tx_status = 'POSTED'::main.budget_transactions_tx_status_enum) AND (bt.deleted_at IS NULL))), (0)::numeric)) - COALESCE(( SELECT sum(
                CASE
                    WHEN (le.entry_direction = 'DEBIT'::main.ledger_entries_entry_direction_enum) THEN le.amount
                    ELSE (- le.amount)
                END) AS sum
           FROM main.ledger_entries le
          WHERE ((le.budget_envelope_id = be.id) AND (le.deleted_at IS NULL))), (0)::numeric)) AS available_amount,
        CASE
            WHEN (allocated_amount > (0)::numeric) THEN round((((COALESCE(( SELECT (sum(
                    CASE
                        WHEN (bt.tx_type = ANY (ARRAY['RESERVE'::main.budget_transactions_tx_type_enum, 'COMMIT'::main.budget_transactions_tx_type_enum])) THEN bt.amount
                        ELSE (0)::numeric
                    END) - sum(
                    CASE
                        WHEN (bt.tx_type = 'RELEASE'::main.budget_transactions_tx_type_enum) THEN bt.amount
                        ELSE (0)::numeric
                    END))
               FROM main.budget_transactions bt
              WHERE ((bt.envelope_id = be.id) AND (bt.tx_status = 'POSTED'::main.budget_transactions_tx_status_enum) AND (bt.deleted_at IS NULL))), (0)::numeric) + COALESCE(( SELECT sum(
                    CASE
                        WHEN (le.entry_direction = 'DEBIT'::main.ledger_entries_entry_direction_enum) THEN le.amount
                        ELSE (- le.amount)
                    END) AS sum
               FROM main.ledger_entries le
              WHERE ((le.budget_envelope_id = be.id) AND (le.deleted_at IS NULL))), (0)::numeric)) / allocated_amount) * (100)::numeric), 2)
            ELSE (0)::numeric
        END AS utilization_pct,
    created_at,
    updated_at
   FROM main.budget_envelopes be
  WHERE (deleted_at IS NULL);


--
-- Name: migrations id; Type: DEFAULT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.migrations ALTER COLUMN id SET DEFAULT nextval('main.migrations_id_seq'::regclass);


--
-- Data for Name: _t019_backfilled_tx; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main._t019_backfilled_tx (tx_id) FROM stdin;
9d538468-c8d8-4321-b518-77fead5f872e
\.


--
-- Data for Name: admin_audit_logs; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.admin_audit_logs (id, tenant_id, admin_id, admin_email, action_type, entity_type, entity_id, ip_address, result, before_values, after_values, justification, is_high_risk, alert_sent, created_at) FROM stdin;
2559d0f2-f90e-482c-b0bc-f172d5795da5	598a895e-5a20-48cc-95bd-a52fe5d4bb65	3b703dae-2955-40a1-affa-f94478da505f	admin@wella.com	SUBMIT	AGREEMENT	782ef449-bd34-40ce-a971-412f083b41b7	\N	SUCCESS	{"previousStatus": "DRAFT"}	{"newStatus": "PENDING", "approvalRequestId": "2e6aded6-9c0b-4de3-b367-19b8f914fe4e"}	\N	f	f	2026-08-03 11:35:22.024636
79cb5c4d-8792-4e92-b65d-cb4601aa81a8	598a895e-5a20-48cc-95bd-a52fe5d4bb65	2929c86e-4321-4a31-a12c-8510ea1cec23	finance.manager@wella.com	APPROVE	AGREEMENT	782ef449-bd34-40ce-a971-412f083b41b7	\N	SUCCESS	{"previousStatus": "PENDING"}	{"newStatus": "APPROVED", "capTotalAmount": 50000}	\N	t	t	2026-08-03 11:35:22.062157
ae8f6c11-1a94-4c94-b0be-0164838ec7cd	598a895e-5a20-48cc-95bd-a52fe5d4bb65	3b703dae-2955-40a1-affa-f94478da505f	admin@wella.com	SALES_ACTUALS_UPLOAD	SalesActualBatch	0b884da4-8965-4e46-8cc6-204fc213a14d	\N	SUCCESS	\N	{"totals": {"netTotal": 360000, "grossTotal": 400000, "discountTotal": 15000}}	\N	f	f	2026-07-27 15:33:24.585261
1fc74c45-1cb7-4f20-92c0-12afdf6bab45	598a895e-5a20-48cc-95bd-a52fe5d4bb65	3b703dae-2955-40a1-affa-f94478da505f	admin@wella.com	SALES_ACTUALS_UPLOAD	SalesActualBatch	ddb2a650-1dd7-4186-91d0-62358ded48e7	\N	SUCCESS	\N	{"totals": {"netTotal": 552000, "grossTotal": 600000, "discountTotal": 30000}}	\N	f	f	2026-07-27 15:33:24.600601
0c8f0242-c3d8-4903-8cc6-80314e489b7e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	3b703dae-2955-40a1-affa-f94478da505f	admin@wella.com	SALES_ACTUALS_UPLOAD	SalesActualBatch	bbadf20e-2a0e-4a54-9a49-47542bc1d1a3	\N	SUCCESS	\N	{"totals": {"netTotal": 460000, "grossTotal": 500000, "discountTotal": 20000}}	\N	f	f	2026-07-27 15:33:24.615743
cc28d0a9-4dc1-4db5-bff0-f77454f77caf	598a895e-5a20-48cc-95bd-a52fe5d4bb65	3b703dae-2955-40a1-affa-f94478da505f	admin@wella.com	UPDATE	mechanic	bff656d7-1ec7-4584-a2ad-c88f8bfd8e7f	::ffff:127.0.0.1	SUCCESS	{"id": "bff656d7-1ec7-4584-a2ad-c88f8bfd8e7f", "code": "VIS_LS", "name": "Visibility Lump Sum", "tactic": {"id": "ee06a177-9fa0-4503-a0dc-9277039e180a", "code": "TAC-VISIBILITY", "name": "Visibility & Display", "isActive": true, "metadata": null, "tenantId": "598a895e-5a20-48cc-95bd-a52fe5d4bb65", "createdAt": "2026-07-29T09:16:02.655Z", "createdBy": "3b703dae-2955-40a1-affa-f94478da505f", "deletedAt": null, "spendType": "OFF_INVOICE", "updatedAt": "2026-07-29T09:16:02.655Z", "updatedBy": null, "tacticType": "LUMP_SUM", "description": null, "applicableChannels": null, "applicableCategories": null}, "category": "lumpsum_spend", "isActive": true, "maxValue": null, "metadata": null, "minValue": "0.0000", "tacticId": "ee06a177-9fa0-4503-a0dc-9277039e180a", "tenantId": "598a895e-5a20-48cc-95bd-a52fe5d4bb65", "testData": null, "createdAt": "2026-07-29T09:16:02.667Z", "createdBy": "3b703dae-2955-40a1-affa-f94478da505f", "deletedAt": null, "inputType": "currency", "updatedAt": "2026-07-29T09:16:02.667Z", "updatedBy": null, "budgetType": "off_invoice", "showInGrid": true, "unitSymbol": "TRY", "description": "Set A mekanik: görünürlük/teşhir lump-sum ödeme (off-invoice). Spend = entered_value (sabit tutar, FU seviyesinde girilir). BRD Set A referans değeri: 2000 TRY.", "groupHeader": "Off-Invoice Lump Sum", "approvalFlow": null, "defaultValue": null, "mechanicType": "AMOUNT", "spendingType": "off_invoice", "decimalPlaces": null, "stepIncrement": null, "applicableCpls": null, "exclusionRules": null, "gridColumnOrder": 30, "gridColumnWidth": null, "calculationRules": null, "formulaVariables": null, "inputConstraints": null, "applicabilityRules": null, "applicableChannels": null, "calculationFormula": "entered_value", "trackAgainstBudget": true, "combinationWarnings": null, "applicableCategories": null, "mutuallyExclusiveWith": null, "formulaValidationStatus": "valid", "requiresApprovalThreshold": null, "maxCombinedDiscountPercentage": null}	{"code": "VIS_LS", "name": "Visibility Lump Sum"}	\N	f	f	2026-08-05 10:47:27.586851
d473b38a-2bfc-4d7d-a9f0-c3d94e03defa	598a895e-5a20-48cc-95bd-a52fe5d4bb65	3b703dae-2955-40a1-affa-f94478da505f	admin@wella.com	UPDATE	mechanic	bff656d7-1ec7-4584-a2ad-c88f8bfd8e7f	::ffff:127.0.0.1	SUCCESS	{"id": "bff656d7-1ec7-4584-a2ad-c88f8bfd8e7f", "code": "VIS_LS", "name": "Visibility Lump Sum", "tactic": {"id": "ee06a177-9fa0-4503-a0dc-9277039e180a", "code": "TAC-VISIBILITY", "name": "Visibility & Display", "isActive": true, "metadata": null, "tenantId": "598a895e-5a20-48cc-95bd-a52fe5d4bb65", "createdAt": "2026-07-29T09:16:02.655Z", "createdBy": "3b703dae-2955-40a1-affa-f94478da505f", "deletedAt": null, "spendType": "OFF_INVOICE", "updatedAt": "2026-07-29T09:16:02.655Z", "updatedBy": null, "tacticType": "LUMP_SUM", "description": null, "applicableChannels": null, "applicableCategories": null}, "category": "lumpsum_spend", "isActive": false, "maxValue": null, "metadata": null, "minValue": "0.0000", "tacticId": "ee06a177-9fa0-4503-a0dc-9277039e180a", "tenantId": "598a895e-5a20-48cc-95bd-a52fe5d4bb65", "testData": null, "createdAt": "2026-07-29T09:16:02.667Z", "createdBy": "3b703dae-2955-40a1-affa-f94478da505f", "deletedAt": null, "inputType": "currency", "updatedAt": "2026-08-05T07:47:27.583Z", "updatedBy": null, "budgetType": "off_invoice", "showInGrid": true, "unitSymbol": "TRY", "description": "Set A mekanik: görünürlük/teşhir lump-sum ödeme (off-invoice). Spend = entered_value (sabit tutar, FU seviyesinde girilir). BRD Set A referans değeri: 2000 TRY.", "groupHeader": "Off-Invoice Lump Sum", "approvalFlow": null, "defaultValue": null, "mechanicType": "AMOUNT", "spendingType": "off_invoice", "decimalPlaces": null, "stepIncrement": null, "applicableCpls": null, "exclusionRules": null, "gridColumnOrder": 30, "gridColumnWidth": null, "calculationRules": null, "formulaVariables": null, "inputConstraints": null, "applicabilityRules": null, "applicableChannels": null, "calculationFormula": "entered_value", "trackAgainstBudget": true, "combinationWarnings": null, "applicableCategories": null, "mutuallyExclusiveWith": null, "formulaValidationStatus": "valid", "requiresApprovalThreshold": null, "maxCombinedDiscountPercentage": null}	{"code": "VIS_LS", "name": "Visibility Lump Sum"}	\N	f	f	2026-08-05 10:47:27.623756
1031f887-237a-4c1b-a8cc-3d009569895b	598a895e-5a20-48cc-95bd-a52fe5d4bb65	3b703dae-2955-40a1-affa-f94478da505f	admin@wella.com	SALES_ACTUALS_UPLOAD	SalesActualBatch	75090357-259a-4e2e-9de0-d3605adf8721	\N	SUCCESS	\N	{"totals": {"netTotal": 360000, "grossTotal": 400000, "discountTotal": 15000}}	\N	f	f	2026-07-27 19:39:17.244113
62ded0c3-29e0-4015-b3ce-0de182d6b349	598a895e-5a20-48cc-95bd-a52fe5d4bb65	3b703dae-2955-40a1-affa-f94478da505f	admin@wella.com	SALES_ACTUALS_UPLOAD	SalesActualBatch	8c8ba121-d460-48c5-a950-987613e0dd68	\N	SUCCESS	\N	{"totals": {"netTotal": 552000, "grossTotal": 600000, "discountTotal": 30000}}	\N	f	f	2026-07-27 19:39:17.252683
b1c5c618-0738-45c3-8564-303c32a93867	598a895e-5a20-48cc-95bd-a52fe5d4bb65	3b703dae-2955-40a1-affa-f94478da505f	admin@wella.com	SALES_ACTUALS_UPLOAD	SalesActualBatch	30f07e12-caba-42f2-91f7-1ea23a307d5e	\N	SUCCESS	\N	{"totals": {"netTotal": 460000, "grossTotal": 500000, "discountTotal": 20000}}	\N	f	f	2026-07-27 19:39:17.265751
b637e0e9-c1dd-48f7-b76d-0f023809fa16	598a895e-5a20-48cc-95bd-a52fe5d4bb65	3b703dae-2955-40a1-affa-f94478da505f	admin@wella.com	SALES_ACTUALS_UPLOAD	SalesActualBatch	12a25277-16fd-45bf-89a2-161cabd56d1b	\N	SUCCESS	\N	{"totals": {"netTotal": 360000, "grossTotal": 400000, "discountTotal": 15000}}	\N	f	f	2026-07-28 06:57:45.19529
7b3b848e-c8eb-4f09-85ac-488edf9e5a23	598a895e-5a20-48cc-95bd-a52fe5d4bb65	3b703dae-2955-40a1-affa-f94478da505f	admin@wella.com	SALES_ACTUALS_UPLOAD	SalesActualBatch	01109d56-dbbe-4839-b6f0-bc6a46f5759c	\N	SUCCESS	\N	{"totals": {"netTotal": 552000, "grossTotal": 600000, "discountTotal": 30000}}	\N	f	f	2026-07-28 06:57:45.208804
1f213187-291b-44e5-881f-5354bf630fc6	598a895e-5a20-48cc-95bd-a52fe5d4bb65	3b703dae-2955-40a1-affa-f94478da505f	admin@wella.com	SALES_ACTUALS_UPLOAD	SalesActualBatch	061b2244-62a8-4602-9dd0-c402367ea202	\N	SUCCESS	\N	{"totals": {"netTotal": 460000, "grossTotal": 500000, "discountTotal": 20000}}	\N	f	f	2026-07-28 06:57:45.234735
b096b0b5-e61f-4a21-a0e7-14eb97cc1383	598a895e-5a20-48cc-95bd-a52fe5d4bb65	3b703dae-2955-40a1-affa-f94478da505f	admin@wella.com	SALES_ACTUALS_UPLOAD	SalesActualBatch	a5c6c19c-73c4-4ed0-b451-09edbdd81e78	\N	SUCCESS	\N	{"totals": {"netTotal": 360000, "grossTotal": 400000, "discountTotal": 15000}}	\N	f	f	2026-08-02 12:27:41.903662
f5d82bc9-bb57-4d8b-a386-26e5f25b2389	598a895e-5a20-48cc-95bd-a52fe5d4bb65	3b703dae-2955-40a1-affa-f94478da505f	admin@wella.com	SALES_ACTUALS_UPLOAD	SalesActualBatch	525df8c2-3935-42e9-98d5-da8f50db0881	\N	SUCCESS	\N	{"totals": {"netTotal": 552000, "grossTotal": 600000, "discountTotal": 30000}}	\N	f	f	2026-08-02 12:27:41.932773
e2a7989c-80d2-44ee-9727-c7b4a6e1ba4c	598a895e-5a20-48cc-95bd-a52fe5d4bb65	3b703dae-2955-40a1-affa-f94478da505f	admin@wella.com	SALES_ACTUALS_UPLOAD	SalesActualBatch	a0bfe3e2-6478-4dd3-b508-e2ccef11b0f3	\N	SUCCESS	\N	{"totals": {"netTotal": 460000, "grossTotal": 500000, "discountTotal": 20000}}	\N	f	f	2026-08-02 12:27:41.945774
\.


--
-- Data for Name: agreement_transactions; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.agreement_transactions (id, tenant_id, agreement_id, invoice_no, invoice_date, amount, currency, cpl_id, batch_id, row_number, idempotency_key, notes, metadata, created_at, updated_at, deleted_at, created_by, updated_by, fiscal_period, is_reversed) FROM stdin;
\.


--
-- Data for Name: agreements; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.agreements (id, tenant_id, agreement_code, agreement_name, agreement_type, cpl_id, region_id, gu_id, fu_id, sku_scope, tactic_id, mechanic_id, mechanic_value, mechanic_type, currency, cap_total_amount, spend_type, start_date, end_date, period_month, justification, status, approval_request_id, approved_at, approved_by, rejected_at, rejected_by, rejection_reason, consumed_amount, current_price, expected_price, competitor_price, competitor_name, created_at, updated_at, deleted_at, created_by, updated_by, description, category_id, reconciliation_period, notes, channel_id, additional_params, kpi_results, closed_at, closed_by, version) FROM stdin;
6675fe95-c389-4f8c-b55e-40d2c6df60a3	598a895e-5a20-48cc-95bd-a52fe5d4bb65	STA-2026-0001	Wella NKA Migros Ocak Promosyon	STA	b39ade6a-ea33-413f-95a0-281c859f32fd	\N	\N	c451e8b8-c653-4bd5-8963-983a33657c05	FU	41b55aae-f357-49f1-bd13-a336bbadaf28	8f8ba312-a826-49ee-85e0-23324d84967e	\N	\N	TRY	50000.00	OFF_INVOICE	2026-01-15	2026-01-31	2026-01	Ocak ayı için Migros ile yapılan promosyon anlaşması	DRAFT	\N	\N	\N	\N	\N	\N	0.00	\N	\N	\N	\N	2026-07-29 12:16:02.994471	2026-07-29 12:16:02.994471	\N	67b863d1-1a98-464d-af7b-df0b219748ae	\N	\N	\N	\N	\N	7ecd1c45-9697-4a06-8416-3ba599977494	\N	\N	\N	\N	1
3eb02a4e-5586-4285-9832-ed75a81811a7	598a895e-5a20-48cc-95bd-a52fe5d4bb65	STA-2026-0002	Wella NKA CarrefourSA Şubat Promosyon	STA	b39ade6a-ea33-413f-95a0-281c859f32fd	\N	\N	c451e8b8-c653-4bd5-8963-983a33657c05	FU	41b55aae-f357-49f1-bd13-a336bbadaf28	8f8ba312-a826-49ee-85e0-23324d84967e	\N	\N	TRY	75000.00	OFF_INVOICE	2026-02-01	2026-02-28	2026-02	Şubat ayı CarrefourSA promosyon anlaşması	APPROVED	\N	2026-07-29 15:16:03.003	67b863d1-1a98-464d-af7b-df0b219748ae	\N	\N	\N	0.00	\N	\N	\N	\N	2026-07-29 12:16:02.997898	2026-07-29 12:16:02.997898	\N	67b863d1-1a98-464d-af7b-df0b219748ae	\N	\N	\N	\N	\N	7ecd1c45-9697-4a06-8416-3ba599977494	\N	\N	\N	\N	1
901bdf30-27bf-4d99-855c-25050012b474	598a895e-5a20-48cc-95bd-a52fe5d4bb65	LTA-2026-0001	Wella Traditional Trade Q1 2026	LTA	b39ade6a-ea33-413f-95a0-281c859f32fd	\N	\N	c451e8b8-c653-4bd5-8963-983a33657c05	FU	41b55aae-f357-49f1-bd13-a336bbadaf28	8f8ba312-a826-49ee-85e0-23324d84967e	\N	\N	TRY	150000.00	OFF_INVOICE	2026-01-01	2026-03-31	2026-01	Q1 2026 geleneksel kanal yıllık anlaşma	DRAFT	\N	\N	\N	\N	\N	\N	0.00	\N	\N	\N	\N	2026-07-29 12:16:02.999515	2026-07-29 12:16:02.999515	\N	67b863d1-1a98-464d-af7b-df0b219748ae	\N	\N	\N	\N	\N	5431c4ae-f1d9-4721-b12a-c968d2742d5c	\N	\N	\N	\N	1
\.


--
-- Data for Name: approval_requests; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.approval_requests (id, tenant_id, request_type, entity_type, entity_id, requested_by_id, requested_at, approval_policy_id, approval_levels, current_level, status, approved_at, approved_by_id, rejected_at, rejected_by_id, rejection_reason, cancelled_at, cancelled_by_id, metadata, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: brands; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.brands (id, tenant_id, code, name, description, is_active, metadata, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
59a8b918-e940-4606-a42e-8738b4221fbc	598a895e-5a20-48cc-95bd-a52fe5d4bb65	WELLA	Wella	\N	t	\N	2026-07-29 12:16:02.673337	2026-07-29 12:16:02.673337	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
\.


--
-- Data for Name: budget_alert_configurations; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.budget_alert_configurations (id, tenant_id, alert_level, notification_channels, escalation_rules, is_active, metadata, created_at, updated_at, deleted_at, created_by, updated_by, threshold_percent) FROM stdin;
f951dad9-725f-4f61-b4bb-0798d3ef59a9	598a895e-5a20-48cc-95bd-a52fe5d4bb65	warning_80	["in_app", "email"]	\N	t	\N	2026-08-02 12:27:41.515887	2026-08-02 12:27:41.515887	\N	\N	\N	80.00
dc0c8a42-1704-4884-bbf1-9e6a21ece2d2	598a895e-5a20-48cc-95bd-a52fe5d4bb65	critical_95	["in_app", "email"]	\N	t	\N	2026-08-02 12:27:41.550433	2026-08-02 12:27:41.550433	\N	\N	\N	95.00
02eebe0f-c634-41b1-b4a7-16e200a604ee	598a895e-5a20-48cc-95bd-a52fe5d4bb65	exceeded_100	["in_app", "email"]	\N	t	\N	2026-08-02 12:27:41.555144	2026-08-02 12:27:41.555144	\N	\N	\N	100.00
\.


--
-- Data for Name: budget_allocations; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.budget_allocations (id, tenant_id, created_at, updated_at, deleted_at, created_by, updated_by, period_type, period_start, period_end, fiscal_year, cpl_id, channel, category, on_invoice_budget, off_invoice_budget, on_invoice_utilized, off_invoice_utilized, on_invoice_reserved, off_invoice_reserved, alert_threshold_80, alert_threshold_95, alert_threshold_100, alert_recipients, hard_limit_mode, allow_carry_forward, metadata) FROM stdin;
a9626cf5-5b60-45ea-960e-2b99bc268590	598a895e-5a20-48cc-95bd-a52fe5d4bb65	2026-08-12 06:42:55.763346	2026-08-12 06:43:33.330236	\N	2929c86e-4321-4a31-a12c-8510ea1cec23	3b703dae-2955-40a1-affa-f94478da505f	yearly	2031-01-01	2031-12-31	2031	\N	T096-VERIFY	\N	22345.67	1654.33	0.00	0.00	0.00	0.00	t	t	t	\N	f	f	\N
babb4b7f-c04d-46dd-8e7e-29b55e649371	598a895e-5a20-48cc-95bd-a52fe5d4bb65	2026-08-12 06:45:00.309118	2026-08-12 06:45:00.309118	\N	2929c86e-4321-4a31-a12c-8510ea1cec23	\N	yearly	2032-01-01	2032-12-31	2032	2eded86b-ae2a-4097-92fb-f304c79c57e1	NKA	CAT-SAC-BOYASI	100000.00	50000.00	0.00	0.00	0.00	0.00	t	t	t	\N	f	f	\N
\.


--
-- Data for Name: budget_envelopes; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.budget_envelopes (id, tenant_id, code, name, fiscal_year, period, allocated_amount, consumed_amount, available_amount, status, budget_owner_id, budget_owner_email, budget_owner_name, currency, description, metadata, created_at, updated_at, deleted_at, created_by, updated_by, channel, category, channel_id, category_id, spend_type) FROM stdin;
2021545e-9c93-4339-8a27-1e53ad39d7f6	598a895e-5a20-48cc-95bd-a52fe5d4bb65	ENV-2026-NKA-Q1	NKA Channel Q1 2026 Budget	2026	2026-01	500000.00	0.00	500000.00	ACTIVE	\N	\N	\N	TRY	National Key Accounts Q1 2026 Trade Budget	{"channel": "NKA"}	2026-07-29 12:16:02.633136	2026-07-29 12:16:02.633136	\N	\N	\N	\N	\N	\N	\N	\N
aff897a3-578c-49dd-9786-bbf9a0db96e1	598a895e-5a20-48cc-95bd-a52fe5d4bb65	ENV-2026-NKA-Q2	NKA Channel Q2 2026 Budget	2026	2026-02	600000.00	0.00	600000.00	ACTIVE	\N	\N	\N	TRY	National Key Accounts Q2 2026 Trade Budget	{"channel": "NKA"}	2026-07-29 12:16:02.641797	2026-07-29 12:16:02.641797	\N	\N	\N	\N	\N	\N	\N	\N
693e59d8-c128-42b6-a22d-80943d911cc0	598a895e-5a20-48cc-95bd-a52fe5d4bb65	ENV-2026-TRAD-Q1	Traditional Trade Q1 2026 Budget	2026	2026-01	300000.00	0.00	300000.00	ACTIVE	\N	\N	\N	TRY	Traditional Trade Q1 2026 Budget	{"channel": "TRADITIONAL_TRADE"}	2026-07-29 12:16:02.64356	2026-07-29 12:16:02.64356	\N	\N	\N	\N	\N	\N	\N	\N
ba676ba6-d409-4191-947a-3ed6af3eca73	598a895e-5a20-48cc-95bd-a52fe5d4bb65	ENV-2026-ECOM-Q1	E-Commerce Q1 2026 Budget	2026	2026-02	200000.00	0.00	200000.00	ACTIVE	\N	\N	\N	TRY	E-Commerce Q1 2026 Budget	{"channel": "E_COMMERCE"}	2026-07-29 12:16:02.645556	2026-07-29 12:16:02.645556	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: budget_reservations; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.budget_reservations (id, tenant_id, envelope_id, agreement_id, agreement_name, reserved_amount, status, requested_by_id, requested_by_email, requested_by_name, approved_by_id, approved_at, rejected_reason, notes, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: budget_transaction_logs; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.budget_transaction_logs (id, tenant_id, budget_allocation_id, transaction_type, on_invoice_amount, off_invoice_amount, plan_id, description, created_by, idempotency_key, created_at, updated_at, deleted_at, updated_by) FROM stdin;
fb777643-c34e-4427-835e-8e913f759095	598a895e-5a20-48cc-95bd-a52fe5d4bb65	a9626cf5-5b60-45ea-960e-2b99bc268590	allocation	12345.67	7654.33	\N	Initial budget allocation	2929c86e-4321-4a31-a12c-8510ea1cec23	\N	2026-08-12 06:42:55.763346	2026-08-12 06:42:55.763346	\N	\N
70ab42dc-dbcf-4df8-9308-ab64c881baf8	598a895e-5a20-48cc-95bd-a52fe5d4bb65	a9626cf5-5b60-45ea-960e-2b99bc268590	adjustment	10000.00	0.00	\N	On-invoice budget adjustment: +9999.999999999998	3b703dae-2955-40a1-affa-f94478da505f	\N	2026-08-12 06:43:33.330236	2026-08-12 06:43:33.330236	\N	\N
5ed63fb6-c344-4940-bd49-d171bb3b4a13	598a895e-5a20-48cc-95bd-a52fe5d4bb65	a9626cf5-5b60-45ea-960e-2b99bc268590	adjustment	0.00	-6000.00	\N	Off-invoice budget adjustment: -6000	3b703dae-2955-40a1-affa-f94478da505f	\N	2026-08-12 06:43:33.330236	2026-08-12 06:43:33.330236	\N	\N
f414c217-5197-460d-93a6-95f5711af404	598a895e-5a20-48cc-95bd-a52fe5d4bb65	babb4b7f-c04d-46dd-8e7e-29b55e649371	allocation	100000.00	50000.00	\N	Initial budget allocation	2929c86e-4321-4a31-a12c-8510ea1cec23	\N	2026-08-12 06:45:00.309118	2026-08-12 06:45:00.309118	\N	\N
\.


--
-- Data for Name: budget_transactions; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.budget_transactions (id, tenant_id, envelope_id, tx_type, tx_status, source_type, source_id, amount, currency, idempotency_key, description, notes, metadata, created_at, updated_at, deleted_at, created_by, updated_by, spend_type) FROM stdin;
3800367a-152d-4171-a0f0-2335c439badc	598a895e-5a20-48cc-95bd-a52fe5d4bb65	2021545e-9c93-4339-8a27-1e53ad39d7f6	ALLOCATE	POSTED	MANUAL	\N	500000.00	TRY	ALLOCATE|ENVELOPE|2021545e-9c93-4339-8a27-1e53ad39d7f6|INITIAL	Initial Q1 2026 budget allocation	\N	\N	2026-07-29 12:16:03.009022	2026-07-29 12:16:03.009022	\N	88e70c08-2113-4d37-b8d9-b29269532fe2	\N	\N
5cdaa457-9f66-4cad-9940-c98b81e4d4c1	598a895e-5a20-48cc-95bd-a52fe5d4bb65	aff897a3-578c-49dd-9786-bbf9a0db96e1	ALLOCATE	POSTED	MANUAL	\N	500000.00	TRY	ALLOCATE|ENVELOPE|aff897a3-578c-49dd-9786-bbf9a0db96e1|INITIAL	Initial Q1 2026 budget allocation	\N	\N	2026-08-02 12:27:41.993194	2026-08-02 12:27:41.993194	\N	3b703dae-2955-40a1-affa-f94478da505f	\N	\N
9d538468-c8d8-4321-b518-77fead5f872e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	2021545e-9c93-4339-8a27-1e53ad39d7f6	RESERVE	POSTED	AGREEMENT	3eb02a4e-5586-4285-9832-ed75a81811a7	75000.00	TRY	RESERVE|AGREEMENT|3eb02a4e-5586-4285-9832-ed75a81811a7|2021545e-9c93-4339-8a27-1e53ad39d7f6	Budget reservation for STA-2026-0002	\N	\N	2026-07-29 12:16:03.010602	2026-07-29 12:16:03.010602	\N	88e70c08-2113-4d37-b8d9-b29269532fe2	\N	OFF_INVOICE
c829c953-92bc-48dc-9851-fa7a52e03876	598a895e-5a20-48cc-95bd-a52fe5d4bb65	aff897a3-578c-49dd-9786-bbf9a0db96e1	RESERVE	POSTED	AGREEMENT	3eb02a4e-5586-4285-9832-ed75a81811a7	75000.00	TRY	RESERVE|AGREEMENT|3eb02a4e-5586-4285-9832-ed75a81811a7|aff897a3-578c-49dd-9786-bbf9a0db96e1	Budget reservation for STA-2026-0002	\N	\N	2026-08-02 12:27:42.003001	2026-08-02 12:27:42.003001	\N	3b703dae-2955-40a1-affa-f94478da505f	\N	\N
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.categories (id, tenant_id, code, name, description, parent_category_id, level, is_active, metadata, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
24fb3bc9-4eed-4116-8f70-395029798c46	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CAT-SAC-BOYASI	Saç Boyası	\N	\N	1	t	{"source": "Wella Product.xlsx"}	2026-07-29 12:16:02.675021	2026-07-29 12:16:02.675021	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
08d8d7d8-b21e-4f81-8fe5-647f38f67f90	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CAT-SET-BOYA	Set Boya	\N	\N	1	t	{"source": "Wella Product.xlsx"}	2026-07-29 12:16:02.677877	2026-07-29 12:16:02.677877	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
d465de24-491e-4f85-bcfd-ab70f8878c73	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CAT-SEKILLENDIRICI	Şekillendirici	\N	\N	1	t	{"source": "Wella Product.xlsx"}	2026-07-29 12:16:02.679309	2026-07-29 12:16:02.679309	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
8161c891-e739-44eb-8489-b24026c2aaa8	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CAT-KOPUK	Köpük	\N	\N	1	t	{"source": "Wella Product.xlsx"}	2026-07-29 12:16:02.680622	2026-07-29 12:16:02.680622	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
0b6be58e-9b58-425d-8328-786664ad54a8	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CAT-PEROKSIT	Peroksit	\N	\N	1	t	{"source": "Wella Product.xlsx"}	2026-07-29 12:16:02.682049	2026-07-29 12:16:02.682049	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
e829006d-fa00-4f7d-b305-e833de3bcf30	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CAT-DIGER	Diğer	\N	\N	1	t	{"source": "Wella Product.xlsx"}	2026-07-29 12:16:02.683441	2026-07-29 12:16:02.683441	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
da0a990e-343b-45c9-93a1-39c9ae695cc8	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CAT-KARMA-KOLI	Karma Koli	\N	\N	1	t	{"source": "Wella Product.xlsx"}	2026-07-29 12:16:02.684832	2026-07-29 12:16:02.684832	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
7036ca74-12fa-4a66-a5fe-363d67455f63	598a895e-5a20-48cc-95bd-a52fe5d4bb65	HAIR_CARE	Hair Care	\N	\N	1	t	\N	2026-07-29 12:16:02.987259	2026-07-29 12:16:02.987259	\N	67b863d1-1a98-464d-af7b-df0b219748ae	\N
\.


--
-- Data for Name: channels; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.channels (id, tenant_id, code, name, description, subchannel, sort_order, is_active, metadata, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
7ecd1c45-9697-4a06-8416-3ba599977494	598a895e-5a20-48cc-95bd-a52fe5d4bb65	NKA	National Key Accounts	National Key Accounts channel	\N	1	t	\N	2026-06-17 18:47:53.491833	2026-06-17 18:47:53.491833	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
5431c4ae-f1d9-4721-b12a-c968d2742d5c	598a895e-5a20-48cc-95bd-a52fe5d4bb65	TRADITIONAL_TRADE	Traditional Trade	Traditional Trade channel	\N	2	t	\N	2026-06-17 18:47:53.503897	2026-06-17 18:47:53.503897	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
40b33c0d-ee52-4956-acec-cf568a4f0d4f	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E_COMMERCE	E-Commerce	E-Commerce channel	\N	3	t	\N	2026-06-17 18:47:53.506854	2026-06-17 18:47:53.506854	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
af6971f2-09b8-4724-869f-20826e474b4b	598a895e-5a20-48cc-95bd-a52fe5d4bb65	EXPORT	Export	Export channel	\N	4	t	\N	2026-06-17 18:47:53.509265	2026-06-17 18:47:53.509265	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
520e11c7-da9d-4411-aec0-5d9be5d42593	598a895e-5a20-48cc-95bd-a52fe5d4bb65	WHOLESALE	Wholesale	Wholesale channel	\N	5	t	\N	2026-06-17 18:47:53.512709	2026-06-17 18:47:53.512709	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
1c40209b-1570-49d8-8ce6-77c754d7eb5f	598a895e-5a20-48cc-95bd-a52fe5d4bb65	RETAIL	Retail	Retail channel	\N	6	t	\N	2026-06-17 18:47:53.515492	2026-06-17 18:47:53.515492	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
80958800-43d7-461c-9d89-67147fe82cc0	598a895e-5a20-48cc-95bd-a52fe5d4bb65	HORECA	HORECA	Hotel, Restaurant, Cafe channel	\N	7	t	\N	2026-06-17 18:47:53.518929	2026-06-17 18:47:53.518929	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
64093768-19dc-4f17-9dc5-49b339789a70	598a895e-5a20-48cc-95bd-a52fe5d4bb65	DISTRIBUTOR	Distributor	Distributor channel (Distribütör)	\N	8	t	\N	2026-06-23 20:05:23.404507	2026-06-23 20:05:23.404507	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
\.


--
-- Data for Name: cpls; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.cpls (id, tenant_id, code, name, description, channel_id, region_id, city, country, contact_person, contact_email, contact_phone, customer_tier, is_vip, annual_revenue, status, metadata, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
2eded86b-ae2a-4097-92fb-f304c79c57e1	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CPL-NKA-001	Migros NKA	\N	7ecd1c45-9697-4a06-8416-3ba599977494	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-17 18:47:53.526524	2026-06-17 18:47:53.526524	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
8a0d6841-b2f5-4f31-81c8-3fec9a82672f	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CPL-NKA-002	CarrefourSA NKA	\N	7ecd1c45-9697-4a06-8416-3ba599977494	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-17 18:47:53.53322	2026-06-17 18:47:53.53322	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
2384a64b-0880-47e1-8678-b3ce0353ea53	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CPL-NKA-003	Metro Türkiye NKA	\N	7ecd1c45-9697-4a06-8416-3ba599977494	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-17 18:47:53.536665	2026-06-17 18:47:53.536665	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
b39ade6a-ea33-413f-95a0-281c859f32fd	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0501.50001	Gratis İç ve Dış Ticaret A.Ş.	\N	7ecd1c45-9697-4a06-8416-3ba599977494	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.456721	2026-06-23 20:05:23.456721	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
4b3850a8-d598-49ca-a740-94730fd7cfa6	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0501.50004	A.S.Watson Güzellik ve Bakım Ürünleri Tic.A.Ş	\N	7ecd1c45-9697-4a06-8416-3ba599977494	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.465748	2026-06-23 20:05:23.465748	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
29982d2e-9f92-424c-bdcf-33462493ad1c	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0501.50005	Eve Mağazacılık A.Ş.	\N	7ecd1c45-9697-4a06-8416-3ba599977494	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.470927	2026-06-23 20:05:23.470927	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
ac0d2c7d-ccd9-4060-a24e-6bdb773f5083	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0501.50006	Dirk Rossmann Mağazacılık Tic.Ltd.Şti.	\N	7ecd1c45-9697-4a06-8416-3ba599977494	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.47398	2026-06-23 20:05:23.47398	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
dbc049f6-0346-46b3-b13d-1817a8b293cc	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0501.50007	Migros Ticaret A.Ş.	\N	7ecd1c45-9697-4a06-8416-3ba599977494	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.477286	2026-06-23 20:05:23.477286	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
4a6ffd3b-e61c-4dbe-abaa-0ed0722fe79c	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0501.50008	Bim Birleşik Mağazalar A.Ş.	\N	7ecd1c45-9697-4a06-8416-3ba599977494	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.480995	2026-06-23 20:05:23.480995	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
9ac62124-efe3-4d61-90a8-b6c3e4e0134c	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0501.50012	Carrefoursa Carrefour Sabancı Tic. Mekz. Anonim. Şti	\N	7ecd1c45-9697-4a06-8416-3ba599977494	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.485696	2026-06-23 20:05:23.485696	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
7a0d58e9-8781-4d6b-b471-240a47aeca01	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0501.50091	File Market Mağazacılık A.Ş.	\N	7ecd1c45-9697-4a06-8416-3ba599977494	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.489514	2026-06-23 20:05:23.489514	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
a871bb23-5433-47e4-8821-6e21e05eeaab	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0502.50002	Hiz Gıda Oto.Teks.İnş.Tur.San.ve Tic.Ltd Şti.	\N	64093768-19dc-4f17-9dc5-49b339789a70	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.492685	2026-06-23 20:05:23.492685	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
e1637a9d-380e-48cd-9830-bbf120e41404	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0502.50015	Hamza Güneyli Gıda San Ve Tic.Ltd.Şti	\N	64093768-19dc-4f17-9dc5-49b339789a70	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.498051	2026-06-23 20:05:23.498051	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
cf3b2c8b-d8b1-4755-a4c3-8aad655e0a65	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0502.50092	Demirezen Gıda Ltd. Şti.	\N	64093768-19dc-4f17-9dc5-49b339789a70	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.502017	2026-06-23 20:05:23.502017	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
2ddf0f01-3cb3-490e-b82b-772aee73e696	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0503.50009	Kar-Dağ Karadeniz Gıda Dağ.Tem.ve Sağ.Ür.San.ve Tic.A.Ş.	\N	64093768-19dc-4f17-9dc5-49b339789a70	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.50864	2026-06-23 20:05:23.50864	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
55b09d5e-3a2f-4579-8ae6-928f86fc09ef	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0503.50023	Sivas Safa Toptan Gıda Tic. ve San.Ltd.Şti.	\N	64093768-19dc-4f17-9dc5-49b339789a70	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.511723	2026-06-23 20:05:23.511723	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
ea138aed-0d24-44af-aa8f-78be33b97fd1	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0504.50011	Duru İtriyat Deposu Tic ve Sanayi Aş.(Antalya)	\N	64093768-19dc-4f17-9dc5-49b339789a70	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.514602	2026-06-23 20:05:23.514602	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
28ca1d98-0301-4526-8a3a-0cc44d7a088c	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0504.50022	Gıdasan İhtiyaç Maddeleri İmalat Ve Paz.A.Ş.	\N	64093768-19dc-4f17-9dc5-49b339789a70	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.517975	2026-06-23 20:05:23.517975	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
a31f3f57-5ae0-4bbb-9f6a-003d34c04525	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0504.50113	Duru İtriyat Deposu San.Ve Tic.A.Ş.(İzmir)	\N	64093768-19dc-4f17-9dc5-49b339789a70	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.526673	2026-06-23 20:05:23.526673	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
734808ca-22dd-4425-b094-c9be94c83f2b	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0505.50057	Özkarınca Koz. Tekstil Gıda Hıdavat İnş.San ve Tic.Ltd.Şti	\N	64093768-19dc-4f17-9dc5-49b339789a70	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.535389	2026-06-23 20:05:23.535389	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
2f664935-9652-46fa-a995-900dcbf809bd	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0505.50078	Üç Gen Gıda  Lüks Hır.Hyv.İnş.Nak.Tic. Ve San. Lmt.	\N	64093768-19dc-4f17-9dc5-49b339789a70	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.542661	2026-06-23 20:05:23.542661	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
1ea11f01-9da0-4897-896d-cc5febea7b38	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0505.50085	Evrensel99 Gıda İnş. Tar. Hayv. Petrol İç ve Dış Ltd. Şti.	\N	64093768-19dc-4f17-9dc5-49b339789a70	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.545236	2026-06-23 20:05:23.545236	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
f0da4013-ae5d-4ba7-a0cb-13c554085daa	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0506.50088	Ak Temizlik Mad. Ev Eşyaları Gıda Mad. San.ve Tic. Ltd. Şti	\N	64093768-19dc-4f17-9dc5-49b339789a70	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.549028	2026-06-23 20:05:23.549028	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
fce2ccf6-3ab6-43de-8dc1-ffbf842e26ca	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0507.50017	Ram Company Consumer Products Sales and Distribution Ltd.	\N	64093768-19dc-4f17-9dc5-49b339789a70	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.552435	2026-06-23 20:05:23.552435	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
826127e6-267d-4c76-b6e5-861525cea6f3	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0508.50060	Bozkuşlar Gıda İnş. Tic. Ve San. Lmt.Şti	\N	64093768-19dc-4f17-9dc5-49b339789a70	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.555674	2026-06-23 20:05:23.555674	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
25297e2d-8503-40bd-a28b-a31306459f6d	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0509.50014	Değişim Tüketim ve Tarım Ürünleri Dağ. A.Ş.	\N	64093768-19dc-4f17-9dc5-49b339789a70	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.559785	2026-06-23 20:05:23.559785	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
15a76d17-8e08-4c69-b283-ead8da0424d8	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0510.50020	Saldos Ticaret  Anonim Şirketi	\N	40b33c0d-ee52-4956-acec-cf568a4f0d4f	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.563008	2026-06-23 20:05:23.563008	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
54943c0b-df0f-4988-a4b0-9350b48d3e84	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0513.50031	Uzuner Gıda San ve Tic.Ltd.Şti	\N	64093768-19dc-4f17-9dc5-49b339789a70	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.566341	2026-06-23 20:05:23.566341	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
6f759975-9c61-4233-a2b3-be1e6f1a09f9	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BS0513.50109	MF Uzay Tic.Top.Satış San Ve Tic Ltd Şti	\N	64093768-19dc-4f17-9dc5-49b339789a70	\N	\N	\N	\N	\N	\N	\N	f	\N	ACTIVE	\N	2026-06-23 20:05:23.570457	2026-06-23 20:05:23.570457	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.customers (id, tenant_id, code, name, channel, type, status, city, district, region, country, address, postal_code, tax_number, tax_office, company_registration_number, contact_person, contact_email, contact_phone, contact_mobile, payment_terms, credit_limit, currency, sales_representative, account_manager, customer_group, customer_segment, customer_tier, business_size, annual_revenue, last_order_date, first_order_date, total_orders, metadata, notes, is_vip, contract_start_date, contract_end_date, created_at, updated_at, deleted_at, created_by, updated_by, number_of_branches, cpl_id) FROM stdin;
5b920145-b8af-4c30-af47-5870b492b5b4	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST002	CarrefourSA	NKA	DIRECT	ACTIVE	Istanbul	\N	Marmara	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	A	\N	\N	\N	\N	0	\N	\N	t	\N	\N	2026-06-17 18:47:53.555122	2026-06-17 18:47:53.555122	\N	\N	\N	\N	\N
076b0df2-f958-4d30-becb-6335874fce8c	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST003	Metro Türkiye	NKA	DIRECT	ACTIVE	Istanbul	\N	Marmara	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	A	\N	\N	\N	\N	0	\N	\N	t	\N	\N	2026-06-17 18:47:53.559818	2026-06-17 18:47:53.559818	\N	\N	\N	\N	\N
b3d0992f-efb1-48ce-ba89-64723d0e8816	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST001	Migros	NKA	DIRECT	ACTIVE	Istanbul	\N	Marmara	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	A	\N	\N	\N	\N	0	\N	\N	t	\N	\N	2026-06-17 18:47:53.548234	2026-06-17 18:47:53.565717	\N	\N	\N	\N	2eded86b-ae2a-4097-92fb-f304c79c57e1
c92618a5-2724-47f2-99d1-1ed8fe94f72d	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0501.50001	Gratis İç ve Dış Ticaret A.Ş.	NKA	DIRECT	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.577852	2026-06-23 20:05:23.577852	\N	\N	\N	\N	b39ade6a-ea33-413f-95a0-281c859f32fd
8c337df0-b2dc-4817-8569-cb85f38d00af	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0501.50004	A.S.Watson Güzellik ve Bakım Ürünleri Tic.A.Ş	NKA	DIRECT	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.585061	2026-06-23 20:05:23.585061	\N	\N	\N	\N	4b3850a8-d598-49ca-a740-94730fd7cfa6
0e6da1fe-2eee-400a-a7fc-9808eb2f89f8	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0501.50005	Eve Mağazacılık A.Ş.	NKA	DIRECT	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.589509	2026-06-23 20:05:23.589509	\N	\N	\N	\N	29982d2e-9f92-424c-bdcf-33462493ad1c
8381f045-8e23-48ee-bf25-3217e6cfd572	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0501.50006	Dirk Rossmann Mağazacılık Tic.Ltd.Şti.	NKA	DIRECT	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.592947	2026-06-23 20:05:23.592947	\N	\N	\N	\N	ac0d2c7d-ccd9-4060-a24e-6bdb773f5083
cc16bd36-aca9-49ab-abd6-df3ecb01a3ff	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0501.50007	Migros Ticaret A.Ş.	NKA	DIRECT	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.595827	2026-06-23 20:05:23.595827	\N	\N	\N	\N	dbc049f6-0346-46b3-b13d-1817a8b293cc
55a5fa3e-f0ec-47e8-b047-b1c93a1edef2	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0501.50008	Bim Birleşik Mağazalar A.Ş.	NKA	DIRECT	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.59864	2026-06-23 20:05:23.59864	\N	\N	\N	\N	4a6ffd3b-e61c-4dbe-abaa-0ed0722fe79c
b50bb352-48cd-4df4-8e71-9e1dbfb4540c	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0501.50012	Carrefoursa Carrefour Sabancı Tic. Mekz. Anonim. Şti	NKA	DIRECT	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.603898	2026-06-23 20:05:23.603898	\N	\N	\N	\N	9ac62124-efe3-4d61-90a8-b6c3e4e0134c
7f277c3a-f9e5-4627-b133-12272969359f	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0501.50091	File Market Mağazacılık A.Ş.	NKA	DIRECT	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.607493	2026-06-23 20:05:23.607493	\N	\N	\N	\N	7a0d58e9-8781-4d6b-b471-240a47aeca01
519c0e88-5e63-4a15-9ab3-8294c0ec4a20	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0502.50002	Hiz Gıda Oto.Teks.İnş.Tur.San.ve Tic.Ltd Şti.	DISTRIBUTOR	DISTRIBUTOR	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.612784	2026-06-23 20:05:23.612784	\N	\N	\N	\N	a871bb23-5433-47e4-8821-6e21e05eeaab
f2386612-9e58-49ca-9b6e-f2a9c598c6ba	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0502.50015	Hamza Güneyli Gıda San Ve Tic.Ltd.Şti	DISTRIBUTOR	DISTRIBUTOR	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.61826	2026-06-23 20:05:23.61826	\N	\N	\N	\N	e1637a9d-380e-48cd-9830-bbf120e41404
ba795412-5444-4689-b963-10918775df38	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0502.50092	Demirezen Gıda Ltd. Şti.	DISTRIBUTOR	DISTRIBUTOR	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.625275	2026-06-23 20:05:23.625275	\N	\N	\N	\N	cf3b2c8b-d8b1-4755-a4c3-8aad655e0a65
dbf63e4d-fec8-4547-a9ba-df14e19d60ff	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0503.50009	Kar-Dağ Karadeniz Gıda Dağ.Tem.ve Sağ.Ür.San.ve Tic.A.Ş.	DISTRIBUTOR	DISTRIBUTOR	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.636877	2026-06-23 20:05:23.636877	\N	\N	\N	\N	2ddf0f01-3cb3-490e-b82b-772aee73e696
29a848fe-2d32-4757-9e0c-589f94f69e88	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0503.50023	Sivas Safa Toptan Gıda Tic. ve San.Ltd.Şti.	DISTRIBUTOR	DISTRIBUTOR	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.64014	2026-06-23 20:05:23.64014	\N	\N	\N	\N	55b09d5e-3a2f-4579-8ae6-928f86fc09ef
c0eceb59-ed21-4c05-bdc2-2aba3fa1004e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0504.50011	Duru İtriyat Deposu Tic ve Sanayi Aş.(Antalya)	DISTRIBUTOR	DISTRIBUTOR	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.64296	2026-06-23 20:05:23.64296	\N	\N	\N	\N	ea138aed-0d24-44af-aa8f-78be33b97fd1
01c78f72-64e6-451b-a451-bef905cefdc3	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0504.50022	Gıdasan İhtiyaç Maddeleri İmalat Ve Paz.A.Ş.	DISTRIBUTOR	DISTRIBUTOR	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.646157	2026-06-23 20:05:23.646157	\N	\N	\N	\N	28ca1d98-0301-4526-8a3a-0cc44d7a088c
63eda9e0-a37b-4de2-baf8-f489357e4dae	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0504.50113	Duru İtriyat Deposu San.Ve Tic.A.Ş.(İzmir)	DISTRIBUTOR	DISTRIBUTOR	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.649616	2026-06-23 20:05:23.649616	\N	\N	\N	\N	a31f3f57-5ae0-4bbb-9f6a-003d34c04525
d9defdf2-baf9-4c68-b95d-6eb97ccbf448	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0505.50057	Özkarınca Koz. Tekstil Gıda Hıdavat İnş.San ve Tic.Ltd.Şti	DISTRIBUTOR	DISTRIBUTOR	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.652978	2026-06-23 20:05:23.652978	\N	\N	\N	\N	734808ca-22dd-4425-b094-c9be94c83f2b
b7b8339f-1f9c-4b4d-aca0-9dda1fb1de37	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0505.50078	Üç Gen Gıda  Lüks Hır.Hyv.İnş.Nak.Tic. Ve San. Lmt.	DISTRIBUTOR	DISTRIBUTOR	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.65563	2026-06-23 20:05:23.65563	\N	\N	\N	\N	2f664935-9652-46fa-a995-900dcbf809bd
b6015bfc-fafc-4550-828b-427c1bc715de	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0505.50085	Evrensel99 Gıda İnş. Tar. Hayv. Petrol İç ve Dış Ltd. Şti.	DISTRIBUTOR	DISTRIBUTOR	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.658657	2026-06-23 20:05:23.658657	\N	\N	\N	\N	1ea11f01-9da0-4897-896d-cc5febea7b38
a918386c-1df3-49b1-9fc8-0c6314c3c033	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0506.50088	Ak Temizlik Mad. Ev Eşyaları Gıda Mad. San.ve Tic. Ltd. Şti	DISTRIBUTOR	DISTRIBUTOR	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.661183	2026-06-23 20:05:23.661183	\N	\N	\N	\N	f0da4013-ae5d-4ba7-a0cb-13c554085daa
5c20978b-d60a-481a-a247-1f3abf4f8c51	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0507.50017	Ram Company Consumer Products Sales and Distribution Ltd.	DISTRIBUTOR	DISTRIBUTOR	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.663743	2026-06-23 20:05:23.663743	\N	\N	\N	\N	fce2ccf6-3ab6-43de-8dc1-ffbf842e26ca
ff2c9943-2089-43b1-a707-356fc14a6cfb	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0508.50060	Bozkuşlar Gıda İnş. Tic. Ve San. Lmt.Şti	DISTRIBUTOR	DISTRIBUTOR	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.666304	2026-06-23 20:05:23.666304	\N	\N	\N	\N	826127e6-267d-4c76-b6e5-861525cea6f3
6c1e9ef6-9718-4c00-8b15-55ae5a42fa34	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0509.50014	Değişim Tüketim ve Tarım Ürünleri Dağ. A.Ş.	DISTRIBUTOR	DISTRIBUTOR	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.669797	2026-06-23 20:05:23.669797	\N	\N	\N	\N	25297e2d-8503-40bd-a28b-a31306459f6d
fd8fb18e-2ece-4a9e-a2dd-9a43d846b0ae	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0510.50020	Saldos Ticaret  Anonim Şirketi	E_COMMERCE	DIRECT	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.674593	2026-06-23 20:05:23.674593	\N	\N	\N	\N	15a76d17-8e08-4c69-b283-ead8da0424d8
da47626d-8b44-410c-bef0-42a84d86022f	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0513.50031	Uzuner Gıda San ve Tic.Ltd.Şti	DISTRIBUTOR	DISTRIBUTOR	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.679631	2026-06-23 20:05:23.679631	\N	\N	\N	\N	54943c0b-df0f-4988-a4b0-9350b48d3e84
d7bfb18f-7c75-4d53-95cb-0e68a9840e3b	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CUST-BS0513.50109	MF Uzay Tic.Top.Satış San Ve Tic Ltd Şti	DISTRIBUTOR	DISTRIBUTOR	ACTIVE	\N	\N	\N	Turkey	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-06-23 20:05:23.683158	2026-06-23 20:05:23.683158	\N	\N	\N	\N	6f759975-9c61-4233-a2b3-be1e6f1a09f9
e4110af0-6d1f-48df-975d-424cbba7e479	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-CUST-1785606839	E2E PW Test Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-01 17:53:59.307601	2026-08-01 17:54:05.737086	2026-08-01 17:54:05.737086	\N	\N	\N	\N
92b185b5-1315-4a2c-992e-6993ce857355	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785608433498	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-01 18:20:37.156848	2026-08-01 18:20:37.313459	2026-08-01 18:20:37.313459	\N	\N	\N	\N
9a0b384e-b363-4d6f-b316-e1fd0cce2bd4	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785608457238	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-01 18:20:59.599531	2026-08-01 18:20:59.714592	2026-08-01 18:20:59.714592	\N	\N	\N	\N
5bd88598-9d78-4d3f-88a3-c99b88c363ac	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785608486909	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-01 18:21:29.265118	2026-08-01 18:21:29.390666	2026-08-01 18:21:29.390666	\N	\N	\N	\N
0f38893d-e6b0-478a-8ba1-a794b57af709	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785608506445	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-01 18:21:48.874728	2026-08-01 18:21:48.983725	2026-08-01 18:21:48.983725	\N	\N	\N	\N
cc011393-cac0-4ed1-84e0-e3f37f99bb9b	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785608525175	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-01 18:22:07.805951	2026-08-01 18:22:07.964388	2026-08-01 18:22:07.964388	\N	\N	\N	\N
a9513afc-85d2-4f60-9cbe-a813e822e0e4	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785608545190	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-01 18:22:27.616816	2026-08-01 18:22:27.73799	2026-08-01 18:22:27.73799	\N	\N	\N	\N
13ccdfef-10d6-4de1-8dfb-75a028db4d35	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785608564121	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-01 18:22:46.616325	2026-08-01 18:22:46.733377	2026-08-01 18:22:46.733377	\N	\N	\N	\N
1636e8f9-2dba-4f15-9f99-32e6ec489c46	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785608969098	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-01 18:29:31.749507	2026-08-01 18:29:31.863133	2026-08-01 18:29:31.863133	\N	\N	\N	\N
a12cb8e0-3ea4-4df1-af76-c76d90259013	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785609194278	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-01 18:33:16.611688	2026-08-01 18:33:16.751922	2026-08-01 18:33:16.751922	\N	\N	\N	\N
9e5bcddd-0663-44e9-ab37-709518b61d17	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785609213318	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-01 18:33:35.734111	2026-08-01 18:33:35.844829	2026-08-01 18:33:35.844829	\N	\N	\N	\N
dc41e54e-c538-42dc-9f5f-3c7229ae42ea	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785626947824	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-01 23:29:12.545785	2026-08-01 23:29:12.766859	2026-08-01 23:29:12.766859	\N	\N	\N	\N
8c942f96-df90-4a17-b3c6-1fa1584307b9	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785626989856	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-01 23:29:53.721707	2026-08-01 23:29:53.914316	2026-08-01 23:29:53.914316	\N	\N	\N	\N
47d75d2f-ab90-4d93-a215-10bde4a37c79	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785658499692	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-02 08:15:12.605415	2026-08-02 08:15:13.167535	2026-08-02 08:15:13.167535	\N	\N	\N	\N
6120f446-63b2-4cbd-8a6d-6f4a389def88	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785658552864	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-02 08:15:57.075314	2026-08-02 08:15:57.323963	2026-08-02 08:15:57.323963	\N	\N	\N	\N
7a06094c-8885-4665-adf6-fd854046a4fc	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785658600376	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-02 08:16:44.475114	2026-08-02 08:16:44.704666	2026-08-02 08:16:44.704666	\N	\N	\N	\N
c753ea3b-1bcb-4a35-8b2a-dc56b6e020c4	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785659004981	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-02 08:23:28.664189	2026-08-02 08:23:28.93692	2026-08-02 08:23:28.93692	\N	\N	\N	\N
17f3bc9d-aa24-4e42-9464-16d440958562	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785659041947	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-02 08:24:07.55817	2026-08-02 08:24:07.86232	2026-08-02 08:24:07.86232	\N	\N	\N	\N
7aac3547-f958-4cee-ac6e-f5738f2c4450	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785659083904	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-02 08:24:47.670222	2026-08-02 08:24:47.853914	2026-08-02 08:24:47.853914	\N	\N	\N	\N
3f074efc-32fd-43d4-b145-89e41bf041fe	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785660175238	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-02 08:42:57.969239	2026-08-02 08:42:58.111698	2026-08-02 08:42:58.111698	\N	\N	\N	\N
04b1944e-216a-4512-8147-51df124f010d	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785660204288	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-02 08:43:27.077185	2026-08-02 08:43:27.258488	2026-08-02 08:43:27.258488	\N	\N	\N	\N
0bda0109-c089-422c-a746-d797955ff4e5	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785660230580	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-02 08:43:53.345267	2026-08-02 08:43:53.534949	2026-08-02 08:43:53.534949	\N	\N	\N	\N
ee716a79-0bc7-4a36-b6d8-aba46f0a7c3d	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785663194931	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-02 09:33:17.905207	2026-08-02 09:33:18.064484	2026-08-02 09:33:18.064484	\N	\N	\N	\N
90e6f9c4-6d90-4c6b-a4aa-02a7622cd7d9	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785663454571	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-02 09:37:37.371815	2026-08-02 09:37:37.551178	2026-08-02 09:37:37.551178	\N	\N	\N	\N
34c5a053-0742-4bf5-b2c8-3011f399bb3a	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785663599871	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-02 09:40:02.61995	2026-08-02 09:40:02.763255	2026-08-02 09:40:02.763255	\N	\N	\N	\N
0233ccc8-bf57-43f1-8b41-16a5a3b210b1	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785663739452	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-02 09:42:22.381519	2026-08-02 09:42:22.524386	2026-08-02 09:42:22.524386	\N	\N	\N	\N
272b52b0-4363-43b1-97e9-296e7c5d6e96	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785663863070	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-02 09:44:26.064421	2026-08-02 09:44:26.20627	2026-08-02 09:44:26.20627	\N	\N	\N	\N
2c9a7dc2-8665-4f20-8e5a-e832a1698b00	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785663889637	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-02 09:44:52.466628	2026-08-02 09:44:52.633257	2026-08-02 09:44:52.633257	\N	\N	\N	\N
7a6b815a-2024-4bb3-9f4f-452891788782	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785663918427	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-02 09:45:21.177951	2026-08-02 09:45:21.334064	2026-08-02 09:45:21.334064	\N	\N	\N	\N
6be4ca9f-632a-405d-918b-2b5d2018902c	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785664355788	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-02 09:52:40.99375	2026-08-02 09:52:41.211887	2026-08-02 09:52:41.211887	\N	\N	\N	\N
ccd92c70-27f4-4353-982f-6ff8b51f0517	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785664483391	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-02 09:54:46.118808	2026-08-02 09:54:46.267284	2026-08-02 09:54:46.267284	\N	\N	\N	\N
18b34876-49b5-4850-a341-938cce5dd05e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1785664606938	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-02 09:56:49.953556	2026-08-02 09:56:50.098644	2026-08-02 09:56:50.098644	\N	\N	\N	\N
d8ca5ff5-f21f-42ae-9771-21cdc30c4f29	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786210860721	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-08 17:41:03.233102	2026-08-08 17:41:03.378807	2026-08-08 17:41:03.378807	\N	\N	\N	\N
6f3de773-3278-48ab-828d-36bbe070091b	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786212318493	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-08 18:05:20.905154	2026-08-08 18:05:21.060528	2026-08-08 18:05:21.060528	\N	\N	\N	\N
cd3726d0-d553-41a8-acb0-3b80e8d3d6fc	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786212791025	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-08 18:13:13.530713	2026-08-08 18:13:13.647544	2026-08-08 18:13:13.647544	\N	\N	\N	\N
dcb20fc4-bb33-4cb4-9c04-76ea9310baa0	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786215638564	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-08 19:00:40.686144	2026-08-08 19:00:40.798327	2026-08-08 19:00:40.798327	\N	\N	\N	\N
b65059b3-5aac-4fef-ac18-c819389129b6	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786216076479	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-08 19:07:58.822361	2026-08-08 19:07:58.982774	2026-08-08 19:07:58.982774	\N	\N	\N	\N
de49aef1-07ae-48da-a8a6-5eb395aa651a	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786216416260	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-08 19:13:38.39799	2026-08-08 19:13:38.520952	2026-08-08 19:13:38.520952	\N	\N	\N	\N
bf634af1-6b94-4a9b-a35a-fe36444b1c59	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786217481655	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-08 19:31:23.94821	2026-08-08 19:31:24.090907	2026-08-08 19:31:24.090907	\N	\N	\N	\N
7438cc80-efb1-4247-a207-00740c941fa9	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786217579276	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-08 19:33:01.693854	2026-08-08 19:33:01.801589	2026-08-08 19:33:01.801589	\N	\N	\N	\N
89114645-a8bc-4506-9381-53b2ba7c2b89	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786217603110	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-08 19:33:25.209869	2026-08-08 19:33:25.364693	2026-08-08 19:33:25.364693	\N	\N	\N	\N
d9b00bcf-999d-4457-bad6-83709d9d240e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786217669861	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-08 19:34:32.156976	2026-08-08 19:34:32.270149	2026-08-08 19:34:32.270149	\N	\N	\N	\N
5384bf95-efec-4664-a648-fa0718bd7439	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786229808069	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-08 22:56:51.426541	2026-08-08 22:56:51.885394	2026-08-08 22:56:51.885394	\N	\N	\N	\N
0bda6a76-9187-480c-8421-9933348798c1	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786229972771	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-08 22:59:36.513138	2026-08-08 22:59:36.711819	2026-08-08 22:59:36.711819	\N	\N	\N	\N
e12fceac-ac46-4562-a6d4-b7326903a660	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786230907009	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-08 23:15:09.747044	2026-08-08 23:15:09.891533	2026-08-08 23:15:09.891533	\N	\N	\N	\N
918dc5d4-3808-4b64-91ee-3611f9f95c08	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786231063426	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-08 23:17:46.340979	2026-08-08 23:17:46.507218	2026-08-08 23:17:46.507218	\N	\N	\N	\N
7db859ee-0bf4-469c-bd4b-2261030e8cb9	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786268823869	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-09 09:47:06.932066	2026-08-09 09:47:07.12023	2026-08-09 09:47:07.12023	\N	\N	\N	\N
5230bb35-bc82-46dd-a64f-0bbb3b38a41b	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786269135311	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-09 09:52:19.360827	2026-08-09 09:52:19.75352	2026-08-09 09:52:19.75352	\N	\N	\N	\N
44dc15aa-87e8-4f65-b14d-bc0d9e23b8c4	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786270751407	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-09 10:19:14.314499	2026-08-09 10:19:14.468417	2026-08-09 10:19:14.468417	\N	\N	\N	\N
92c8bf52-42c9-41a8-a512-31cba832f5ad	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786271118685	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-09 10:25:22.38865	2026-08-09 10:25:22.646503	2026-08-09 10:25:22.646503	\N	\N	\N	\N
2dd7f588-d39b-4457-8c68-40015164969b	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786274408467	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-09 11:20:11.581081	2026-08-09 11:20:11.800578	2026-08-09 11:20:11.800578	\N	\N	\N	\N
a1d05322-b6da-4020-8fde-dd888aafced4	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786275059097	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-09 11:31:02.143067	2026-08-09 11:31:02.386974	2026-08-09 11:31:02.386974	\N	\N	\N	\N
ccdc813e-2c05-45a6-8b76-e17c6a0f3060	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786275365579	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-09 11:36:08.913751	2026-08-09 11:36:09.076941	2026-08-09 11:36:09.076941	\N	\N	\N	\N
aef970fa-6d47-46fb-bd27-2bd04c8e50c6	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786276507240	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-09 11:55:10.400557	2026-08-09 11:55:10.577212	2026-08-09 11:55:10.577212	\N	\N	\N	\N
abf4579d-632e-475f-a481-044cafa5b299	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786276920887	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-09 12:02:04.086318	2026-08-09 12:02:04.287537	2026-08-09 12:02:04.287537	\N	\N	\N	\N
67201113-3017-46a3-8b9a-858276de1f6d	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786278001719	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-09 12:20:04.639857	2026-08-09 12:20:04.904843	2026-08-09 12:20:04.904843	\N	\N	\N	\N
a8ef8249-aa6f-4f96-bcb7-875c865b1b0a	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786280264813	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-09 12:57:47.715126	2026-08-09 12:57:48.030504	2026-08-09 12:57:48.030504	\N	\N	\N	\N
7a8b400b-43b3-4d2b-a63f-78fb4c0770b1	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786280378417	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-09 12:59:40.908815	2026-08-09 12:59:41.05006	2026-08-09 12:59:41.05006	\N	\N	\N	\N
5c27f37c-171f-4ea2-a568-1367792f2286	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786280504515	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-09 13:01:46.918212	2026-08-09 13:01:47.051478	2026-08-09 13:01:47.051478	\N	\N	\N	\N
b7ed27f0-39c8-44f0-a2ef-1e5652f73586	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786280719532	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-09 13:05:21.977887	2026-08-09 13:05:22.090419	2026-08-09 13:05:22.090419	\N	\N	\N	\N
1e9847a9-354e-437f-a9a2-430228ae3f87	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786281299093	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-09 13:15:01.502606	2026-08-09 13:15:01.609506	2026-08-09 13:15:01.609506	\N	\N	\N	\N
1eaf9bbe-59d4-42f7-93fe-d39e5a5113dd	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786296921223	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-09 17:35:23.566354	2026-08-09 17:35:23.672203	2026-08-09 17:35:23.672203	\N	\N	\N	\N
163d469e-3a1c-44e9-8b4e-3ca20af7c058	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786296984368	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-09 17:36:26.53282	2026-08-09 17:36:26.646632	2026-08-09 17:36:26.646632	\N	\N	\N	\N
12a29a24-9e6e-4fcb-85f1-a80e161d3a70	598a895e-5a20-48cc-95bd-a52fe5d4bb65	E2E-PW-UPLOAD-1786297114242	E2E Playwright Upload Customer	RETAIL	DIRECT	ACTIVE	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	TRY	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	\N	f	\N	\N	2026-08-09 17:38:36.728076	2026-08-09 17:38:36.857876	2026-08-09 17:38:36.857876	\N	\N	\N	\N
\.


--
-- Data for Name: forecasting_units; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.forecasting_units (id, tenant_id, code, name, description, gu_id, size, segment, is_plannable, default_base_volume, base_price, currency, unit_of_measure, is_active, metadata, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
e5ae5fc1-1519-4fe0-9e29-52898c3c2945	598a895e-5a20-48cc-95bd-a52fe5d4bb65	FU-KARMA-KOLI	Wella Karma Koli	\N	7b885427-7888-4014-83bb-393f7fc2ba48	\N	\N	t	\N	\N	TRY	\N	t	{"source": "Wella Product.xlsx", "sheet2Category": "Karma Koli"}	2026-07-29 12:16:02.697403	2026-07-29 12:16:02.697403	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
b6a8cd09-c073-4672-bfa1-09618a9bb044	598a895e-5a20-48cc-95bd-a52fe5d4bb65	FU-WELLAFLEX	Wella Wellaflex	\N	2885493c-7a3c-405c-8857-f6e9c0dfbbb1	\N	\N	t	\N	\N	TRY	\N	t	{"source": "Wella Product.xlsx", "sheet2Category": "Köpük"}	2026-07-29 12:16:02.700098	2026-07-29 12:16:02.700098	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
21d4bb42-3d17-431f-b040-1b52a1ebebba	598a895e-5a20-48cc-95bd-a52fe5d4bb65	FU-TUP-BOYA	Wella Tüp Boya	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	\N	\N	t	\N	\N	TRY	\N	t	{"source": "Wella Product.xlsx", "sheet2Category": "Saç Boyası"}	2026-07-29 12:16:02.701365	2026-07-29 12:16:02.701365	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
38095fb8-a94e-4577-b927-758b4a6cab34	598a895e-5a20-48cc-95bd-a52fe5d4bb65	FU-NEW-WAVE	Wella New Wave	\N	3072464e-d25b-47fb-9182-d222ec30e74f	\N	\N	t	\N	\N	TRY	\N	t	{"source": "Wella Product.xlsx", "sheet2Category": "Şekillendirici"}	2026-07-29 12:16:02.702719	2026-07-29 12:16:02.702719	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
54a8a83a-6e73-4aff-bba2-0223d634af1f	598a895e-5a20-48cc-95bd-a52fe5d4bb65	FU-NATURALS	Wella Naturals	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	\N	\N	t	\N	\N	TRY	\N	t	{"source": "Wella Product.xlsx", "sheet2Category": "Saç Boyası"}	2026-07-29 12:16:02.704028	2026-07-29 12:16:02.704028	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
a48113b4-6a66-4c10-b8b9-e0d77b754125	598a895e-5a20-48cc-95bd-a52fe5d4bb65	FU-INTENSE	Wella İntense	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	\N	\N	t	\N	\N	TRY	\N	t	{"source": "Wella Product.xlsx", "sheet2Category": "Set Boya"}	2026-07-29 12:16:02.705309	2026-07-29 12:16:02.705309	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
f33675dd-6bc5-4a0b-8483-be94ad4b270d	598a895e-5a20-48cc-95bd-a52fe5d4bb65	FU-PEROKSIT	Wella Peroksit	\N	18e5cf4a-2e63-4381-a6d5-14cccf367287	\N	\N	t	\N	\N	TRY	\N	t	{"source": "Wella Product.xlsx", "sheet2Category": "Peroksit"}	2026-07-29 12:16:02.706695	2026-07-29 12:16:02.706695	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
2a460e05-b93a-4d24-9a35-5051d935a53f	598a895e-5a20-48cc-95bd-a52fe5d4bb65	FU-KOLESTON-KIT	Wella Koleston Kit	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	\N	\N	t	\N	\N	TRY	\N	t	{"source": "Wella Product.xlsx", "sheet2Category": "Set Boya"}	2026-07-29 12:16:02.708136	2026-07-29 12:16:02.708136	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
889ae817-6fcb-4df3-9409-074fe2a3b460	598a895e-5a20-48cc-95bd-a52fe5d4bb65	FU-KOLESTON	Wella Koleston	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	\N	\N	t	\N	\N	TRY	\N	t	{"source": "Wella Product.xlsx", "sheet2Category": "Saç Boyası"}	2026-07-29 12:16:02.70945	2026-07-29 12:16:02.70945	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
f5b0e3ad-f524-4a84-96ae-0cba7176fe50	598a895e-5a20-48cc-95bd-a52fe5d4bb65	FU-PROMOSYON	Wella Promosyon	\N	e77c959a-69dd-40d5-bc8f-d6d25b33aa50	\N	\N	t	\N	\N	TRY	\N	t	{"source": "Wella Product.xlsx", "sheet2Category": "Diğer"}	2026-07-29 12:16:02.710849	2026-07-29 12:16:02.710849	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
c451e8b8-c653-4bd5-8963-983a33657c05	598a895e-5a20-48cc-95bd-a52fe5d4bb65	FU-WELLA-HC-500ML	Wella Hair Care 500ml	\N	7e5eacf9-cf1d-4bd1-a479-029ea6722311	500ml	Premium	t	\N	\N	TRY	\N	t	\N	2026-07-29 12:16:02.98985	2026-07-29 12:16:02.98985	\N	67b863d1-1a98-464d-af7b-df0b219748ae	\N
fa4b7d6c-92de-448a-8ac6-e54ced38c81a	598a895e-5a20-48cc-95bd-a52fe5d4bb65	FU-E2E-GRID-SINGLE-SKU	E2E Grid Fixture FU (single SKU)	\N	7e5eacf9-cf1d-4bd1-a479-029ea6722311	500ml	Premium	t	\N	\N	TRY	\N	t	\N	2026-08-08 17:34:33.917431	2026-08-08 17:34:33.917431	\N	67b863d1-1a98-464d-af7b-df0b219748ae	\N
\.


--
-- Data for Name: generic_units; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.generic_units (id, tenant_id, code, name, description, brand_id, category_id, is_active, metadata, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
041bdf91-afbf-4d2d-a744-2181eca5410e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	GU-WELLA-SAC-BOYASI	Wella Saç Boyası	\N	59a8b918-e940-4606-a42e-8738b4221fbc	24fb3bc9-4eed-4116-8f70-395029798c46	t	{"source": "Wella Product.xlsx"}	2026-07-29 12:16:02.686157	2026-07-29 12:16:02.686157	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	598a895e-5a20-48cc-95bd-a52fe5d4bb65	GU-WELLA-SET-BOYA	Wella Set Boya	\N	59a8b918-e940-4606-a42e-8738b4221fbc	08d8d7d8-b21e-4f81-8fe5-647f38f67f90	t	{"source": "Wella Product.xlsx"}	2026-07-29 12:16:02.689093	2026-07-29 12:16:02.689093	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
3072464e-d25b-47fb-9182-d222ec30e74f	598a895e-5a20-48cc-95bd-a52fe5d4bb65	GU-WELLA-SEKILLENDIRICI	Wella Şekillendirici	\N	59a8b918-e940-4606-a42e-8738b4221fbc	d465de24-491e-4f85-bcfd-ab70f8878c73	t	{"source": "Wella Product.xlsx"}	2026-07-29 12:16:02.690556	2026-07-29 12:16:02.690556	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
2885493c-7a3c-405c-8857-f6e9c0dfbbb1	598a895e-5a20-48cc-95bd-a52fe5d4bb65	GU-WELLA-KOPUK	Wella Köpük	\N	59a8b918-e940-4606-a42e-8738b4221fbc	8161c891-e739-44eb-8489-b24026c2aaa8	t	{"source": "Wella Product.xlsx"}	2026-07-29 12:16:02.692019	2026-07-29 12:16:02.692019	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
18e5cf4a-2e63-4381-a6d5-14cccf367287	598a895e-5a20-48cc-95bd-a52fe5d4bb65	GU-WELLA-PEROKSIT	Wella Peroksit	\N	59a8b918-e940-4606-a42e-8738b4221fbc	0b6be58e-9b58-425d-8328-786664ad54a8	t	{"source": "Wella Product.xlsx"}	2026-07-29 12:16:02.693475	2026-07-29 12:16:02.693475	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
e77c959a-69dd-40d5-bc8f-d6d25b33aa50	598a895e-5a20-48cc-95bd-a52fe5d4bb65	GU-WELLA-DIGER	Wella Diğer	\N	59a8b918-e940-4606-a42e-8738b4221fbc	e829006d-fa00-4f7d-b305-e833de3bcf30	t	{"source": "Wella Product.xlsx"}	2026-07-29 12:16:02.694752	2026-07-29 12:16:02.694752	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
7b885427-7888-4014-83bb-393f7fc2ba48	598a895e-5a20-48cc-95bd-a52fe5d4bb65	GU-WELLA-KARMA-KOLI	Wella Karma Koli	\N	59a8b918-e940-4606-a42e-8738b4221fbc	da0a990e-343b-45c9-93a1-39c9ae695cc8	t	{"source": "Wella Product.xlsx"}	2026-07-29 12:16:02.695959	2026-07-29 12:16:02.695959	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
7e5eacf9-cf1d-4bd1-a479-029ea6722311	598a895e-5a20-48cc-95bd-a52fe5d4bb65	GU-WELLA-HC-001	Wella Hair Care Generic Unit	\N	59a8b918-e940-4606-a42e-8738b4221fbc	7036ca74-12fa-4a66-a5fe-363d67455f63	t	\N	2026-07-29 12:16:02.988536	2026-07-29 12:16:02.988536	\N	67b863d1-1a98-464d-af7b-df0b219748ae	\N
\.


--
-- Data for Name: kpis; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.kpis (id, tenant_id, kpi_code, kpi_name, kpi_group, kpi_description, formula_type, formula_text, depends_on_kpis, calculation_order, calculation_level, display_format, decimal_places, show_in_grid, column_order, aggregation_method_fu, rag_green_threshold, rag_amber_threshold, is_active, metadata, created_at, updated_at, deleted_at, created_by, updated_by, version) FROM stdin;
72acdab8-f7fc-4938-b660-1af40890054c	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BASE_VOL	Base Volume	Volume	Historical baseline volume (user input)	user_input	BASE_VOL	\N	1	sku	number	0	t	1	sum	\N	\N	t	\N	2026-06-17 18:51:08.274275	2026-06-17 18:51:08.274275	\N	\N	\N	1
6a08d0a0-51e7-4095-b434-ecac4fab38e8	598a895e-5a20-48cc-95bd-a52fe5d4bb65	PLAN_VOL	Planned Volume	Volume	Planned promotion volume (user input)	user_input	PLAN_VOL	\N	2	sku	number	0	t	2	sum	\N	\N	t	\N	2026-06-17 18:51:08.413767	2026-06-17 18:51:08.413767	\N	\N	\N	1
d28e154b-cd44-485d-8adb-462c1fe1a710	598a895e-5a20-48cc-95bd-a52fe5d4bb65	GP_ROI_PCT	GP ROI %	ROI	Incremental GP ROI %: INCR_GP / TOTAL_PLANNED_SPEND * 100 (BRD canonical — ADR 0011: bkz. docs/decisions/0011-gp-roi-paydasi-total-planned-spend.md)	expression	INCR_GP / TOTAL_PLANNED_SPEND * 100	["INCR_GP", "TOTAL_PLANNED_SPEND"]	48	sku	percentage	1	t	8	weighted_avg	20.0000	10.0000	t	\N	2026-06-17 18:51:08.444848	2026-08-10 20:20:34.632097	\N	\N	\N	1
84737267-4b82-40fb-aa9f-09a85443e555	598a895e-5a20-48cc-95bd-a52fe5d4bb65	PLANNED_LTA_ON	Planned LTA On-Invoice	Spend	Planned LTA on-invoice deduction (context-injected from SpendCalc)	external	PLANNED_LTA_ON	\N	5	sku	currency	2	f	\N	sum	\N	\N	t	\N	2026-06-25 07:51:36.246243	2026-06-25 07:51:36.246243	\N	\N	\N	1
2361fec1-db09-40de-a953-37f00b0f069a	598a895e-5a20-48cc-95bd-a52fe5d4bb65	PLANNED_LTA_OFF	Planned LTA Off-Invoice	Spend	Planned LTA off-invoice deduction (context-injected from SpendCalc)	external	PLANNED_LTA_OFF	\N	6	sku	currency	2	f	\N	sum	\N	\N	t	\N	2026-06-25 07:51:36.31741	2026-06-25 07:51:36.31741	\N	\N	\N	1
b4f8e3eb-ab88-4dd6-9fb6-da7b6e7bc768	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BASE_LTA_ON	Base LTA On-Invoice	Spend	Base LTA on-invoice deduction (context-injected from SpendCalc)	external	BASE_LTA_ON	\N	7	sku	currency	2	f	\N	sum	\N	\N	t	\N	2026-06-25 07:51:36.322233	2026-06-25 07:51:36.322233	\N	\N	\N	1
67f642af-ca72-4a72-b9bb-134df0216305	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BASE_LTA_OFF	Base LTA Off-Invoice	Spend	Base LTA off-invoice deduction (context-injected from SpendCalc)	external	BASE_LTA_OFF	\N	8	sku	currency	2	f	\N	sum	\N	\N	t	\N	2026-06-25 07:51:36.328059	2026-06-25 07:51:36.328059	\N	\N	\N	1
2081dc17-f237-4b92-be45-a786503c94e0	598a895e-5a20-48cc-95bd-a52fe5d4bb65	TOTAL_PLANNED_SPEND	Total Planned Spend	Spend	Sum of all planned spend (LTA + promo); context-injected from SpendCalc	external	TOTAL_PLANNED_SPEND	\N	9	sku	currency	2	t	6	sum	\N	\N	t	\N	2026-06-25 07:51:36.33725	2026-06-25 07:51:36.33725	\N	\N	\N	1
e73bd4c2-9060-4e65-b917-27934e46b954	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BASE_TOTAL_SPEND	Base Total Spend	Spend	Base total spend (LTA only, no promo); context-injected from SpendCalc	external	BASE_TOTAL_SPEND	\N	10	sku	currency	2	f	\N	sum	\N	\N	t	\N	2026-06-25 07:51:36.34933	2026-06-25 07:51:36.34933	\N	\N	\N	1
322d3c80-61a4-4a9f-a478-2b46dc33108e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	INCR_SPEND	Incremental Spend	Spend	TOTAL_PLANNED_SPEND - BASE_TOTAL_SPEND; context-injected from SpendCalc	external	INCR_SPEND	\N	11	sku	currency	2	f	\N	sum	\N	\N	t	\N	2026-06-25 07:51:36.35563	2026-06-25 07:51:36.35563	\N	\N	\N	1
d440b9f2-5ef3-49c8-b9ed-2fbfbf2438f0	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BASE_GSV	Base GSV	Revenue	Base Gross Sales Value: BASE_VOL * BPTT (BRD formula level 3)	expression	BASE_VOL * BPTT	["BASE_VOL", "BPTT"]	15	sku	currency	2	f	\N	sum	\N	\N	t	\N	2026-06-25 07:51:36.362219	2026-06-25 07:51:36.362219	\N	\N	\N	1
c7fb99af-1ebb-4920-a929-1966ce9f718a	598a895e-5a20-48cc-95bd-a52fe5d4bb65	PLANNED_GSV	Planned GSV	Revenue	Planned Gross Sales Value: PLAN_VOL * BPTT (BRD formula level 3)	expression	PLAN_VOL * BPTT	["PLAN_VOL", "BPTT"]	16	sku	currency	2	f	\N	sum	\N	\N	t	\N	2026-06-25 07:51:36.373085	2026-06-25 07:51:36.373085	\N	\N	\N	1
d7986a66-1dba-4912-9cce-a8ab32702bb0	598a895e-5a20-48cc-95bd-a52fe5d4bb65	INCR_VOL	Incremental Volume	Volume	Planned minus base volume: PLAN_VOL - BASE_VOL	expression	PLAN_VOL - BASE_VOL	["PLAN_VOL", "BASE_VOL"]	20	sku	number	0	t	3	sum	\N	\N	t	\N	2026-06-17 18:51:08.418728	2026-06-25 07:51:36.380865	\N	\N	\N	1
09062581-f63a-4945-bec3-a0c7a4c448ed	598a895e-5a20-48cc-95bd-a52fe5d4bb65	UPLIFT_PCT	Uplift %	Volume	Volume uplift percentage: (PLAN_VOL - BASE_VOL) / BASE_VOL * 100	expression	(PLAN_VOL - BASE_VOL) / BASE_VOL * 100	["PLAN_VOL", "BASE_VOL"]	21	sku	percentage	1	t	4	weighted_avg	\N	\N	t	\N	2026-06-17 18:51:08.423991	2026-06-25 07:51:36.39078	\N	\N	\N	1
174d23b9-e453-489e-8e34-d7867f30a0e7	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BASE_COGS	Base COGS	Cost	Base cost of goods sold: BASE_VOL * COGS (BRD formula)	expression	BASE_VOL * COGS	["BASE_VOL", "COGS"]	30	sku	currency	2	f	\N	sum	\N	\N	t	\N	2026-06-25 07:51:36.405154	2026-06-25 07:51:36.405154	\N	\N	\N	1
a6dbccc8-41e1-46bb-af94-04d1a388e4f5	598a895e-5a20-48cc-95bd-a52fe5d4bb65	PLANNED_COGS	Planned COGS	Cost	Planned cost of goods sold: PLAN_VOL * COGS (BRD formula)	expression	PLAN_VOL * COGS	["PLAN_VOL", "COGS"]	31	sku	currency	2	f	\N	sum	\N	\N	t	\N	2026-06-25 07:51:36.408439	2026-06-25 07:51:36.408439	\N	\N	\N	1
6e8293bc-bfca-456a-8acb-5bbc61ec19dd	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BASE_GP	Base Gross Profit	Profit	Base gross profit: BASE_TO - BASE_COGS (BRD formula)	expression	BASE_TO - BASE_COGS	["BASE_TO", "BASE_COGS"]	35	sku	currency	2	f	\N	sum	\N	\N	t	\N	2026-06-25 07:51:36.41275	2026-06-25 07:51:36.41275	\N	\N	\N	1
3a16223e-df41-4fa7-98a9-1ed478c8a54f	598a895e-5a20-48cc-95bd-a52fe5d4bb65	PLANNED_GP	Planned Gross Profit	Profit	Planned gross profit: PLANNED_TO - PLANNED_COGS (BRD formula)	expression	PLANNED_TO - PLANNED_COGS	["PLANNED_TO", "PLANNED_COGS"]	36	sku	currency	2	f	\N	sum	\N	\N	t	\N	2026-06-25 07:51:36.416206	2026-06-25 07:51:36.416206	\N	\N	\N	1
b585aac7-6e7c-48c1-8fcf-7cb1fd16b8f0	598a895e-5a20-48cc-95bd-a52fe5d4bb65	INCR_GP	Incremental Gross Profit	Profit	Incremental gross profit: PLANNED_GP - BASE_GP (BRD formula) — MUST be before GP_ROI_PCT	expression	PLANNED_GP - BASE_GP	["PLANNED_GP", "BASE_GP"]	46	sku	currency	2	t	7	sum	\N	\N	t	\N	2026-06-25 07:51:36.422034	2026-06-25 07:51:36.422034	\N	\N	\N	1
3448af56-b255-4f3a-8bb2-d91f5e3bbb6a	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CPP_ON_SPEND	CPP On-Invoice Spend	Spend	CPP on-invoice spend: (PLANNED_GSV - PLANNED_LTA_ON) * (CPP_ON_PCT / 100) (BRD formula)	expression	(PLANNED_GSV - PLANNED_LTA_ON) * CPP_ON_PCT / 100	["PLANNED_GSV", "PLANNED_LTA_ON", "CPP_ON_PCT"]	47	sku	currency	2	f	\N	sum	\N	\N	t	\N	2026-06-25 07:51:36.427846	2026-06-25 07:51:36.427846	\N	\N	\N	1
03c1adee-5c3e-4a86-b8d2-7fdc30f400e6	598a895e-5a20-48cc-95bd-a52fe5d4bb65	GP_MARGIN_PCT	GP Margin %	Profit	Planned GP as percentage of planned turnover: PLANNED_GP / PLANNED_TO * 100	expression	PLANNED_GP / PLANNED_TO * 100	["PLANNED_GP", "PLANNED_TO"]	49	sku	percentage	1	f	\N	weighted_avg	\N	\N	t	\N	2026-06-17 18:51:08.458452	2026-06-25 07:59:40.586901	\N	\N	\N	1
fd3ccd34-3157-4f7c-ac3c-a0c9dac27c13	598a895e-5a20-48cc-95bd-a52fe5d4bb65	PLANNED_TO	Planned Turnover	Revenue	Planned net turnover: PLANNED_GSV - PLANNED_ON_INVOICE_SPEND (BRD NIV semantics — only on-invoice deductions; T-008)	expression	PLANNED_GSV - PLANNED_ON_INVOICE_SPEND	["PLANNED_GSV", "PLANNED_ON_INVOICE_SPEND"]	26	sku	currency	2	t	5	sum	\N	\N	t	\N	2026-06-25 07:51:36.400893	2026-06-25 08:09:30.358699	\N	\N	\N	1
50068167-f935-4091-80d7-d447c93ec405	598a895e-5a20-48cc-95bd-a52fe5d4bb65	BASE_TO	Base Turnover	Revenue	Base net turnover: BASE_GSV - BASE_LTA_ON (BRD NIV semantics — only on-invoice; T-008)	expression	BASE_GSV - BASE_LTA_ON	["BASE_GSV", "BASE_LTA_ON"]	25	sku	currency	2	f	\N	sum	\N	\N	t	\N	2026-06-25 07:51:36.397134	2026-06-25 08:09:30.386919	\N	\N	\N	1
929f207d-a219-4ee3-8a6d-9bed4e786667	598a895e-5a20-48cc-95bd-a52fe5d4bb65	PLANNED_ON_INVOICE_SPEND	Planned On-Invoice Spend	Spend	Total planned on-invoice deductions (LTA_ON + all on-invoice promo); context-injected from SpendCalc (T-008)	external	PLANNED_ON_INVOICE_SPEND	[]	12	sku	currency	2	f	\N	sum	\N	\N	t	\N	2026-06-25 08:09:30.393417	2026-06-25 08:09:30.393417	\N	\N	\N	1
745bc991-07ee-455a-8e40-4ec03a364d0d	598a895e-5a20-48cc-95bd-a52fe5d4bb65	PLAN_TURNOVER	Planned Turnover	Revenue	Planned volume x unit price	expression	PLAN_VOL * BPTT	\N	5	sku	currency	2	t	5	sum	\N	\N	f	\N	2026-06-17 18:51:08.432496	2026-06-25 08:44:09.127597	\N	\N	\N	1
77bd0abb-906d-4f4b-8628-8eca5b867aa4	598a895e-5a20-48cc-95bd-a52fe5d4bb65	TACTIC_SPEND	Tactic Spend	Spend	Total tactic spend allocated to SKU	external	TACTIC_SPEND	\N	6	sku	currency	2	t	6	sum	\N	\N	f	\N	2026-06-17 18:51:08.43705	2026-06-25 08:44:09.194594	\N	\N	\N	1
8242efb4-f0e4-47d6-abeb-50ab69460d45	598a895e-5a20-48cc-95bd-a52fe5d4bb65	GP	Gross Profit	Profit	Turnover minus COGS minus tactic spend	expression	(PLAN_VOL * BPTT) - (PLAN_VOL * COGS) - TACTIC_SPEND	\N	7	sku	currency	2	t	7	sum	\N	\N	f	\N	2026-06-17 18:51:08.440882	2026-06-25 08:44:09.197308	\N	\N	\N	1
\.


--
-- Data for Name: ledger_entries; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.ledger_entries (id, tenant_id, source_type, source_id, agreement_id, spend_type, entry_direction, amount, currency, period_month, posting_date, channel, cpl_id, fu_id, tactic_id, mechanic_id, budget_envelope_id, idempotency_key, description, metadata, created_at, updated_at, deleted_at, created_by, updated_by, reverses_entry_id, is_reversed) FROM stdin;
\.


--
-- Data for Name: lta_agreements; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.lta_agreements (id, tenant_id, cpl_id, effective_date, expiry_date, metadata, created_at, updated_at, deleted_at, created_by, updated_by, agreement_name, agreement_code, status, total_agreement_value, notes) FROM stdin;
\.


--
-- Data for Name: lta_plan_overrides; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.lta_plan_overrides (id, tenant_id, plan_id, lta_rate_id, lta_agreement_id, override_on_invoice_pct, override_off_invoice_pct, override_reason, approved_by, approved_at, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: lta_rates; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.lta_rates (id, tenant_id, lta_agreement_id, channel_id, channel, category_id, category, on_invoice_percentage, off_invoice_percentage, minimum_volume_commitment, maximum_discount_cap, payment_terms, is_active, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: mechanic_spend_breakdown; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.mechanic_spend_breakdown (id, tenant_id, plan_sku_id, mechanic_id, plan_mechanic_value_id, calculated_amount, distribution_basis, metadata, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: mechanics; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.mechanics (id, tenant_id, code, name, description, tactic_id, mechanic_type, calculation_rules, min_value, max_value, is_active, metadata, created_at, updated_at, deleted_at, created_by, updated_by, spending_type, calculation_formula, applicability_rules, input_constraints, category, input_type, default_value, step_increment, decimal_places, unit_symbol, formula_variables, formula_validation_status, test_data, applicable_channels, applicable_categories, applicable_cpls, exclusion_rules, show_in_grid, grid_column_order, grid_column_width, group_header, track_against_budget, budget_type, requires_approval_threshold, approval_flow, mutually_exclusive_with, max_combined_discount_percentage, combination_warnings) FROM stdin;
cd96fff2-1b04-41c8-b462-2dfac78e4acf	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CPP_ON_PCT	CPP On-Invoice %	Set A mekanik: on-invoice yüzde indirim. Spend = (PLANNED_GSV - PLANNED_LTA_ON) * CPP_ON_PCT / 100. BRD Set A referans değeri: %10.	7cd1aee3-3d05-47f9-949b-3614275c80f9	PERCENT	\N	0.0000	100.0000	t	\N	2026-07-29 12:16:02.660818	2026-07-29 12:16:02.660818	\N	3b703dae-2955-40a1-affa-f94478da505f	\N	on_invoice	(PLANNED_GSV - PLANNED_LTA_ON) * entered_value / 100	\N	\N	on_invoice_discount	percentage	\N	\N	\N	%	\N	valid	\N	\N	\N	\N	\N	t	10	\N	On-Invoice Discounts	t	on_invoice	\N	\N	\N	\N	\N
8f8ba312-a826-49ee-85e0-23324d84967e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	MEC-DISCOUNT	Discount	Genel on-invoice indirim mekanik (agreement seed ile uyumlu). Spend = (PLANNED_GSV - PLANNED_LTA_ON) * value / 100.	41b55aae-f357-49f1-bd13-a336bbadaf28	PERCENT	\N	0.0000	100.0000	t	\N	2026-07-29 12:16:02.664092	2026-07-29 12:16:02.664092	\N	3b703dae-2955-40a1-affa-f94478da505f	\N	on_invoice	(PLANNED_GSV - PLANNED_LTA_ON) * entered_value / 100	\N	\N	on_invoice_discount	percentage	\N	\N	\N	%	\N	valid	\N	\N	\N	\N	\N	t	11	\N	On-Invoice Discounts	t	on_invoice	\N	\N	\N	\N	\N
f8fae07e-97b1-41c9-b593-abae512d82df	598a895e-5a20-48cc-95bd-a52fe5d4bb65	CPP_OFF_PCT	CPP Off-Invoice %	Off-invoice yüzde indirim. Spend = (PLANNED_GSV - PLANNED_LTA_ON - PLANNED_LTA_OFF - on_inv_promos) * value / 100.	13d8d3de-6f08-4222-b217-a311ae754b1e	PERCENT	\N	0.0000	100.0000	t	\N	2026-07-29 12:16:02.66586	2026-07-29 12:16:02.66586	\N	3b703dae-2955-40a1-affa-f94478da505f	\N	off_invoice	(PLANNED_GSV - PLANNED_LTA_ON - PLANNED_LTA_OFF - total_on_inv_promos) * entered_value / 100	\N	\N	off_invoice_discount	percentage	\N	\N	\N	%	\N	valid	\N	\N	\N	\N	\N	t	20	\N	Off-Invoice Discounts	t	off_invoice	\N	\N	\N	\N	\N
84f04968-7035-4743-bcbe-3adc1347bbdb	598a895e-5a20-48cc-95bd-a52fe5d4bb65	DISPLAY_FEE	Display / Shelf Fee	Teşhir / raf bedeli lump-sum (off-invoice). Spend = entered_value (sabit tutar, FU seviyesinde girilir).	ee06a177-9fa0-4503-a0dc-9277039e180a	AMOUNT	\N	0.0000	\N	t	\N	2026-07-29 12:16:02.669496	2026-07-29 12:16:02.669496	\N	3b703dae-2955-40a1-affa-f94478da505f	\N	off_invoice	entered_value	\N	\N	lumpsum_spend	currency	\N	\N	\N	TRY	\N	valid	\N	\N	\N	\N	\N	t	31	\N	Off-Invoice Lump Sum	t	off_invoice	\N	\N	\N	\N	\N
76e59170-9a44-4c4d-8ae3-6fbe8ff576ee	598a895e-5a20-48cc-95bd-a52fe5d4bb65	PRICE_SUP	Price Support Per Unit	Set A mekanik: birim başı fiyat desteği (off-invoice). Spend = entered_value * PLANNED_VOLUME. BRD Set A referans değeri: 0.25 TRY/birim.	75b984e8-83d8-4abe-95fa-720ffc3aa2ec	AMOUNT_PER_UNIT	\N	0.0000	\N	t	\N	2026-07-29 12:16:02.671252	2026-07-29 12:16:02.671252	\N	3b703dae-2955-40a1-affa-f94478da505f	\N	off_invoice	entered_value * PLANNED_VOLUME	\N	\N	per_unit_support	currency	\N	\N	\N	TRY/unit	\N	valid	\N	\N	\N	\N	\N	t	40	\N	Off-Invoice Per Unit	t	off_invoice	\N	\N	\N	\N	\N
bff656d7-1ec7-4584-a2ad-c88f8bfd8e7f	598a895e-5a20-48cc-95bd-a52fe5d4bb65	VIS_LS	Visibility Lump Sum	Set A mekanik: görünürlük/teşhir lump-sum ödeme (off-invoice). Spend = entered_value (sabit tutar, FU seviyesinde girilir). BRD Set A referans değeri: 2000 TRY.	ee06a177-9fa0-4503-a0dc-9277039e180a	AMOUNT	\N	0.0000	\N	t	\N	2026-07-29 12:16:02.667702	2026-08-10 12:14:15.215109	\N	3b703dae-2955-40a1-affa-f94478da505f	\N	off_invoice	entered_value	\N	\N	lumpsum_spend	currency	\N	\N	\N	TRY	\N	valid	\N	\N	\N	\N	\N	t	30	\N	Off-Invoice Lump Sum	t	off_invoice	\N	\N	\N	\N	\N
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.migrations (id, "timestamp", name) FROM stdin;
133	1704067200000	CreateTenants1704067200000
134	1704067260000	CreateUsers1704067260000
135	1704067320000	CreateCustomers1704067320000
136	1704067380000	AddNumberOfBranchesToCustomers1704067380000
137	1704067500000	CreateBudgetEnvelopes1704067500000
138	1704067520000	CreateBudgetTransactions1704067520000
139	1704067540000	CreateLedgerEntries1704067540000
140	1704067560000	CreateBudgetReservations1704067560000
141	1704067620000	CreateNotifications1704067620000
142	1704067680000	CreateAdminAuditLogs1704067680000
143	1704067740000	CreateBudgetSummaryView1704067740000
144	1704067800000	CreateAgreements1704067800000
145	1704067810000	CreateApprovalRequests1704067810000
146	1704067820000	CreateAgreementTransactions1704067820000
147	1704067900000	AddMissingFieldsToAgreements1704067900000
148	1704068000000	CreateMasterDataEntities1704068000000
149	1704068100000	UpdateAgreementsMasterDataRelations1704068100000
150	1704068200000	CreateKpis1704068200000
151	1704068300000	CreatePlans1704068300000
152	1704068400000	AddPlanToApprovalRequestTypeEnum1704068400000
153	1707400000000	AddChannelCategoryToBudgetEnvelope1707400000000
154	1769975912034	RemoveOldChannelColumnFromAgreements1769975912034
155	1770568724090	AddAdditionalParamsToAgreements1770568724090
156	1770580780000	MakeFuIdNullableInAgreements1770580780000
157	1771169825000	UpdateBudgetAllocationStructure1771169825000
158	1771182475737	AddFinanceManagerAndCategoryManagerRoles1771182475737
159	1771200000000	AddSpendManagementTables1771200000000
160	1771201000000	AddPromoMechanicsConfig1771201000000
161	1771202000000	UpdateLTAAgreementsStructure1771202000000
162	1772000000000	AddApprovalWorkflowFieldsToPlans1772000000000
163	1772000001000	AddFiscalPeriodToAgreementTransaction1772000001000
164	1773000000000	CreateOnInvoiceTables1773000000000
165	1774000000000	AddCalculatedKpisToPlans1774000000000
166	1775000000000	AddManagerAndReadonlyRoles1775000000000
167	1776000000000	AddDistributorCustomerChannel1776000000000
168	1777000000000	LedgerReversalSupport1777000000000
169	1778000000000	AddSettlementFieldsToAgreements1778000000000
170	1779000000000	CreateUserScopes1779000000000
171	1780000000000	FixKpiBrdFormulas1780000000000
172	1781000000000	FixTurnoverOnInvoiceOnly1781000000000
173	1782000000000	DeactivateLegacyKpis1782000000000
174	1783000000000	AddThresholdPercentToBudgetAlertConfig1783000000000
175	1784000000000	BackfillMechanicClassification1784000000000
176	1785000000000	CreateSalesActualsTables1785000000000
177	1786000000000	AddMetadataToBudgetAllocations1786000000000
178	1787000000000	AddCreatedByUpdatedByToPlanApprovalHistory1787000000000
179	1788000000000	MakePlanGpFieldsNullable1788000000000
180	1789000000000	FixBudgetSummaryCommitDoubleCounting1789000000000
181	1790000000000	BackfillAgreementBudgetReservationLeaks1790000000000
182	1791000000000	ConsolidateRolesToBrd1791000000000
184	1792000000000	BackfillPlannerUserScopes1792000000000
186	1793000000000	AddOptimisticLockVersions1793000000000
188	1794000000000	AddOptimisticLockVersionToKpis1794000000000
191	1795000000000	AddSpendTypeToBudgetDimensions1795000000000
192	1796000000000	SplitPlanMechanicEnteredValue1796000000000
193	1797000000000	DropPlanMechanicEnteredValue1797000000000
197	1798000000000	AddPartialIdempotencyIndexToBudgetTransactionLogs1798000000000
201	1799000000000	AddBudgetAlertConfigSchemaConstraints1799000000000
203	1801000000000	FixGpRoiPctDenominator1801000000000
206	1802000000000	FinancialFkRestrictAndLedgerOrphanPurge1802000000000
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.notifications (id, tenant_id, type, recipient_id, recipient_email, recipient_name, channel, priority, status, subject, body, metadata, sent_at, read_at, expires_at, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: on_invoice_batches; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.on_invoice_batches (id, tenant_id, batch_code, status, fiscal_period, total_rows, valid_rows, error_rows, total_discount_amount, affected_envelopes_count, file_name, file_size, validation_summary, metadata, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: on_invoice_entries; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.on_invoice_entries (id, tenant_id, batch_id, invoice_no, invoice_date, fiscal_period, customer_id, customer_code, sku_id, sku_code, quantity, list_price, actual_price, discount, discount_type, currency, status, validation_status, validation_errors, row_number, budget_envelope_id, idempotency_key, metadata, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: plan_approval_history; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.plan_approval_history (id, tenant_id, plan_id, action, actioned_by, comments, rejection_reason, escalation_reason, specific_changes, metadata, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: plan_fus; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.plan_fus (id, tenant_id, plan_id, fu_id, tactics, total_planned_volume, total_spend, total_gp, gp_roi, rag_status, created_at, updated_at, deleted_at, created_by, updated_by, calculated_kpis, version) FROM stdin;
\.


--
-- Data for Name: plan_mechanic_values; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.plan_mechanic_values (id, tenant_id, plan_fu_id, mechanic_id, calculated_spend, on_invoice_amount, off_invoice_amount, distribution_method, metadata, created_at, updated_at, deleted_at, created_by, updated_by, entered_rate_pct, entered_unit_amount, entered_total_amount) FROM stdin;
\.


--
-- Data for Name: plan_skus; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.plan_skus (id, tenant_id, plan_fu_id, sku_id, base_volume, planned_volume, incremental_volume, planned_turnover, tactic_spend, planned_gp, gp_roi, rag_status, created_at, updated_at, deleted_at, created_by, updated_by, base_lta_on_invoice_spend, base_lta_off_invoice_spend, planned_lta_on_invoice_spend, planned_lta_off_invoice_spend, promo_on_invoice_spend, promo_off_invoice_spend, calculated_kpis, version) FROM stdin;
\.


--
-- Data for Name: plans; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.plans (id, tenant_id, plan_code, plan_name, description, cpl_id, channel_id, region_id, category_id, start_date, end_date, period_month, status, approval_request_id, approved_at, approved_by, rejected_at, rejected_by, rejection_reason, comments, total_planned_volume, total_spend, total_gp, overall_roi, rag_status, created_at, updated_at, deleted_at, created_by, updated_by, submission_notes, submitted_at, submitted_by, pending_finance_review, escalation_reason, escalated_at, escalated_by, on_invoice_spend, off_invoice_spend, version) FROM stdin;
784dce08-7c56-4756-b2c4-ea5725ea89de	598a895e-5a20-48cc-95bd-a52fe5d4bb65	PLAN-2026-Q3-001-2590	T-096 VERIFY PLAN	\N	2eded86b-ae2a-4097-92fb-f304c79c57e1	7ecd1c45-9697-4a06-8416-3ba599977494	\N	24fb3bc9-4eed-4116-8f70-395029798c46	2032-03-01	2032-03-31	2032-03	DRAFT	\N	\N	\N	\N	\N	\N	\N	0.000	0.00	0.00	\N	\N	2026-08-12 06:44:52.595356	2026-08-12 06:44:52.595356	\N	67b863d1-1a98-464d-af7b-df0b219748ae	\N	\N	\N	\N	f	\N	\N	\N	0.00	0.00	1
\.


--
-- Data for Name: regions; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.regions (id, tenant_id, code, name, description, parent_region_id, level, country, is_active, metadata, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: sales_actual_batches; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.sales_actual_batches (id, tenant_id, fiscal_period, cpl_id, category_id, channel_id, status, source_type, file_name, file_hash, total_rows, valid_rows, error_rows, gross_total, net_total, discount_total, replaced_by_batch_id, replaced_at, validation_summary, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
a5c6c19c-73c4-4ed0-b451-09edbdd81e78	598a895e-5a20-48cc-95bd-a52fe5d4bb65	2026-01	ac0d2c7d-ccd9-4060-a24e-6bdb773f5083	d465de24-491e-4f85-bcfd-ab70f8878c73	7ecd1c45-9697-4a06-8416-3ba599977494	ACTIVE	SEED	actuals_2026-01.csv	e3f061aa34e24f93906ee5bdf67cfb4b51525925de5805b393af449ab53e9343	1	1	0	400000.00	360000.00	15000.00	\N	\N	\N	2026-08-02 12:27:41.880218	2026-08-02 12:27:41.880218	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
525df8c2-3935-42e9-98d5-da8f50db0881	598a895e-5a20-48cc-95bd-a52fe5d4bb65	2026-01	4b3850a8-d598-49ca-a740-94730fd7cfa6	24fb3bc9-4eed-4116-8f70-395029798c46	7ecd1c45-9697-4a06-8416-3ba599977494	ACTIVE	SEED	actuals_2026-01.csv	e3f061aa34e24f93906ee5bdf67cfb4b51525925de5805b393af449ab53e9343	1	1	0	600000.00	552000.00	30000.00	\N	\N	\N	2026-08-02 12:27:41.880218	2026-08-02 12:27:41.880218	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
a0bfe3e2-6478-4dd3-b508-e2ccef11b0f3	598a895e-5a20-48cc-95bd-a52fe5d4bb65	2026-02	ac0d2c7d-ccd9-4060-a24e-6bdb773f5083	08d8d7d8-b21e-4f81-8fe5-647f38f67f90	7ecd1c45-9697-4a06-8416-3ba599977494	ACTIVE	SEED	actuals_2026-02.csv	0744d129d5d69b95ecc11e8ba00da124971c3ce4036f3f12a3d88792da5503f8	1	1	0	500000.00	460000.00	20000.00	\N	\N	\N	2026-08-02 12:27:41.943578	2026-08-02 12:27:41.943578	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
\.


--
-- Data for Name: sales_actuals; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.sales_actuals (id, tenant_id, batch_id, fiscal_period, cpl_id, category_id, channel_id, cpl_code, category_name, channel_code, gross_amount, net_amount, discount_amount, currency, source_row_number, raw_row, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
bd23e4d1-3421-45dd-8be8-ab626ee216d4	598a895e-5a20-48cc-95bd-a52fe5d4bb65	a5c6c19c-73c4-4ed0-b451-09edbdd81e78	2026-01	ac0d2c7d-ccd9-4060-a24e-6bdb773f5083	d465de24-491e-4f85-bcfd-ab70f8878c73	7ecd1c45-9697-4a06-8416-3ba599977494	BS0501.50006	Şekillendirici	NKA	400000.00	360000.00	15000.00	TRY	2	{"category": "Şekillendirici", "cpl_code": "BS0501.50006", "net_amount": "360000", "channel_code": "NKA", "gross_amount": "400000", "discount_amount": "15000"}	2026-08-02 12:27:41.880218	2026-08-02 12:27:41.880218	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
d016978d-838f-4892-9c24-8623573841ec	598a895e-5a20-48cc-95bd-a52fe5d4bb65	525df8c2-3935-42e9-98d5-da8f50db0881	2026-01	4b3850a8-d598-49ca-a740-94730fd7cfa6	24fb3bc9-4eed-4116-8f70-395029798c46	7ecd1c45-9697-4a06-8416-3ba599977494	BS0501.50004	Saç Boyası	NKA	600000.00	552000.00	30000.00	TRY	3	{"category": "Saç Boyası", "cpl_code": "BS0501.50004", "net_amount": "552000", "channel_code": "NKA", "gross_amount": "600000", "discount_amount": "30000"}	2026-08-02 12:27:41.880218	2026-08-02 12:27:41.880218	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
4a60d654-496b-4242-acf1-a765516913a0	598a895e-5a20-48cc-95bd-a52fe5d4bb65	a0bfe3e2-6478-4dd3-b508-e2ccef11b0f3	2026-02	ac0d2c7d-ccd9-4060-a24e-6bdb773f5083	08d8d7d8-b21e-4f81-8fe5-647f38f67f90	7ecd1c45-9697-4a06-8416-3ba599977494	BS0501.50006	Set Boya	NKA	500000.00	460000.00	20000.00	TRY	2	{"category": "Set Boya", "cpl_code": "BS0501.50006", "net_amount": "460000", "channel_code": "NKA", "gross_amount": "500000", "discount_amount": "20000"}	2026-08-02 12:27:41.943578	2026-08-02 12:27:41.943578	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
\.


--
-- Data for Name: skus; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.skus (id, tenant_id, code, name, description, gu_id, fu_id, variant, size, barcode, unit_price, cogs, currency, unit_of_measure, is_active, metadata, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
c80e88f9-0ffe-4362-859e-6afcb4079245	598a895e-5a20-48cc-95bd-a52fe5d4bb65	SKU-E2E-LUMPSUM-A	E2E Lumpsum Fixture SKU A (Wella HC 500ml)	\N	7e5eacf9-cf1d-4bd1-a479-029ea6722311	c451e8b8-c653-4bd5-8963-983a33657c05	\N	500ml	\N	100.0000	60.0000	TRY	\N	t	\N	2026-08-03 07:53:30.643459	2026-08-03 07:53:30.643459	\N	67b863d1-1a98-464d-af7b-df0b219748ae	\N
e2cc5085-24c0-4961-97d3-720619a3ab55	598a895e-5a20-48cc-95bd-a52fe5d4bb65	SKU-E2E-LUMPSUM-B	E2E Lumpsum Fixture SKU B (Wella HC 500ml)	\N	7e5eacf9-cf1d-4bd1-a479-029ea6722311	c451e8b8-c653-4bd5-8963-983a33657c05	\N	500ml	\N	100.0000	60.0000	TRY	\N	t	\N	2026-08-03 07:53:30.681533	2026-08-03 07:53:30.681533	\N	67b863d1-1a98-464d-af7b-df0b219748ae	\N
3e20daf1-3bbc-47dc-957b-59d5d2545bf2	598a895e-5a20-48cc-95bd-a52fe5d4bb65	SKU-E2E-GRID-SINGLE-SKU	E2E Grid Fixture SKU (Wella HC 500ml)	\N	7e5eacf9-cf1d-4bd1-a479-029ea6722311	fa4b7d6c-92de-448a-8ac6-e54ced38c81a	\N	500ml	\N	100.0000	60.0000	TRY	\N	t	\N	2026-08-08 17:34:33.964682	2026-08-08 17:34:33.964682	\N	67b863d1-1a98-464d-af7b-df0b219748ae	\N
568c0a4b-950d-4897-9605-fc37138d1531	598a895e-5a20-48cc-95bd-a52fe5d4bb65	601402913	Bim Karma Koli Koleston Saç Boyası *1	\N	7b885427-7888-4014-83bb-393f7fc2ba48	e5ae5fc1-1519-4fe0-9e29-52898c3c2945	\N	\N	601402913	1839.5000	\N	TRY	\N	t	{"fkms": "11", "source": "Wella Product.xlsx", "altGrup": "Karma Koli", "anaGrup": "Karma Koli"}	2026-07-29 12:16:02.712558	2026-07-29 12:16:02.712558	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
40bbe2a1-d673-4f73-afd1-ed81aff1c80c	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099240010632	EskiWellaflex Flexıble UltraStrong HoldHaırspray*6	\N	2885493c-7a3c-405c-8857-f6e9c0dfbbb1	b6a8cd09-c073-4672-bfa1-09618a9bb044	\N	\N	6099240010632	162.0600	\N	TRY	\N	t	{"fkms": "1", "source": "Wella Product.xlsx", "altGrup": "Spray", "anaGrup": "Şekillendirici"}	2026-07-29 12:16:02.715181	2026-07-29 12:16:02.715181	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
c483b57a-d5a2-44e3-9f77-5adef75484c9	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117818	Koleston Single 11/1 Açık Küllü Sarı *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117818	81.8700	\N	TRY	\N	t	{"fkms": "17", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.716506	2026-07-29 12:16:02.716506	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
83f13bf9-b484-4041-ab1c-5cad954059a6	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117819	Koleston Single 3/4 Koyu Kestane *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117819	81.8700	\N	TRY	\N	t	{"fkms": "3", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.719148	2026-07-29 12:16:02.719148	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
89939789-0bd2-4cb4-b395-2b1d88c3e61b	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117820	Koleston Single 2/0 Siyah *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117820	81.8700	\N	TRY	\N	t	{"fkms": "7", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.720594	2026-07-29 12:16:02.720594	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
5b201de0-6373-4fd4-bf0b-44d293eb6ca4	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117821	Koleston Single 3/66 Patlican Moru *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117821	81.8700	\N	TRY	\N	t	{"fkms": "19", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.721897	2026-07-29 12:16:02.721897	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
de902258-cc8f-4122-993a-87a97f765e7b	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117823	Koleston Single 3/0 Koyu Kahve *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117823	81.8700	\N	TRY	\N	t	{"fkms": "17", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.723202	2026-07-29 12:16:02.723202	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
eeafcead-9182-42d7-9273-792667495440	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117830	Koleston Single 4/0 Kahve *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117830	81.8700	\N	TRY	\N	t	{"fkms": "2", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.72452	2026-07-29 12:16:02.72452	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
1ddfe778-6600-4f68-82a2-5d57b4f062f6	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117832	Koleston Single 4/6 Kızıl Viyole *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117832	81.8700	\N	TRY	\N	t	{"fkms": "11", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.725793	2026-07-29 12:16:02.725793	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
d3cb698e-5f0e-45be-9aa7-35582245d91b	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117833	Koleston Single 4/77 Kadife Kahve *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117833	81.8700	\N	TRY	\N	t	{"fkms": "10", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.727267	2026-07-29 12:16:02.727267	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
7038e543-faf7-4e1a-bcf7-b27ff1137263	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117834	Koleston Single 5/0 Açık Kahve *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117834	81.8700	\N	TRY	\N	t	{"fkms": "5", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.729727	2026-07-29 12:16:02.729727	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
1a8c484e-c048-4151-85d6-a5b2e1515bbf	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117835	Koleston Single 5/37 Kışkırtıcı Kahve *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117835	81.8700	\N	TRY	\N	t	{"fkms": "11", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.733396	2026-07-29 12:16:02.733396	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
703a9731-afd9-4280-8236-4e9e18260b3d	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117836	Koleston Single 5/4 Açık Kestane *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117836	81.8700	\N	TRY	\N	t	{"fkms": "18", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.735663	2026-07-29 12:16:02.735663	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
6ecea84c-804e-406e-9c02-234faf9b9b57	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117837	Koleston Single 5/66 Şarap Kızılı *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117837	81.8700	\N	TRY	\N	t	{"fkms": "1", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.737174	2026-07-29 12:16:02.737174	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
4704ca74-8533-496b-9cdf-bb6bc4943274	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117838	Koleston Single 6/0 Koyu Kumral *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117838	81.8700	\N	TRY	\N	t	{"fkms": "1", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.738539	2026-07-29 12:16:02.738539	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
05e4d2de-9cdb-47ef-8460-375ffea242cb	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117839	Koleston Single 55/46 Kızıl Büyü *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117839	81.8700	\N	TRY	\N	t	{"fkms": "2", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.740781	2026-07-29 12:16:02.740781	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
6cd834db-9336-43bc-990a-382c74262b9b	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117840	Koleston Single 6/35 Elegan Kahve *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117840	81.8700	\N	TRY	\N	t	{"fkms": "5", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.742053	2026-07-29 12:16:02.742053	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
24a77de4-dc8e-4686-8885-74535bdd2134	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117841	Koleston Single 6/4 Kızıl Bakır *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117841	81.8700	\N	TRY	\N	t	{"fkms": "9", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.7436	2026-07-29 12:16:02.7436	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
0765cea3-7f87-475d-8f14-15223cb0bab4	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117842	Koleston Single 6/74 Terrakota *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117842	81.8700	\N	TRY	\N	t	{"fkms": "11", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.745204	2026-07-29 12:16:02.745204	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
de10ad33-5b34-4ab9-a960-c89c6b72408a	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117843	Koleston Single 6/7 Çikolata Kahve *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117843	81.8700	\N	TRY	\N	t	{"fkms": "3", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.746572	2026-07-29 12:16:02.746572	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
f5c2dc60-0b8b-4ea0-a58e-35ab82d604da	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117844	Koleston Single 66/46 Aşk Alevi *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117844	81.8700	\N	TRY	\N	t	{"fkms": "5", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.747866	2026-07-29 12:16:02.747866	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
6b98508c-1e54-4369-b369-941e3f51312f	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117845	Koleston Single 7/0 Kumral *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117845	81.8700	\N	TRY	\N	t	{"fkms": "1", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.749155	2026-07-29 12:16:02.749155	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
39c900c5-ba57-4cb5-8869-50d125a267d2	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117846	Koleston Single 7/1 Küllü Kumral *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117846	81.8700	\N	TRY	\N	t	{"fkms": "1", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.750351	2026-07-29 12:16:02.750351	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
741f4476-a3ed-4759-b5d4-08e9efd2c8b2	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117847	Koleston Single 7/3 Fındık Kabuğu *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117847	81.8700	\N	TRY	\N	t	{"fkms": "3", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.752252	2026-07-29 12:16:02.752252	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
2832744d-f128-4126-aebd-8632715af5bf	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117848	Koleston Single 7/77 Işıltılı Kahve *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117848	81.8700	\N	TRY	\N	t	{"fkms": "1", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.753694	2026-07-29 12:16:02.753694	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
6f8e461c-1b01-4147-9450-cb577a933557	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117849	Koleston Single 77/44 Kor Ateşi Kızılı *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117849	81.8700	\N	TRY	\N	t	{"fkms": "4", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.755768	2026-07-29 12:16:02.755768	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
3c476444-33eb-47b0-b54b-3de4dbb085ee	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117851	Koleston Single 8/1 Açık Küllü Kumral *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117851	81.8700	\N	TRY	\N	t	{"fkms": "4", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.762359	2026-07-29 12:16:02.762359	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
9b7a27bb-9935-4195-9038-1447ebcb1447	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117852	Koleston Single 9/0 Sarı *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117852	81.8700	\N	TRY	\N	t	{"fkms": "6", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.766745	2026-07-29 12:16:02.766745	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
7f5e251d-68eb-499e-850f-b581b7385b52	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350117853	Koleston Single 9/3 Altın Sarısı *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350117853	81.8700	\N	TRY	\N	t	{"fkms": "17", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.768305	2026-07-29 12:16:02.768305	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
fabd654f-4351-4782-a060-4f79426af13d	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350129898	Eski Wellaflex Saç Spreyi 250 ml Invisible Hold *6	\N	2885493c-7a3c-405c-8857-f6e9c0dfbbb1	b6a8cd09-c073-4672-bfa1-09618a9bb044	\N	\N	6099350129898	162.0600	\N	TRY	\N	t	{"fkms": "4", "source": "Wella Product.xlsx", "altGrup": "Spray", "anaGrup": "Şekillendirici"}	2026-07-29 12:16:02.772621	2026-07-29 12:16:02.772621	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
c09350f2-81b5-49af-b5ca-31726bc1e5e7	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350129900	Eski Wellaflex Saç Köpüğü 200 ml Invisible Hold *6	\N	2885493c-7a3c-405c-8857-f6e9c0dfbbb1	b6a8cd09-c073-4672-bfa1-09618a9bb044	\N	\N	6099350129900	162.0600	\N	TRY	\N	t	{"fkms": "1", "source": "Wella Product.xlsx", "altGrup": "Köpük", "anaGrup": "Köpük"}	2026-07-29 12:16:02.781463	2026-07-29 12:16:02.781463	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
deb41145-302a-4ba0-869c-9011bda88cb8	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350129903	D Wellaflex Brillant Colors Strong HoldHairspray*6	\N	2885493c-7a3c-405c-8857-f6e9c0dfbbb1	b6a8cd09-c073-4672-bfa1-09618a9bb044	\N	\N	6099350129903	162.0500	\N	TRY	\N	t	{"fkms": "3", "source": "Wella Product.xlsx", "altGrup": "Spray", "anaGrup": "Şekillendirici"}	2026-07-29 12:16:02.782955	2026-07-29 12:16:02.782955	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
297f7009-773a-414c-890e-94201cc0430e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350129904	EskiWellaflex Curls&Waves Strong HoldMousse200ml*6	\N	2885493c-7a3c-405c-8857-f6e9c0dfbbb1	b6a8cd09-c073-4672-bfa1-09618a9bb044	\N	\N	6099350129904	162.0500	\N	TRY	\N	t	{"fkms": "2", "source": "Wella Product.xlsx", "altGrup": "Köpük", "anaGrup": "Köpük"}	2026-07-29 12:16:02.78448	2026-07-29 12:16:02.78448	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
cb178356-7497-47b7-9309-eb8a69ae8e8e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350129922	Wella New Wave Smoothıng Mousse 200 ml *6	\N	3072464e-d25b-47fb-9182-d222ec30e74f	38095fb8-a94e-4577-b927-758b4a6cab34	\N	\N	6099350129922	92.2700	\N	TRY	\N	t	{"fkms": "1", "source": "Wella Product.xlsx", "altGrup": "Mousse", "anaGrup": "Şekillendirici"}	2026-07-29 12:16:02.785752	2026-07-29 12:16:02.785752	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
d892e0b8-f73a-4698-84c9-52b052803602	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350129923	Eski Wellaflex 2Nd Day Volume Mousse ExtraStrong*6	\N	2885493c-7a3c-405c-8857-f6e9c0dfbbb1	b6a8cd09-c073-4672-bfa1-09618a9bb044	\N	\N	6099350129923	162.0600	\N	TRY	\N	t	{"fkms": "3", "source": "Wella Product.xlsx", "altGrup": "Köpük", "anaGrup": "Köpük"}	2026-07-29 12:16:02.787011	2026-07-29 12:16:02.787011	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
dd2b9c12-4905-4e19-a1c1-6031e37f4f69	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350129925	EskiWellaflex Flexıble UltraStrong HoldHaırspray*6	\N	2885493c-7a3c-405c-8857-f6e9c0dfbbb1	b6a8cd09-c073-4672-bfa1-09618a9bb044	\N	\N	6099350129925	162.0600	\N	TRY	\N	t	{"fkms": "5", "source": "Wella Product.xlsx", "altGrup": "Spray", "anaGrup": "Şekillendirici"}	2026-07-29 12:16:02.788187	2026-07-29 12:16:02.788187	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
d2919247-934e-420a-875e-6841a345ae61	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350130353	Koleston Naturals 5/0 Açık Kahve *24	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	54a8a83a-6e73-4aff-bba2-0223d634af1f	\N	\N	6099350130353	181.6100	\N	TRY	\N	t	{"fkms": "38", "source": "Wella Product.xlsx", "altGrup": "Demi-Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.792313	2026-07-29 12:16:02.792313	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
3a95c948-9a48-4c9d-baf9-673545a62ce5	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350130354	Koleston Naturals 5/45 Koyu Nar Kızılı *24	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	54a8a83a-6e73-4aff-bba2-0223d634af1f	\N	\N	6099350130354	181.6100	\N	TRY	\N	t	{"fkms": "15", "source": "Wella Product.xlsx", "altGrup": "Demi-Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.797512	2026-07-29 12:16:02.797512	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
353d0e0e-6565-4440-b41a-e1e9951be319	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350130355	Koleston Naturals 3/66 Kızıl Kestane *24	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	54a8a83a-6e73-4aff-bba2-0223d634af1f	\N	\N	6099350130355	181.6100	\N	TRY	\N	t	{"fkms": "18", "source": "Wella Product.xlsx", "altGrup": "Demi-Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.798754	2026-07-29 12:16:02.798754	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
a7578f89-a459-4042-93a4-b3fc0be8c126	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350130356	Koleston Naturals 7/0 Kumral *24	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	54a8a83a-6e73-4aff-bba2-0223d634af1f	\N	\N	6099350130356	181.6100	\N	TRY	\N	t	{"fkms": "47", "source": "Wella Product.xlsx", "altGrup": "Demi-Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.799984	2026-07-29 12:16:02.799984	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
2fe0b8bf-c67d-4f91-8805-fbe9341b35be	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350130357	Koleston Naturals 2/0 Siyah *24	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	54a8a83a-6e73-4aff-bba2-0223d634af1f	\N	\N	6099350130357	181.6100	\N	TRY	\N	t	{"fkms": "42", "source": "Wella Product.xlsx", "altGrup": "Demi-Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.801226	2026-07-29 12:16:02.801226	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
d8974bd6-c05f-432f-be21-e34b79e312ce	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350130358	Koleston Naturals 3/4 Koyu Kestane *24	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	54a8a83a-6e73-4aff-bba2-0223d634af1f	\N	\N	6099350130358	181.6100	\N	TRY	\N	t	{"fkms": "32", "source": "Wella Product.xlsx", "altGrup": "Demi-Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.802422	2026-07-29 12:16:02.802422	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
24021ddf-d754-4752-a361-d814190575ec	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350130359	Koleston Naturals 5/73 Altın Kestane *24	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	54a8a83a-6e73-4aff-bba2-0223d634af1f	\N	\N	6099350130359	181.6100	\N	TRY	\N	t	{"fkms": "17", "source": "Wella Product.xlsx", "altGrup": "Demi-Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.803657	2026-07-29 12:16:02.803657	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
f13c4273-4e44-4ae6-837b-1cf44878f2ef	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350130360	Koleston Naturals 2/8 Böğürtlen Siyahı *24	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	54a8a83a-6e73-4aff-bba2-0223d634af1f	\N	\N	6099350130360	181.6100	\N	TRY	\N	t	{"fkms": "32", "source": "Wella Product.xlsx", "altGrup": "Demi-Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.80484	2026-07-29 12:16:02.80484	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
41e66ce0-e1b2-4ffc-a0b4-3affa0e715da	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350130361	Koleston Naturals 8/1 Açık Küllü Kumral *24	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	54a8a83a-6e73-4aff-bba2-0223d634af1f	\N	\N	6099350130361	181.6100	\N	TRY	\N	t	{"fkms": "44", "source": "Wella Product.xlsx", "altGrup": "Demi-Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.806046	2026-07-29 12:16:02.806046	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
f18488e9-28f9-4de6-a18c-8cf17d990b27	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350130362	Koleston Naturals 5/37 Orta Kestane *24	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	54a8a83a-6e73-4aff-bba2-0223d634af1f	\N	\N	6099350130362	181.6100	\N	TRY	\N	t	{"fkms": "25", "source": "Wella Product.xlsx", "altGrup": "Demi-Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.807168	2026-07-29 12:16:02.807168	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
1eaeac53-381f-426c-a9ed-2f36e14d186a	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350130363	Koleston Naturals 11/7 Vanilya Sarısı *24	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	54a8a83a-6e73-4aff-bba2-0223d634af1f	\N	\N	6099350130363	181.6100	\N	TRY	\N	t	{"fkms": "32", "source": "Wella Product.xlsx", "altGrup": "Demi-Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.809021	2026-07-29 12:16:02.809021	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
7be58bb7-fd1e-4f07-86dc-89fd0869eae1	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350130364	Koleston Naturals 6/0 Koyu Kumral *24	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	54a8a83a-6e73-4aff-bba2-0223d634af1f	\N	\N	6099350130364	181.6100	\N	TRY	\N	t	{"fkms": "39", "source": "Wella Product.xlsx", "altGrup": "Demi-Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.810313	2026-07-29 12:16:02.810313	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
0c7c0642-e113-4550-8be7-5e2400c9ed08	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350130365	Koleston Naturals 6/7 Çikolata Kahve *24	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	54a8a83a-6e73-4aff-bba2-0223d634af1f	\N	\N	6099350130365	181.6100	\N	TRY	\N	t	{"fkms": "39", "source": "Wella Product.xlsx", "altGrup": "Demi-Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.811557	2026-07-29 12:16:02.811557	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
a674b044-82d0-4bc5-860a-ce3d22d99640	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350130366	Koleston Naturals 8/0 Açık Kumral *24	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	54a8a83a-6e73-4aff-bba2-0223d634af1f	\N	\N	6099350130366	181.6100	\N	TRY	\N	t	{"fkms": "43", "source": "Wella Product.xlsx", "altGrup": "Demi-Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.81277	2026-07-29 12:16:02.81277	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
76727800-79cb-4b13-9a64-0f15923d8b9b	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350130367	Koleston Naturals 4/0 Kahve *24	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	54a8a83a-6e73-4aff-bba2-0223d634af1f	\N	\N	6099350130367	181.6100	\N	TRY	\N	t	{"fkms": "41", "source": "Wella Product.xlsx", "altGrup": "Demi-Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.813945	2026-07-29 12:16:02.813945	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
d0829531-998d-43d0-9d5f-a6fb1b5efc9f	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350130368	Koleston Naturals 7/3 Karamel Kumral *24	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	54a8a83a-6e73-4aff-bba2-0223d634af1f	\N	\N	6099350130368	181.6100	\N	TRY	\N	t	{"fkms": "40", "source": "Wella Product.xlsx", "altGrup": "Demi-Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.815177	2026-07-29 12:16:02.815177	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
d2781a6e-42d6-4e00-8543-52a14cd8cead	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350130369	Koleston Naturals 4/6 Kızıl Viyole *24	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	54a8a83a-6e73-4aff-bba2-0223d634af1f	\N	\N	6099350130369	181.6100	\N	TRY	\N	t	{"fkms": "23", "source": "Wella Product.xlsx", "altGrup": "Demi-Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.81643	2026-07-29 12:16:02.81643	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
242d8300-7ed8-42bb-b35c-15050aabadb7	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350130370	Koleston Naturals 3/0 Koyu Kahve *24	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	54a8a83a-6e73-4aff-bba2-0223d634af1f	\N	\N	6099350130370	181.6100	\N	TRY	\N	t	{"fkms": "45", "source": "Wella Product.xlsx", "altGrup": "Demi-Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.81756	2026-07-29 12:16:02.81756	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
c17fd90c-e887-4e4f-8402-34ef7ba45c23	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350130371	Koleston Naturals 6/34 Bakır Kumral *24	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	54a8a83a-6e73-4aff-bba2-0223d634af1f	\N	\N	6099350130371	181.6100	\N	TRY	\N	t	{"fkms": "21", "source": "Wella Product.xlsx", "altGrup": "Demi-Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.818707	2026-07-29 12:16:02.818707	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
0ce220d0-2bf4-4efa-8f4e-3531602e941d	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350130372	Koleston Naturals 7/1 Küllü Kumral *24	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	54a8a83a-6e73-4aff-bba2-0223d634af1f	\N	\N	6099350130372	181.6100	\N	TRY	\N	t	{"fkms": "47", "source": "Wella Product.xlsx", "altGrup": "Demi-Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.819908	2026-07-29 12:16:02.819908	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
605f42b2-22b8-42d4-aa31-37bae68b5ad3	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350130373	Koleston Naturals 6/1 Büyüleyici Kahve *24	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	54a8a83a-6e73-4aff-bba2-0223d634af1f	\N	\N	6099350130373	181.6100	\N	TRY	\N	t	{"fkms": "30", "source": "Wella Product.xlsx", "altGrup": "Demi-Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.821868	2026-07-29 12:16:02.821868	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
6d0951f1-9837-4d08-b222-b66a6a50efcb	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350130374	Koleston Naturals 6/73 Ayışığı Kahvesi *24	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	54a8a83a-6e73-4aff-bba2-0223d634af1f	\N	\N	6099350130374	181.6100	\N	TRY	\N	t	{"fkms": "40", "source": "Wella Product.xlsx", "altGrup": "Demi-Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.823162	2026-07-29 12:16:02.823162	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
3e5370c6-95e5-4b99-ae48-b42c4a62141d	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350151939	Wella New Wave Curls & Waves Mousse 200 ml *6	\N	3072464e-d25b-47fb-9182-d222ec30e74f	38095fb8-a94e-4577-b927-758b4a6cab34	\N	\N	6099350151939	92.2700	\N	TRY	\N	t	{"fkms": "1", "source": "Wella Product.xlsx", "altGrup": "Mousse", "anaGrup": "Şekillendirici"}	2026-07-29 12:16:02.824465	2026-07-29 12:16:02.824465	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
fc75db69-f931-4522-aebf-74f9274a2ed6	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350151940	Wella New Wave Volume Haırspray 250 ml *6	\N	3072464e-d25b-47fb-9182-d222ec30e74f	38095fb8-a94e-4577-b927-758b4a6cab34	\N	\N	6099350151940	92.2700	\N	TRY	\N	t	{"fkms": "1", "source": "Wella Product.xlsx", "altGrup": "Spray", "anaGrup": "Şekillendirici"}	2026-07-29 12:16:02.825765	2026-07-29 12:16:02.825765	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
fab35612-94c4-4476-9adb-36087e7af3e1	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350166343	Koleston Intense 7/0 Kumral *24	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	a48113b4-6a66-4c10-b8b9-e0d77b754125	\N	\N	6099350166343	181.6100	\N	TRY	\N	t	{"fkms": "31", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.826992	2026-07-29 12:16:02.826992	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
a4252b56-3803-46f9-a266-3ddea02a3f1e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	SKU-E2E-COGS-FIXTURE	E2E COGS Fixture SKU (Wella HC 500ml)	\N	7e5eacf9-cf1d-4bd1-a479-029ea6722311	c451e8b8-c653-4bd5-8963-983a33657c05	\N	500ml	\N	100.0000	60.0000	TRY	\N	t	\N	2026-07-29 12:16:02.991329	2026-07-29 12:16:02.991329	\N	67b863d1-1a98-464d-af7b-df0b219748ae	\N
4193a96f-bc33-499e-9e6b-b225c298fd14	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350166344	Koleston Intense 9/3 Açık Altın Sarısı *24	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	a48113b4-6a66-4c10-b8b9-e0d77b754125	\N	\N	6099350166344	181.6100	\N	TRY	\N	t	{"fkms": "19", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.828085	2026-07-29 12:16:02.828085	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
ac20c27c-cd60-4968-beef-150730199c03	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350166345	Koleston Intense 8/0 Açık Kumral *24	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	a48113b4-6a66-4c10-b8b9-e0d77b754125	\N	\N	6099350166345	181.6100	\N	TRY	\N	t	{"fkms": "39", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.830102	2026-07-29 12:16:02.830102	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
85d22cc3-61c4-44e6-9c95-d898b223cca4	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350166346	Koleston Intense 10/0 Çok Açık Sarı *24	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	a48113b4-6a66-4c10-b8b9-e0d77b754125	\N	\N	6099350166346	181.6100	\N	TRY	\N	t	{"fkms": "22", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.831248	2026-07-29 12:16:02.831248	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
e924c351-4f35-46ea-a142-8ac6d983f0b0	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350166347	Koleston Intense 5/66 Patlıcan Moru *24	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	a48113b4-6a66-4c10-b8b9-e0d77b754125	\N	\N	6099350166347	181.6100	\N	TRY	\N	t	{"fkms": "19", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.832399	2026-07-29 12:16:02.832399	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
fde4566e-dbb2-4178-b7de-e02c3e2deb07	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350166348	Koleston Intense 7/3 Fındık Kabuğu *24	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	a48113b4-6a66-4c10-b8b9-e0d77b754125	\N	\N	6099350166348	181.6100	\N	TRY	\N	t	{"fkms": "37", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.833565	2026-07-29 12:16:02.833565	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
174fe9ed-3bf3-434a-b71e-e3a742099e60	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350166349	Koleston Intense 6/0 Koyu Kumral *24	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	a48113b4-6a66-4c10-b8b9-e0d77b754125	\N	\N	6099350166349	181.6100	\N	TRY	\N	t	{"fkms": "37", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.83469	2026-07-29 12:16:02.83469	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
2a95bcbd-fe43-4728-8043-8d6d90828ef2	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350166350	Koleston Intense 7/11 Ekstra Küllü Kumral *24	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	a48113b4-6a66-4c10-b8b9-e0d77b754125	\N	\N	6099350166350	181.6100	\N	TRY	\N	t	{"fkms": "40", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.835821	2026-07-29 12:16:02.835821	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
94d63834-a249-4fcb-8704-a5e73a11007f	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350166351	Koleston Intense 5/4 Açık Kestane *24	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	a48113b4-6a66-4c10-b8b9-e0d77b754125	\N	\N	6099350166351	181.6100	\N	TRY	\N	t	{"fkms": "30", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.837122	2026-07-29 12:16:02.837122	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
bc756c40-ace5-4e2b-8208-c2a0f2fafd13	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350166352	Koleston Intense 8/11 Ekstra Açık Küllü Kumral *24	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	a48113b4-6a66-4c10-b8b9-e0d77b754125	\N	\N	6099350166352	181.6100	\N	TRY	\N	t	{"fkms": "39", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.838159	2026-07-29 12:16:02.838159	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
cf8ce37c-fa9a-4002-a243-75fcbb659545	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350166353	Koleston Intense 6/7 Çikolata Kahve *24	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	a48113b4-6a66-4c10-b8b9-e0d77b754125	\N	\N	6099350166353	181.6100	\N	TRY	\N	t	{"fkms": "39", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.839184	2026-07-29 12:16:02.839184	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
53ed049c-3179-4171-9be7-150926ed548d	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350166354	Koleston Intense 9/0 Sarı *24	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	a48113b4-6a66-4c10-b8b9-e0d77b754125	\N	\N	6099350166354	181.6100	\N	TRY	\N	t	{"fkms": "34", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.840188	2026-07-29 12:16:02.840188	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
a42cf44d-ed36-4064-80ff-78950e2a04ce	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350166355	Koleston Intense 1/0 Mavi Siyah *24	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	a48113b4-6a66-4c10-b8b9-e0d77b754125	\N	\N	6099350166355	181.6100	\N	TRY	\N	t	{"fkms": "41", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.84117	2026-07-29 12:16:02.84117	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
4b96da37-fef4-4f44-af2a-1b89882c45cf	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350166356	Koleston Intense 7/17 Buzlu Çikolata *24	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	a48113b4-6a66-4c10-b8b9-e0d77b754125	\N	\N	6099350166356	181.6100	\N	TRY	\N	t	{"fkms": "36", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.842141	2026-07-29 12:16:02.842141	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
87cf72b5-b23c-4f36-824e-4f3545fdb308	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350166357	Koleston Intense 10/81 Çok Açık Küllü İnci Sar *24	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	a48113b4-6a66-4c10-b8b9-e0d77b754125	\N	\N	6099350166357	181.6100	\N	TRY	\N	t	{"fkms": "34", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.843185	2026-07-29 12:16:02.843185	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
016effac-1e14-4e37-b8cb-5a0e6ee054c6	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350166358	Koleston Intense 4/1 Küllü Kahve *24	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	a48113b4-6a66-4c10-b8b9-e0d77b754125	\N	\N	6099350166358	181.6100	\N	TRY	\N	t	{"fkms": "32", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.844467	2026-07-29 12:16:02.844467	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
1e7c362b-ae26-45e3-b0e9-b83a8233087b	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350166359	Koleston Intense 5/1 Ekstra Küllü Kahve *24	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	a48113b4-6a66-4c10-b8b9-e0d77b754125	\N	\N	6099350166359	181.6100	\N	TRY	\N	t	{"fkms": "30", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.845513	2026-07-29 12:16:02.845513	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
8ead8823-3f2a-4f87-bccf-e61b658a3229	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350166360	Koleston Intense 3/0 Koyu Kahve *24	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	a48113b4-6a66-4c10-b8b9-e0d77b754125	\N	\N	6099350166360	181.6100	\N	TRY	\N	t	{"fkms": "41", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.846546	2026-07-29 12:16:02.846546	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
5b3c53d5-9a54-4ed5-b46c-b5b5578704de	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350167682	Koleston Peroksit 9% *50	\N	18e5cf4a-2e63-4381-a6d5-14cccf367287	f33675dd-6bc5-4a0b-8483-be94ad4b270d	\N	\N	6099350167682	42.5600	\N	TRY	\N	t	{"fkms": "2", "source": "Wella Product.xlsx", "altGrup": "Peroksit", "anaGrup": "Peroksit"}	2026-07-29 12:16:02.848387	2026-07-29 12:16:02.848387	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
809c1ead-cff8-410d-9ff1-fd56b5a4c907	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350170207	Koleston Supreme Kit 4/1 Gizemli Küllü Kumral *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350170207	413.2200	\N	TRY	\N	t	{"fkms": "18", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.849482	2026-07-29 12:16:02.849482	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
1fa7012f-f1bc-4265-aac0-ebe8252ecdb3	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350170208	Koleston Supreme Kit 7/18 Işıltılı Küllü Kumral*18	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	889ae817-6fcb-4df3-9409-074fe2a3b460	\N	\N	6099350170208	338.1500	\N	TRY	\N	t	{"fkms": "20", "source": "Wella Product.xlsx", "altGrup": "Kit", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.850669	2026-07-29 12:16:02.850669	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
10efb763-aca0-4db6-901d-a071cc5bc709	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350170209	Koleston Supreme Kit 8/18 Açık Inci Küllü Kumral18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350170209	413.2200	\N	TRY	\N	t	{"fkms": "21", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.851733	2026-07-29 12:16:02.851733	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
f211c12c-cb5a-4327-a986-f947f0500195	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350170547	Koleston Supreme Kit 7/1 Küllü Kumral *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350170547	413.2200	\N	TRY	\N	t	{"fkms": "47", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.852747	2026-07-29 12:16:02.852747	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
d0123033-6dbe-42c7-aba5-6a076187f0de	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350170548	Koleston Supreme Kit 6/0 Koyu Kumral *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350170548	413.2200	\N	TRY	\N	t	{"fkms": "45", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.853806	2026-07-29 12:16:02.853806	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
272e0278-ae15-490e-9247-3022f5d734d5	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350170549	Koleston Supreme Kit 7/0 Kumral *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350170549	413.2200	\N	TRY	\N	t	{"fkms": "46", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.854864	2026-07-29 12:16:02.854864	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
d946c60b-1d31-481f-9400-9203f6f19aab	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350170550	Koleston Supreme Kit 6/1 Koyu Küllü Kumral *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350170550	413.2200	\N	TRY	\N	t	{"fkms": "26", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.855847	2026-07-29 12:16:02.855847	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
63e30fb3-30a5-479e-b1b4-ad1f02704648	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350170551	Koleston Supreme Kit 8/1 Açık Küllü Kumral *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350170551	413.2200	\N	TRY	\N	t	{"fkms": "41", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.856871	2026-07-29 12:16:02.856871	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
228e649f-a34b-4858-9307-f61ba00a484d	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350171204	Yeni Wellaflex Men Saç Spreyi 250 ml *6	\N	3072464e-d25b-47fb-9182-d222ec30e74f	38095fb8-a94e-4577-b927-758b4a6cab34	\N	\N	6099350171204	162.0500	\N	TRY	\N	t	{"fkms": "17", "source": "Wella Product.xlsx", "altGrup": "Spray", "anaGrup": "Şekillendirici"}	2026-07-29 12:16:02.857914	2026-07-29 12:16:02.857914	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
c2c25f13-0d81-4333-a891-2970fdfcbaab	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350171207	Yeni Wellaflex Men Matte Paste *6	\N	3072464e-d25b-47fb-9182-d222ec30e74f	38095fb8-a94e-4577-b927-758b4a6cab34	\N	\N	6099350171207	152.6000	\N	TRY	\N	t	{"fkms": "18", "source": "Wella Product.xlsx", "altGrup": "Wax", "anaGrup": "Şekillendirici"}	2026-07-29 12:16:02.859052	2026-07-29 12:16:02.859052	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
8a543c13-6d8f-4766-bfbf-159b99921ec6	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172031	Koleston Supreme Kit 4/77 Kadife Kahve *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172031	413.2200	\N	TRY	\N	t	{"fkms": "19", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.860157	2026-07-29 12:16:02.860157	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
d73bc781-2249-46dd-9395-f127f19cc4c3	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172032	Koleston Supreme Kit 3/0 Koyu Kahve *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172032	413.2200	\N	TRY	\N	t	{"fkms": "47", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.861286	2026-07-29 12:16:02.861286	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
dbd18862-9063-4cd2-9c51-9a8a29756886	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172033	Koleston Supreme Kit 2/0 Siyah *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172033	413.2200	\N	TRY	\N	t	{"fkms": "48", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.862348	2026-07-29 12:16:02.862348	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
55679831-79fa-4ca3-b727-49a7d6256a8b	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172034	Koleston Supreme Kit 6/3 Altın Kumral *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172034	413.2200	\N	TRY	\N	t	{"fkms": "15", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.863386	2026-07-29 12:16:02.863386	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
cb870f43-e26e-4c48-a0d5-699eeb51caf4	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172035	Koleston Supreme Kit 4/6 Kızıl Viyole *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172035	413.2200	\N	TRY	\N	t	{"fkms": "20", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.864453	2026-07-29 12:16:02.864453	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
c8e30bda-80e0-42fb-bd16-bc0825245047	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172036	Koleston Supreme Kit 3/66 Patlıcan Moru *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172036	413.2200	\N	TRY	\N	t	{"fkms": "17", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.865636	2026-07-29 12:16:02.865636	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
80969697-519b-40b3-b963-dab6cb888e5f	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172037	Koleston Supreme Kit 6/73 Toffee Çikolata Kahve*18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172037	413.2200	\N	TRY	\N	t	{"fkms": "21", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.866713	2026-07-29 12:16:02.866713	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
48a6c4eb-07c5-4211-8f88-885f561ada09	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172038	Koleston Supreme Kit 5/75 Çekici Bakır *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172038	413.2200	\N	TRY	\N	t	{"fkms": "14", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.867998	2026-07-29 12:16:02.867998	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
f7a252e7-35cd-4f0e-b029-3a919cf24a65	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172039	Koleston Supreme Kit 5/37 Kışkırtıcı Kahve *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172039	413.2200	\N	TRY	\N	t	{"fkms": "31", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.869062	2026-07-29 12:16:02.869062	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
6c488027-c50a-4d1d-9ff0-9e66120e21fc	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172040	Koleston Supreme Kit 5/0 Açık Kahve *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172040	413.2200	\N	TRY	\N	t	{"fkms": "46", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.870153	2026-07-29 12:16:02.870153	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
6d76122a-b80d-4f9a-912a-5c4742680f62	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172041	Koleston Supreme Kit 6/74 Koyu Amber Kumral *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172041	413.2200	\N	TRY	\N	t	{"fkms": "17", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.871178	2026-07-29 12:16:02.871178	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
2ab7b4a0-2005-4966-8b17-051fabd21164	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172042	Koleston Supreme Kit 66/46 Aşk Alevi *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172042	413.2200	\N	TRY	\N	t	{"fkms": "23", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.872211	2026-07-29 12:16:02.872211	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
9c88e090-cede-4f39-b118-51d87efe257e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172043	Koleston Supreme Kit 6/7 Çikolata Kahve *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172043	413.2200	\N	TRY	\N	t	{"fkms": "43", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.873211	2026-07-29 12:16:02.873211	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
2d6393c5-06b1-4a6c-bbd1-c409b11ff792	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172044	Koleston Supreme Kit 7/77 Işıltılı Kahve *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172044	413.2200	\N	TRY	\N	t	{"fkms": "34", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.874261	2026-07-29 12:16:02.874261	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
5a113994-72e9-4847-a91e-f08163da37a5	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172045	Koleston Supreme Kit 4/66 Sıcak Kızıl *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172045	413.2200	\N	TRY	\N	t	{"fkms": "11", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.875315	2026-07-29 12:16:02.875315	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
7b7b799a-311d-45ff-aa6f-2f638bffd0cf	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172046	Koleston Supreme Kit 7/3 Fındık Kabuğu *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172046	413.2200	\N	TRY	\N	t	{"fkms": "42", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.87633	2026-07-29 12:16:02.87633	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
b2defcaa-d0d1-46fe-bcba-3e50a2c9de72	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172047	Koleston Supreme Kit 44/46 Koyu Ateşli Kızıl *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172047	413.2200	\N	TRY	\N	t	{"fkms": "16", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.87734	2026-07-29 12:16:02.87734	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
0ba6d2f9-2f0b-4237-9482-a3540c07de2a	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172048	Koleston Supreme Kit 55/46 Kızıl Büyü *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172048	413.2200	\N	TRY	\N	t	{"fkms": "38", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.878603	2026-07-29 12:16:02.878603	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
74496201-9429-4fcf-8dbd-eb69ec890262	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172049	Koleston Supreme Kit 2/8 Mavi Siyah *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172049	413.2200	\N	TRY	\N	t	{"fkms": "35", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.879641	2026-07-29 12:16:02.879641	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
d5b01677-2b48-4be9-8f29-7de24a10244a	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172050	Koleston Supreme Kit 5/4 Açık Kestane *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172050	413.2200	\N	TRY	\N	t	{"fkms": "28", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.880826	2026-07-29 12:16:02.880826	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
46178eba-499b-4b1e-86a4-7aacc075bcd9	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172051	Koleston Supreme Kit 3/4 Koyu Kestane *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172051	413.2200	\N	TRY	\N	t	{"fkms": "44", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.882063	2026-07-29 12:16:02.882063	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
e59dd0a0-0145-4c45-a491-f0cbbd8e225b	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172052	Koleston Supreme Kit 8/0 Açık Kumral *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172052	413.2200	\N	TRY	\N	t	{"fkms": "35", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.883252	2026-07-29 12:16:02.883252	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
5a27ce7d-0f1f-45f7-aa6e-dc8842c16755	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172053	Koleston Supreme Kit 77/44 Kor Ateş Kızılı *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172053	413.2200	\N	TRY	\N	t	{"fkms": "21", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.884536	2026-07-29 12:16:02.884536	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
c1e81943-a6f4-4a39-9a71-378a2c57795f	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172054	Koleston Supreme Kit 4/0 Kahve *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172054	413.2200	\N	TRY	\N	t	{"fkms": "43", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.887423	2026-07-29 12:16:02.887423	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
58bd91e9-d8bb-4754-90ab-789baf31d91d	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172055	Koleston Supreme Kit 8/74 Gizemli Kahve *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172055	413.2200	\N	TRY	\N	t	{"fkms": "26", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.888451	2026-07-29 12:16:02.888451	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
c335abc0-d87e-41f6-854c-f2bd87b3dfec	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172056	Koleston Supreme Kit 9/1 Özel Açık Kül Sarısı *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172056	413.2200	\N	TRY	\N	t	{"fkms": "15", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.889454	2026-07-29 12:16:02.889454	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
be62ef34-0b3a-4509-beaf-1d4b816c69d8	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172057	Koleston Supreme Kit 6/4 Kızıl Bakır *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172057	413.2200	\N	TRY	\N	t	{"fkms": "14", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.890821	2026-07-29 12:16:02.890821	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
b97c5cc8-f306-400b-bf5d-068bfeebee04	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172058	Koleston Supreme Kit 10/0 Çok Açık Sarı *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172058	413.2200	\N	TRY	\N	t	{"fkms": "12", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.891889	2026-07-29 12:16:02.891889	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
814f53f4-980c-4358-b4bf-399887f338b4	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172059	Koleston Supreme Kit 5/66 Şarap Kızılı *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172059	413.2200	\N	TRY	\N	t	{"fkms": "17", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.892979	2026-07-29 12:16:02.892979	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
69753114-f775-4284-a202-95f36901d71a	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172060	Koleston Supreme Kit 9/0 Sarı *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172060	413.2200	\N	TRY	\N	t	{"fkms": "20", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.894042	2026-07-29 12:16:02.894042	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
ffa7c52f-23d5-4d99-96c8-a41b34348dfa	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172061	Koleston Supreme Kit 12/81 Küllü İnci Sarısı *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172061	413.2200	\N	TRY	\N	t	{"fkms": "10", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.895112	2026-07-29 12:16:02.895112	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
79f99c29-3efc-4abe-9dc1-1c1d91a2bf5d	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172062	Koleston Supreme Kit 12/0 Çok Açık Doğal Sarı *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172062	413.2200	\N	TRY	\N	t	{"fkms": "31", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.896158	2026-07-29 12:16:02.896158	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
2a0b4e5d-53c5-4bad-8777-c66fd05f08d1	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172063	Koleston Supreme Kit 12/11 Yoğun Küllü Sarı *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172063	413.2200	\N	TRY	\N	t	{"fkms": "23", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.897171	2026-07-29 12:16:02.897171	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
acec0163-e013-42d5-babc-066e8a2f7926	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172064	Koleston Supreme Kit 12/1 Küllü Sarı *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172064	413.2200	\N	TRY	\N	t	{"fkms": "19", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.898172	2026-07-29 12:16:02.898172	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
19eb04de-810a-465b-aae2-7c1bd65d3b03	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350172096	Koleston Balyaj - Ombre Kiti  *18	\N	8c1a5a0e-8d8d-42c8-bfe5-a3cd0a8961f8	2a460e05-b93a-4d24-9a35-5051d935a53f	\N	\N	6099350172096	413.2200	\N	TRY	\N	t	{"fkms": "19", "source": "Wella Product.xlsx", "altGrup": "Set Boya", "anaGrup": "Set Boya"}	2026-07-29 12:16:02.899272	2026-07-29 12:16:02.899272	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
3d4c8b48-2d96-4403-8fcc-ad5d4db9003c	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350174891	Yeni Wellaflex Saç Spreyi 75 ml Invisible Hold *12	\N	2885493c-7a3c-405c-8857-f6e9c0dfbbb1	b6a8cd09-c073-4672-bfa1-09618a9bb044	\N	\N	6099350174891	106.3100	\N	TRY	\N	t	{"fkms": "11", "source": "Wella Product.xlsx", "altGrup": "Spray", "anaGrup": "Şekillendirici"}	2026-07-29 12:16:02.900326	2026-07-29 12:16:02.900326	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
87ac59bf-643a-43fa-84f4-90e634c3cec6	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350174943	Yeni Wellaflex Saç Spreyi 400 ml 2 Days Volume *6	\N	2885493c-7a3c-405c-8857-f6e9c0dfbbb1	b6a8cd09-c073-4672-bfa1-09618a9bb044	\N	\N	6099350174943	232.6200	\N	TRY	\N	t	{"fkms": "7", "source": "Wella Product.xlsx", "altGrup": "Spray", "anaGrup": "Şekillendirici"}	2026-07-29 12:16:02.901451	2026-07-29 12:16:02.901451	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
e7fe643b-a006-4308-bc8b-be82b21bda7c	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350174944	Yeni Wellaflex Saç Spreyi 400 ml Invisible Hold *6	\N	2885493c-7a3c-405c-8857-f6e9c0dfbbb1	b6a8cd09-c073-4672-bfa1-09618a9bb044	\N	\N	6099350174944	232.6200	\N	TRY	\N	t	{"fkms": "8", "source": "Wella Product.xlsx", "altGrup": "Spray", "anaGrup": "Şekillendirici"}	2026-07-29 12:16:02.902628	2026-07-29 12:16:02.902628	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
f4fee54e-114e-4310-8ed2-ab20e96e96f2	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350174945	Yeni Wellaflex Saç Sprey 400ml Silk Finish&Hold*6	\N	3072464e-d25b-47fb-9182-d222ec30e74f	38095fb8-a94e-4577-b927-758b4a6cab34	\N	\N	6099350174945	232.6200	\N	TRY	\N	t	{"fkms": "8", "source": "Wella Product.xlsx", "altGrup": "Spray", "anaGrup": "Şekillendirici"}	2026-07-29 12:16:02.903698	2026-07-29 12:16:02.903698	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
f6d93055-a5cb-44bf-bf88-4477a3dad1fd	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350174993	Yeni Wellaflex Saç Spreyi 250 ml 2 Days Volume *6	\N	2885493c-7a3c-405c-8857-f6e9c0dfbbb1	b6a8cd09-c073-4672-bfa1-09618a9bb044	\N	\N	6099350174993	162.0500	\N	TRY	\N	t	{"fkms": "21", "source": "Wella Product.xlsx", "altGrup": "Spray", "anaGrup": "Şekillendirici"}	2026-07-29 12:16:02.904755	2026-07-29 12:16:02.904755	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
ea71a944-8206-4746-947c-5629fbd87502	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350174996	Yeni Wellaflex Saç Spreyi 250ml Silk Finish&Hold*6	\N	2885493c-7a3c-405c-8857-f6e9c0dfbbb1	b6a8cd09-c073-4672-bfa1-09618a9bb044	\N	\N	6099350174996	162.0500	\N	TRY	\N	t	{"fkms": "17", "source": "Wella Product.xlsx", "altGrup": "Spray", "anaGrup": "Şekillendirici"}	2026-07-29 12:16:02.905856	2026-07-29 12:16:02.905856	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
aedad35d-f4f0-4da4-a56f-dac2ae53eec4	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350175014	Yeni Wellaflex Saç Spreyi 75 ml 2 Days Volume *12	\N	2885493c-7a3c-405c-8857-f6e9c0dfbbb1	b6a8cd09-c073-4672-bfa1-09618a9bb044	\N	\N	6099350175014	106.3100	\N	TRY	\N	t	{"fkms": "27", "source": "Wella Product.xlsx", "altGrup": "Spray", "anaGrup": "Şekillendirici"}	2026-07-29 12:16:02.906878	2026-07-29 12:16:02.906878	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
2f336474-afc5-41a4-97aa-38d12d9fcd2c	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350175050	Yeni Wellaflex Saç Köpüğü 200 ml 2 Days Volume *6	\N	2885493c-7a3c-405c-8857-f6e9c0dfbbb1	b6a8cd09-c073-4672-bfa1-09618a9bb044	\N	\N	6099350175050	162.0500	\N	TRY	\N	t	{"fkms": "25", "source": "Wella Product.xlsx", "altGrup": "Köpük", "anaGrup": "Köpük"}	2026-07-29 12:16:02.909087	2026-07-29 12:16:02.909087	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
5d6faaf3-1f54-4496-b3f5-2af25cc823ba	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350175052	Yeni Wellaflex Saç Köpüğü 200ml Curls Definition*6	\N	2885493c-7a3c-405c-8857-f6e9c0dfbbb1	b6a8cd09-c073-4672-bfa1-09618a9bb044	\N	\N	6099350175052	162.0500	\N	TRY	\N	t	{"fkms": "25", "source": "Wella Product.xlsx", "altGrup": "Köpük", "anaGrup": "Köpük"}	2026-07-29 12:16:02.910091	2026-07-29 12:16:02.910091	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
4fa60aef-7ae1-48c8-8ba9-86ddcb2bee7e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350175053	Yeni Wellaflex Saç Köpüğü 200ml Silk Finish&Hold*6	\N	2885493c-7a3c-405c-8857-f6e9c0dfbbb1	b6a8cd09-c073-4672-bfa1-09618a9bb044	\N	\N	6099350175053	162.0500	\N	TRY	\N	t	{"fkms": "20", "source": "Wella Product.xlsx", "altGrup": "Spray", "anaGrup": "Şekillendirici"}	2026-07-29 12:16:02.911107	2026-07-29 12:16:02.911107	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
979dd7e6-c406-4831-8a1f-a7f2d74cf608	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350175282	Yeni Wellaflex Saç Spreyi 250 ml Invisible Hold *6	\N	2885493c-7a3c-405c-8857-f6e9c0dfbbb1	b6a8cd09-c073-4672-bfa1-09618a9bb044	\N	\N	6099350175282	162.0500	\N	TRY	\N	t	{"fkms": "25", "source": "Wella Product.xlsx", "altGrup": "Spray", "anaGrup": "Şekillendirici"}	2026-07-29 12:16:02.912158	2026-07-29 12:16:02.912158	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
8bfc9b8a-74be-411b-91df-31484a8c3668	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350175696	Yeni Wellaflex Saç Köpüğü 200 ml Invisible Hold *6	\N	2885493c-7a3c-405c-8857-f6e9c0dfbbb1	b6a8cd09-c073-4672-bfa1-09618a9bb044	\N	\N	6099350175696	162.0500	\N	TRY	\N	t	{"fkms": "20", "source": "Wella Product.xlsx", "altGrup": "Köpük", "anaGrup": "Köpük"}	2026-07-29 12:16:02.913215	2026-07-29 12:16:02.913215	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
a393b2d3-05e7-402e-8887-518fbce7ce35	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350182574	Yeni Wellaflex Men Jel Sprey 150 ml *6	\N	3072464e-d25b-47fb-9182-d222ec30e74f	38095fb8-a94e-4577-b927-758b4a6cab34	\N	\N	6099350182574	152.6000	\N	TRY	\N	t	{"fkms": "8", "source": "Wella Product.xlsx", "altGrup": "Spray", "anaGrup": "Şekillendirici"}	2026-07-29 12:16:02.914272	2026-07-29 12:16:02.914272	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
54d357d4-81bb-42c1-992e-ec0157c8c0eb	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350184919	Koleston Peroksit 9% *50	\N	18e5cf4a-2e63-4381-a6d5-14cccf367287	f33675dd-6bc5-4a0b-8483-be94ad4b270d	\N	\N	6099350184919	42.5600	\N	TRY	\N	t	{"fkms": "38", "source": "Wella Product.xlsx", "altGrup": "Peroksit", "anaGrup": "Peroksit"}	2026-07-29 12:16:02.915341	2026-07-29 12:16:02.915341	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
222081b9-fb68-4793-a424-17fdc1252e53	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350184920	Koleston Peroksit 6% *50	\N	18e5cf4a-2e63-4381-a6d5-14cccf367287	f33675dd-6bc5-4a0b-8483-be94ad4b270d	\N	\N	6099350184920	42.5600	\N	TRY	\N	t	{"fkms": "36", "source": "Wella Product.xlsx", "altGrup": "Peroksit", "anaGrup": "Peroksit"}	2026-07-29 12:16:02.916355	2026-07-29 12:16:02.916355	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
baf006e5-ad2d-40d3-aef5-d02e58f1db21	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185289	Koleston Single 4/6 Kızıl Viyole *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185289	81.8700	\N	TRY	\N	t	{"fkms": "7", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.917352	2026-07-29 12:16:02.917352	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
77eb1eb5-5a42-46ee-8003-5dad80f54706	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185290	Koleston Single 3/66 Patlican Moru *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185290	81.8700	\N	TRY	\N	t	{"fkms": "2", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.918679	2026-07-29 12:16:02.918679	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
a1daf4d4-cd8e-4988-a3a7-8dcf7843d5b0	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185291	Koleston Single 8/0 Açık Kumral *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185291	81.8700	\N	TRY	\N	t	{"fkms": "34", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.919672	2026-07-29 12:16:02.919672	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
8dd42910-9399-473d-a794-500e645eed12	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185292	Koleston Single 6/7 Çikolata Kahve *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185292	81.8700	\N	TRY	\N	t	{"fkms": "32", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.920675	2026-07-29 12:16:02.920675	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
88e3a53e-00d0-41b0-9805-1c51dcca1ead	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185293	Koleston Single 2/0 Siyah *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185293	81.8700	\N	TRY	\N	t	{"fkms": "39", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.921679	2026-07-29 12:16:02.921679	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
d5febefc-dab9-4b90-80de-040719d642a3	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185294	Koleston Single 77/44 Kor Ateşi Kızılı *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185294	81.8700	\N	TRY	\N	t	{"fkms": "16", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.922717	2026-07-29 12:16:02.922717	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
c56e3294-0f5f-488a-b5b6-37ea3afb102e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185295	Koleston Single 9/3 Altın Sarısı *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185295	81.8700	\N	TRY	\N	t	{"fkms": "10", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.923906	2026-07-29 12:16:02.923906	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
556c19a7-00f9-4390-9faa-efd36ce5a47d	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185296	Koleston Single 7/0 Kumral Yeni *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185296	81.8700	\N	TRY	\N	t	{"fkms": "36", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.924925	2026-07-29 12:16:02.924925	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
4d57d5d8-c548-4723-afc4-30b639abb9fe	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185297	Koleston Single 5/66 Şarap Kızılı *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185297	81.8700	\N	TRY	\N	t	{"fkms": "18", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.92592	2026-07-29 12:16:02.92592	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
175b7159-be49-4df0-93b5-69d048d3ee43	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185298	Koleston Single 7/3 Fındık Kabuğu *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185298	81.8700	\N	TRY	\N	t	{"fkms": "35", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.927177	2026-07-29 12:16:02.927177	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
d470160e-3028-4c18-8cd2-10bfd1f937d6	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185299	Koleston Single 11/1 Açık Küllü Sarı *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185299	81.8700	\N	TRY	\N	t	{"fkms": "19", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.928253	2026-07-29 12:16:02.928253	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
08c0e84a-6150-4783-8f7b-225582e3dd43	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185300	Koleston Single 6/0 Koyu Kumral *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185300	81.8700	\N	TRY	\N	t	{"fkms": "41", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.929489	2026-07-29 12:16:02.929489	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
b6be261f-697b-44ee-8030-d24913dda605	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185301	Koleston Single 9/0 Sarı *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185301	81.8700	\N	TRY	\N	t	{"fkms": "32", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.930478	2026-07-29 12:16:02.930478	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
53c3442f-18ac-4551-9843-78eef202fdc4	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185302	Koleston Single 3/0 Koyu Kahve *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185302	81.8700	\N	TRY	\N	t	{"fkms": "26", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.93165	2026-07-29 12:16:02.93165	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
1f0c7201-a8f4-4c70-8f90-cc36a66103f1	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185303	Koleston Single 7/77 Işıltılı Kahve Yeni *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185303	81.8700	\N	TRY	\N	t	{"fkms": "36", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.932653	2026-07-29 12:16:02.932653	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
86f2185a-f565-4844-823b-04943c9936d3	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185304	Koleston Single 5/4 Açık Kestane *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185304	81.8700	\N	TRY	\N	t	{"fkms": "12", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.933949	2026-07-29 12:16:02.933949	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
19b9521d-6a37-4ff1-9f2c-77838acd24b7	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185305	Koleston Single 6/35 Elegan Kahve *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185305	81.8700	\N	TRY	\N	t	{"fkms": "22", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.934946	2026-07-29 12:16:02.934946	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
3a26a31a-5219-46f7-b8cd-58f98d5fd635	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185306	Koleston Single 7/1 Küllü Kumral *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185306	81.8700	\N	TRY	\N	t	{"fkms": "36", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.936198	2026-07-29 12:16:02.936198	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
2d13e6c1-1dce-405f-a5d2-14679790bc8b	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185307	Koleston Single 5/0 Açık Kahve *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185307	81.8700	\N	TRY	\N	t	{"fkms": "26", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.937158	2026-07-29 12:16:02.937158	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
33dd8316-35ba-4154-8f19-f41426413fc6	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185308	Koleston Single 4/0 Kahve *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185308	81.8700	\N	TRY	\N	t	{"fkms": "28", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.938142	2026-07-29 12:16:02.938142	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
875b86de-5929-4b77-b63c-3977effeb21e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185309	Koleston Single 3/4 Koyu Kestane *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185309	81.8700	\N	TRY	\N	t	{"fkms": "23", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.939103	2026-07-29 12:16:02.939103	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
faa57b17-ec5a-49fa-9b38-33d95d9a0a92	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185310	Koleston Single 8/1 Açık Küllü Kumral *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185310	81.8700	\N	TRY	\N	t	{"fkms": "36", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.94012	2026-07-29 12:16:02.94012	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
26c18c8f-6fc7-4ce8-825f-42fe82444732	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185311	Koleston Single 66/46 Aşk Alevi *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185311	81.8700	\N	TRY	\N	t	{"fkms": "23", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.9411	2026-07-29 12:16:02.9411	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
6f75b807-deee-4ed5-b43e-5d2cecf0f0d6	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185513	Koleston Single 55/46 Kızıl Büyü *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185513	81.8700	\N	TRY	\N	t	{"fkms": "16", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.942055	2026-07-29 12:16:02.942055	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
699c8c09-ef4e-4133-ae82-c1a8c32492b5	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099350185514	Koleston Single 5/37 Kışkırtıcı Kahve *72	\N	041bdf91-afbf-4d2d-a744-2181eca5410e	21d4bb42-3d17-431f-b040-1b52a1ebebba	\N	\N	6099350185514	81.8700	\N	TRY	\N	t	{"fkms": "13", "source": "Wella Product.xlsx", "altGrup": "Single", "anaGrup": "Saç Boyası"}	2026-07-29 12:16:02.943043	2026-07-29 12:16:02.943043	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
417077ad-70e5-41a9-969f-348203aa2244	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099363069024	Koleston Saç Boyama Seti *96	\N	e77c959a-69dd-40d5-bc8f-d6d25b33aa50	f5b0e3ad-f524-4a84-96ae-0cba7176fe50	\N	\N	6099363069024	0.0100	\N	TRY	\N	t	{"fkms": "4", "source": "Wella Product.xlsx", "altGrup": "Promosyon", "anaGrup": "Diğer"}	2026-07-29 12:16:02.944023	2026-07-29 12:16:02.944023	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
7525de09-d6be-4164-a3aa-3a99bedfcae9	598a895e-5a20-48cc-95bd-a52fe5d4bb65	6099617250113	Koleston Saç Tarağı *72	\N	e77c959a-69dd-40d5-bc8f-d6d25b33aa50	f5b0e3ad-f524-4a84-96ae-0cba7176fe50	\N	\N	6099617250113	0.0100	\N	TRY	\N	t	{"fkms": "1", "source": "Wella Product.xlsx", "altGrup": "Promosyon", "anaGrup": "Diğer"}	2026-07-29 12:16:02.94499	2026-07-29 12:16:02.94499	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
\.


--
-- Data for Name: tactics; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.tactics (id, tenant_id, code, name, description, tactic_type, spend_type, applicable_channels, applicable_categories, is_active, metadata, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
7cd1aee3-3d05-47f9-949b-3614275c80f9	598a895e-5a20-48cc-95bd-a52fe5d4bb65	TAC-ON-DISCOUNT	On-Invoice Discount	\N	DISCOUNT	ON_INVOICE	\N	\N	t	\N	2026-07-29 12:16:02.64802	2026-07-29 12:16:02.64802	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
13d8d3de-6f08-4222-b217-a311ae754b1e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	TAC-OFF-DISCOUNT	Off-Invoice Discount	\N	DISCOUNT	OFF_INVOICE	\N	\N	t	\N	2026-07-29 12:16:02.653474	2026-07-29 12:16:02.653474	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
ee06a177-9fa0-4503-a0dc-9277039e180a	598a895e-5a20-48cc-95bd-a52fe5d4bb65	TAC-VISIBILITY	Visibility & Display	\N	LUMP_SUM	OFF_INVOICE	\N	\N	t	\N	2026-07-29 12:16:02.655301	2026-07-29 12:16:02.655301	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
75b984e8-83d8-4abe-95fa-720ffc3aa2ec	598a895e-5a20-48cc-95bd-a52fe5d4bb65	TAC-PRICE-SUPPORT	Price Support	\N	OTHER	OFF_INVOICE	\N	\N	t	\N	2026-07-29 12:16:02.656897	2026-07-29 12:16:02.656897	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
41b55aae-f357-49f1-bd13-a336bbadaf28	598a895e-5a20-48cc-95bd-a52fe5d4bb65	TAC-PROMO	Promotion	\N	DISCOUNT	OFF_INVOICE	\N	\N	t	\N	2026-07-29 12:16:02.658648	2026-07-29 12:16:02.658648	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
\.


--
-- Data for Name: tenants; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.tenants (id, name, domain, status, plan, contact_email, contact_phone, contact_person, address, city, country, postal_code, tax_number, company_registration_number, industry, settings, subscription_start_date, subscription_end_date, max_users, max_storage_gb, current_storage_gb, metadata, notes, created_at, updated_at, deleted_at) FROM stdin;
598a895e-5a20-48cc-95bd-a52fe5d4bb65	Wella Turkey	wella.tsp.local	ACTIVE	PROFESSIONAL	admin@wella.com	\N	Wella Admin	\N	Istanbul	Turkey	\N	\N	\N	FMCG	{"features": {"apiAccess": true, "bulkImport": true, "customReports": true, "advancedAnalytics": true}, "timezone": "Europe/Istanbul", "defaultCurrency": "TRY", "fiscalYearStart": "01-01"}	\N	\N	50	100	0.00	\N	\N	2026-06-17 18:47:52.731774	2026-06-17 18:47:52.731774	\N
\.


--
-- Data for Name: typeorm_metadata; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.typeorm_metadata (type, database, schema, "table", name, value) FROM stdin;
\.


--
-- Data for Name: user_scopes; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.user_scopes (id, tenant_id, user_id, cpl_id, category_id, channel_id, is_active, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
dad99eda-0518-4046-949d-f09623a2525b	598a895e-5a20-48cc-95bd-a52fe5d4bb65	67b863d1-1a98-464d-af7b-df0b219748ae	2eded86b-ae2a-4097-92fb-f304c79c57e1	\N	\N	t	2026-07-27 22:05:28.71455	2026-07-27 22:05:28.71455	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
582e4763-125b-4f21-a38d-49c973608e43	598a895e-5a20-48cc-95bd-a52fe5d4bb65	67b863d1-1a98-464d-af7b-df0b219748ae	8a0d6841-b2f5-4f31-81c8-3fec9a82672f	\N	\N	t	2026-07-27 22:05:28.735333	2026-07-27 22:05:28.735333	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
20776b14-09a3-4c3d-bde1-d45b9f19ff39	598a895e-5a20-48cc-95bd-a52fe5d4bb65	67b863d1-1a98-464d-af7b-df0b219748ae	2384a64b-0880-47e1-8678-b3ce0353ea53	\N	\N	t	2026-07-27 22:05:28.738168	2026-07-27 22:05:28.738168	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
6d9024f7-8189-43d1-9ed7-c797c04ef05d	598a895e-5a20-48cc-95bd-a52fe5d4bb65	67b863d1-1a98-464d-af7b-df0b219748ae	b39ade6a-ea33-413f-95a0-281c859f32fd	\N	\N	t	2026-07-27 22:05:28.740502	2026-07-27 22:05:28.740502	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
c3867b54-f6ce-4af0-8db3-8a21de6a4b0c	598a895e-5a20-48cc-95bd-a52fe5d4bb65	67b863d1-1a98-464d-af7b-df0b219748ae	4b3850a8-d598-49ca-a740-94730fd7cfa6	\N	\N	t	2026-07-27 22:05:28.742859	2026-07-27 22:05:28.742859	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
548d6a4d-814a-4ddc-8788-59914fadac26	598a895e-5a20-48cc-95bd-a52fe5d4bb65	67b863d1-1a98-464d-af7b-df0b219748ae	29982d2e-9f92-424c-bdcf-33462493ad1c	\N	\N	t	2026-07-27 22:05:28.744791	2026-07-27 22:05:28.744791	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
ec386417-ad25-484e-bf1c-a046e92926ea	598a895e-5a20-48cc-95bd-a52fe5d4bb65	67b863d1-1a98-464d-af7b-df0b219748ae	ac0d2c7d-ccd9-4060-a24e-6bdb773f5083	\N	\N	t	2026-07-27 22:05:28.747634	2026-07-27 22:05:28.747634	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
04040aec-1266-41ec-8a1d-2d05131d39bc	598a895e-5a20-48cc-95bd-a52fe5d4bb65	67b863d1-1a98-464d-af7b-df0b219748ae	dbc049f6-0346-46b3-b13d-1817a8b293cc	\N	\N	t	2026-07-27 22:05:28.749868	2026-07-27 22:05:28.749868	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
cdf3967b-ca43-449b-b240-699a605a628e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	67b863d1-1a98-464d-af7b-df0b219748ae	4a6ffd3b-e61c-4dbe-abaa-0ed0722fe79c	\N	\N	t	2026-07-27 22:05:28.752422	2026-07-27 22:05:28.752422	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
43aead19-50f2-4c7f-9f34-ff6a45ab033a	598a895e-5a20-48cc-95bd-a52fe5d4bb65	67b863d1-1a98-464d-af7b-df0b219748ae	9ac62124-efe3-4d61-90a8-b6c3e4e0134c	\N	\N	t	2026-07-27 22:05:28.754552	2026-07-27 22:05:28.754552	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
c4691001-7e03-40a5-9349-a564f168ff28	598a895e-5a20-48cc-95bd-a52fe5d4bb65	67b863d1-1a98-464d-af7b-df0b219748ae	7a0d58e9-8781-4d6b-b471-240a47aeca01	\N	\N	t	2026-07-27 22:05:28.756679	2026-07-27 22:05:28.756679	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
f0a7fe52-78ca-4dba-b5cf-5ee47ca65f58	598a895e-5a20-48cc-95bd-a52fe5d4bb65	699cc16e-f082-4d28-97a3-c4f12ecfddc6	a871bb23-5433-47e4-8821-6e21e05eeaab	\N	\N	t	2026-07-27 22:05:28.759144	2026-07-27 22:05:28.759144	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
d8ca9d23-461f-4098-8298-f296d0b1e167	598a895e-5a20-48cc-95bd-a52fe5d4bb65	699cc16e-f082-4d28-97a3-c4f12ecfddc6	e1637a9d-380e-48cd-9830-bbf120e41404	\N	\N	t	2026-07-27 22:05:28.760822	2026-07-27 22:05:28.760822	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
e197f0c5-d80b-4f74-bc5c-22edba253f6d	598a895e-5a20-48cc-95bd-a52fe5d4bb65	699cc16e-f082-4d28-97a3-c4f12ecfddc6	cf3b2c8b-d8b1-4755-a4c3-8aad655e0a65	\N	\N	t	2026-07-27 22:05:28.762694	2026-07-27 22:05:28.762694	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
1a4b415b-4f67-45b3-ad90-6353556954d8	598a895e-5a20-48cc-95bd-a52fe5d4bb65	699cc16e-f082-4d28-97a3-c4f12ecfddc6	2ddf0f01-3cb3-490e-b82b-772aee73e696	\N	\N	t	2026-07-27 22:05:28.764574	2026-07-27 22:05:28.764574	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
c264d638-2e6f-46a5-91a8-dab83fad15d2	598a895e-5a20-48cc-95bd-a52fe5d4bb65	699cc16e-f082-4d28-97a3-c4f12ecfddc6	55b09d5e-3a2f-4579-8ae6-928f86fc09ef	\N	\N	t	2026-07-27 22:05:28.767317	2026-07-27 22:05:28.767317	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
ff7d35ff-6cca-469e-b978-c201c58c8895	598a895e-5a20-48cc-95bd-a52fe5d4bb65	699cc16e-f082-4d28-97a3-c4f12ecfddc6	ea138aed-0d24-44af-aa8f-78be33b97fd1	\N	\N	t	2026-07-27 22:05:28.769568	2026-07-27 22:05:28.769568	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
bd6b0940-001d-4872-8593-79684c77d642	598a895e-5a20-48cc-95bd-a52fe5d4bb65	699cc16e-f082-4d28-97a3-c4f12ecfddc6	28ca1d98-0301-4526-8a3a-0cc44d7a088c	\N	\N	t	2026-07-27 22:05:28.772512	2026-07-27 22:05:28.772512	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
e8ea4c19-69b2-4318-b6b5-841e94b7188f	598a895e-5a20-48cc-95bd-a52fe5d4bb65	699cc16e-f082-4d28-97a3-c4f12ecfddc6	a31f3f57-5ae0-4bbb-9f6a-003d34c04525	\N	\N	t	2026-07-27 22:05:28.774234	2026-07-27 22:05:28.774234	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
6aef0880-7c44-4339-b436-a8971c073f71	598a895e-5a20-48cc-95bd-a52fe5d4bb65	699cc16e-f082-4d28-97a3-c4f12ecfddc6	734808ca-22dd-4425-b094-c9be94c83f2b	\N	\N	t	2026-07-27 22:05:28.776671	2026-07-27 22:05:28.776671	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
8210c301-2d9d-4c65-83d4-924a41ffd03c	598a895e-5a20-48cc-95bd-a52fe5d4bb65	699cc16e-f082-4d28-97a3-c4f12ecfddc6	2f664935-9652-46fa-a995-900dcbf809bd	\N	\N	t	2026-07-27 22:05:28.778715	2026-07-27 22:05:28.778715	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
827fff4d-9207-44ef-adf2-5de66bbe9203	598a895e-5a20-48cc-95bd-a52fe5d4bb65	699cc16e-f082-4d28-97a3-c4f12ecfddc6	1ea11f01-9da0-4897-896d-cc5febea7b38	\N	\N	t	2026-07-27 22:05:28.781076	2026-07-27 22:05:28.781076	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
6919e174-3730-4e1a-b9d8-f0bbecfcef0a	598a895e-5a20-48cc-95bd-a52fe5d4bb65	699cc16e-f082-4d28-97a3-c4f12ecfddc6	f0da4013-ae5d-4ba7-a0cb-13c554085daa	\N	\N	t	2026-07-27 22:05:28.784514	2026-07-27 22:05:28.784514	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
a006cafc-2a0f-4b53-b5e9-999ce4ffb562	598a895e-5a20-48cc-95bd-a52fe5d4bb65	699cc16e-f082-4d28-97a3-c4f12ecfddc6	fce2ccf6-3ab6-43de-8dc1-ffbf842e26ca	\N	\N	t	2026-07-27 22:05:28.786919	2026-07-27 22:05:28.786919	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
d5ce2d96-cf2a-4e39-affa-a727e9e699f8	598a895e-5a20-48cc-95bd-a52fe5d4bb65	699cc16e-f082-4d28-97a3-c4f12ecfddc6	826127e6-267d-4c76-b6e5-861525cea6f3	\N	\N	t	2026-07-27 22:05:28.788993	2026-07-27 22:05:28.788993	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
df86b5af-9fb5-4a03-93ca-2a3a613bb497	598a895e-5a20-48cc-95bd-a52fe5d4bb65	699cc16e-f082-4d28-97a3-c4f12ecfddc6	25297e2d-8503-40bd-a28b-a31306459f6d	\N	\N	t	2026-07-27 22:05:28.790864	2026-07-27 22:05:28.790864	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
8bc203c4-a159-4fcf-9420-b226db8f5925	598a895e-5a20-48cc-95bd-a52fe5d4bb65	699cc16e-f082-4d28-97a3-c4f12ecfddc6	54943c0b-df0f-4988-a4b0-9350b48d3e84	\N	\N	t	2026-07-27 22:05:28.792906	2026-07-27 22:05:28.792906	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
54472fb1-f828-42e0-aaac-432dd187f442	598a895e-5a20-48cc-95bd-a52fe5d4bb65	699cc16e-f082-4d28-97a3-c4f12ecfddc6	6f759975-9c61-4233-a2b3-be1e6f1a09f9	\N	\N	t	2026-07-27 22:05:28.795383	2026-07-27 22:05:28.795383	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
64fd4cff-493f-4b5d-859e-fbe9ddde4538	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	ed0fc161-6d46-4ca8-bbef-6a7c0f2f2686	\N	t	2026-07-27 22:05:28.797518	2026-07-27 22:05:28.797518	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
604a3355-5be3-46b4-bb08-33bfc752142e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	fcc3b7fc-f296-4f3d-917b-1a628edc1921	\N	t	2026-07-27 22:05:28.799338	2026-07-27 22:05:28.799338	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
2a506776-4af0-4a7e-b380-ee31b3b20995	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0f62abdc-4e3c-43af-b886-b2c2eae9be23	\N	20cd3b37-4316-4e75-9cc2-d5ad35c84195	\N	t	2026-07-27 22:05:28.801901	2026-07-27 22:05:28.801901	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
9141bdbb-d6f3-4e55-adda-4af4cae67b7e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	ed0fc161-6d46-4ca8-bbef-6a7c0f2f2686	\N	t	2026-07-27 22:14:35.228514	2026-07-27 22:14:35.228514	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
f8846f05-1e10-40af-a9df-2e3f810235cb	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	fcc3b7fc-f296-4f3d-917b-1a628edc1921	\N	t	2026-07-27 22:14:35.238452	2026-07-27 22:14:35.238452	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
718f606e-6147-4860-8440-96423672a030	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	432b26b4-52bd-4f44-8f08-40e92fc7d496	\N	t	2026-07-28 06:57:45.093736	2026-07-28 06:57:45.093736	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
c0c1e5f5-b4d8-477d-b8ec-963fdf82a023	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	1f770ca4-42b7-4f2d-9d60-3d0d936e4952	\N	t	2026-07-28 06:57:45.109943	2026-07-28 06:57:45.109943	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
0aedb604-8e87-4cd6-bd72-10050cfa0e8c	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0f62abdc-4e3c-43af-b886-b2c2eae9be23	\N	f8e41915-c3e3-4e01-8425-05ee2ffe28bd	\N	t	2026-07-28 06:57:45.113992	2026-07-28 06:57:45.113992	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
ca167920-663b-4bc3-8e07-f70ee329c8a2	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	432b26b4-52bd-4f44-8f08-40e92fc7d496	\N	t	2026-07-28 06:57:45.11665	2026-07-28 06:57:45.11665	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
9d9f1db2-b59e-4d2a-bdb6-dd80d6495094	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	1f770ca4-42b7-4f2d-9d60-3d0d936e4952	\N	t	2026-07-28 06:57:45.119139	2026-07-28 06:57:45.119139	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
f4ef06a9-a472-4916-8e0c-f74bc4102b3c	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	e7136ac4-aacb-4ae8-9c4c-c0892079b3f3	\N	t	2026-07-29 07:09:38.239632	2026-07-29 07:09:38.239632	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
f2dafda7-0cee-486f-9a47-602ea1e5a1da	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	17b23887-2c26-49fc-97ae-968e1dca72af	\N	t	2026-07-29 07:09:38.242837	2026-07-29 07:09:38.242837	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
d3b7a5fa-82d1-409c-978d-66313f29929e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0f62abdc-4e3c-43af-b886-b2c2eae9be23	\N	96a35f3d-aa39-45e4-8462-6956bd3f06ae	\N	t	2026-07-29 07:09:38.246525	2026-07-29 07:09:38.246525	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
1ad360f2-75ae-4fa6-be14-fe3af8170da2	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	e7136ac4-aacb-4ae8-9c4c-c0892079b3f3	\N	t	2026-07-29 07:09:38.249806	2026-07-29 07:09:38.249806	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
a9534f78-3d23-4849-820b-61bf4e25185a	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	17b23887-2c26-49fc-97ae-968e1dca72af	\N	t	2026-07-29 07:09:38.251918	2026-07-29 07:09:38.251918	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
043328dc-9907-423b-b372-2b3e221aa184	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	fbe88af8-48fd-451d-8097-8e79f718986a	\N	t	2026-07-29 07:11:52.445422	2026-07-29 07:11:52.445422	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
f347bc3a-2a04-4094-9868-16f333f9d043	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	ec85b483-cbc6-4e09-9fbd-b8596d382cb8	\N	t	2026-07-29 07:11:52.453101	2026-07-29 07:11:52.453101	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
ab837c2d-5340-425c-8ec6-ebd514fdb20b	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0f62abdc-4e3c-43af-b886-b2c2eae9be23	\N	821d1063-8646-4a13-b1e9-e32ca890441f	\N	t	2026-07-29 07:11:52.45857	2026-07-29 07:11:52.45857	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
17d9e547-1c0b-4b23-ad85-6e061ba77072	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	fbe88af8-48fd-451d-8097-8e79f718986a	\N	t	2026-07-29 07:11:52.461021	2026-07-29 07:11:52.461021	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
7724dfe3-1e33-4f9a-b50f-8c87ee2143a3	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	ec85b483-cbc6-4e09-9fbd-b8596d382cb8	\N	t	2026-07-29 07:11:52.462693	2026-07-29 07:11:52.462693	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
8d17051e-e7d4-4cd2-aa7e-30d23a3cfe05	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	12e68fd7-e6e5-4f7b-b59f-d0989ef40fb3	\N	t	2026-07-29 07:23:30.101419	2026-07-29 07:23:30.101419	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
1aec76e6-0702-45bc-8b83-f50d64b3eb5b	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	390abfb9-d5f9-447d-aedd-2992b0af086e	\N	t	2026-07-29 07:23:30.117231	2026-07-29 07:23:30.117231	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
0f1d1cb5-6f4d-4bbf-b3f4-8aab1ea7b7e3	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0f62abdc-4e3c-43af-b886-b2c2eae9be23	\N	31704a79-8136-4d25-a3ab-574cfbad4147	\N	t	2026-07-29 07:23:30.12056	2026-07-29 07:23:30.12056	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
cb6749fa-0267-40b4-b7ef-bf8999ed6334	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	12e68fd7-e6e5-4f7b-b59f-d0989ef40fb3	\N	t	2026-07-29 07:23:30.122014	2026-07-29 07:23:30.122014	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
03faf5c0-4062-4b01-9c4d-3a5cdb9e15c9	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	390abfb9-d5f9-447d-aedd-2992b0af086e	\N	t	2026-07-29 07:23:30.123588	2026-07-29 07:23:30.123588	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
9d8f1eae-c6dd-4c2e-844f-c34bc59139a4	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	c9f2ff12-b970-4032-b83a-d394515791d0	\N	t	2026-07-29 07:28:45.400842	2026-07-29 07:28:45.400842	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
db970b98-dc95-455c-b2d9-6c3571e3123e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	ae85686b-cb1a-4e63-9dc5-1329f53e845e	\N	t	2026-07-29 07:28:45.405294	2026-07-29 07:28:45.405294	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
ed04b564-e5bc-4a13-9b8e-e4403409d7ca	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0f62abdc-4e3c-43af-b886-b2c2eae9be23	\N	e6a3a4e4-f291-473f-8d2d-253af7c58e90	\N	t	2026-07-29 07:28:45.407097	2026-07-29 07:28:45.407097	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
36d2240d-7de9-45a4-9369-5665d88e08c5	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	c9f2ff12-b970-4032-b83a-d394515791d0	\N	t	2026-07-29 07:28:45.408509	2026-07-29 07:28:45.408509	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
854148e2-b897-40b9-a61a-00fb17cf4a20	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	ae85686b-cb1a-4e63-9dc5-1329f53e845e	\N	t	2026-07-29 07:28:45.410064	2026-07-29 07:28:45.410064	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
c12f7314-7ce3-4fd5-9233-fd447142a9ab	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	2d2ddd74-aba6-4a27-8ace-c40368b27001	\N	t	2026-07-29 07:56:31.378422	2026-07-29 07:56:31.378422	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
fb5d7d8a-4587-41a4-89f8-54a7b56b2a34	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	3eb95f4a-1316-405c-b02e-5efc1e8da00a	\N	t	2026-07-29 07:56:31.391394	2026-07-29 07:56:31.391394	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
895254e5-1d94-42e4-b425-32e84e2c8148	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0f62abdc-4e3c-43af-b886-b2c2eae9be23	\N	c1bcc9af-ce9a-48a2-8cb3-ea164f97ebdb	\N	t	2026-07-29 07:56:31.393496	2026-07-29 07:56:31.393496	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
60d4db96-36a0-40fb-94b6-c3d122bd2630	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	2d2ddd74-aba6-4a27-8ace-c40368b27001	\N	t	2026-07-29 07:56:31.39462	2026-07-29 07:56:31.39462	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
eaaa482a-7054-4cd6-946f-1a697c273e50	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	3eb95f4a-1316-405c-b02e-5efc1e8da00a	\N	t	2026-07-29 07:56:31.395722	2026-07-29 07:56:31.395722	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
332391bd-41fe-4b21-9410-7b3c6ce0ebd8	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	c08fcc81-d594-48f4-89f1-ca5ae477bb37	\N	t	2026-07-29 08:03:07.611774	2026-07-29 08:03:07.611774	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
46455099-7090-45db-9fb2-3829c51e07a6	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	24b2f4eb-bfdc-493d-97ba-db4865e14a04	\N	t	2026-07-29 08:03:07.616673	2026-07-29 08:03:07.616673	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
e3066ba4-3d85-45b8-bc7b-0ce7c75d3419	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0f62abdc-4e3c-43af-b886-b2c2eae9be23	\N	a5b428df-f650-4e87-90d6-8abcc761af89	\N	t	2026-07-29 08:03:07.617783	2026-07-29 08:03:07.617783	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
11b4f9cb-8a3f-49a4-a540-435121f23b0c	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	c08fcc81-d594-48f4-89f1-ca5ae477bb37	\N	t	2026-07-29 08:03:07.618825	2026-07-29 08:03:07.618825	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
2e813751-665a-49ff-8945-1283114713f9	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	24b2f4eb-bfdc-493d-97ba-db4865e14a04	\N	t	2026-07-29 08:03:07.619857	2026-07-29 08:03:07.619857	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
5c98661a-234d-4a57-a8a3-c8c27c82755f	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	b5b2da31-a71d-41f3-b51c-ec70f8156b15	\N	t	2026-07-29 08:07:35.940816	2026-07-29 08:07:35.940816	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
490cc342-0e08-447b-b84e-32dc44758221	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	a9e5e2b2-954f-4bff-bfd1-c3e36fe1173c	\N	t	2026-07-29 08:07:35.943423	2026-07-29 08:07:35.943423	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
0d212a9e-709f-456e-b980-6a2c8c48e252	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0f62abdc-4e3c-43af-b886-b2c2eae9be23	\N	4b8ab68f-4ded-46c0-b828-3c233c949b44	\N	t	2026-07-29 08:07:35.944491	2026-07-29 08:07:35.944491	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
5236131b-95df-43b9-9393-b79f254d8821	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	b5b2da31-a71d-41f3-b51c-ec70f8156b15	\N	t	2026-07-29 08:07:35.945338	2026-07-29 08:07:35.945338	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
7edc010a-8b3d-48db-86a6-de29539d5fd2	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	a9e5e2b2-954f-4bff-bfd1-c3e36fe1173c	\N	t	2026-07-29 08:07:35.946215	2026-07-29 08:07:35.946215	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
eff0b545-aebd-4d79-aada-8d241a5e5b98	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	74024da4-a6c7-4014-b91b-619264dfe51d	\N	t	2026-07-29 08:10:21.473816	2026-07-29 08:10:21.473816	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
215e19ee-d8f4-4310-8d96-2967f8377336	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	1c91e537-df4f-434c-b104-96ccf1133644	\N	t	2026-07-29 08:10:21.476331	2026-07-29 08:10:21.476331	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
3c45ed34-142e-47a7-abd3-251039bf157f	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0f62abdc-4e3c-43af-b886-b2c2eae9be23	\N	5491af67-54db-47d5-b1d7-4dcbc90d73cc	\N	t	2026-07-29 08:10:21.478193	2026-07-29 08:10:21.478193	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
93a0bd56-b68e-4fe1-9045-25699ce0eecd	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	74024da4-a6c7-4014-b91b-619264dfe51d	\N	t	2026-07-29 08:10:21.479013	2026-07-29 08:10:21.479013	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
d59d237c-09af-4180-8ce6-8dced7c0f645	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	1c91e537-df4f-434c-b104-96ccf1133644	\N	t	2026-07-29 08:10:21.479898	2026-07-29 08:10:21.479898	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
5a3e5993-db39-446b-ac71-19865b381b34	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	e63526fd-e38f-4978-96b2-78e6d83ff14c	\N	t	2026-07-29 08:13:23.911846	2026-07-29 08:13:23.911846	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
291bea7e-7357-4272-8faa-07458501e6f0	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	95d08220-459f-4a04-b071-33ed8b7537e1	\N	t	2026-07-29 08:13:23.914755	2026-07-29 08:13:23.914755	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
d595d83c-327f-462e-8475-6cd8949e25b5	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0f62abdc-4e3c-43af-b886-b2c2eae9be23	\N	3da3cb12-ea85-45d9-81ac-1f42bb98adb9	\N	t	2026-07-29 08:13:23.915845	2026-07-29 08:13:23.915845	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
a4909023-ce00-4741-9a60-ac1f784f8333	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	e63526fd-e38f-4978-96b2-78e6d83ff14c	\N	t	2026-07-29 08:13:23.916873	2026-07-29 08:13:23.916873	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
077bf6c7-238d-4a8a-84a8-5a68132c25f0	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	95d08220-459f-4a04-b071-33ed8b7537e1	\N	t	2026-07-29 08:13:23.917803	2026-07-29 08:13:23.917803	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
728b8687-837d-4097-a082-284ca36e97b1	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	032e0113-ea5e-40d3-b8c4-fc3fe3c90b59	\N	t	2026-07-29 08:13:58.816421	2026-07-29 08:13:58.816421	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
f8c7423d-1c3d-4650-b159-e2a7022124c9	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	ffdf5d95-981e-4dc9-b613-2b836222c90b	\N	t	2026-07-29 08:13:58.819515	2026-07-29 08:13:58.819515	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
8d2e0c80-79d9-4681-8f14-7bfc35769d0c	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0f62abdc-4e3c-43af-b886-b2c2eae9be23	\N	6118dbaf-c427-4a4f-bc12-4d135664488c	\N	t	2026-07-29 08:13:58.820487	2026-07-29 08:13:58.820487	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
52ad144b-f992-4029-aa8b-70e2f8b14b0b	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	032e0113-ea5e-40d3-b8c4-fc3fe3c90b59	\N	t	2026-07-29 08:13:58.821386	2026-07-29 08:13:58.821386	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
9943b248-57dd-4fbb-bc7c-d4ecddf7b4e8	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	ffdf5d95-981e-4dc9-b613-2b836222c90b	\N	t	2026-07-29 08:13:58.822869	2026-07-29 08:13:58.822869	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
1895e0b2-b75c-4bd6-b31f-e8bb27aba5e7	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	0409c7e1-540f-4d86-b47e-88324b77053d	\N	t	2026-07-29 08:19:31.871603	2026-07-29 08:19:31.871603	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
3d377b9f-2459-4cf3-a1aa-3d92e0d951e0	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	d8d9c3e3-3403-4df4-b67c-3bee8b97b3b4	\N	t	2026-07-29 08:19:31.877557	2026-07-29 08:19:31.877557	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
1d3fb9f8-6e21-4c41-8111-87622e356ae7	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0f62abdc-4e3c-43af-b886-b2c2eae9be23	\N	49790d2d-5d8c-415b-9ae0-3fcc14714393	\N	t	2026-07-29 08:19:31.878701	2026-07-29 08:19:31.878701	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
dacbbae9-de2f-407e-96bf-bb350e430e4c	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	0409c7e1-540f-4d86-b47e-88324b77053d	\N	t	2026-07-29 08:19:31.87999	2026-07-29 08:19:31.87999	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
de83304a-7f33-4429-b30a-48a08c9ea201	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	d8d9c3e3-3403-4df4-b67c-3bee8b97b3b4	\N	t	2026-07-29 08:19:31.881122	2026-07-29 08:19:31.881122	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
1ec1a9af-888c-4a17-91b5-0b7d875f1216	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	631be798-6e98-4ddb-b262-91beddffc9fa	\N	t	2026-07-29 08:21:01.191043	2026-07-29 08:21:01.191043	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
ec240c6c-60b4-4e4d-9182-3d886ad8402e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	5a39bc91-cb14-49a8-a4ca-7f743c4319d6	\N	t	2026-07-29 08:21:01.196875	2026-07-29 08:21:01.196875	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
44cf2bbe-ca40-4f8e-ba59-a1bc5e930f9b	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0f62abdc-4e3c-43af-b886-b2c2eae9be23	\N	68a60d10-e48d-400e-8261-3dfc87e7a99f	\N	t	2026-07-29 08:21:01.198073	2026-07-29 08:21:01.198073	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
cacdcbcd-714f-4ea0-9c1c-0bc0e21a9252	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	631be798-6e98-4ddb-b262-91beddffc9fa	\N	t	2026-07-29 08:21:01.199184	2026-07-29 08:21:01.199184	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
1b705931-3def-4c9a-b029-d0117653ba63	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	5a39bc91-cb14-49a8-a4ca-7f743c4319d6	\N	t	2026-07-29 08:21:01.200322	2026-07-29 08:21:01.200322	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
6b3bd9a6-801b-43c8-b4f7-0cd3de6eb584	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	e36012f4-89c7-473e-bb8f-fc6c5556c909	\N	t	2026-07-29 11:48:20.775169	2026-07-29 11:48:20.775169	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
ce0ab51a-6e35-4fb7-a8ae-89cb97aa65ed	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	8de77f59-bf94-49ec-b1cc-4c1850550ed7	\N	t	2026-07-29 11:48:20.778712	2026-07-29 11:48:20.778712	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
1e0e367f-a4b9-4dbd-a61a-2a4c3a26e7c2	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0f62abdc-4e3c-43af-b886-b2c2eae9be23	\N	05fcfe03-c04a-4e00-8dde-247ae3b20d00	\N	t	2026-07-29 11:48:20.78041	2026-07-29 11:48:20.78041	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
8c19b56f-20c4-401e-a13a-b6049e98caa1	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	e36012f4-89c7-473e-bb8f-fc6c5556c909	\N	t	2026-07-29 11:48:20.781278	2026-07-29 11:48:20.781278	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
7515fa5c-f491-4c5e-983a-6fc4440dfaf1	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	8de77f59-bf94-49ec-b1cc-4c1850550ed7	\N	t	2026-07-29 11:48:20.782171	2026-07-29 11:48:20.782171	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
d3e48b59-cd39-4642-a043-c3ba5d7ec615	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	24fb3bc9-4eed-4116-8f70-395029798c46	\N	t	2026-07-29 12:16:02.977731	2026-07-29 12:16:02.977731	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
96a5ca6d-8151-468e-9b0f-65390e26cade	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0e23990b-31a0-4ac2-be89-a46ebc8200d4	\N	08d8d7d8-b21e-4f81-8fe5-647f38f67f90	\N	t	2026-07-29 12:16:02.980551	2026-07-29 12:16:02.980551	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
72391bc3-a924-47a9-801c-5fb62cc99e01	598a895e-5a20-48cc-95bd-a52fe5d4bb65	0f62abdc-4e3c-43af-b886-b2c2eae9be23	\N	d465de24-491e-4f85-bcfd-ab70f8878c73	\N	t	2026-07-29 12:16:02.981949	2026-07-29 12:16:02.981949	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
3ee50863-85cd-472b-85db-93a6151b987e	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	24fb3bc9-4eed-4116-8f70-395029798c46	\N	t	2026-07-29 12:16:02.98343	2026-07-29 12:16:02.98343	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
b716a391-4b00-4a1f-932d-2095e921c5dd	598a895e-5a20-48cc-95bd-a52fe5d4bb65	c03038c6-42a2-405d-845f-468829103d8f	\N	08d8d7d8-b21e-4f81-8fe5-647f38f67f90	\N	t	2026-07-29 12:16:02.984719	2026-07-29 12:16:02.984719	\N	3b703dae-2955-40a1-affa-f94478da505f	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: main; Owner: -
--

COPY main.users (id, tenant_id, email, password_hash, role, status, full_name, first_name, last_name, phone_number, department, job_title, avatar_url, last_login_at, login_count, failed_login_attempts, locked_until, password_changed_at, must_change_password, refresh_token, email_verified, email_verification_token, email_verification_expires, password_reset_token, password_reset_expires, preferences, permissions, created_at, updated_at, deleted_at, created_by, updated_by) FROM stdin;
0e23990b-31a0-4ac2-be89-a46ebc8200d4	598a895e-5a20-48cc-95bd-a52fe5d4bb65	category.manager@wella.com	$2b$10$a8u3BvpX2iBQ6xTLPsUC9uRX0mY58qY5OA5AUomBxGYNr8y4f98u2	CATEGORY_MANAGER	ACTIVE	Mike Category Manager	Mike	Category Manager	\N	Sales	Category Manager	\N	2026-08-12 09:45:07.834	3357	0	\N	\N	f	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIwZTIzOTkwYi0zMWEwLTRhYzItYmU4OS1hNDZlYmM4MjAwZDQiLCJlbWFpbCI6ImNhdGVnb3J5Lm1hbmFnZXJAd2VsbGEuY29tIiwicm9sZSI6IkNBVEVHT1JZX01BTkFHRVIiLCJ0ZW5hbnRJZCI6IjU5OGE4OTVlLTVhMjAtNDhjYy05NWJkLWE1MmZlNWQ0YmI2NSIsImlhdCI6MTc4NjUxNzEwNywiZXhwIjoxNzg3MTIxOTA3fQ.AFL4juNF_TVZZepXWYDlTdc2hlb78BUda1T8FVP2gK8	t	\N	\N	\N	\N	\N	\N	2026-06-17 18:47:53.474558	2026-08-12 06:45:07.835494	\N	\N	\N
699cc16e-f082-4d28-97a3-c4f12ecfddc6	598a895e-5a20-48cc-95bd-a52fe5d4bb65	planner2@wella.com	$2b$10$LSQrhJKNcY2xShgWfoOvQe28Iao/oS7N1XLaEtLEhlDigtQkKDv5W	PLANNER	ACTIVE	Deniz Planner Two	Deniz	Planner Two	\N	Sales	Trade Planner	\N	2026-08-10 15:13:49.461	589	0	\N	\N	f	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2OTljYzE2ZS1mMDgyLTRkMjgtOTdhMy1jNGYxMmVjZmRkYzYiLCJlbWFpbCI6InBsYW5uZXIyQHdlbGxhLmNvbSIsInJvbGUiOiJQTEFOTkVSIiwidGVuYW50SWQiOiI1OThhODk1ZS01YTIwLTQ4Y2MtOTViZC1hNTJmZTVkNGJiNjUiLCJpYXQiOjE3ODYzNjQwMjksImV4cCI6MTc4Njk2ODgyOX0.hdDaQhNESuVWxJvDHDWroYl7KCnJwldJv4dPQafvPl4	t	\N	\N	\N	\N	\N	\N	2026-07-27 22:05:28.231519	2026-08-10 12:13:49.462891	\N	\N	\N
0f62abdc-4e3c-43af-b886-b2c2eae9be23	598a895e-5a20-48cc-95bd-a52fe5d4bb65	category.manager2@wella.com	$2b$10$HuXFCQzMq9I.XXL/xmCTAua6z4Y5y0SgYfTl43ficcNh/bop9WBb2	CATEGORY_MANAGER	ACTIVE	Ayşe Category Manager Two	Ayşe	Category Manager Two	\N	Sales	Category Manager	\N	2026-08-10 15:13:51.582	589	0	\N	\N	f	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIwZjYyYWJkYy00ZTNjLTQzYWYtYjg4Ni1iMmMyZWFlOWJlMjMiLCJlbWFpbCI6ImNhdGVnb3J5Lm1hbmFnZXIyQHdlbGxhLmNvbSIsInJvbGUiOiJDQVRFR09SWV9NQU5BR0VSIiwidGVuYW50SWQiOiI1OThhODk1ZS01YTIwLTQ4Y2MtOTViZC1hNTJmZTVkNGJiNjUiLCJpYXQiOjE3ODYzNjQwMzEsImV4cCI6MTc4Njk2ODgzMX0.e08RiNf3j2Ni-oBCY79EQbKTCHFNMKuloSlqwt0JzV0	t	\N	\N	\N	\N	\N	\N	2026-07-27 22:05:28.287244	2026-08-10 12:13:51.583287	\N	\N	\N
c03038c6-42a2-405d-845f-468829103d8f	598a895e-5a20-48cc-95bd-a52fe5d4bb65	manager@wella.com	$2b$10$pTp6EdD4a3LfWspfHYx.LO.ACLWxQL0hglXzXdrbeM.l..Aeq9DiW	CATEGORY_MANAGER	ACTIVE	Jane Manager	Jane	Manager	\N	Sales	Sales Manager	\N	2026-08-11 01:48:11.497	1794	0	\N	\N	f	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJjMDMwMzhjNi00MmEyLTQwNWQtODQ1Zi00Njg4MjkxMDNkOGYiLCJlbWFpbCI6Im1hbmFnZXJAd2VsbGEuY29tIiwicm9sZSI6IkNBVEVHT1JZX01BTkFHRVIiLCJ0ZW5hbnRJZCI6IjU5OGE4OTVlLTVhMjAtNDhjYy05NWJkLWE1MmZlNWQ0YmI2NSIsImlhdCI6MTc4NjUxNjgwMywiZXhwIjoxNzg3MTIxNjAzfQ.HFUYjPFc9xkzvfHsnxCZClJbD2kUrrTTZ3_YqU3m_Yw	t	\N	\N	\N	\N	\N	\N	2026-06-17 18:47:53.459115	2026-08-12 06:40:03.701665	\N	\N	\N
3b703dae-2955-40a1-affa-f94478da505f	598a895e-5a20-48cc-95bd-a52fe5d4bb65	admin@wella.com	$2b$10$53iEUedKST2H0dmaMAVYv.mI3WBcQjDGLaMTPx5rDCAr/RlNFO2FS	ADMIN	ACTIVE	System Admin	System	Admin	\N	IT	System Administrator	\N	2026-08-12 09:43:33.086	7441	0	\N	\N	f	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIzYjcwM2RhZS0yOTU1LTQwYTEtYWZmYS1mOTQ0NzhkYTUwNWYiLCJlbWFpbCI6ImFkbWluQHdlbGxhLmNvbSIsInJvbGUiOiJBRE1JTiIsInRlbmFudElkIjoiNTk4YTg5NWUtNWEyMC00OGNjLTk1YmQtYTUyZmU1ZDRiYjY1IiwiaWF0IjoxNzg2NTE3MDEzLCJleHAiOjE3ODcxMjE4MTN9.n0hL2T4FRj63n1HA4P1xUacPM6ry5VxSwEKHTPBBJsQ	t	\N	\N	\N	\N	\N	\N	2026-06-17 18:47:53.428639	2026-08-12 06:43:33.086911	\N	\N	\N
67b863d1-1a98-464d-af7b-df0b219748ae	598a895e-5a20-48cc-95bd-a52fe5d4bb65	planner@wella.com	$2b$10$sfV6P.s14zvgG7qqYpwufubJ4ai9KTCmeHAQlJtVStdrhsMKnIXGe	PLANNER	ACTIVE	John Planner	John	Planner	\N	Sales	Trade Planner	\N	2026-08-12 09:44:52.312	6386	0	\N	\N	f	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2N2I4NjNkMS0xYTk4LTQ2NGQtYWY3Yi1kZjBiMjE5NzQ4YWUiLCJlbWFpbCI6InBsYW5uZXJAd2VsbGEuY29tIiwicm9sZSI6IlBMQU5ORVIiLCJ0ZW5hbnRJZCI6IjU5OGE4OTVlLTVhMjAtNDhjYy05NWJkLWE1MmZlNWQ0YmI2NSIsImlhdCI6MTc4NjUxNzA5MiwiZXhwIjoxNzg3MTIxODkyfQ.mo9FffqqG8p2fZSFRvxuK5Ft2wzgNWOcOCG67QgvRck	t	\N	\N	\N	\N	\N	\N	2026-06-17 18:47:53.450136	2026-08-12 06:44:52.319353	\N	\N	\N
2929c86e-4321-4a31-a12c-8510ea1cec23	598a895e-5a20-48cc-95bd-a52fe5d4bb65	finance.manager@wella.com	$2b$10$V4AFidbfuka/bxObTXPU6ON5igb5JD149qagZzg.K9dewRRMSyJCm	FINANCE_MANAGER	ACTIVE	Sarah Finance Manager	Sarah	Finance Manager	\N	Finance	Finance Manager	\N	2026-08-12 09:49:19.898	3046	0	\N	\N	f	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyOTI5Yzg2ZS00MzIxLTRhMzEtYTEyYy04NTEwZWExY2VjMjMiLCJlbWFpbCI6ImZpbmFuY2UubWFuYWdlckB3ZWxsYS5jb20iLCJyb2xlIjoiRklOQU5DRV9NQU5BR0VSIiwidGVuYW50SWQiOiI1OThhODk1ZS01YTIwLTQ4Y2MtOTViZC1hNTJmZTVkNGJiNjUiLCJpYXQiOjE3ODY1MTczNTksImV4cCI6MTc4NzEyMjE1OX0.i--lVlXAgZgvq2EgDNimepklDzyeD0YO3F93aorMCQ4	t	\N	\N	\N	\N	\N	\N	2026-06-17 18:47:53.470831	2026-08-12 06:49:19.896317	\N	\N	\N
88e70c08-2113-4d37-b8d9-b29269532fe2	598a895e-5a20-48cc-95bd-a52fe5d4bb65	finance@wella.com	$2b$10$21dBPfJy3KqHXTWSf9JrEeqaJun2fZtbtj9U3vC16vQdSJQ7qQ0VW	FINANCE_MANAGER	ACTIVE	Bob Finance	Bob	Finance	\N	Finance	Finance Analyst	\N	2026-08-10 15:14:13.016	3067	0	\N	\N	f	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI4OGU3MGMwOC0yMTEzLTRkMzctYjhkOS1iMjkyNjk1MzJmZTIiLCJlbWFpbCI6ImZpbmFuY2VAd2VsbGEuY29tIiwicm9sZSI6IkZJTkFOQ0VfTUFOQUdFUiIsInRlbmFudElkIjoiNTk4YTg5NWUtNWEyMC00OGNjLTk1YmQtYTUyZmU1ZDRiYjY1IiwiaWF0IjoxNzg2MzY0MDUzLCJleHAiOjE3ODY5Njg4NTN9.dpzdp7FnlY3x0T2ZK_l1tGJTyrGKDWsDO-sixBS2Pac	t	\N	\N	\N	\N	\N	\N	2026-06-17 18:47:53.465687	2026-08-10 12:14:13.018889	\N	\N	\N
a1b6b8f5-e03b-4d53-bbca-a274d8ff8cd5	598a895e-5a20-48cc-95bd-a52fe5d4bb65	readonly@wella.com	$2b$10$rPcHjTo9ARwT8wMlrXFjM.XBBZIV8dlE8eHQjZq8PDgtYbn2sKb0.	READONLY	ACTIVE	Read Only User	Read	Only	\N	Audit	Auditor	\N	2026-08-10 15:14:12.913	2193	0	\N	\N	f	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhMWI2YjhmNS1lMDNiLTRkNTMtYmJjYS1hMjc0ZDhmZjhjZDUiLCJlbWFpbCI6InJlYWRvbmx5QHdlbGxhLmNvbSIsInJvbGUiOiJSRUFET05MWSIsInRlbmFudElkIjoiNTk4YTg5NWUtNWEyMC00OGNjLTk1YmQtYTUyZmU1ZDRiYjY1IiwiaWF0IjoxNzg2MzY0MDUyLCJleHAiOjE3ODY5Njg4NTJ9.ROK2aasCYZ7wTSAngPcP2aLazfK1ANT5-T772hppLwU	t	\N	\N	\N	\N	\N	\N	2026-06-17 18:47:53.481074	2026-08-10 12:14:12.915901	\N	\N	\N
\.


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: main; Owner: -
--

SELECT pg_catalog.setval('main.migrations_id_seq', 206, true);


--
-- Name: agreements PK_01532f6c999d44c776e3d1fa4c8; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.agreements
    ADD CONSTRAINT "PK_01532f6c999d44c776e3d1fa4c8" PRIMARY KEY (id);


--
-- Name: customers PK_133ec679a801fab5e070f73d3ea; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.customers
    ADD CONSTRAINT "PK_133ec679a801fab5e070f73d3ea" PRIMARY KEY (id);


--
-- Name: plan_approval_history PK_1b6e17180651502ba08d0a20501; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plan_approval_history
    ADD CONSTRAINT "PK_1b6e17180651502ba08d0a20501" PRIMARY KEY (id);


--
-- Name: agreement_transactions PK_1f52c50599e8f795511edefa31f; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.agreement_transactions
    ADD CONSTRAINT "PK_1f52c50599e8f795511edefa31f" PRIMARY KEY (id);


--
-- Name: categories PK_24dbc6126a28ff948da33e97d3b; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.categories
    ADD CONSTRAINT "PK_24dbc6126a28ff948da33e97d3b" PRIMARY KEY (id);


--
-- Name: lta_plan_overrides PK_25cb9bbc6d933b60097c459c179; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.lta_plan_overrides
    ADD CONSTRAINT "PK_25cb9bbc6d933b60097c459c179" PRIMARY KEY (id);


--
-- Name: mechanics PK_2c0ed23afc0cc7ff361c17e53df; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.mechanics
    ADD CONSTRAINT "PK_2c0ed23afc0cc7ff361c17e53df" PRIMARY KEY (id);


--
-- Name: generic_units PK_2d4215283da341be556b1660aab; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.generic_units
    ADD CONSTRAINT "PK_2d4215283da341be556b1660aab" PRIMARY KEY (id);


--
-- Name: budget_transactions PK_31ac84aae9de19608a7d00b9bc5; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.budget_transactions
    ADD CONSTRAINT "PK_31ac84aae9de19608a7d00b9bc5" PRIMARY KEY (id);


--
-- Name: skus PK_334d59b0b01e5f2193966266e27; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.skus
    ADD CONSTRAINT "PK_334d59b0b01e5f2193966266e27" PRIMARY KEY (id);


--
-- Name: budget_reservations PK_338ece04adbaedea1b64e01994f; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.budget_reservations
    ADD CONSTRAINT "PK_338ece04adbaedea1b64e01994f" PRIMARY KEY (id);


--
-- Name: plans PK_3720521a81c7c24fe9b7202ba61; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plans
    ADD CONSTRAINT "PK_3720521a81c7c24fe9b7202ba61" PRIMARY KEY (id);


--
-- Name: approval_requests PK_484806bb8ff331b851fc75973c0; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.approval_requests
    ADD CONSTRAINT "PK_484806bb8ff331b851fc75973c0" PRIMARY KEY (id);


--
-- Name: lta_rates PK_4a75eb6c5c975b5bc88a93e2e2d; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.lta_rates
    ADD CONSTRAINT "PK_4a75eb6c5c975b5bc88a93e2e2d" PRIMARY KEY (id);


--
-- Name: regions PK_4fcd12ed6a046276e2deb08801c; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.regions
    ADD CONSTRAINT "PK_4fcd12ed6a046276e2deb08801c" PRIMARY KEY (id);


--
-- Name: tenants PK_53be67a04681c66b87ee27c9321; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.tenants
    ADD CONSTRAINT "PK_53be67a04681c66b87ee27c9321" PRIMARY KEY (id);


--
-- Name: notifications PK_6a72c3c0f683f6462415e653c3a; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.notifications
    ADD CONSTRAINT "PK_6a72c3c0f683f6462415e653c3a" PRIMARY KEY (id);


--
-- Name: forecasting_units PK_6b4ac195f7d9b14a335f2425691; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.forecasting_units
    ADD CONSTRAINT "PK_6b4ac195f7d9b14a335f2425691" PRIMARY KEY (id);


--
-- Name: ledger_entries PK_6efcb84411d3f08b08450ae75d5; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.ledger_entries
    ADD CONSTRAINT "PK_6efcb84411d3f08b08450ae75d5" PRIMARY KEY (id);


--
-- Name: plan_skus PK_77cd1cd0c168e01b9d42d965197; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plan_skus
    ADD CONSTRAINT "PK_77cd1cd0c168e01b9d42d965197" PRIMARY KEY (id);


--
-- Name: tactics PK_7973d1467789e279b50cc8466fe; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.tactics
    ADD CONSTRAINT "PK_7973d1467789e279b50cc8466fe" PRIMARY KEY (id);


--
-- Name: sales_actuals PK_798a6becccc05795ffb7bb8fdc1; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.sales_actuals
    ADD CONSTRAINT "PK_798a6becccc05795ffb7bb8fdc1" PRIMARY KEY (id);


--
-- Name: budget_alert_configurations PK_7d46ea410fc477d70b05a289177; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.budget_alert_configurations
    ADD CONSTRAINT "PK_7d46ea410fc477d70b05a289177" PRIMARY KEY (id);


--
-- Name: mechanic_spend_breakdown PK_82d2464a33f9fb05a537d0de618; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.mechanic_spend_breakdown
    ADD CONSTRAINT "PK_82d2464a33f9fb05a537d0de618" PRIMARY KEY (id);


--
-- Name: migrations PK_8c82d7f526340ab734260ea46be; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.migrations
    ADD CONSTRAINT "PK_8c82d7f526340ab734260ea46be" PRIMARY KEY (id);


--
-- Name: cpls PK_8de97b8ddcc9bb59f6bc4f9a7d0; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.cpls
    ADD CONSTRAINT "PK_8de97b8ddcc9bb59f6bc4f9a7d0" PRIMARY KEY (id);


--
-- Name: plan_mechanic_values PK_8fe2b07b74a415362ba5d5744cb; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plan_mechanic_values
    ADD CONSTRAINT "PK_8fe2b07b74a415362ba5d5744cb" PRIMARY KEY (id);


--
-- Name: budget_allocations PK_933f4bf5c342928196cc20be363; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.budget_allocations
    ADD CONSTRAINT "PK_933f4bf5c342928196cc20be363" PRIMARY KEY (id);


--
-- Name: kpis PK_96cc541107cdc102a50e2b0ac90; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.kpis
    ADD CONSTRAINT "PK_96cc541107cdc102a50e2b0ac90" PRIMARY KEY (id);


--
-- Name: budget_envelopes PK_a02301e8dc843258d20721374d3; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.budget_envelopes
    ADD CONSTRAINT "PK_a02301e8dc843258d20721374d3" PRIMARY KEY (id);


--
-- Name: users PK_a3ffb1c0c8416b9fc6f907b7433; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.users
    ADD CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY (id);


--
-- Name: brands PK_b0c437120b624da1034a81fc561; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.brands
    ADD CONSTRAINT "PK_b0c437120b624da1034a81fc561" PRIMARY KEY (id);


--
-- Name: plan_fus PK_b112f4bcaf44f85f6f4eb98942b; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plan_fus
    ADD CONSTRAINT "PK_b112f4bcaf44f85f6f4eb98942b" PRIMARY KEY (id);


--
-- Name: on_invoice_entries PK_b92c0aef42d5be9bbaf40c180f0; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.on_invoice_entries
    ADD CONSTRAINT "PK_b92c0aef42d5be9bbaf40c180f0" PRIMARY KEY (id);


--
-- Name: budget_transaction_logs PK_bc431af68c3b46ed037d6fea8f5; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.budget_transaction_logs
    ADD CONSTRAINT "PK_bc431af68c3b46ed037d6fea8f5" PRIMARY KEY (id);


--
-- Name: channels PK_bc603823f3f741359c2339389f9; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.channels
    ADD CONSTRAINT "PK_bc603823f3f741359c2339389f9" PRIMARY KEY (id);


--
-- Name: sales_actual_batches PK_bdbb9225c02b10f3648fef31714; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.sales_actual_batches
    ADD CONSTRAINT "PK_bdbb9225c02b10f3648fef31714" PRIMARY KEY (id);


--
-- Name: lta_agreements PK_c3ee304ede06f7d3385be9f9246; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.lta_agreements
    ADD CONSTRAINT "PK_c3ee304ede06f7d3385be9f9246" PRIMARY KEY (id);


--
-- Name: admin_audit_logs PK_de7a8fc2fbb525484c71a86bb96; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.admin_audit_logs
    ADD CONSTRAINT "PK_de7a8fc2fbb525484c71a86bb96" PRIMARY KEY (id);


--
-- Name: on_invoice_batches PK_e2ea03257ff3b952917f742224b; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.on_invoice_batches
    ADD CONSTRAINT "PK_e2ea03257ff3b952917f742224b" PRIMARY KEY (id);


--
-- Name: user_scopes PK_user_scopes; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.user_scopes
    ADD CONSTRAINT "PK_user_scopes" PRIMARY KEY (id);


--
-- Name: tenants UQ_32731f181236a46182a38c992a8; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.tenants
    ADD CONSTRAINT "UQ_32731f181236a46182a38c992a8" UNIQUE (name);


--
-- Name: tenants UQ_da4054294eaae43ec7f85b6a3a1; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.tenants
    ADD CONSTRAINT "UQ_da4054294eaae43ec7f85b6a3a1" UNIQUE (domain);


--
-- Name: _t019_backfilled_tx _t019_backfilled_tx_pkey; Type: CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main._t019_backfilled_tx
    ADD CONSTRAINT _t019_backfilled_tx_pkey PRIMARY KEY (tx_id);


--
-- Name: IDX_ADMIN_AUDIT_LOGS_ENTITY; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_ADMIN_AUDIT_LOGS_ENTITY" ON main.admin_audit_logs USING btree (entity_type, entity_id);


--
-- Name: IDX_ADMIN_AUDIT_LOGS_HIGH_RISK; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_ADMIN_AUDIT_LOGS_HIGH_RISK" ON main.admin_audit_logs USING btree (is_high_risk, created_at);


--
-- Name: IDX_ADMIN_AUDIT_LOGS_TENANT_ADMIN; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_ADMIN_AUDIT_LOGS_TENANT_ADMIN" ON main.admin_audit_logs USING btree (tenant_id, admin_id);


--
-- Name: IDX_ADMIN_AUDIT_LOGS_TENANT_CREATED; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_ADMIN_AUDIT_LOGS_TENANT_CREATED" ON main.admin_audit_logs USING btree (tenant_id, created_at);


--
-- Name: IDX_AGREEMENTS_APPROVAL_REQUEST_ID; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_AGREEMENTS_APPROVAL_REQUEST_ID" ON main.agreements USING btree (approval_request_id) WHERE (approval_request_id IS NOT NULL);


--
-- Name: IDX_AGREEMENTS_CPL_ID; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_AGREEMENTS_CPL_ID" ON main.agreements USING btree (cpl_id);


--
-- Name: IDX_AGREEMENTS_PERIOD_MONTH; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_AGREEMENTS_PERIOD_MONTH" ON main.agreements USING btree (period_month);


--
-- Name: IDX_AGREEMENTS_STATUS; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_AGREEMENTS_STATUS" ON main.agreements USING btree (status);


--
-- Name: IDX_AGREEMENTS_TENANT_CODE; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_AGREEMENTS_TENANT_CODE" ON main.agreements USING btree (tenant_id, agreement_code);


--
-- Name: IDX_AGREEMENTS_TENANT_CPL_STATUS; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_AGREEMENTS_TENANT_CPL_STATUS" ON main.agreements USING btree (tenant_id, cpl_id, status);


--
-- Name: IDX_AGREEMENTS_TENANT_PERIOD_STATUS; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_AGREEMENTS_TENANT_PERIOD_STATUS" ON main.agreements USING btree (tenant_id, period_month, status);


--
-- Name: IDX_AGREEMENTS_TENANT_STATUS; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_AGREEMENTS_TENANT_STATUS" ON main.agreements USING btree (tenant_id, status);


--
-- Name: IDX_AGREEMENT_TRANSACTIONS_AGREEMENT_ID; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_AGREEMENT_TRANSACTIONS_AGREEMENT_ID" ON main.agreement_transactions USING btree (agreement_id);


--
-- Name: IDX_AGREEMENT_TRANSACTIONS_BATCH_ID; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_AGREEMENT_TRANSACTIONS_BATCH_ID" ON main.agreement_transactions USING btree (batch_id);


--
-- Name: IDX_AGREEMENT_TRANSACTIONS_INVOICE_DATE; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_AGREEMENT_TRANSACTIONS_INVOICE_DATE" ON main.agreement_transactions USING btree (invoice_date);


--
-- Name: IDX_AGREEMENT_TRANSACTIONS_TENANT_AGREEMENT; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_AGREEMENT_TRANSACTIONS_TENANT_AGREEMENT" ON main.agreement_transactions USING btree (tenant_id, agreement_id);


--
-- Name: IDX_AGREEMENT_TRANSACTIONS_TENANT_IDEMPOTENCY; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_AGREEMENT_TRANSACTIONS_TENANT_IDEMPOTENCY" ON main.agreement_transactions USING btree (tenant_id, idempotency_key);


--
-- Name: IDX_AGREEMENT_TRANSACTIONS_TENANT_INVOICE; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_AGREEMENT_TRANSACTIONS_TENANT_INVOICE" ON main.agreement_transactions USING btree (tenant_id, invoice_no, invoice_date);


--
-- Name: IDX_APPROVAL_REQUESTS_STATUS; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_APPROVAL_REQUESTS_STATUS" ON main.approval_requests USING btree (status);


--
-- Name: IDX_APPROVAL_REQUESTS_TENANT_ENTITY; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_APPROVAL_REQUESTS_TENANT_ENTITY" ON main.approval_requests USING btree (tenant_id, entity_type, entity_id);


--
-- Name: IDX_APPROVAL_REQUESTS_TENANT_REQUESTED_BY; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_APPROVAL_REQUESTS_TENANT_REQUESTED_BY" ON main.approval_requests USING btree (tenant_id, requested_by_id);


--
-- Name: IDX_APPROVAL_REQUESTS_TENANT_STATUS; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_APPROVAL_REQUESTS_TENANT_STATUS" ON main.approval_requests USING btree (tenant_id, status);


--
-- Name: IDX_BRANDS_TENANT_CODE; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_BRANDS_TENANT_CODE" ON main.brands USING btree (tenant_id, code);


--
-- Name: IDX_BUDGET_ENVELOPES_FISCAL_PERIOD; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_BUDGET_ENVELOPES_FISCAL_PERIOD" ON main.budget_envelopes USING btree (fiscal_year, period);


--
-- Name: IDX_BUDGET_ENVELOPES_TENANT_CODE; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_BUDGET_ENVELOPES_TENANT_CODE" ON main.budget_envelopes USING btree (tenant_id, code);


--
-- Name: IDX_BUDGET_ENVELOPES_TENANT_STATUS; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_BUDGET_ENVELOPES_TENANT_STATUS" ON main.budget_envelopes USING btree (tenant_id, status);


--
-- Name: IDX_BUDGET_RESERVATIONS_TENANT_AGREEMENT; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_BUDGET_RESERVATIONS_TENANT_AGREEMENT" ON main.budget_reservations USING btree (tenant_id, agreement_id);


--
-- Name: IDX_BUDGET_RESERVATIONS_TENANT_ENVELOPE; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_BUDGET_RESERVATIONS_TENANT_ENVELOPE" ON main.budget_reservations USING btree (tenant_id, envelope_id);


--
-- Name: IDX_BUDGET_RESERVATIONS_TENANT_STATUS; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_BUDGET_RESERVATIONS_TENANT_STATUS" ON main.budget_reservations USING btree (tenant_id, status);


--
-- Name: IDX_BUDGET_TRANSACTIONS_TENANT_ENVELOPE_TYPE; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_BUDGET_TRANSACTIONS_TENANT_ENVELOPE_TYPE" ON main.budget_transactions USING btree (tenant_id, envelope_id, tx_type);


--
-- Name: IDX_BUDGET_TRANSACTIONS_TENANT_IDEMPOTENCY; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_BUDGET_TRANSACTIONS_TENANT_IDEMPOTENCY" ON main.budget_transactions USING btree (tenant_id, idempotency_key);


--
-- Name: IDX_BUDGET_TRANSACTIONS_TENANT_SOURCE; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_BUDGET_TRANSACTIONS_TENANT_SOURCE" ON main.budget_transactions USING btree (tenant_id, source_type, source_id);


--
-- Name: IDX_BUDGET_TRANSACTIONS_TENANT_TYPE_STATUS; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_BUDGET_TRANSACTIONS_TENANT_TYPE_STATUS" ON main.budget_transactions USING btree (tenant_id, tx_type, tx_status);


--
-- Name: IDX_BUDGET_TRANSACTION_LOGS_TENANT_IDEMPOTENCY; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_BUDGET_TRANSACTION_LOGS_TENANT_IDEMPOTENCY" ON main.budget_transaction_logs USING btree (tenant_id, idempotency_key) WHERE (idempotency_key IS NOT NULL);


--
-- Name: IDX_CATEGORIES_PARENT; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_CATEGORIES_PARENT" ON main.categories USING btree (parent_category_id);


--
-- Name: IDX_CATEGORIES_TENANT_CODE; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_CATEGORIES_TENANT_CODE" ON main.categories USING btree (tenant_id, code);


--
-- Name: IDX_CHANNELS_TENANT_CODE; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_CHANNELS_TENANT_CODE" ON main.channels USING btree (tenant_id, code);


--
-- Name: IDX_CPLS_CHANNEL; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_CPLS_CHANNEL" ON main.cpls USING btree (channel_id);


--
-- Name: IDX_CPLS_TENANT_CODE; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_CPLS_TENANT_CODE" ON main.cpls USING btree (tenant_id, code);


--
-- Name: IDX_CUSTOMERS_CHANNEL; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_CUSTOMERS_CHANNEL" ON main.customers USING btree (channel);


--
-- Name: IDX_CUSTOMERS_CITY; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_CUSTOMERS_CITY" ON main.customers USING btree (city);


--
-- Name: IDX_CUSTOMERS_CPL; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_CUSTOMERS_CPL" ON main.customers USING btree (cpl_id);


--
-- Name: IDX_CUSTOMERS_IS_VIP; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_CUSTOMERS_IS_VIP" ON main.customers USING btree (is_vip);


--
-- Name: IDX_CUSTOMERS_TENANT_CODE; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_CUSTOMERS_TENANT_CODE" ON main.customers USING btree (tenant_id, code);


--
-- Name: IDX_CUSTOMERS_TENANT_ID; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_CUSTOMERS_TENANT_ID" ON main.customers USING btree (tenant_id);


--
-- Name: IDX_CUSTOMERS_TENANT_STATUS; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_CUSTOMERS_TENANT_STATUS" ON main.customers USING btree (tenant_id, status);


--
-- Name: IDX_FORECASTING_UNITS_GU; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_FORECASTING_UNITS_GU" ON main.forecasting_units USING btree (gu_id);


--
-- Name: IDX_FORECASTING_UNITS_TENANT_CODE; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_FORECASTING_UNITS_TENANT_CODE" ON main.forecasting_units USING btree (tenant_id, code);


--
-- Name: IDX_GENERIC_UNITS_BRAND; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_GENERIC_UNITS_BRAND" ON main.generic_units USING btree (brand_id);


--
-- Name: IDX_GENERIC_UNITS_CATEGORY; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_GENERIC_UNITS_CATEGORY" ON main.generic_units USING btree (category_id);


--
-- Name: IDX_GENERIC_UNITS_TENANT_CODE; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_GENERIC_UNITS_TENANT_CODE" ON main.generic_units USING btree (tenant_id, code);


--
-- Name: IDX_KPIS_CALCULATION_ORDER; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_KPIS_CALCULATION_ORDER" ON main.kpis USING btree (calculation_order);


--
-- Name: IDX_KPIS_GROUP; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_KPIS_GROUP" ON main.kpis USING btree (kpi_group);


--
-- Name: IDX_KPIS_TENANT_CODE; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_KPIS_TENANT_CODE" ON main.kpis USING btree (tenant_id, kpi_code);


--
-- Name: IDX_LEDGER_ENTRIES_TENANT_AGREEMENT; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_LEDGER_ENTRIES_TENANT_AGREEMENT" ON main.ledger_entries USING btree (tenant_id, agreement_id);


--
-- Name: IDX_LEDGER_ENTRIES_TENANT_ENVELOPE; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_LEDGER_ENTRIES_TENANT_ENVELOPE" ON main.ledger_entries USING btree (tenant_id, budget_envelope_id);


--
-- Name: IDX_LEDGER_ENTRIES_TENANT_IDEMPOTENCY; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_LEDGER_ENTRIES_TENANT_IDEMPOTENCY" ON main.ledger_entries USING btree (tenant_id, idempotency_key);


--
-- Name: IDX_LEDGER_ENTRIES_TENANT_PERIOD; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_LEDGER_ENTRIES_TENANT_PERIOD" ON main.ledger_entries USING btree (tenant_id, period_month);


--
-- Name: IDX_LEDGER_ENTRIES_TENANT_SPEND_TYPE; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_LEDGER_ENTRIES_TENANT_SPEND_TYPE" ON main.ledger_entries USING btree (tenant_id, spend_type);


--
-- Name: IDX_MECHANICS_TACTIC; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_MECHANICS_TACTIC" ON main.mechanics USING btree (tactic_id);


--
-- Name: IDX_MECHANICS_TENANT_CODE; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_MECHANICS_TENANT_CODE" ON main.mechanics USING btree (tenant_id, code);


--
-- Name: IDX_NOTIFICATIONS_TENANT_CREATED; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_NOTIFICATIONS_TENANT_CREATED" ON main.notifications USING btree (tenant_id, created_at);


--
-- Name: IDX_NOTIFICATIONS_TENANT_RECIPIENT; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_NOTIFICATIONS_TENANT_RECIPIENT" ON main.notifications USING btree (tenant_id, recipient_id);


--
-- Name: IDX_NOTIFICATIONS_TENANT_STATUS; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_NOTIFICATIONS_TENANT_STATUS" ON main.notifications USING btree (tenant_id, status);


--
-- Name: IDX_NOTIFICATIONS_TENANT_TYPE; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_NOTIFICATIONS_TENANT_TYPE" ON main.notifications USING btree (tenant_id, type);


--
-- Name: IDX_ON_INVOICE_BATCHES_TENANT_BATCH_CODE; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_ON_INVOICE_BATCHES_TENANT_BATCH_CODE" ON main.on_invoice_batches USING btree (tenant_id, batch_code);


--
-- Name: IDX_ON_INVOICE_BATCHES_TENANT_FISCAL_PERIOD; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_ON_INVOICE_BATCHES_TENANT_FISCAL_PERIOD" ON main.on_invoice_batches USING btree (tenant_id, fiscal_period);


--
-- Name: IDX_ON_INVOICE_BATCHES_TENANT_STATUS; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_ON_INVOICE_BATCHES_TENANT_STATUS" ON main.on_invoice_batches USING btree (tenant_id, status);


--
-- Name: IDX_ON_INVOICE_ENTRIES_TENANT_BATCH_ID; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_ON_INVOICE_ENTRIES_TENANT_BATCH_ID" ON main.on_invoice_entries USING btree (tenant_id, batch_id);


--
-- Name: IDX_ON_INVOICE_ENTRIES_TENANT_CUSTOMER_ID; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_ON_INVOICE_ENTRIES_TENANT_CUSTOMER_ID" ON main.on_invoice_entries USING btree (tenant_id, customer_id);


--
-- Name: IDX_ON_INVOICE_ENTRIES_TENANT_DISCOUNT_TYPE; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_ON_INVOICE_ENTRIES_TENANT_DISCOUNT_TYPE" ON main.on_invoice_entries USING btree (tenant_id, discount_type);


--
-- Name: IDX_ON_INVOICE_ENTRIES_TENANT_FISCAL_PERIOD; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_ON_INVOICE_ENTRIES_TENANT_FISCAL_PERIOD" ON main.on_invoice_entries USING btree (tenant_id, fiscal_period);


--
-- Name: IDX_ON_INVOICE_ENTRIES_TENANT_IDEMPOTENCY; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_ON_INVOICE_ENTRIES_TENANT_IDEMPOTENCY" ON main.on_invoice_entries USING btree (tenant_id, idempotency_key);


--
-- Name: IDX_ON_INVOICE_ENTRIES_TENANT_INVOICE; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_ON_INVOICE_ENTRIES_TENANT_INVOICE" ON main.on_invoice_entries USING btree (tenant_id, invoice_no, invoice_date);


--
-- Name: IDX_ON_INVOICE_ENTRIES_TENANT_SKU_ID; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_ON_INVOICE_ENTRIES_TENANT_SKU_ID" ON main.on_invoice_entries USING btree (tenant_id, sku_id);


--
-- Name: IDX_REGIONS_PARENT; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_REGIONS_PARENT" ON main.regions USING btree (parent_region_id);


--
-- Name: IDX_REGIONS_TENANT_CODE; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_REGIONS_TENANT_CODE" ON main.regions USING btree (tenant_id, code);


--
-- Name: IDX_SKUS_FU; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_SKUS_FU" ON main.skus USING btree (fu_id);


--
-- Name: IDX_SKUS_GU; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_SKUS_GU" ON main.skus USING btree (gu_id);


--
-- Name: IDX_SKUS_TENANT_CODE; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_SKUS_TENANT_CODE" ON main.skus USING btree (tenant_id, code);


--
-- Name: IDX_TACTICS_TENANT_CODE; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_TACTICS_TENANT_CODE" ON main.tactics USING btree (tenant_id, code);


--
-- Name: IDX_TENANT_DOMAIN; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_TENANT_DOMAIN" ON main.tenants USING btree (domain) WHERE (domain IS NOT NULL);


--
-- Name: IDX_TENANT_STATUS; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_TENANT_STATUS" ON main.tenants USING btree (status);


--
-- Name: IDX_USERS_ROLE; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_USERS_ROLE" ON main.users USING btree (role);


--
-- Name: IDX_USERS_TENANT_EMAIL; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_USERS_TENANT_EMAIL" ON main.users USING btree (tenant_id, email);


--
-- Name: IDX_USERS_TENANT_ID; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_USERS_TENANT_ID" ON main.users USING btree (tenant_id);


--
-- Name: IDX_USERS_TENANT_STATUS; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_USERS_TENANT_STATUS" ON main.users USING btree (tenant_id, status);


--
-- Name: IDX_agreements_category_id; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_agreements_category_id" ON main.agreements USING btree (category_id);


--
-- Name: IDX_budget_alert_config_tenant_level; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_budget_alert_config_tenant_level" ON main.budget_alert_configurations USING btree (tenant_id, alert_level);


--
-- Name: IDX_budget_allocations_cpl; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_budget_allocations_cpl" ON main.budget_allocations USING btree (cpl_id);


--
-- Name: IDX_budget_allocations_period_dates; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_budget_allocations_period_dates" ON main.budget_allocations USING btree (period_start, period_end);


--
-- Name: IDX_budget_allocations_period_fiscal; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_budget_allocations_period_fiscal" ON main.budget_allocations USING btree (period_type, fiscal_year);


--
-- Name: IDX_budget_allocations_tenant_period; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_budget_allocations_tenant_period" ON main.budget_allocations USING btree (tenant_id, period_type, period_start, period_end, cpl_id, channel, category) WHERE (deleted_at IS NULL);


--
-- Name: IDX_budget_transaction_logs_allocation_created; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_budget_transaction_logs_allocation_created" ON main.budget_transaction_logs USING btree (budget_allocation_id, created_at);


--
-- Name: IDX_budget_transaction_logs_plan; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_budget_transaction_logs_plan" ON main.budget_transaction_logs USING btree (plan_id);


--
-- Name: IDX_budget_transaction_logs_type; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_budget_transaction_logs_type" ON main.budget_transaction_logs USING btree (transaction_type);


--
-- Name: IDX_lta_agreements_cpl_id; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_lta_agreements_cpl_id" ON main.lta_agreements USING btree (cpl_id);


--
-- Name: IDX_lta_agreements_cpl_status; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_lta_agreements_cpl_status" ON main.lta_agreements USING btree (cpl_id, status);


--
-- Name: IDX_lta_agreements_dates; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_lta_agreements_dates" ON main.lta_agreements USING btree (effective_date, expiry_date);


--
-- Name: IDX_lta_agreements_status; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_lta_agreements_status" ON main.lta_agreements USING btree (status);


--
-- Name: IDX_lta_agreements_tenant_code; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_lta_agreements_tenant_code" ON main.lta_agreements USING btree (tenant_id, agreement_code);


--
-- Name: IDX_lta_plan_overrides_lta_rate_id; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_lta_plan_overrides_lta_rate_id" ON main.lta_plan_overrides USING btree (lta_rate_id);


--
-- Name: IDX_lta_plan_overrides_plan_id; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_lta_plan_overrides_plan_id" ON main.lta_plan_overrides USING btree (plan_id);


--
-- Name: IDX_lta_plan_overrides_plan_rate; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_lta_plan_overrides_plan_rate" ON main.lta_plan_overrides USING btree (plan_id, lta_rate_id);


--
-- Name: IDX_lta_rates_agreement_channel_category; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_lta_rates_agreement_channel_category" ON main.lta_rates USING btree (lta_agreement_id, channel, category);


--
-- Name: IDX_lta_rates_agreement_id; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_lta_rates_agreement_id" ON main.lta_rates USING btree (lta_agreement_id);


--
-- Name: IDX_lta_rates_category_id; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_lta_rates_category_id" ON main.lta_rates USING btree (category_id);


--
-- Name: IDX_lta_rates_channel_id; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_lta_rates_channel_id" ON main.lta_rates USING btree (channel_id);


--
-- Name: IDX_mechanic_spend_breakdown_mechanic_id; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_mechanic_spend_breakdown_mechanic_id" ON main.mechanic_spend_breakdown USING btree (mechanic_id);


--
-- Name: IDX_mechanic_spend_breakdown_plan_mechanic_value_id; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_mechanic_spend_breakdown_plan_mechanic_value_id" ON main.mechanic_spend_breakdown USING btree (plan_mechanic_value_id);


--
-- Name: IDX_mechanic_spend_breakdown_plan_sku_id; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_mechanic_spend_breakdown_plan_sku_id" ON main.mechanic_spend_breakdown USING btree (plan_sku_id);


--
-- Name: IDX_mechanic_spend_breakdown_plan_sku_mechanic; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_mechanic_spend_breakdown_plan_sku_mechanic" ON main.mechanic_spend_breakdown USING btree (plan_sku_id, mechanic_id);


--
-- Name: IDX_plan_approval_history_plan_id_created_at; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_plan_approval_history_plan_id_created_at" ON main.plan_approval_history USING btree (plan_id, created_at);


--
-- Name: IDX_plan_approval_history_tenant_id_action; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_plan_approval_history_tenant_id_action" ON main.plan_approval_history USING btree (tenant_id, action);


--
-- Name: IDX_plan_fus_calculated_kpis; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_plan_fus_calculated_kpis" ON main.plan_fus USING gin (calculated_kpis);


--
-- Name: IDX_plan_fus_fu_id; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_plan_fus_fu_id" ON main.plan_fus USING btree (fu_id);


--
-- Name: IDX_plan_fus_plan_fu_unique; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_plan_fus_plan_fu_unique" ON main.plan_fus USING btree (plan_id, fu_id);


--
-- Name: IDX_plan_fus_plan_id; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_plan_fus_plan_id" ON main.plan_fus USING btree (plan_id);


--
-- Name: IDX_plan_mechanic_values_mechanic_id; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_plan_mechanic_values_mechanic_id" ON main.plan_mechanic_values USING btree (mechanic_id);


--
-- Name: IDX_plan_mechanic_values_plan_fu_id; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_plan_mechanic_values_plan_fu_id" ON main.plan_mechanic_values USING btree (plan_fu_id);


--
-- Name: IDX_plan_mechanic_values_plan_fu_mechanic; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_plan_mechanic_values_plan_fu_mechanic" ON main.plan_mechanic_values USING btree (plan_fu_id, mechanic_id);


--
-- Name: IDX_plan_skus_calculated_kpis; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_plan_skus_calculated_kpis" ON main.plan_skus USING gin (calculated_kpis);


--
-- Name: IDX_plan_skus_plan_fu_id; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_plan_skus_plan_fu_id" ON main.plan_skus USING btree (plan_fu_id);


--
-- Name: IDX_plan_skus_plan_fu_sku_unique; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_plan_skus_plan_fu_sku_unique" ON main.plan_skus USING btree (plan_fu_id, sku_id);


--
-- Name: IDX_plan_skus_sku_id; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_plan_skus_sku_id" ON main.plan_skus USING btree (sku_id);


--
-- Name: IDX_plans_approval_request; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_plans_approval_request" ON main.plans USING btree (approval_request_id) WHERE (approval_request_id IS NOT NULL);


--
-- Name: IDX_plans_tenant_category_status; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_plans_tenant_category_status" ON main.plans USING btree (tenant_id, category_id, status);


--
-- Name: IDX_plans_tenant_cpl_status; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_plans_tenant_cpl_status" ON main.plans USING btree (tenant_id, cpl_id, status);


--
-- Name: IDX_plans_tenant_plan_code; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "IDX_plans_tenant_plan_code" ON main.plans USING btree (tenant_id, plan_code);


--
-- Name: IDX_plans_tenant_status; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_plans_tenant_status" ON main.plans USING btree (tenant_id, status);


--
-- Name: IDX_user_scopes_tenant_id; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_user_scopes_tenant_id" ON main.user_scopes USING btree (tenant_id);


--
-- Name: IDX_user_scopes_user_id; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX "IDX_user_scopes_user_id" ON main.user_scopes USING btree (user_id);


--
-- Name: UQ_user_scopes_user_cpl_category; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX "UQ_user_scopes_user_cpl_category" ON main.user_scopes USING btree (user_id, cpl_id, category_id);


--
-- Name: idx_budget_envelopes_category; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX idx_budget_envelopes_category ON main.budget_envelopes USING btree (tenant_id, category) WHERE (deleted_at IS NULL);


--
-- Name: idx_budget_envelopes_channel_category_period; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX idx_budget_envelopes_channel_category_period ON main.budget_envelopes USING btree (tenant_id, channel, category, period) WHERE (deleted_at IS NULL);


--
-- Name: idx_budget_envelopes_channel_category_period_spend; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX idx_budget_envelopes_channel_category_period_spend ON main.budget_envelopes USING btree (tenant_id, channel, category, period, spend_type) WHERE (deleted_at IS NULL);


--
-- Name: idx_budget_envelopes_channel_period; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX idx_budget_envelopes_channel_period ON main.budget_envelopes USING btree (tenant_id, channel, period) WHERE (deleted_at IS NULL);


--
-- Name: idx_budget_envelopes_channel_period_spend; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX idx_budget_envelopes_channel_period_spend ON main.budget_envelopes USING btree (tenant_id, channel, period, spend_type) WHERE (deleted_at IS NULL);


--
-- Name: idx_budget_transactions_envelope_status; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX idx_budget_transactions_envelope_status ON main.budget_transactions USING btree (envelope_id, tx_status) WHERE (deleted_at IS NULL);


--
-- Name: idx_ledger_entries_envelope; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX idx_ledger_entries_envelope ON main.ledger_entries USING btree (budget_envelope_id) WHERE (deleted_at IS NULL);


--
-- Name: ix_sa_tenant_batch; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX ix_sa_tenant_batch ON main.sales_actuals USING btree (tenant_id, batch_id);


--
-- Name: ix_sa_tenant_dims; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX ix_sa_tenant_dims ON main.sales_actuals USING btree (tenant_id, fiscal_period, cpl_id, category_id, channel_id);


--
-- Name: ix_sab_tenant_period; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX ix_sab_tenant_period ON main.sales_actual_batches USING btree (tenant_id, fiscal_period);


--
-- Name: ix_sab_tenant_status; Type: INDEX; Schema: main; Owner: -
--

CREATE INDEX ix_sab_tenant_status ON main.sales_actual_batches USING btree (tenant_id, status);


--
-- Name: ux_sales_actual_batches_active_scope; Type: INDEX; Schema: main; Owner: -
--

CREATE UNIQUE INDEX ux_sales_actual_batches_active_scope ON main.sales_actual_batches USING btree (tenant_id, fiscal_period, cpl_id, category_id, channel_id) WHERE ((status = 'ACTIVE'::main.sales_actual_batches_status_enum) AND (deleted_at IS NULL));


--
-- Name: tactics FK_002bc4a3eddd205cabb9623a894; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.tactics
    ADD CONSTRAINT "FK_002bc4a3eddd205cabb9623a894" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: plan_mechanic_values FK_0063320c78eee28dc115f8b7c3e; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plan_mechanic_values
    ADD CONSTRAINT "FK_0063320c78eee28dc115f8b7c3e" FOREIGN KEY (mechanic_id) REFERENCES main.mechanics(id) ON DELETE RESTRICT;


--
-- Name: budget_reservations FK_08b246a35bf7a2871fbedb08bbb; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.budget_reservations
    ADD CONSTRAINT "FK_08b246a35bf7a2871fbedb08bbb" FOREIGN KEY (envelope_id) REFERENCES main.budget_envelopes(id) ON DELETE RESTRICT;


--
-- Name: agreements FK_092dcfb053d1e92c97f1e049f1b; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.agreements
    ADD CONSTRAINT "FK_092dcfb053d1e92c97f1e049f1b" FOREIGN KEY (gu_id) REFERENCES main.generic_units(id) ON DELETE SET NULL;


--
-- Name: agreement_transactions FK_0b259a8de93e93b6b320cc28289; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.agreement_transactions
    ADD CONSTRAINT "FK_0b259a8de93e93b6b320cc28289" FOREIGN KEY (cpl_id) REFERENCES main.customers(id) ON DELETE SET NULL;


--
-- Name: generic_units FK_0e1222ec4ca292eac4e273690cd; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.generic_units
    ADD CONSTRAINT "FK_0e1222ec4ca292eac4e273690cd" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: agreements FK_0f5b9d92fe48d8072f7c46d96dd; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.agreements
    ADD CONSTRAINT "FK_0f5b9d92fe48d8072f7c46d96dd" FOREIGN KEY (created_by) REFERENCES main.users(id) ON DELETE SET NULL;


--
-- Name: ledger_entries FK_100a4dde20ac61937a6a4e58b59; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.ledger_entries
    ADD CONSTRAINT "FK_100a4dde20ac61937a6a4e58b59" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE RESTRICT;


--
-- Name: users FK_109638590074998bb72a2f2cf08; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.users
    ADD CONSTRAINT "FK_109638590074998bb72a2f2cf08" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: agreement_transactions FK_2027a62e21e985af943ee1d6087; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.agreement_transactions
    ADD CONSTRAINT "FK_2027a62e21e985af943ee1d6087" FOREIGN KEY (agreement_id) REFERENCES main.agreements(id) ON DELETE RESTRICT;


--
-- Name: on_invoice_batches FK_21615076e1bc498b99a360a8c68; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.on_invoice_batches
    ADD CONSTRAINT "FK_21615076e1bc498b99a360a8c68" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: sales_actual_batches FK_219838b9ec96d1b6bec3b0c0965; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.sales_actual_batches
    ADD CONSTRAINT "FK_219838b9ec96d1b6bec3b0c0965" FOREIGN KEY (updated_by) REFERENCES main.users(id) ON DELETE SET NULL;


--
-- Name: plans FK_25da9bd76e34caf96b65dffee16; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plans
    ADD CONSTRAINT "FK_25da9bd76e34caf96b65dffee16" FOREIGN KEY (escalated_by) REFERENCES main.users(id) ON DELETE SET NULL;


--
-- Name: sales_actual_batches FK_265960db7499bc69cc33e7e5b2b; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.sales_actual_batches
    ADD CONSTRAINT "FK_265960db7499bc69cc33e7e5b2b" FOREIGN KEY (cpl_id) REFERENCES main.cpls(id) ON DELETE RESTRICT;


--
-- Name: on_invoice_entries FK_265a9ab4f5822fdcaaf0322ab2d; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.on_invoice_entries
    ADD CONSTRAINT "FK_265a9ab4f5822fdcaaf0322ab2d" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE RESTRICT;


--
-- Name: agreements FK_2694dcb82533d5059a8ea5a3ac4; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.agreements
    ADD CONSTRAINT "FK_2694dcb82533d5059a8ea5a3ac4" FOREIGN KEY (mechanic_id) REFERENCES main.mechanics(id) ON DELETE RESTRICT;


--
-- Name: regions FK_26fd3475b73815de7715bd07194; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.regions
    ADD CONSTRAINT "FK_26fd3475b73815de7715bd07194" FOREIGN KEY (parent_region_id) REFERENCES main.regions(id) ON DELETE SET NULL;


--
-- Name: cpls FK_28204184c569e9ea8c3f4657ff3; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.cpls
    ADD CONSTRAINT "FK_28204184c569e9ea8c3f4657ff3" FOREIGN KEY (region_id) REFERENCES main.regions(id) ON DELETE SET NULL;


--
-- Name: skus FK_2ed9d774ab87c2734c0edf5dbcc; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.skus
    ADD CONSTRAINT "FK_2ed9d774ab87c2734c0edf5dbcc" FOREIGN KEY (gu_id) REFERENCES main.generic_units(id) ON DELETE RESTRICT;


--
-- Name: budget_transactions FK_314f83d5049538585140ef39376; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.budget_transactions
    ADD CONSTRAINT "FK_314f83d5049538585140ef39376" FOREIGN KEY (envelope_id) REFERENCES main.budget_envelopes(id) ON DELETE RESTRICT;


--
-- Name: brands FK_33bb5b1b1a3a7e8b9787cd87784; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.brands
    ADD CONSTRAINT "FK_33bb5b1b1a3a7e8b9787cd87784" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: sales_actual_batches FK_415c1cbe0ff5dc490a20021be89; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.sales_actual_batches
    ADD CONSTRAINT "FK_415c1cbe0ff5dc490a20021be89" FOREIGN KEY (created_by) REFERENCES main.users(id) ON DELETE SET NULL;


--
-- Name: budget_allocations FK_41b10db5a79496d615b6d2ae5d5; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.budget_allocations
    ADD CONSTRAINT "FK_41b10db5a79496d615b6d2ae5d5" FOREIGN KEY (cpl_id) REFERENCES main.cpls(id) ON DELETE RESTRICT;


--
-- Name: channels FK_47b27864a7c91c1ca3ce14d6ed1; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.channels
    ADD CONSTRAINT "FK_47b27864a7c91c1ca3ce14d6ed1" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: kpis FK_480d834b279982a9714e6b53028; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.kpis
    ADD CONSTRAINT "FK_480d834b279982a9714e6b53028" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: plans FK_4af50d60499cf33072eb5fe9d99; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plans
    ADD CONSTRAINT "FK_4af50d60499cf33072eb5fe9d99" FOREIGN KEY (region_id) REFERENCES main.regions(id) ON DELETE SET NULL;


--
-- Name: agreements FK_4e495bddb9d955f4f2759f75a50; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.agreements
    ADD CONSTRAINT "FK_4e495bddb9d955f4f2759f75a50" FOREIGN KEY (region_id) REFERENCES main.regions(id) ON DELETE SET NULL;


--
-- Name: agreements FK_4e63c76af85a2b9838335acdc9c; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.agreements
    ADD CONSTRAINT "FK_4e63c76af85a2b9838335acdc9c" FOREIGN KEY (tactic_id) REFERENCES main.tactics(id) ON DELETE RESTRICT;


--
-- Name: plan_approval_history FK_4f4664da464c6d8280c4665f859; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plan_approval_history
    ADD CONSTRAINT "FK_4f4664da464c6d8280c4665f859" FOREIGN KEY (actioned_by) REFERENCES main.users(id) ON DELETE CASCADE;


--
-- Name: budget_transactions FK_51d1a2d2f67aeb0f0184a9f7021; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.budget_transactions
    ADD CONSTRAINT "FK_51d1a2d2f67aeb0f0184a9f7021" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE RESTRICT;


--
-- Name: mechanic_spend_breakdown FK_54dbfe9df242d1aada3b456eb95; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.mechanic_spend_breakdown
    ADD CONSTRAINT "FK_54dbfe9df242d1aada3b456eb95" FOREIGN KEY (plan_sku_id) REFERENCES main.plan_skus(id) ON DELETE CASCADE;


--
-- Name: plan_fus FK_562f38b679ba53aa56596a80b40; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plan_fus
    ADD CONSTRAINT "FK_562f38b679ba53aa56596a80b40" FOREIGN KEY (plan_id) REFERENCES main.plans(id) ON DELETE CASCADE;


--
-- Name: approval_requests FK_583d55f85471d6c6453c4724569; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.approval_requests
    ADD CONSTRAINT "FK_583d55f85471d6c6453c4724569" FOREIGN KEY (approved_by_id) REFERENCES main.users(id) ON DELETE SET NULL;


--
-- Name: mechanics FK_586cde98f992c365e49b2b08ad7; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.mechanics
    ADD CONSTRAINT "FK_586cde98f992c365e49b2b08ad7" FOREIGN KEY (tactic_id) REFERENCES main.tactics(id) ON DELETE RESTRICT;


--
-- Name: sales_actual_batches FK_5a13ef2420de51a3eb60dd7038e; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.sales_actual_batches
    ADD CONSTRAINT "FK_5a13ef2420de51a3eb60dd7038e" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: plan_approval_history FK_5ca387fe1222d64c28d1fa286aa; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plan_approval_history
    ADD CONSTRAINT "FK_5ca387fe1222d64c28d1fa286aa" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: categories FK_5d4fe23b360b1b9e16a3f41727f; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.categories
    ADD CONSTRAINT "FK_5d4fe23b360b1b9e16a3f41727f" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: skus FK_6063268d5cbf0cdf746328dfa5b; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.skus
    ADD CONSTRAINT "FK_6063268d5cbf0cdf746328dfa5b" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: forecasting_units FK_60d66281ba365e6062f89b2227c; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.forecasting_units
    ADD CONSTRAINT "FK_60d66281ba365e6062f89b2227c" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: on_invoice_entries FK_63df3d9820dba620c3a109d5463; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.on_invoice_entries
    ADD CONSTRAINT "FK_63df3d9820dba620c3a109d5463" FOREIGN KEY (batch_id) REFERENCES main.on_invoice_batches(id) ON DELETE RESTRICT;


--
-- Name: sales_actuals FK_6ab139e5b0e26a668a7db2db8b9; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.sales_actuals
    ADD CONSTRAINT "FK_6ab139e5b0e26a668a7db2db8b9" FOREIGN KEY (created_by) REFERENCES main.users(id) ON DELETE RESTRICT;


--
-- Name: on_invoice_entries FK_6aff5a8f9ebcb0f9db7b9b57d66; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.on_invoice_entries
    ADD CONSTRAINT "FK_6aff5a8f9ebcb0f9db7b9b57d66" FOREIGN KEY (created_by) REFERENCES main.users(id) ON DELETE RESTRICT;


--
-- Name: sales_actual_batches FK_6de5175cc0635ca614ffba5a135; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.sales_actual_batches
    ADD CONSTRAINT "FK_6de5175cc0635ca614ffba5a135" FOREIGN KEY (channel_id) REFERENCES main.channels(id) ON DELETE RESTRICT;


--
-- Name: plan_skus FK_708486b0e010a4d52a3cf7a3f80; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plan_skus
    ADD CONSTRAINT "FK_708486b0e010a4d52a3cf7a3f80" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: agreements FK_73ddc6cada086d7f7b329b2e5af; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.agreements
    ADD CONSTRAINT "FK_73ddc6cada086d7f7b329b2e5af" FOREIGN KEY (cpl_id) REFERENCES main.cpls(id) ON DELETE RESTRICT;


--
-- Name: generic_units FK_742279e3e1bac24907b42ecc962; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.generic_units
    ADD CONSTRAINT "FK_742279e3e1bac24907b42ecc962" FOREIGN KEY (category_id) REFERENCES main.categories(id) ON DELETE RESTRICT;


--
-- Name: plans FK_784677bd6054f30d1606e6b2db3; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plans
    ADD CONSTRAINT "FK_784677bd6054f30d1606e6b2db3" FOREIGN KEY (approved_by) REFERENCES main.users(id) ON DELETE SET NULL;


--
-- Name: agreement_transactions FK_79631c9145e6aa251b4da50edb9; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.agreement_transactions
    ADD CONSTRAINT "FK_79631c9145e6aa251b4da50edb9" FOREIGN KEY (updated_by) REFERENCES main.users(id) ON DELETE RESTRICT;


--
-- Name: agreement_transactions FK_7d54b927aa0c1e68525c2a66f19; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.agreement_transactions
    ADD CONSTRAINT "FK_7d54b927aa0c1e68525c2a66f19" FOREIGN KEY (created_by) REFERENCES main.users(id) ON DELETE RESTRICT;


--
-- Name: sales_actuals FK_7ef8bc2e51a68b05a7dace2130f; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.sales_actuals
    ADD CONSTRAINT "FK_7ef8bc2e51a68b05a7dace2130f" FOREIGN KEY (updated_by) REFERENCES main.users(id) ON DELETE RESTRICT;


--
-- Name: agreements FK_82d0dfd8c20a43c824d33fedc0e; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.agreements
    ADD CONSTRAINT "FK_82d0dfd8c20a43c824d33fedc0e" FOREIGN KEY (channel_id) REFERENCES main.channels(id) ON DELETE RESTRICT;


--
-- Name: sales_actual_batches FK_8369622d18f442c9d5beb7a7e69; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.sales_actual_batches
    ADD CONSTRAINT "FK_8369622d18f442c9d5beb7a7e69" FOREIGN KEY (category_id) REFERENCES main.categories(id) ON DELETE RESTRICT;


--
-- Name: agreements FK_86c49f54d185406f53122f4729c; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.agreements
    ADD CONSTRAINT "FK_86c49f54d185406f53122f4729c" FOREIGN KEY (updated_by) REFERENCES main.users(id) ON DELETE SET NULL;


--
-- Name: lta_plan_overrides FK_8807fbe566bc4235b80ce6f652a; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.lta_plan_overrides
    ADD CONSTRAINT "FK_8807fbe566bc4235b80ce6f652a" FOREIGN KEY (lta_rate_id) REFERENCES main.lta_rates(id) ON DELETE CASCADE;


--
-- Name: plans FK_88735f9485010b536da623bdc16; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plans
    ADD CONSTRAINT "FK_88735f9485010b536da623bdc16" FOREIGN KEY (rejected_by) REFERENCES main.users(id) ON DELETE SET NULL;


--
-- Name: mechanic_spend_breakdown FK_89a0944a2432e5da0a410ff43a1; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.mechanic_spend_breakdown
    ADD CONSTRAINT "FK_89a0944a2432e5da0a410ff43a1" FOREIGN KEY (plan_mechanic_value_id) REFERENCES main.plan_mechanic_values(id) ON DELETE CASCADE;


--
-- Name: plans FK_8d43d330ab20fc36f2b8ec77098; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plans
    ADD CONSTRAINT "FK_8d43d330ab20fc36f2b8ec77098" FOREIGN KEY (approval_request_id) REFERENCES main.approval_requests(id) ON DELETE SET NULL;


--
-- Name: lta_plan_overrides FK_94c771cee4fa60d56b147305ec7; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.lta_plan_overrides
    ADD CONSTRAINT "FK_94c771cee4fa60d56b147305ec7" FOREIGN KEY (plan_id) REFERENCES main.plans(id) ON DELETE CASCADE;


--
-- Name: plan_fus FK_94fb2dfb84e11d023ec2eafdbdb; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plan_fus
    ADD CONSTRAINT "FK_94fb2dfb84e11d023ec2eafdbdb" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: customers FK_97913f35ac2e435a4463fb50a01; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.customers
    ADD CONSTRAINT "FK_97913f35ac2e435a4463fb50a01" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: on_invoice_entries FK_9b1002c8e1f85ba87e79f1621b5; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.on_invoice_entries
    ADD CONSTRAINT "FK_9b1002c8e1f85ba87e79f1621b5" FOREIGN KEY (updated_by) REFERENCES main.users(id) ON DELETE RESTRICT;


--
-- Name: plan_fus FK_9e068695704066b03502fb3048f; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plan_fus
    ADD CONSTRAINT "FK_9e068695704066b03502fb3048f" FOREIGN KEY (fu_id) REFERENCES main.forecasting_units(id) ON DELETE RESTRICT;


--
-- Name: ledger_entries FK_a18723db3e6f87bae5b04dbd109; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.ledger_entries
    ADD CONSTRAINT "FK_a18723db3e6f87bae5b04dbd109" FOREIGN KEY (budget_envelope_id) REFERENCES main.budget_envelopes(id) ON DELETE RESTRICT;


--
-- Name: skus FK_a1b9e2a7b70d55aee0b2e371818; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.skus
    ADD CONSTRAINT "FK_a1b9e2a7b70d55aee0b2e371818" FOREIGN KEY (fu_id) REFERENCES main.forecasting_units(id) ON DELETE SET NULL;


--
-- Name: approval_requests FK_a2ed2bfe67f7da72fe842f1d1c8; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.approval_requests
    ADD CONSTRAINT "FK_a2ed2bfe67f7da72fe842f1d1c8" FOREIGN KEY (rejected_by_id) REFERENCES main.users(id) ON DELETE SET NULL;


--
-- Name: generic_units FK_a2f7155fd630ebed57d1cc6aff0; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.generic_units
    ADD CONSTRAINT "FK_a2f7155fd630ebed57d1cc6aff0" FOREIGN KEY (brand_id) REFERENCES main.brands(id) ON DELETE RESTRICT;


--
-- Name: sales_actuals FK_a7e9b80fbb69486651d53da1477; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.sales_actuals
    ADD CONSTRAINT "FK_a7e9b80fbb69486651d53da1477" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE RESTRICT;


--
-- Name: approval_requests FK_a97fb580bc9ec86aa1b54087383; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.approval_requests
    ADD CONSTRAINT "FK_a97fb580bc9ec86aa1b54087383" FOREIGN KEY (updated_by) REFERENCES main.users(id) ON DELETE SET NULL;


--
-- Name: sales_actual_batches FK_ae3e056f650421a1c2beec79ca9; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.sales_actual_batches
    ADD CONSTRAINT "FK_ae3e056f650421a1c2beec79ca9" FOREIGN KEY (replaced_by_batch_id) REFERENCES main.sales_actual_batches(id) ON DELETE SET NULL;


--
-- Name: agreements FK_agreements_fu_id; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.agreements
    ADD CONSTRAINT "FK_agreements_fu_id" FOREIGN KEY (fu_id) REFERENCES main.forecasting_units(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: budget_transaction_logs FK_b01aa597874f81d2e309dd02150; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.budget_transaction_logs
    ADD CONSTRAINT "FK_b01aa597874f81d2e309dd02150" FOREIGN KEY (plan_id) REFERENCES main.plans(id) ON DELETE SET NULL;


--
-- Name: plans FK_b2d783911968bc49f7a3decaf36; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plans
    ADD CONSTRAINT "FK_b2d783911968bc49f7a3decaf36" FOREIGN KEY (submitted_by) REFERENCES main.users(id) ON DELETE SET NULL;


--
-- Name: forecasting_units FK_b4dc6fea4da233d2240169e5fdd; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.forecasting_units
    ADD CONSTRAINT "FK_b4dc6fea4da233d2240169e5fdd" FOREIGN KEY (gu_id) REFERENCES main.generic_units(id) ON DELETE RESTRICT;


--
-- Name: lta_rates FK_b800bcafa74fde483c2e2fda49d; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.lta_rates
    ADD CONSTRAINT "FK_b800bcafa74fde483c2e2fda49d" FOREIGN KEY (lta_agreement_id) REFERENCES main.lta_agreements(id) ON DELETE CASCADE;


--
-- Name: lta_plan_overrides FK_beace77c15af36ca8b96d6d5a19; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.lta_plan_overrides
    ADD CONSTRAINT "FK_beace77c15af36ca8b96d6d5a19" FOREIGN KEY (approved_by) REFERENCES main.users(id) ON DELETE RESTRICT;


--
-- Name: mechanic_spend_breakdown FK_c0f4bfe088a071a0fa0f363a4ef; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.mechanic_spend_breakdown
    ADD CONSTRAINT "FK_c0f4bfe088a071a0fa0f363a4ef" FOREIGN KEY (mechanic_id) REFERENCES main.mechanics(id) ON DELETE RESTRICT;


--
-- Name: agreements FK_c0fca727c8538979bd95a8f2f13; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.agreements
    ADD CONSTRAINT "FK_c0fca727c8538979bd95a8f2f13" FOREIGN KEY (rejected_by) REFERENCES main.users(id) ON DELETE SET NULL;


--
-- Name: on_invoice_batches FK_c1fb846ef2b11d5b92cc367b094; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.on_invoice_batches
    ADD CONSTRAINT "FK_c1fb846ef2b11d5b92cc367b094" FOREIGN KEY (updated_by) REFERENCES main.users(id) ON DELETE SET NULL;


--
-- Name: plan_approval_history FK_c338af85bdb2421177523cbf1fa; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plan_approval_history
    ADD CONSTRAINT "FK_c338af85bdb2421177523cbf1fa" FOREIGN KEY (plan_id) REFERENCES main.plans(id) ON DELETE CASCADE;


--
-- Name: budget_reservations FK_c4dc2a1e8e1cd03d0937b1be140; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.budget_reservations
    ADD CONSTRAINT "FK_c4dc2a1e8e1cd03d0937b1be140" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE RESTRICT;


--
-- Name: cpls FK_c5b74ad864e9652b3ca760067dd; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.cpls
    ADD CONSTRAINT "FK_c5b74ad864e9652b3ca760067dd" FOREIGN KEY (channel_id) REFERENCES main.channels(id) ON DELETE RESTRICT;


--
-- Name: approval_requests FK_c8f82490b1a2b973da9acbef284; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.approval_requests
    ADD CONSTRAINT "FK_c8f82490b1a2b973da9acbef284" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: agreements FK_ce57a248271b283fadf145de118; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.agreements
    ADD CONSTRAINT "FK_ce57a248271b283fadf145de118" FOREIGN KEY (category_id) REFERENCES main.categories(id) ON DELETE SET NULL;


--
-- Name: agreements FK_cf93755b0e3f8ea3afedced900f; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.agreements
    ADD CONSTRAINT "FK_cf93755b0e3f8ea3afedced900f" FOREIGN KEY (approved_by) REFERENCES main.users(id) ON DELETE SET NULL;


--
-- Name: approval_requests FK_d059d4d7644a5e9b3d5c72c55ab; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.approval_requests
    ADD CONSTRAINT "FK_d059d4d7644a5e9b3d5c72c55ab" FOREIGN KEY (created_by) REFERENCES main.users(id) ON DELETE SET NULL;


--
-- Name: sales_actuals FK_d090bf56813fcf1b4572aa5d75f; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.sales_actuals
    ADD CONSTRAINT "FK_d090bf56813fcf1b4572aa5d75f" FOREIGN KEY (batch_id) REFERENCES main.sales_actual_batches(id) ON DELETE RESTRICT;


--
-- Name: plan_mechanic_values FK_d1635951ba884825b35f9a3c3fe; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plan_mechanic_values
    ADD CONSTRAINT "FK_d1635951ba884825b35f9a3c3fe" FOREIGN KEY (plan_fu_id) REFERENCES main.plan_fus(id) ON DELETE CASCADE;


--
-- Name: agreements FK_d22dc644eeb61f8b7cd2747ec1a; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.agreements
    ADD CONSTRAINT "FK_d22dc644eeb61f8b7cd2747ec1a" FOREIGN KEY (approval_request_id) REFERENCES main.approval_requests(id) ON DELETE SET NULL;


--
-- Name: approval_requests FK_d65106bd0bda1a84e007aa7ed7c; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.approval_requests
    ADD CONSTRAINT "FK_d65106bd0bda1a84e007aa7ed7c" FOREIGN KEY (cancelled_by_id) REFERENCES main.users(id) ON DELETE SET NULL;


--
-- Name: mechanics FK_d6e5a2bb906be03422946a45112; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.mechanics
    ADD CONSTRAINT "FK_d6e5a2bb906be03422946a45112" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: on_invoice_entries FK_d71515c8031a71e19826b3deb1c; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.on_invoice_entries
    ADD CONSTRAINT "FK_d71515c8031a71e19826b3deb1c" FOREIGN KEY (customer_id) REFERENCES main.customers(id) ON DELETE RESTRICT;


--
-- Name: budget_transaction_logs FK_d803327caaf6745f39ccc8729da; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.budget_transaction_logs
    ADD CONSTRAINT "FK_d803327caaf6745f39ccc8729da" FOREIGN KEY (budget_allocation_id) REFERENCES main.budget_allocations(id) ON DELETE CASCADE;


--
-- Name: agreements FK_d8ef8b3d1b3b6ac3d6616d5704f; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.agreements
    ADD CONSTRAINT "FK_d8ef8b3d1b3b6ac3d6616d5704f" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: notifications FK_d93ddd7e1b890535ecafbb334ec; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.notifications
    ADD CONSTRAINT "FK_d93ddd7e1b890535ecafbb334ec" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: budget_transaction_logs FK_dbf6259f6e8603a54a4dc29c76b; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.budget_transaction_logs
    ADD CONSTRAINT "FK_dbf6259f6e8603a54a4dc29c76b" FOREIGN KEY (created_by) REFERENCES main.users(id) ON DELETE RESTRICT;


--
-- Name: categories FK_de08738901be6b34d2824a1e243; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.categories
    ADD CONSTRAINT "FK_de08738901be6b34d2824a1e243" FOREIGN KEY (parent_category_id) REFERENCES main.categories(id) ON DELETE SET NULL;


--
-- Name: admin_audit_logs FK_df6424756dc2edd5ef911dbe777; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.admin_audit_logs
    ADD CONSTRAINT "FK_df6424756dc2edd5ef911dbe777" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: on_invoice_entries FK_dfd2ed55f8f178b70d49bb3f13a; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.on_invoice_entries
    ADD CONSTRAINT "FK_dfd2ed55f8f178b70d49bb3f13a" FOREIGN KEY (sku_id) REFERENCES main.skus(id) ON DELETE RESTRICT;


--
-- Name: on_invoice_entries FK_e043845c5d52a65548357c3cf93; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.on_invoice_entries
    ADD CONSTRAINT "FK_e043845c5d52a65548357c3cf93" FOREIGN KEY (budget_envelope_id) REFERENCES main.budget_envelopes(id) ON DELETE RESTRICT;


--
-- Name: lta_agreements FK_e25656547aaa8b535cc3d1a4cf8; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.lta_agreements
    ADD CONSTRAINT "FK_e25656547aaa8b535cc3d1a4cf8" FOREIGN KEY (cpl_id) REFERENCES main.cpls(id) ON DELETE RESTRICT;


--
-- Name: lta_rates FK_e2dd71e562adb6f508b11abec38; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.lta_rates
    ADD CONSTRAINT "FK_e2dd71e562adb6f508b11abec38" FOREIGN KEY (channel_id) REFERENCES main.channels(id) ON DELETE RESTRICT;


--
-- Name: cpls FK_ea7722085c0c4ebe6f254b0705c; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.cpls
    ADD CONSTRAINT "FK_ea7722085c0c4ebe6f254b0705c" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: agreement_transactions FK_eab217d37aca0311b8596857d49; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.agreement_transactions
    ADD CONSTRAINT "FK_eab217d37aca0311b8596857d49" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE RESTRICT;


--
-- Name: plan_skus FK_ee104a0670bdea204f5f1423de6; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plan_skus
    ADD CONSTRAINT "FK_ee104a0670bdea204f5f1423de6" FOREIGN KEY (sku_id) REFERENCES main.skus(id) ON DELETE RESTRICT;


--
-- Name: plan_skus FK_ef3f1274132e34857347b8522ff; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plan_skus
    ADD CONSTRAINT "FK_ef3f1274132e34857347b8522ff" FOREIGN KEY (plan_fu_id) REFERENCES main.plan_fus(id) ON DELETE CASCADE;


--
-- Name: lta_rates FK_ef8c70538f0d0f7f9bc5c23d779; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.lta_rates
    ADD CONSTRAINT "FK_ef8c70538f0d0f7f9bc5c23d779" FOREIGN KEY (category_id) REFERENCES main.categories(id) ON DELETE RESTRICT;


--
-- Name: plans FK_f0299352f08a40c33f96d767b2b; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plans
    ADD CONSTRAINT "FK_f0299352f08a40c33f96d767b2b" FOREIGN KEY (category_id) REFERENCES main.categories(id) ON DELETE RESTRICT;


--
-- Name: customers FK_f0568fbe24fe4c1765333b47be3; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.customers
    ADD CONSTRAINT "FK_f0568fbe24fe4c1765333b47be3" FOREIGN KEY (cpl_id) REFERENCES main.cpls(id) ON DELETE SET NULL;


--
-- Name: plans FK_f17ddc6d7cd26981b7ac8bf902f; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plans
    ADD CONSTRAINT "FK_f17ddc6d7cd26981b7ac8bf902f" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: regions FK_f2db4fc89c92746155984b1e93b; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.regions
    ADD CONSTRAINT "FK_f2db4fc89c92746155984b1e93b" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: plans FK_f50dafee2c0651aaf5aa20d419d; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plans
    ADD CONSTRAINT "FK_f50dafee2c0651aaf5aa20d419d" FOREIGN KEY (cpl_id) REFERENCES main.cpls(id) ON DELETE RESTRICT;


--
-- Name: lta_plan_overrides FK_f7141e340a32b7d55c99480956d; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.lta_plan_overrides
    ADD CONSTRAINT "FK_f7141e340a32b7d55c99480956d" FOREIGN KEY (lta_agreement_id) REFERENCES main.lta_agreements(id) ON DELETE CASCADE;


--
-- Name: on_invoice_batches FK_f7f84e38074dec38a85d0737e23; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.on_invoice_batches
    ADD CONSTRAINT "FK_f7f84e38074dec38a85d0737e23" FOREIGN KEY (created_by) REFERENCES main.users(id) ON DELETE SET NULL;


--
-- Name: approval_requests FK_fe1fd51dc3f183b37762a01458e; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.approval_requests
    ADD CONSTRAINT "FK_fe1fd51dc3f183b37762a01458e" FOREIGN KEY (requested_by_id) REFERENCES main.users(id) ON DELETE CASCADE;


--
-- Name: plans FK_fe90c0a6127b7d0e076b5d1d672; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.plans
    ADD CONSTRAINT "FK_fe90c0a6127b7d0e076b5d1d672" FOREIGN KEY (channel_id) REFERENCES main.channels(id) ON DELETE RESTRICT;


--
-- Name: budget_envelopes FK_ff450ca607378cff5627d5c88b1; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.budget_envelopes
    ADD CONSTRAINT "FK_ff450ca607378cff5627d5c88b1" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: ledger_entries FK_ledger_entries_agreement_id_restrict; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.ledger_entries
    ADD CONSTRAINT "FK_ledger_entries_agreement_id_restrict" FOREIGN KEY (agreement_id) REFERENCES main.agreements(id) ON DELETE RESTRICT;


--
-- Name: user_scopes FK_user_scopes_cpl; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.user_scopes
    ADD CONSTRAINT "FK_user_scopes_cpl" FOREIGN KEY (cpl_id) REFERENCES main.cpls(id) ON DELETE CASCADE;


--
-- Name: user_scopes FK_user_scopes_tenant; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.user_scopes
    ADD CONSTRAINT "FK_user_scopes_tenant" FOREIGN KEY (tenant_id) REFERENCES main.tenants(id) ON DELETE CASCADE;


--
-- Name: user_scopes FK_user_scopes_user; Type: FK CONSTRAINT; Schema: main; Owner: -
--

ALTER TABLE ONLY main.user_scopes
    ADD CONSTRAINT "FK_user_scopes_user" FOREIGN KEY (user_id) REFERENCES main.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 8tgTntaYoU7Hunrfk6w8UarcJ6YiTTgLOW18fGos4xrdFPR3hp7O29mxbsJkrYy

