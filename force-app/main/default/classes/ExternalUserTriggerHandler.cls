public with sharing class ExternalUserTriggerHandler {

    private static final Set<String> ALLOWED_STATUSES = new Set<String>{
        'New', 'Submitted', 'Approved', 'Rejected'
    };

    private static final String EMAIL_REGEX =
        '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$';

    public static void handle(
        List<External_User__c> newRecords,
        Map<Id, External_User__c> oldMap,
        Boolean isInsert,
        Boolean isUpdate
    ) {
        Set<Decimal> externalIds = new Set<Decimal>();
        for (External_User__c rec : newRecords) {
            if (rec.External_Id__c != null) {
                externalIds.add(rec.External_Id__c);
            }
        }

        Map<Decimal, Id> existingByExternalId = new Map<Decimal, Id>();
        if (!externalIds.isEmpty()) {
            for (External_User__c existing : [
                SELECT Id, External_Id__c
                FROM External_User__c
                WHERE External_Id__c IN :externalIds
            ]) {
                existingByExternalId.put(existing.External_Id__c, existing.Id);
            }
        }

        for (External_User__c rec : newRecords) {
            validateRecord(rec, isInsert, isUpdate, existingByExternalId);
        }
    }

    private static void validateRecord(
        External_User__c rec,
        Boolean isInsert,
        Boolean isUpdate,
        Map<Decimal, Id> existingByExternalId
    ) {
        if (rec.External_Id__c == null) {
            rec.addError('External Id is required.');
            return;
        }

        if (String.isBlank(rec.Name__c)) {
            rec.addError('Name is required.');
            return;
        }

        if (String.isBlank(rec.Username__c)) {
            rec.addError('Username is required.');
            return;
        }

        if (String.isNotBlank(rec.Email__c) && !Pattern.matches(EMAIL_REGEX, rec.Email__c)) {
            rec.addError('Email format is invalid.');
            return;
        }

        if (String.isNotBlank(rec.Status__c) && !ALLOWED_STATUSES.contains(rec.Status__c)) {
            rec.addError('Status must be one of: New, Submitted, Approved, Rejected.');
            return;
        }

        if (existingByExternalId.containsKey(rec.External_Id__c)) {
            Id matchedId = existingByExternalId.get(rec.External_Id__c);
            Boolean isDuplicate = isInsert || (isUpdate && matchedId != rec.Id);
            if (isDuplicate) {
                rec.addError('A record with this External Id already exists.');
            }
        }
    }
}