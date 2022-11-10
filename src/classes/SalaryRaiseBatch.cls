/**
 * Created by anast on 27.10.2022.
 */

public class SalaryRaiseBatch implements Database.Batchable<SObject>, Schedulable {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
                'SELECT Id, Salary__c, LastRaiseDate__c FROM Sales_Manager__c WHERE LastRaiseDate__c <= LAST_N_MONTHS:6');
    }
    public void execute(Database.BatchableContext bc, List<Sales_Manager__c> sales) {
        for (Deal__c deal : [
                SELECT Id, Sales_Manager__r.Id
                FROM Deal__c
                WHERE End_Date__c >= LAST_N_MONTHS:6 AND Status__c = 'Won'
        ]) {
            for (Sales_Manager__c sm : sales) {
                if (deal.Sales_Manager__r.Id == sm.Id) {
                    sm.Salary__c += 10;
                    sm.LastRaiseDate__c = System.today();
                }
            }
        }
        update sales;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Sales managers records processed. Congrats!');
    }

    public void execute(SchedulableContext context) {
        SalaryRaiseBatch raiseBatch = new SalaryRaiseBatch();
        Id batchId = Database.executeBatch(raiseBatch);
    }
}