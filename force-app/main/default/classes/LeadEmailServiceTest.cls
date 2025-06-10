@isTest
private class LeadEmailServiceTest {

    @isTest static void testCreateIndividualRecordsAndSendEmails() {
        
        // Check for pre-existing Individual records
        Integer preExistingCount = [SELECT COUNT() FROM Individual];
        System.debug('Initial count of Individual before test: ' + preExistingCount);
        
        // Check to make sure the OrgWideEmailAddress exists.
        List<OrgWideEmailAddress> orgWideEmails = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'dhanushtherocker@gmail.com' LIMIT 1];
        System.assert(!orgWideEmails.isEmpty(), 'Expected OrgWideEmailAddress not found for the test. Ensure it exists in the org.');

        // Create Test Leads
        List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 5; i++) {
            Lead newLead = new Lead();
            newLead.LastName = 'TestLast' + i;
            newLead.Email = 'test' + i + '@example.com';
            newLead.Company = 'TestCompany' + i;
            newLead.uniqueCodeEncrypted__c = 'UniqueCode' + i;
            testLeads.add(newLead);
        }
        insert testLeads;

        // Extract the unique codes from the testLeads
        List<String> uniqueCodes = new List<String>();
        for (Lead lead : testLeads) {
            uniqueCodes.add(lead.uniqueCodeEncrypted__c);
        }

        // Call our method to test
        Test.startTest();
        LeadEmailService.createIndividualRecordsAndSendEmails(testLeads);
        Test.stopTest();

        // Debugging the number of Individual records after the operation
        Integer postOpCount = [SELECT COUNT() FROM Individual];
        System.debug('Count of Individual after operation: ' + postOpCount);

        // Verify the Individual records were created using the list of unique codes in the SOQL query
        List<Individual> individuals = [SELECT Id, Unique_Id__c FROM Individual WHERE Unique_Id__c IN :uniqueCodes];
        System.assertEquals(testLeads.size(), postOpCount - preExistingCount, 'Expected number of Individual records not created.');
    }
}