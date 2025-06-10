// public with sharing class IndividualConsentManager {

//     @AuraEnabled
//     public static String updateIndividualOptOutStatusByUniqueId(String uniqueId, Boolean hasOptedOut) {


//         // to know which profile is getting accessed by

//         // Get the User's Profile Id
//         Id userProfileId = UserInfo.getProfileId();

//         // Query for the Profile Name
//         String profileName = [SELECT Name FROM Profile WHERE Id = :userProfileId].Name;

//         System.debug('Profile Name: ' + profileName);


//         //end here---
        
//         String actualUniqueId = String.valueOf(uniqueId);
//         System.debug('uniqueId   ' + uniqueId);
//         actualUniqueId = String.escapeSingleQuotes(actualUniqueId);
//         actualUniqueId = actualUniqueId.replace(' ', '+');//new code
//         System.debug('actualUniqueId  ' + actualUniqueId);

//         try {
//             if(String.isBlank(actualUniqueId)) {
//                 return 'Invalid unique ID provided.';
//             }

//             String queryString = 'SELECT Id, HasOptedOutProcessing FROM Individual WHERE Unique_Id__c = \'' + actualUniqueId + '\' LIMIT 1';
            
//             //String queryString = 'SELECT Id, HasOptedOutProcessing FROM Individual WHERE SBAPPS__Unique_Id__c = \'' + actualUniqueId + '\' LIMIT 1';

//             //commenting for testing
//             // List<Individual> individualRecordsTemp = [SELECT Id, HasOptedOutProcessing 
//             //                    FROM Individual 
//             //                    WHERE Id = '0PK5j0000015VtLGAU' 
//             //                    LIMIT 1];
//                               // System.debug(individualRecordTemp);

//             //end code

//             //added for testing 
//             System.debug('queryString ---' + queryString);
            
//             // List<Individual> individualRecordsTemp = [SELECT Id, HasOptedOutProcessing 
//             // FROM Individual              
//             // LIMIT 1];

//             //end of testing

//             //System.debug('queryString>>> ', queryString);
//             List<Individual> individualRecords = Database.query(queryString);
//             System.debug('individualRecords ---' + individualRecords);
//             // Check if any records were returned
//             if(individualRecords.size() > 0) {
//                 Individual individualRecord = individualRecords[0];
				
//                 System.debug('before updating1');
//                 System.debug(individualRecord.HasOptedOutProcessing);
//                 // Update the Individual's HasOptedOutProcessing status
//                 individualRecord.HasOptedOutProcessing = hasOptedOut;
// 				System.debug('before updating2');
//                 System.debug(individualRecord.HasOptedOutProcessing);
//                 // Perform the update
//                 update individualRecord;
                
                

//                 return 'Consent updated successfully.';
//             } else {
//                 return 'No Individual record found with the provided unique ID.';
//             }
//         } catch(Exception e) {
//             return 'Error updating consent: ' + e.getMessage();
//         }
//     }
// }
public with sharing class IndividualConsentManager {

    @AuraEnabled
    public static String updateIndividualOptOutStatusByUniqueId(String uniqueId, Boolean hasOptedOut) {

        // Log the User's Profile Name for debugging
        Id userProfileId = UserInfo.getProfileId();
        String profileName = [SELECT Name FROM Profile WHERE Id = :userProfileId].Name;
        System.debug('Profile Name: ' + profileName);

        String actualUniqueId = String.valueOf(uniqueId);
        System.debug('uniqueId   ' + uniqueId);
        actualUniqueId = String.escapeSingleQuotes(actualUniqueId);
        actualUniqueId = actualUniqueId.replace(' ', '+');//new code
        System.debug('actualUniqueId  ' + actualUniqueId);

        try {
            if (String.isBlank(actualUniqueId)) {
                return 'Invalid unique ID provided.';
            }
            
            String queryString = 'SELECT Id, HasOptedOutProcessing__c FROM Subscription__c WHERE uniqueid__c = \'' + actualUniqueId + '\' LIMIT 1';
            List<Subscription__c> subscriptionRecords = Database.query(queryString);
            System.debug('queryString-------------'+queryString);
            System.debug('subscriptionRecords--------'+subscriptionRecords);
            System.debug('!subscriptionRecords.isEmpty()--------'+!subscriptionRecords.isEmpty());

            if (!subscriptionRecords.isEmpty()) {
                // Record exists, so update it
                
                return 'You have already unsubscribed';
            } else {
                // Record does not exist, so insert new one
                Subscription__c newSubscription = new Subscription__c();
                newSubscription.uniqueid__c = actualUniqueId;
                newSubscription.HasOptedOutProcessing__c = hasOptedOut;
                insert newSubscription;
                return 'Thank you for submitting your request';
            }
        } catch (Exception e) {
            return 'Error updating consent: ' + e.getMessage();
        }
    }
}