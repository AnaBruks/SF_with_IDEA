/**
 * Created by anast on 17.10.2022.
 */

trigger CarsTrigger on Car__c (after insert, after update) {
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        CarTriggerHandler.onAfterInsert(Trigger.new);
    }
}