/**
 * Created by anast on 17.10.2022.
 */

public with sharing class CarTriggerHandler {
    public static void onAfterInsert(List<Car__c> cars) {
        List<Car__c> notValidCars = new List<Car__c>();
        for (Car__c car : cars) {
            if (!car.Is_Valid_For_Rent__c)
                notValidCars.add(car);
        }
        if (notValidCars.size() > 0) {
            List<Deal__c> deals = [SELECT Id FROM Deal__c WHERE Status__c = 'Open' AND Car__r.Id IN :notValidCars];
            for (Deal__c deal : deals) {
                deal.Status__c = 'Lost';
            }
            update deals;
        }
    }
}