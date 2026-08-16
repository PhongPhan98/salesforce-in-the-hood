**Trainee:** PhongPX3
**Org:** Developer Edition — `phongpx9x.ce0892578f3b@agentforce.com`
**Repository:** `SalesforceMockExam`

## Task 1 — Custom object + permissions

**Where it's built:**

- Object definition: `force-app/main/default/objects/External_User__c/`
- Permission sets: `force-app/main/default/permissionsets/`

**What was done:**
`External_User__c` created with fields mapped 1:1 to the `/users` API shape: `External_Id__c` (Number, Unique/External ID), `Name__c`, `Username__c`, `Email__c`, `Phone__c`, `Website__c`, `City__c`, `Company_Name__c`, `Status__c` (Picklist: New, Submitted, Approved, Rejected). OWD set to Private. `External_User_Manager` permission set grants Read/Create/Edit (no Delete) with FLS on all fields; a second, more-restricted (read-only) variant was also created to demonstrate differentiated access. Permission set assigned to own user.

---

## Task 2 — LWC + LDS + SLDS

**Where it's built:**

- LWC component: `force-app/main/default/lwc/`

**What was done:**
LWC displays the current running user's Name, Email, and Title/Profile, read via `@wire(getRecord)` with `Id` sourced from `@salesforce/user/Id` — no Apex used for the read. Styled with SLDS (`slds-card`, `slds-grid`, etc.). Deployed to a Lightning App Page and confirmed rendering.

---

## Task 3 — Apex GET callout + LWC datatable

**Where it's built:**

- Apex service: `force-app/main/default/classes/ExternalUserService.cls`
- Apex mock: `force-app/main/default/classes/ExternalUserCalloutMock.cls`
- Apex test: `force-app/main/default/classes/ExternalUserServiceTest.cls`
- LWC: `force-app/main/default/lwc/external-user-directory/`

**What was done:**
Remote Site Setting added for `https://jsonplaceholder.typicode.com`. `ExternalUserService` performs an HTTP GET against `/users`, deserializes the JSON, and exposes the result via an `@AuraEnabled(cacheable=true)` method. The LWC calls this method and renders results in a `lightning-datatable` with defined columns (Name, Username/Email, plus one more field). Empty results and callout errors are handled gracefully in the LWC. `ExternalUserCalloutMock` provides `HttpCalloutMock` for test isolation; `ExternalUserServiceTest` meets ≥75% coverage.

---

## Task 4 — Form + POST callout

**Where it's built:**

- LWC form: `force-app/main/default/lwc/` (`externalUserForm.js`)
- Apex wrapper: `force-app/main/default/classes/ExternalUserWrapper.cls`

**What was done:**
LWC form captures new-user fields (name and email at minimum). On submit, Apex performs an HTTP POST with a JSON body to `https://jsonplaceholder.typicode.com/users`. The response (created id / echoed payload) is displayed back to the user. Non-200 responses are handled gracefully with a user-facing error.

---

## Task 5 — Approval process

**Where it's built:**

- Setup → Process Automation → Approval Processes → `External_User__c`

**What was done:**
Approval Process created on `External_User__c` with entry criteria `Status__c = 'Submitted'`. Initial submission action sets `Status__c = 'Submitted'` and locks the record. Approval action sets `Status__c = 'Approved'`; rejection action sets `Status__c = 'Rejected'`. Approver assigned is the user created in Task 6.

---

## Task 6 — Approver user

**Where it's built:**

- Setup → Users → New User

**What was done:**
New user ("Approval Manager") created with an appropriate profile/role, set as the approver so Task 5 routes to them. End-to-end flow demonstrated: record submitted → approver receives it → approves → status updates to Approved.

---

## Task 7 — Apex trigger validation (15 pts) ✅

**Where it's built:**

- Trigger: `force-app/main/default/triggers/ExternalUserTrigger.trigger`
- Handler: `force-app/main/default/classes/ExternalUserTriggerHandler.cls`
- Test: `force-app/main/default/classes/ExternalUserTriggerHandlerTest.cls`

**What was done:**
Trigger fires on `before insert` and `before update`, delegating entirely to `ExternalUserTriggerHandler.handle()` — no logic in the trigger body itself. Handler validates: `External_Id__c` required, `Name__c` required, `Username__c` required, `Email__c` format (when present), `Status__c` restricted to allowed picklist values (when present). Duplicate prevention keyed on `External_Id__c`, correctly excluding the record's own Id on update so re-saves don't false-flag. Invalid records rejected via `addError()` with clear, specific messages. Test class covers both valid-save and invalid-block paths (missing External Id, missing Name, missing Username, invalid email, invalid status, duplicate on insert, duplicate on update, and a control test proving self-updates aren't flagged as duplicates) — 8/8 tests passing, coverage ≥75%.
