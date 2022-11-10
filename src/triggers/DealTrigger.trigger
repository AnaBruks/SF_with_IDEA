/**
 * Created by anast on 17.10.2022.
 */

trigger DealTrigger on Deal__c (before insert) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert)
            DealTriggerHandler.onBeforeInsert(Trigger.new);
    }
}