# Business Requirements

This file contains business requirements transformed to Commands using Event Storming methodology

## Event Storming

Таск-трекер должен быть отдельным дашбордом и доступен всем сотрудникам компании UberPopug Inc.

This will be a Read Model.

---

Авторизация в таск-трекере должна выполняться через общий сервис авторизации UberPopug Inc
(у нас там инновационная система авторизации на основе формы клюва).

Actor - User \
Command - Authenticate User \
Data - Account + Account public id \
Event - User.Authenticated

---

Новые таски может создавать кто угодно (администратор, начальник, разработчик, менеджер и любая другая роль).
У задачи должны быть описание, статус (выполнена или нет) и попуг, на которого заассайнена задача.

Actor - Authorized and Authenticated Account (admin, manager, developer, etc) \
Command - Create Task \
Data - Task + Task public id \
Event - Task.Created

---

Менеджеры или администраторы должны иметь кнопку «заассайнить задачи», которая возьмёт все открытые задачи
и рандомно заассайнит каждую на любого из сотрудников. Не успел закрыть задачу до реассайна —
сорян, делай следующую.

Actor - Authorized and Authenticated Account (admin, manager) \
Command - Assign Tasks \
Data - Account public id of the related developer \
Event - Task.Assigned - each assigned task generates this event

---

Каждый сотрудник должен иметь возможность видеть в отдельном месте список заассайненных на него задач
и отметить задачу выполненной.

Showing tasks lists business requirement will be a Read Model.

Complete task will be a command

Actor - Authorized and Authenticated Account (can be any role) \
Command - Complete Task \
Data - Task - status and public_id, Account public_id \
Event - Task.Completed

---

Аккаунтинг должен быть в отдельном дашборде и доступным только для администраторов и бухгалтеров.

This will be a Read Model with constraints.

---

Авторизация в дешборде аккаунтинга должна выполняться через общий сервис аутентификации UberPopug Inc.

This is a Constraint - no command needed.

---

У каждого из сотрудников должен быть свой счёт, который показывает, сколько за сегодня он получил денег.
У счёта должен быть аудитлог того, за что были списаны или начислены деньги, с подробным описанием каждой из задач.

Showing account balance for the user is a Read Model.

Account balance change is a Command.

Actor - Task.Completed/Task.AssignedAndCostAccounted - events \
Command - Balance Change \
Data - Account Balance, Account \
Event - Account.BalanceChanged

Account balance audit is a Command.

Actor - Account.BalanceChanged - event \
Command - Audit Balance Change \
Data - Account Balance \
Event - Balance.ChangeAudited - this event is not needed

---

Расценки:

- цены на задачу определяется единоразово, в момент появления в системе (можно с минимальной задержкой)
  - цены рассчитывается без привязки к сотруднику
- формула, которая говорит сколько списать денег с сотрудника при ассайне задачи — `rand(-10..-20)$`
- формула, которая говорит сколько начислить денег сотруднику для выполненой задачи — `rand(20..40)$`
- деньги списываются сразу после ассайна на сотрудника, а начисляются после выполнения задачи.
- отрицательный баланс переносится на следующий день. Единственный способ его погасить -
  закрыть достаточное количество задач в течении дня.

Calculate Task Cost Command: \
Actor - Task.Created - event \
Command - Add Task Cost \
Data - Task, Task public_id \
Event - Task.CostCalculated

Write Off Task Cost From Developer Account Command: \
Actor - Task.Assigned - event \
Command - Write Off Task Cost From Developer Account \
Data - Task, Account, Account Balance \
Event - Task.AssignedAndCostAccounted

---

Дешборд должен выводить количество заработанных топ-менеджментом за сегодня денег.

Read Model.

---

В конце дня необходимо:

- считать сколько денег сотрудник получил за рабочий день
- отправлять на почту сумму выплаты.

Billing Period Command: \
Actor - Time Based System Event - End of the day \
Command - Close Billing Period \
Data - Account Balance \
Event - Billing.PeriodClosed

Notification Command: \
Actor - Billing.PeriodClosed \
Command - Send Notification \
Data - Account Balance, Account (email) \
Event - Billing.PeriodNotificationSent - not needed

---

После выплаты баланса (в конце дня) он должен обнуляться,
и в аудитлоге всех операций аккаунтинга должно быть отображено, что была выплачена сумма.

Account Balance Nullify Command: \
Actor - Billing.PeriodClosed \
Command - Nullify Account Balance \
Data - Account Balance \
Event - Account.BalanceNullified

Account Balance Nullify Audit Command: \
Actor - Account.BalanceNullified \
Command - Audit Account Balance Nullify \
Data - Account Balance \
Event - Account.BalanceNullifyAudited - not needed

---

Дашборд должен выводить информацию по дням, а не за весь период сразу.

Read Model.

---

Аналитика — это отдельный дашборд, доступный только админам.

Read Model with constraints.

---

Нужно указывать, сколько заработал топ-менеджмент за сегодня: сколько попугов ушло в минус.

Read Model.

---

Нужно показывать самую дорогую задачу за день, неделю или месяц.

Read Model.

## Business Chains

Business Chain format:
`<Command Name> Command > <Event Name> Event > ... > <Command Name> Command`

### Task Creation

Create Task Command > Task.Created Event > Add Task Cost Command

### Tasks Assignment

Assign Tasks Command > Task.Assigned Event > Write Off Task Cost From Developer Account Command >
Task.AssignedAndCostAccounted Event > Balance Change Command > Account.BalanceChanged Event >
Audit Balance Change Command

### Task Completion

Complete Task Command > Task.Completed Event > Balance Change Command > Account.BalanceChanged Event >
Audit Balance Change Command

### Closing Billing Period

Close Billing Period Command > Billing.PeriodClosed Event > Nullify Account Balance Command >
Account.BalanceNullifyAudited Event > Audit Account Balance Nullify Command

Close Billing Period Command > Billing.PeriodClosed Event > Send Notification Command
