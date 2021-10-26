# Events in Task Tracker system

## Business Events

### Role.Changed

Producer: Auth

Consumers: Tasks, Accounting, Analytics

### Task.Assigned

Producer: Tasks

Consumers: Accounting

### Task.AssignedAndCostAccounted

Producer: Accounting

Consumers: Tasks, Analytics

### Account.BalanceChanged

Producer: Accounting

Consumers: Analytics

### Task.Completed

Producer: Tasks

Consumers: Accounting

### Billing.PeriodClosed

Producer: Accounting

Consumers: -

### Account.BalanceNullifyAudited

Producer: Accounting

Consumers: Analytics

## CUD events

### Account.Created

Producer: Auth

Consumers: Tasks, Accounting, Analytics

### Account.Deleted

Producer: Auth

Consumers: Tasks, Accounting, Analytics

### User.Authenticated

Producer: Auth

Consumers: Tasks, Accounting, Analytics

### User.LoggedOut

Producer: Auth

Consumers: Tasks, Accounting, Analytics

### Task.Created

Producer: Tasks

Consumers: Accounting

## Task.CostCalculated

Producer: Accounting

Consumers: Tasks, Analytics
