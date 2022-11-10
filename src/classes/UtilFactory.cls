/**
 * Created by anast on 19.10.2022.
 */

@IsTest
public class UtilFactory {
    public static List<Sales_Manager__c> createSalesManager(Integer quantity) {
        List<Sales_Manager__c> salesManagers = new List<Sales_Manager__c>();
        for (Integer i = 0; i < quantity; i++) {
            salesManagers.add(new Sales_Manager__c(Name = 'Ana' + i, Email__c = 'ana' + i + '@gmail.com'));
        }
        return salesManagers;
    }

    public static List<Car__c> createCar(Integer quantity) {
        List<Car__c> cars = new List<Car__c>();
        for (Integer i = 0; i < quantity; i++) {
            if (i / 2 == 0) // 0, 2, 4, 6,.. - not valid
                cars.add(new Car__c (Is_Valid_For_Rent__c = false, Model__c = 'Toyota Corova' + i));
            cars.add(new Car__c(Is_Valid_For_Rent__c = true, Model__c = 'Lada Baklazhan' + i));
        }
        return cars;
    }
}