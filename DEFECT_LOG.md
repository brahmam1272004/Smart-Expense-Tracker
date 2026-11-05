# Defect Log – Expense Tracker

## Testing Summary

| Test Case | Expected Result | Actual Result | Status |
|---|---|---|---|
| Add valid expense | Expense should be saved | Expense saved successfully | PASS |
| Add valid income | Income should be saved | Income saved successfully | PASS |
| Empty amount | Validation error should appear | Validation error displayed | PASS |
| View transaction history | Transactions should be displayed | Transactions displayed | PASS |
| View transaction details | Details should open | Details opened correctly | PASS |
| Edit transaction | Updated values should be saved | Transaction updated successfully | PASS |
| Delete transaction | Transaction should be removed | Transaction deleted successfully | PASS |
| Category-wise report | Category totals should appear | Category totals displayed | PASS |
| Data persistence | Data should remain after refresh | Data remained after refresh | PASS |
| Flutter analysis | No code issues | No issues found | PASS |
| Flutter tests | Tests should pass | All tests passed | PASS |

## Known Issues
- Physical Android device testing is pending.
- Additional robustness testing is pending.

## Conclusion
The main application features were tested successfully in Chrome. Further testing on an Android device is required.
