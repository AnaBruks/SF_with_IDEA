/**
 * Created by anast on 09.10.2022.
 */

public with sharing class CarRentServices {
    public void setEndDate(List<Deal__c> dealsList) {
        if (dealsList == null || dealsList.isEmpty())
            return;
        for (Deal__c deal : dealsList)
            deal.End_Date__c = System.today();
    }
    public List<Deal__c> filterFinished(List<Deal__c> deals, String status) {
        if (deals.isEmpty() || deals == null)
            return null;
        List<Deal__c> result = new List<Deal__c>();
        for (Deal__c deal : deals) {
            if (deal.Status__c == status)
                result.add(deal);
        }
        return result;
    }


    public static Database.SaveResult createSalesManager(String name, Date birthdate, String email) {
        Sales_Manager__c sm = new Sales_Manager__c(Name = name, Birth_Date__c = birthdate, Email__c = email);
        return Database.insert(sm, true);
    }
    public static void createNewDeal(Datetime startDate, Datetime endDate, Id salesRepId, Id carId) {
        Deal__c deal = new Deal__c(Start_Date__c = startDate,
                End_Date__c = endDate,
                Sales_Manager__c = salesRepId,
                Car__c = carId,
                Status__c = 'Open');
        insert deal;
    }
    public static void deactivateCar(Id carId) {
        List<Deal__c> dealsList = [
                SELECT Id
                FROM Deal__c
                WHERE Car__r.Id = :carId AND Status__c = 'Open'
        ];
        for (Deal__c d : dealsList) {
            d.Status__c = 'Lost';
        }
        update dealsList;

        Car__c lostCar = [SELECT Id FROM Car__c WHERE Id = :carId LIMIT 1];
        lostCar.Is_Valid_For_Rent__c = false;
        update lostCar;
    }
    public static Database.SaveResult updateDeal(Id dealId, Map<String, Object> fieldNameToValue) {
        Deal__c dealToUpdate = [SELECT Id FROM Deal__c WHERE Id = :dealId LIMIT 1];

        for (String key : fieldNameToValue.keySet()) {
            dealToUpdate.put(key, fieldNameToValue.get(key));
        }
        return Database.update(dealToUpdate, true);
    }


    public static List<Deal__c> getWonDeals(DateTime startDate, DateTime endDate) {
        return [
                SELECT Id
                FROM Deal__c
                WHERE Status__c = 'Won' AND Start_Date__c >= :startDate AND End_Date__c <= :endDate
        ];
    }
    public static Map<Id, Integer> getWonDealsBySalesManagerIds(Set <Id> salesManagerIds) {
        Map<Id, Integer> result = new Map<Id, Integer>();

        List<AggregateResult> countResults = [
                SELECT COUNT(Id) amount, Sales_Manager__c sm
                FROM Deal__c
                WHERE Status__c = 'Won'
                AND Sales_Manager__c IN :salesManagerIds
                GROUP BY Sales_Manager__c
        ];

        for (AggregateResult count_res : countResults) {
            result.put((Id) (count_res.get('sm')), (Integer) (count_res.get('amount')));
        }
        return result;
    }
    public static List<Car__c> getCarsAvailableForRent(Date rentStart, Date rentEnd) {
        return (List<Car__c>) [
                SELECT Id, Is_Valid_For_Rent__c, Model__c
                FROM Car__c WHERE Is_Valid_For_Rent__c = TRUE
                AND Id IN (
                        SELECT Car__c
                        FROM Deal__c
                        WHERE Start_Date__c >=:rentStart AND End_Date__c <=:rentEnd AND Status__c != 'Open'
                )
        ];
    }
    public static Map<Id, Integer> getCarRentStatistic() {
        Map<Id, Integer> result = new Map<Id, Integer>();
        List<AggregateResult> timesOfRent = [      // get number of rents from deals for cars that have deals
                SELECT COUNT(Id) amount, Car__c car
                FROM Deal__c
                GROUP BY Car__c
        ];
//        List<AggregateResult> timesOfRent0 = [
//                SELECT COUNT(Deals__r) amount, Id car
//                FROM Car__c
//               WHERE Deals__r IN (SELECT Id FROM Deal__c WHERE Car__r.Id = car)
//                GROUP BY Id
//        ];

        for (AggregateResult number_rents : timesOfRent) {
            result.put((Id) number_rents.get('car'), (Integer) (number_rents.get('amount')));
        }
        return result;
    }
    public static Sales_Manager__c getTopRatedSalesRepOfYear(Integer year) {
        List<AggregateResult> wonDealsNumber = [
                SELECT COUNT(Id) n, Sales_Manager__r.Id sid
                FROM Deal__c
                WHERE Status__c = 'Won' AND CALENDAR_YEAR(End_Date__c) = :year
                GROUP BY Sales_Manager__r.Id
                ORDER BY COUNT(Id) DESC
        ];
        return  new Sales_Manager__c(Id = (Id) wonDealsNumber[0].get('sid') );
    }


}