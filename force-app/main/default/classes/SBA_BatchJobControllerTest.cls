@isTest
public class SBA_BatchJobControllerTest {
    @isTest 
    static void testSBA_BatchJobController() {
        // Arrange
        String selectedBatchJobName = 'SBA_DummyBatchJob'; // Assume 'SBA_DummyBatchJob' is a valid batch job
        
        // Act
        Test.startTest();
        SBA_BatchJobController.runSBA_BatchJob(selectedBatchJobName);
        Test.stopTest();
        
        // Assert
        // Add assertions based on the expected outcomes of running the batch job
    }

    @isTest
    static void testGetSBA_BatchJobNames() {
        // Act
        Test.startTest();
        List<String> batchJobNames = SBA_BatchJobController.getSBA_BatchJobNames();
        Test.stopTest();

        // Assert
        System.assertNotEquals(null, batchJobNames, 'The batch job names list should not be null');
    }
}