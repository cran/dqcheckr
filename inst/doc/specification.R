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

