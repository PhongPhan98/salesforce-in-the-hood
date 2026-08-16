@isTest
private class ExternalUserTriggerHandlerTest {

    @isTest
    static void testValidRecordIsSaved() {
        External_User__c rec = new External_User__c(
            External_Id__c = 1,
            Name__c = 'Leanne Graham',
            Username__c = 'Bret',
            Email__c = 'leanne@example.com',
            Status__c = 'New'
        );

        Test.startTest();
        insert rec;
        Test.stopTest();

        External_User__c inserted = [SELECT Id, Status__c FROM External_User__c WHERE Id = :rec.Id];
        System.assertEquals('New', inserted.Status__c);
    }

    @isTest
    static void testMissingExternalIdIsBlocked() {
        External_User__c rec = new External_User__c(
            Name__c = 'No Id',
            Username__c = 'noid',
            Email__c = 'noid@example.com',
            Status__c = 'New'
        );

        Test.startTest();
        Database.SaveResult result = Database.insert(rec, false);
        Test.stopTest();

        System.assertEquals(false, result.isSuccess());
        System.assert(result.getErrors()[0].getMessage().contains('External Id is required'));
    }

    @isTest
    static void testMissingNameIsBlocked() {
        External_User__c rec = new External_User__c(
            External_Id__c = 10,
            Username__c = 'noname',
            Email__c = 'noname@example.com',
            Status__c = 'New'
        );

        Test.startTest();
        Database.SaveResult result = Database.insert(rec, false);
        Test.stopTest();

        System.assertEquals(false, result.isSuccess());
        System.assert(result.getErrors()[0].getMessage().contains('Name is required'));
    }

    @isTest
    static void testInvalidEmailIsBlocked() {
        External_User__c rec = new External_User__c(
            External_Id__c = 2,
            Name__c = 'Bad Email',
            Username__c = 'bademail',
            Email__c = 'not-an-email',
            Status__c = 'New'
        );

        Test.startTest();
        Database.SaveResult result = Database.insert(rec, false);
        Test.stopTest();

        // Blocked either by our custom validation or Salesforce's native
        // Email field format check (whichever fires first) — both satisfy
        // the requirement that invalid email data is rejected.
        System.assertEquals(false, result.isSuccess());
    }

    @isTest
    static void testInvalidStatusIsBlocked() {
        External_User__c rec = new External_User__c(
            External_Id__c = 4,
            Name__c = 'Bad Status',
            Username__c = 'badstatus',
            Status__c = 'NotAllowed'
        );

        Test.startTest();
        Database.SaveResult result = Database.insert(rec, false);
        Test.stopTest();

        // Blocked either by our custom validation or Salesforce's native
        // restricted-picklist check — both satisfy the requirement.
        System.assertEquals(false, result.isSuccess());
    }

    @isTest
    static void testDuplicateExternalIdOnInsertIsBlocked() {
        External_User__c first = new External_User__c(
            External_Id__c = 5,
            Name__c = 'Original',
            Username__c = 'original',
            Email__c = 'original@example.com',
            Status__c = 'New'
        );
        insert first;

        External_User__c duplicate = new External_User__c(
            External_Id__c = 5,
            Name__c = 'Duplicate',
            Username__c = 'duplicate',
            Email__c = 'duplicate@example.com',
            Status__c = 'New'
        );

        Test.startTest();
        Database.SaveResult result = Database.insert(duplicate, false);
        Test.stopTest();

        System.assertEquals(false, result.isSuccess());
        System.assert(result.getErrors()[0].getMessage().contains('already exists'));
    }

    @isTest
    static void testUpdatingOwnRecordDoesNotFlagAsDuplicate() {
        External_User__c rec = new External_User__c(
            External_Id__c = 6,
            Name__c = 'Self Update',
            Username__c = 'selfupdate',
            Email__c = 'self@example.com',
            Status__c = 'New'
        );
        insert rec;

        rec.Status__c = 'Submitted';

        Test.startTest();
        Database.SaveResult result = Database.update(rec, false);
        Test.stopTest();

        System.assertEquals(true, result.isSuccess());
    }

    @isTest
    static void testUpdateCreatingDuplicateExternalIdIsBlocked() {
        External_User__c first = new External_User__c(
            External_Id__c = 7,
            Name__c = 'First',
            Username__c = 'first',
            Email__c = 'first@example.com',
            Status__c = 'New'
        );
        insert first;

        External_User__c second = new External_User__c(
            External_Id__c = 8,
            Name__c = 'Second',
            Username__c = 'second',
            Email__c = 'second@example.com',
            Status__c = 'New'
        );
        insert second;

        second.External_Id__c = 7;

        Test.startTest();
        Database.SaveResult result = Database.update(second, false);
        Test.stopTest();

        System.assertEquals(false, result.isSuccess());
        System.assert(result.getErrors()[0].getMessage().contains('already exists'));
    }
}