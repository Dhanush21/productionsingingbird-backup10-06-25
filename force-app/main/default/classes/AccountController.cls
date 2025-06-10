public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String accountId) {
        return [SELECT Name, Title, Email, Phone FROM Contact WHERE AccountId = :accountId];
    }
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpenOpportunities(String accountId) {
        // Replace this query with your logic to fetch the open opportunities related to the Account.
        return [SELECT Id, Name, StageName, Amount FROM Opportunity WHERE AccountId = :accountId];
    }
}