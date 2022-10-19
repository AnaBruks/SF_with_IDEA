/**
 * Created by anast on 17.10.2022.
 */

trigger DealTrigger on Deal__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate)
            DealTriggerHandler.onBeforeInsert(Trigger.new);
    }
}