public with sharing class BatchJobCaller_2 {
    public void someMethodCallingBatch() {
        // Get the Account Id (replace 'Your_Account_Id' with the actual Account Id).
        String accountId = 'Your_Account_Id';

        // To call the Batch Apex job, create an instance of MyBatchApexClass and execute it using Database.executeBatch.
        MyBatchApexClass batchApexInstance = new MyBatchApexClass(accountId);
        Integer batchSize = 100; // Set the batch size as needed.
        Database.executeBatch(batchApexInstance, batchSize);
    }
}