/**
 * Created by anast on 09.10.2022.
 */

public with sharing class CarRentServices {

    // will receive list of records and set End_Date__c to today
    public void setEndDate(List<Deal__c> list) {
        for (Deal__c deal : list) {
            deal.End_Date__c = System.today();
        }
    }


// return Rent deals that are Won or Lost. Input params: List<Deal__c> deals, String status.
// The method should return List<Deal__c> filtered by Status__c.

    public List<Deal__c> fillterFinished(List<Deal__c> deals, String status) {
        List<Deal__c> result = new List<Deal__c>();
        for (Deal__c deal : deals) {
            if (deal.Status__c == status)
                result.add(deal);
        }
        return result;
    }
}