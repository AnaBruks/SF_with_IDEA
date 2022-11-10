/**
 * Created by anast on 17.10.2022.
 */

public with sharing class DealTriggerHandler {
    public static void onBeforeInsert(List<Deal__c> deals) { // list of new deals we are creating
        List<Deal__c> wonLostDeals = [
                SELECT Id, Name, Start_Date__c, End_Date__c, Status__c, Car__c
                FROM Deal__c
                WHERE Status__c = 'Won' OR Status__c = 'Open'
        ];
        //IMPORTANT! we ALWAYS create OPEN deals
        for (Deal__c paramDeal : deals) {
            for (Deal__c deal : wonLostDeals) {
                if (paramDeal.Car__c == deal.Car__c
                        && paramDeal.Start_Date__c == deal.Start_Date__c
                        && paramDeal.End_Date__c == deal.End_Date__c && paramDeal.Status__c!='Lost')
                    paramDeal.addError('You\'re trying to create a duplicate');
            }
        }
    }
}



//        Set<Deal__c> dealSet = new Set<Deal__c>();
//        for (Deal__c d : deals) {
//            dealSet.add(d);
//            if (dealSet.size() != deals.size())
//                d.addError('Duplicate!');
//        }

//        List<Deal__c> cloneDeals = deals.deepClone(); // to find the duplicates among deals before the insert
//        for (Deal__c paramDeal : deals) {
//            for (Deal__c clone : cloneDeals) {
//                if (paramDeal.Car__c == clone.Car__c
//                        && paramDeal.Start_Date__c == clone.Start_Date__c
//                        && paramDeal.End_Date__c == clone.End_Date__c)
//                    paramDeal.addError('You\'re trying to create a duplicate');
//            }
//        }