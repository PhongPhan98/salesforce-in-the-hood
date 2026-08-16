trigger ExternalUserTrigger on External_User__c (before insert, before update) {
    ExternalUserTriggerHandler.handle(
        Trigger.new,
        Trigger.oldMap,
        Trigger.isInsert,
        Trigger.isUpdate
    );
}