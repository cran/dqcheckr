## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, eval = FALSE)

## ----one-call-----------------------------------------------------------------
# run_dq_check("customer_accounts", config_dir = "path/to/configs")

## ----install------------------------------------------------------------------
# devtools::install("path/to/dqr/dqcheckr")
# library(dqcheckr)

## ----type-inference-----------------------------------------------------------
# infer_col_type(c("2024-01-15", "2024-06-30"))  # "date"
# infer_col_type(c("100", "200", "N/A"))          # "character" (only 67% numeric)
# infer_col_type(c("100", "200", "N/A", rep("50", 17)))  # "numeric" (95% numeric)
# infer_col_type(c(NA, "", NA))                   # "unknown"
# # with a custom threshold:
# infer_col_type(c(rep("1", 17), "a", "b", "c"), threshold = 0.80)  # "numeric" (85%)

## ----run-check----------------------------------------------------------------
# result <- run_dq_check(
#   dataset_name = "customer_accounts",
#   config_dir   = "path/to/configs",   # contains dqcheckr.yml + customer_accounts.yml
#   open_report  = TRUE                 # open HTML in browser when interactive
# )
# 
# # Console output (always printed):
# # [dqcheckr] customer_accounts: FAIL - 1 warning(s), 2 failure(s). Report: reports/...html
# 
# result$status       # "PASS", "WARN", or "FAIL"
# result$report_path  # full path to the HTML file
# result$snapshot_id  # integer row ID in snapshots table

## ----individual-checks--------------------------------------------------------
# library(dqcheckr)
# 
# # Build a minimal config programmatically
# cfg <- list(
#   rules = list(
#     max_missing_rate     = 0.05,
#     max_non_numeric_rate = 0.01,
#     min_row_count        = 0
#   ),
#   column_rules     = list(
#     status = list(allowed_values = c("ACTIVE", "CLOSED"))
#   ),
#   key_columns      = "id",
#   expected_columns = NULL
# )
# 
# df <- read.csv("data/customer_accounts.csv", colClasses = "character")
# df[] <- lapply(df, trimws)
# 
# # Run any individual check
# check_missing_rate(df, cfg)       # QC-01
# check_empty_column(df, cfg)       # QC-02
# check_duplicate_rows(df, cfg)     # QC-03
# check_row_count(df, cfg)          # QC-04  (INFO)
# check_col_count(df, cfg)          # QC-05  (INFO)
# check_inferred_types(df, cfg)     # QC-06  (INFO)
# check_numeric_stats(df, cfg)      # QC-07  (INFO)
# check_distinct_counts(df, cfg)    # QC-08  (INFO)
# check_allowed_values(df, cfg)     # QC-09
# check_numeric_bounds(df, cfg)     # QC-10
# check_non_numeric(df, cfg)        # QC-11
# check_key_uniqueness(df, cfg)     # QC-12
# check_pattern(df, cfg)            # QC-13
# check_min_row_count(df, cfg)      # QC-14
# check_outliers(df, cfg)           # QC-15
# check_schema_contract(df, cfg)    # SC-01 / SC-02
# 
# # Inspect a result
# r <- check_missing_rate(df, cfg)[[1]]
# r$status    # "PASS" or "FAIL"
# r$observed  # e.g. "3.2% missing (4 of 125)"
# 
# # Run all single-snapshot checks at once
# all_results <- run_qc_checks(df, cfg)
# 
# # Overall status across any result list
# overall_status(all_results)  # "FAIL" > "WARN" > "PASS" > "INFO"

## ----custom-file--------------------------------------------------------------
# # File: custom/customer_accounts_checks.R
# 
# custom_checks <- function(df) {
#   results <- list()
# 
#   # Rule: ACTIVE accounts must not have a zero balance
#   active_zero <- df[df$account_status == "ACTIVE" &
#                     !is.na(df$account_balance) &
#                     df$account_balance == "0", ]
#   n <- nrow(active_zero)
#   results <- c(results, list(dq_result(
#     check_id   = "CUST-01",
#     check_name = "No zero-balance active accounts",
#     column     = "account_balance",   # enables per-column storage in SQLite
#     status     = if (n > 0) "FAIL" else "PASS",
#     observed   = sprintf("%d ACTIVE account(s) with balance 0", n),
#     message    = if (n > 0)
#       sprintf("%d ACTIVE account(s) have a zero balance.", n)
#     else
#       "No ACTIVE accounts have a zero balance."
#   )))
# 
#   results
# }

## ----snapshot-query-----------------------------------------------------------
# library(DBI)
# library(RSQLite)
# 
# con <- dbConnect(SQLite(), "data/snapshots.sqlite")
# 
# # Recent runs for one dataset
# dbGetQuery(con,
#   "SELECT id, file_name, overall_status, check_fail_count, run_timestamp
#    FROM snapshots
#    WHERE dataset_name = 'customer_accounts'
#    ORDER BY id DESC
#    LIMIT 10")
# 
# # Column-level stats for the most recent run
# dbGetQuery(con,
#   "SELECT column_name, dq_check, value, threshold
#    FROM column_snapshots
#    WHERE snapshot_id = (
#      SELECT MAX(id) FROM snapshots WHERE dataset_name = 'customer_accounts'
#    )
#    ORDER BY column_name, dq_check")
# 
# dbDisconnect(con)

## ----cross-dataset------------------------------------------------------------
# dbGetQuery(con,
#   "SELECT dataset_name, COUNT(*) AS runs,
#           SUM(check_fail_count) AS total_failures
#    FROM snapshots
#    GROUP BY dataset_name")

## ----starwars-setup-----------------------------------------------------------
# # Config directory contains:
# #   dqcheckr.yml         — global thresholds
# #   starwars_csv.yml     — CSV dataset config
# #   starwars_fwf.yml     — FWF dataset config
# 
# # Run checks on both formats
# result_csv <- run_dq_check("starwars_csv", config_dir = "config", open_report = TRUE)
# result_fwf <- run_dq_check("starwars_fwf", config_dir = "config", open_report = TRUE)

