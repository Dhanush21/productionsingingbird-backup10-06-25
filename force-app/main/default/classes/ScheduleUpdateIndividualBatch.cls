global class ScheduleUpdateIndividualBatch implements Schedulable {
    global void execute(SchedulableContext SC) {
        UpdateIndividualBatch batch = new UpdateIndividualBatch();
        database.executeBatch(batch);
    }
}