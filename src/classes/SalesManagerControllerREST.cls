@RestResource(urlMapping='/Sales_Manager__c/getFiveOldest*')
global with sharing class SalesManagerControllerREST{

        @HttpGet
        global static List<Sales_Manager__c> getFiveOldestManagers() {
           return [SELECT Id, Name, Birth_Date__c FROM Sales_Manager__c WHERE Birth_Date__c!=null  ORDER BY Birth_Date__c ASC LIMIT 5];
         }
}