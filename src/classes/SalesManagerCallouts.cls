/**
 * Created by anast on 29.10.2022.
 */

public with sharing class SalesManagerCallouts {
    @AuraEnabled
    public static Boolean makePostCallout(Id recordId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setEndpoint('https://avenga-school.herokuapp.com/push-data');

        Sales_Manager__c salesManager = [SELECT Id, Name, Email__c, Is_Synced__c FROM Sales_Manager__c WHERE Id = :recordId];
        String serialSales = JSON.serialize(salesManager);
        request.setBody(serialSales);

        Boolean result = false;
        try {
            HttpResponse response = http.send(request);
            System.debug(response.getBody());
            System.debug('Status code: ' + response.getStatusCode());

            if (response.getStatusCode() == 200){
                salesManager.Is_Synced__c = true;
                update salesManager;
                result = true;
            }
        } catch (System.CalloutException e) {
            System.debug(e.getMessage());
            return false;
        }
        return result;
    }
}