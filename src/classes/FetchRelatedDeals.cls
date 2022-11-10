/**
 * Created by anast on 24.10.2022.
 */

public with sharing class FetchRelatedDeals {
    @AuraEnabled(Cacheable=true)
    public static List<Deal__c> retrieveDeals(Id recordId) {

        return (List<Deal__c>) [SELECT Id, Name, Start_Date__c, Status__c // Car__r.Name
        FROM Deal__c
        WHERE Status__c= 'Open' AND Sales_Manager__r.Id =: recordId];
    }
}