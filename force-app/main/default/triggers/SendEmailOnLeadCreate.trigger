trigger SendEmailOnLeadCreate on Lead (before insert, after insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        LeadEncryptionService.setUniqueEncryptedCodes(Trigger.new);
    } else if (Trigger.isAfter && Trigger.isInsert) {
        LeadEmailService.createIndividualRecordsAndSendEmails(Trigger.new);
    }
}