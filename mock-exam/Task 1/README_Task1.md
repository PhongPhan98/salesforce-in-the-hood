# Task 1 — Custom Object + Permissions

## Overview
Created the `External_User__c` custom object as the storage target for external `/users`
data (from `https://jsonplaceholder.typicode.com/users`), locked it down with a Private
org-wide default, and built two permission sets to demonstrate differentiated access.

## Object: External_User__c

| Field Label | API Name | Type | Notes |
|---|---|---|---|
| External Id | `External_Id__c` | Number(18,0) | Unique, External ID |
| Name | `Name__c` | Text(255) | maps to `name` |
| Username | `Username__c` | Text(255) | maps to `username` |
| Email | `Email__c` | Email | maps to `email` |
| Phone | `Phone__c` | Phone | maps to `phone` |
| Website | `Website__c` | URL | maps to `website` |
| City | `City__c` | Text(255) | maps to `address.city` |
| Company Name | `Company_Name__c` | Text(255) | maps to `company.name` |
| Status | `Status__c` | Picklist | New, Submitted, Approved, Rejected (default: New) |

Standard fields (Name, Owner, Created By, Last Modified By) retained as system defaults.

**Screenshot:** `task1_object_fields.png`
**Screenshot:** `task1_externalid_detail.png` — confirms Unique + External ID on `External_Id__c`

## Org-Wide Default (OWD)

Set via Setup → Sharing Settings → Organization-Wide Defaults:

- **External User**: Default Internal Access = **Private**

**Screenshot:** `task1_owd_private.png`

## Permission Sets

### External_User_Manager (primary access)
- Object Permissions: Read ✓, Create ✓, Edit ✓, Delete ✗
- Field-Level Security: Read + Edit access on all 9 custom fields
- Assigned to: my own user (via Manage Assignments)

**Screenshot:** `task1_permset_manager_objectperms.png`
**Screenshot:** `task1_permset_manager_fls.png`
**Screenshot:** `task1_assignment.png`

### External_User_ReadOnly (restricted variant)
- Object Permissions: Read only
- Field-Level Security: Read-only access on all 9 custom fields
- Demonstrates a second, more restricted access tier for the same object

**Screenshot:** `task1_permset_readonly.png`

## Profile vs. Permission Set

My user's Profile provides baseline access — things like login hours, default record
types, and general org-level settings — but grants no access to `External_User__c`
on its own, since no object permissions were added at the profile level. Instead, I
used a Permission Set (`External_User_Manager`) to layer Read/Create/Edit and
field-level access on top of my profile without modifying it directly. This approach
lets the same access be assigned to other users later just by adding the permission
set, and it's why I also built a second permission set (`External_User_ReadOnly`) —
to show how the same object can support different access levels for different users
without touching profiles at all.

## Acceptance Criteria Checklist
- [x] Object and all `/users`-mapped fields exist with correct types
- [x] `External_Id__c` is Unique
- [x] OWD = Private
- [x] Permission set assigned to my user
- [x] Screenshots of Object Permissions and FLS
- [x] Profile vs. Permission Set explanation (above)
