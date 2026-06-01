## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, eval = FALSE)

## -----------------------------------------------------------------------------
# run_dq_check("customer_accounts", config_dir = "config")

## -----------------------------------------------------------------------------
# dq_result(check_id, check_name, column = NA, status, observed, threshold = NA, message)
# # status: "PASS" | "WARN" | "FAIL" | "INFO"

## -----------------------------------------------------------------------------
# run_dq_check(
#   dataset_name,        # matches <dataset_name>.yml in config_dir
#   config_dir = ".",    # contains dqcheckr.yml and <dataset_name>.yml
#   open_report = TRUE   # open in browser when interactive
# )
# # Returns invisibly: list(status, report_path, snapshot_id)

## -----------------------------------------------------------------------------
# compare_snapshots(
#   dataset_name,
#   snapshot_id_prev = NULL,   # defaults to second-most-recent
#   snapshot_id_curr = NULL,   # defaults to most-recent
#   db_path          = NULL,   # defaults to snapshot_db from dqcheckr.yml
#   config_dir       = ".",
#   report           = TRUE,   # render HTML drift report
#   open_report      = interactive()
# )
# # Returns invisibly: named list with dataset_name, snap_prev, snap_curr,
# #   table_drift, schema_changes, missing_rate_changes, non_numeric_changes,
# #   mean_shifts, distinct_changes
# 
# list_snapshots(dataset_name = NULL, db_path)
# # Returns a data frame of snapshot records; dataset_name = NULL returns all datasets

