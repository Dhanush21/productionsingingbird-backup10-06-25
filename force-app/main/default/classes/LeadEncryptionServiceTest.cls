@isTest
private class LeadEncryptionServiceTest {

    @isTest
    static void testSetUniqueEncryptedCodes() {
        // 1. Setup test data
        List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 5; i++) {
            testLeads.add(new Lead(
                LastName = 'TestLastName' + i,
                Email = 'test' + i + '@example.com',
                Company = 'TestCompany' + i  // Added the Company field
            ));
        }

        // Insert the test leads
        insert testLeads;

        // Ensure that none of the leads have the unique code set before the method call
        for (Lead l : testLeads) {
            System.assert(l.uniqueCodeEncrypted__c == null, 'Initial unique code should be null.');
        }

        // 2. Invoke the method
        LeadEncryptionService.setUniqueEncryptedCodes(testLeads);

        // 3. Assert the results
        // Refresh the leads from the database to get the updated field values
        testLeads = [SELECT Id, Email, uniqueCodeEncrypted__c FROM Lead WHERE Id IN :testLeads];
        
        for (Lead l : testLeads) {
            System.assertNotEquals(null, l.uniqueCodeEncrypted__c, 'Encrypted code should be populated.');
            System.assert(l.uniqueCodeEncrypted__c != l.Email, 'Encrypted code should not be the same as the email.');
        }
    }
}