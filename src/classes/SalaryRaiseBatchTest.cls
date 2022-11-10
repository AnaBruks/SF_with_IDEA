/**
 * Created by anast on 27.10.2022.
 */

@IsTest
private class SalaryRaiseBatchTest {
    @TestSetup
    static void setup() {
        List<Sales_Manager__c> smList = new List<Sales_Manager__c>();
        for (Integer i = 0; i < 200; i++) {
            smList.add(new Sales_Manager__c(Name = 'Alice' + i, Email__c = 'alice' + i + '@gmail.com',
                    LastRaiseDate__c = Date.newInstance(2020, 07, 01),
                    Salary__c = 100));
        }
        insert smList;

        List<Car__c> cars = new List<Car__c>();
        for (Integer i = 0; i < 200; i++) {
            cars.add(new Car__c(Name = 'car' + i, Model__c = 'sedan' + i));
        }
        insert cars;

        List<Deal__c> paramDeals = new List<Deal__c>();
        for (Integer i = 0; i < 200; i++) {
            paramDeals.add(new Deal__c(Status__c = 'Open', Sales_Manager__c = smList.get(i).Id,
                    Start_Date__c = Datetime.newInstance(2021, 07, 01),
                    End_Date__c = Datetime.newInstance(2022, 09, 01),
                    Car__c = cars.get(i).Id));
        }
        insert paramDeals;

        for (Deal__c d : paramDeals)
            d.Status__c = 'Won'; //today?
        update paramDeals;
    }

    @IsTest
    static void testSalaryBatch() {
        Test.startTest();
        SalaryRaiseBatch job = new SalaryRaiseBatch();
        Id batchId = Database.executeBatch(job);
        Test.stopTest();

        List<Sales_Manager__c> managersToCheck = [SELECT Id, Salary__c, LastRaiseDate__c FROM Sales_Manager__c];

        System.assert(!managersToCheck.isEmpty(),'Empty list!'); //check for emptiness of the list
        for (Sales_Manager__c sales : managersToCheck) {
            System.assertEquals(110, sales.Salary__c, 'Wrong salary!');
            System.assertEquals(System.today(), sales.LastRaiseDate__c, 'Last raise is today!');
        }
    }
}