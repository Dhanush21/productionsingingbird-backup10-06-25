public class BatchJobCaller_1 {
    public void executeBatchJob() {
        NotifyInactiveUsersBatchManagerNotify batchJobNotifyMgr = new NotifyInactiveUsersBatchManagerNotify();
        Database.executeBatch(batchJobNotifyMgr);
        NotifyInactiveUsersNotifyBeforeDay batchJobNotifyMgrTwo = new NotifyInactiveUsersNotifyBeforeDay();
        Database.executeBatch(batchJobNotifyMgrTwo);
    
    }
}