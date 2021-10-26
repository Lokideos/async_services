# Events in Task Tracker system

## Business Events

### RoleChanged

Producer: Auth

Consumers: Tasks, Accounting, Analytics


### Task Assigned

Producer: Tasks

Consumers: Accounting

### AssignedTaskCostAccounted

Producer: Accounting

Consumers: Tasks, Analytics

### AccountingBalanceChanged

Producer: Accounting

Consumers: Analytics

### AssignedTaskCostAccounted

Producer: Accounting

Consumers: Analytics

### TaskCompleted

Producer: Tasks

Consumers: Accounting

### BillingPeriodClosed

Producer: Accounting

Consumers: -

### AccountBalanceNullifyAudited

Producer: Accounting

Consumers: Analytics

## CUD events

### AccountCreated

Producer: Auth

Consumers: Tasks, Accounting, Analytics

### AccountDeleted

Producer: Auth

Consumers: Tasks, Accounting, Analytics

### UserLoggedIn

Producer: Auth

Consumers: Tasks, Accounting, Analytics

### UserLoggedOut

Producer: Auth

Consumers: Tasks, Accounting, Analytics

### TaskCreated

Producer: Tasks

Consumers: Accounting

## TaskCostCalculated

Producer: Accounting

Consumers: Tasks, Analytics
