public class SBA_BatchJobController {
    
    @AuraEnabled(cacheable=true)
    public static List<String> getSBA_BatchJobNames() {
        List<String> batchJobNames = new List<String>();
        for (ApexClass ac : [SELECT Name FROM ApexClass WHERE Name LIKE '%Batch%']) {
            batchJobNames.add(ac.Name);
        }
        return batchJobNames;
    }

    @AuraEnabled
    public static void runSBA_BatchJob(String jobName) {
        Type b = Type.forName(jobName);
        if(b != null) {
            Database.Batchable<sObject> batchClass = (Database.Batchable<sObject>) b.newInstance();
            Database.executeBatch(batchClass);
        }
    }
}