global class UpdateIndividualBatch implements Database.Batchable<sObject> {

    // Start method
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // Query only Subscription__c records that have not been updated
        String query = 'SELECT uniqueid__c FROM Subscription__c WHERE updatedInIndividual__c = false';
        return Database.getQueryLocator(query);
    }

    // Execute method
    global void execute(Database.BatchableContext bc, List<Subscription__c> subscriptions) {
        // Collect all unique IDs from subscriptions
        Set<String> uniqueIds = new Set<String>();
        for (Subscription__c sub : subscriptions) {
            uniqueIds.add(sub.uniqueid__c);
        }

        // Query Individual records that match the unique IDs
        List<Individual> individualsToUpdate = [SELECT Id, Unique_Id__c, HasOptedOutProcessing FROM Individual WHERE Unique_Id__c IN :uniqueIds];

        // Update the HasOptedOutProcessing field
        for (Individual ind : individualsToUpdate) {
            ind.HasOptedOutProcessing = true; // Set your logic here
        }

        // Update the Individual records in Salesforce
        update individualsToUpdate;

        // Update the updatedInIndividual__c field in Subscription__c
        for (Subscription__c sub : subscriptions) {
            for (Individual ind : individualsToUpdate) {
                if (sub.uniqueid__c == ind.Unique_Id__c) {
                    sub.updatedInIndividual__c = true;
                    break;
                }
            }
        }

        // Update the Subscription__c records in Salesforce
        update subscriptions;
    }

    // Finish method
    global void finish(Database.BatchableContext bc) {
        // Optional: Operations to be performed after the batch finishes
    }
}