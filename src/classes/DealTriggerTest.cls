/**
 * Created by anast on 20.10.2022.
 */

@IsTest
private class DealTriggerTest {
 //   static List<Deal__c> deals = new List<Deal__c>();
    static List<Sales_Manager__c> sales = UtilFactory.createSalesManager(10);
    static List<Car__c> cars = UtilFactory.createCar(10); // 5 valid + 5 not valid

    @IsTest
    static void duplicatedDealTest() {
        insert sales;
        insert cars;
        Deal__c deals1 = new Deal__c(Start_Date__c = DateTime.newInstance(2000, 1, 28),
                End_Date__c = DateTime.newInstance(2002, 1, 28),
                Sales_Manager__c = sales.get(2).Id,
                Car__c = cars.get(1).Id);

        Deal__c deals2 = new Deal__c(Start_Date__c = Datetime.newInstance(2021, 1, 29),
                End_Date__c = DateTime.newInstance(2021, 5, 28),
                Sales_Manager__c = sales.get(2).Id,
                Car__c = cars.get(3).Id);

        Deal__c deals3 = new Deal__c(Start_Date__c = Datetime.newInstance(2021, 1, 29),
                End_Date__c = DateTime.newInstance(2021, 5, 28),
                Sales_Manager__c = sales.get(2).Id,
                Car__c = cars.get(3).Id);

        Test.startTest();
        Database.SaveResult result1 = Database.insert(deals1, false);
        Database.SaveResult result2 = Database.insert(deals2, false);
        Database.SaveResult result3 = Database.insert(deals3, false);
        Test.stopTest();

        System.assert(result1.isSuccess(), 'DealTriggerHandler.onBeforeInsert: not duplicate');
        System.assert(result2.isSuccess(), 'DealTriggerHandler.onBeforeInsert: not duplicate');
        System.assert(!result3.isSuccess(), 'DealTriggerHandler.onBeforeInsert: this is a duplicate');
        System.assertEquals(result3.getErrors()[0].getMessage(), 'You\'re trying to create a duplicate',
                'DealTriggerHandler.onBeforeInsert: there must be an error!');

    }
}