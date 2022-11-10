/**
 * Created by anast on 19.10.2022.
 */

@IsTest
private class SoqlMethodsTest {
    static List<Deal__c> deals = new List<Deal__c>();
    static List<Sales_Manager__c> sales = UtilFactory.createSalesManager(3);
    static List<Car__c> cars = UtilFactory.createCar(10); // 5 valid + 5 not valid

    @TestSetup
    public static void dataSetup() {
        insert cars;
        insert sales;
        //IMPORTANT! when status sets WON or LOST  -> End_Date__c = System.now() 2022.10.(21)
        Deal__c deals1 = new Deal__c(
                Start_Date__c = DateTime.newInstance(2000, 1, 28),
                End_Date__c = DateTime.newInstance(2002, 1, 28),
                Sales_Manager__c = sales.get(2).Id,
                Car__c = cars.get(1).Id);
        insert deals1;
        deals1.Status__c = 'Won';

        Deal__c deals2 = new Deal__c(
                Start_Date__c = Datetime.newInstance(2021, 1, 29),
                End_Date__c = DateTime.newInstance(2021, 5, 28),
                Sales_Manager__c = sales.get(2).Id,
                Car__c = cars.get(3).Id); //2won
        insert deals2;
        deals2.Status__c = 'Won';

        Deal__c deals3 = new Deal__c(
                Start_Date__c = DateTime.newInstance(2022, 1, 28),
                End_Date__c = DateTime.newInstance(2022, 8, 28),
                Sales_Manager__c = sales.get(1).Id,
                Car__c = cars.get(5).Id
        ); //1 won
        insert deals3;
        deals3.Status__c = 'Won';

        Deal__c deals4 = new Deal__c(
                Start_Date__c = DateTime.newInstance(2022, 2, 28),
                End_Date__c = DateTime.newInstance(2023, 1, 28),
                Sales_Manager__c = sales.get(1).Id,
                Car__c = cars.get(7).Id
        );
        insert deals4;

        Deal__c deals5 = new Deal__c(
                Start_Date__c = DateTime.newInstance(2000, 1, 28),
                End_Date__c = DateTime.newInstance(2023, 1, 28),
                Sales_Manager__c = sales.get(0).Id,
                Car__c = cars.get(9).Id);                       //0 won
        insert deals5;
        deals5.Status__c = 'Lost';

        deals.add(deals1);
        deals.add(deals2);
        deals.add(deals3);
        deals.add(deals4);
        deals.add(deals5);
        update deals;
    }

    @IsTest
    static void getWonDealsForPeriodTest() {
        List<Deal__c> d = [SELECT Id FROM Deal__c];
        List<Deal__c> dealss = new List<Deal__c>();
        dealss.add(d[1]);
        dealss.add(d[2]);

        Test.startTest();
        List<Deal__c> wonDeals = CarRentServices.getWonDeals(Datetime.newInstance(1999, 01, 20),
                DateTime.newInstance(2104, 6, 28));   // 3
        List<Deal__c> wonDeals2 = CarRentServices.getWonDeals(Datetime.newInstance(2020, 01, 02),
                DateTime.newInstance(2104, 6, 28));   // 2
        List<Deal__c> wonDeals3 = CarRentServices.getWonDeals(Datetime.newInstance(2023, 01, 28), System.now()); //0
        Test.stopTest();

        System.assert(wonDeals.size() == 3, 'CarRentServices.getWonDeals: wrong number of won deals');
        System.assert(wonDeals2.size() == 2, 'CarRentServices.getWonDeals: wrong number of won deals');
        System.assert(wonDeals3.size() == 0, 'CarRentServices.getWonDeals: wrong number of won deals');

        System.assertEquals(dealss, wonDeals2, 'CarRentServices.getWonDeals: wrong deals found!');
    }

    @IsTest
    static void getWonDealsBySalesManagerIdsTest() {
        Map<Id, Integer> wonBySM = new Map<Id, Integer>();

        List<Sales_Manager__c> salesManagers = [SELECT Id FROM Sales_Manager__c];
        Set<Id> ids = new Set<Id>();

        for (Integer i = 1; i < sales.size(); i++) {
            ids.add(salesManagers.get(i).Id);
            wonBySM.put(salesManagers.get(i).Id, i);
        }
        Test.startTest();
        Map<Id, Integer> result = CarRentServices.getWonDealsBySalesManagerIds(ids);
        Test.stopTest();

        System.assert(result.size() == 2, 'CarRentServices.getWonDealsBySalesManagerIds: all sales managers should be counted');
        System.assertEquals(wonBySM, result, 'CarRentServices.getWonDealsBySalesManagerIds: won deals are counted incorrectly');
    }

    @IsTest
    static void getCarsAvailableForRentTest() {
        List<Car__c> c = [SELECT Id, Is_Valid_For_Rent__c, Model__c FROM Car__c WHERE Is_Valid_For_Rent__c = TRUE];
        List<Car__c> availableCars = new List<Car__c>();
        availableCars.add(c.get(0));
        availableCars.add(c.get(1));
        availableCars.add(c.get(3));
        availableCars.add(c.get(7));

        List<Car__c> availableCars2 = new List<Car__c>();
        availableCars2.add(c.get(3));

        Test.startTest();
        List<Car__c> result = CarRentServices.getCarsAvailableForRent(Date.newInstance(2000, 01, 01),
                Date.newInstance(2999, 01, 20));//4
        List<Car__c> result2 = CarRentServices.getCarsAvailableForRent(Date.newInstance(2022, 01, 01),
                Date.newInstance(2999, 01, 20));//1
        Test.stopTest();

        System.assert(result.size() == 4, 'CarRentServices.getCarsAvailableForRent: wrong quantity of cars');
        System.assertEquals(availableCars, result, 'CarRentServices.getCarsAvailableForRent: wrong cars are counted');

        System.assert(result2.size() == 1, 'CarRentServices.getCarsAvailableForRent: wrong quantity of cars');
        System.assertEquals(availableCars2, result2, 'CarRentServices.getCarsAvailableForRent: wrong cars are counted');
    }

    @IsTest
    static void getCarRentStatisticTest() {
        Map<Id, Integer> rentStat = new Map<Id, Integer>();
        List<Car__c> carsDeals = [SELECT Id FROM Car__c];
        rentStat.put(carsDeals[1].Id, 1);
        rentStat.put(carsDeals[3].Id, 1);
        rentStat.put(carsDeals[5].Id, 1);
        rentStat.put(carsDeals[7].Id, 1);
        rentStat.put(carsDeals[9].Id, 1);

        Test.startTest();
        Map<Id, Integer> result = CarRentServices.getCarRentStatistic();
        Test.stopTest();

        System.assert(result.size() == 5, 'CarRentServices.getCarRentStatistic: all cars should be counted');
        System.assertEquals(rentStat, result, 'CarRentServices.getCarRentStatistic: cars are counted incorrectly');

    }

    @IsTest
    static void getTopRatedSalesRepOfYearTest() {
        Sales_Manager__c best = [
                SELECT Id
                FROM Sales_Manager__c
                WHERE Email__c = 'ana2@gmail.com'
        ];
        Test.startTest();
        Sales_Manager__c bestResult = (Sales_Manager__c) (CarRentServices.getTopRatedSalesRepOfYear(2022));
        Test.stopTest();

        System.assertEquals(best.Id, bestResult.Id, 'CarRentServices.getTopRatedSalesRepOfYear: this isn\'t the best sales manager');
    }
}