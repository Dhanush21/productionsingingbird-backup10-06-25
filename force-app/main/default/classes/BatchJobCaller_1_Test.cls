@isTest
public class BatchJobCaller_1_Test {
    @isTest
    public static void testExecuteBatchJob() {
        // Create test data if needed
        // ...
        
        // Start test execution
        Test.startTest();
        
        // Execute the first batch job
        Database.Batchable<SObject> batchJob1 = new NotifyInactiveUsersBatchManagerNotify();
        ID job1Id = Database.executeBatch(batchJob1);
        
        // Execute the second batch job
        Database.Batchable<SObject> batchJob2 = new NotifyInactiveUsersNotifyBeforeDay();
        ID job2Id = Database.executeBatch(batchJob2);
        
        // Perform assertions or additional tests if needed
        // ...
        
        // End test execution
        Test.stopTest();
    }
}