# SF_with_IDEA
CarRentServices CLASS includes the following tasks:

1) method setEndDate() that will receive list of records and set End_Date__c to today
2) method fillterFinished() which should return Rent deals that are Won or Lost. Input params: List<Deal__c> deals, String status. The method should return List<Deal__c> filtered by Status__c.


getWonDeals	(DateTime startDate, DateTime endDate)           	Return list of all deals of status Won are in specified date range
getWonDealsBySalesManagerIds(Set<Id> salesManagerIds)	        return map, where key - sales manager id and value - number of won deals.
getCarsAvailableForRent	(Date rentStart, Date rentEnd)      	Get all cars available for rent right now. Availability is defined by Deal's Start/End dates and Status
getCarRentStatistic()	                                        Return map, where key - car id, and value - number of times car was rent.
getTopRatedSalesRepOfYear	(Integer year)                    	Get sales rep record who made the most won deals of the specified year

createSalesManager	(String name, Date birthdate)           	                    create new Sales Manager record.
createNewDeal (DateTime startDate, DateTime endDate, Id salesRepId, Id carId)   	create new Deal
updateDeal (Id dealId, Map<String, Object> fieldNameToValue)                    	update deal with values in a map
deactivateCar	(Id carId)                                    	  Car got broken. Update all open deals for this car with Status Lost. Car's IsAvailableForRent set false.
