@isTest
private class IndividualConsentManagerTest {

    @isTest static void testUpdateIndividualOptOutStatusByUniqueId() {
        // Setup test data
        // Create a test Individual record
        Individual testIndividual = new Individual();
        testIndividual.Unique_Id__c = 'TestUniqueId123';
        testIndividual.HasOptedOutProcessing = false;
        insert testIndividual;

        // Test data preparation is complete here
        // Begin testing the method functionality

        // Test for valid unique ID and opt-out status change
        Test.startTest();
        String resultSuccess = IndividualConsentManager.updateIndividualOptOutStatusByUniqueId('TestUniqueId123', true);
        Test.stopTest();

        // Verify the method returns success message
        System.assertEquals('Consent updated successfully.', resultSuccess);

        // Retrieve the updated record to verify the change
        Individual updatedIndividual = [SELECT HasOptedOutProcessing FROM Individual WHERE Id = :testIndividual.Id];
        System.assertEquals(true, updatedIndividual.HasOptedOutProcessing, 'The opt-out status should be updated to true.');

        // Test for invalid unique ID
        String resultInvalidId = IndividualConsentManager.updateIndividualOptOutStatusByUniqueId('InvalidUniqueId', true);
        System.assertEquals('No Individual record found with the provided unique ID.', resultInvalidId);

        // Optionally, you can add more test cases for different scenarios like blank uniqueId, exception handling, etc.
    }
}