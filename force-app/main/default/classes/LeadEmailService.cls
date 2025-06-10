public class LeadEmailService {

    public static void createIndividualRecordsAndSendEmails(List<Lead> leads) {
        // Create and insert Individual records
        List<Individual> individualsToInsert = new List<Individual>();
        for (Lead newLead : leads) {
            Individual ind = new Individual();
            ind.Unique_Id__c = newLead.uniqueCodeEncrypted__c;
            ind.LastName = newLead.LastName;
            individualsToInsert.add(ind);
        }
        insert individualsToInsert;

        String orgWideEmailAddressId = getOrgWideEmailAddressId();
        
        // Create and send email messages
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        //String emailTemplateId = '00X5j000000IpXzEAK'; // Replace with your template ID
        String emailTemplateId = System.Label.EmailTemplateId;
        for (Lead newLead : leads) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTemplateId(emailTemplateId);
            email.setToAddresses(new String[] { newLead.Email });
            email.setTargetObjectId(newLead.Id);
            email.setOrgWideEmailAddressId(orgWideEmailAddressId);
            
            // String unsubscribeUrl = 'https://grtech.my.site.com/consent/s?unique_id=' + newLead.uniqueCodeEncrypted__c;
            // email.setSubject('Welcome & Your Subscription Preferences');
            String unsubscribeUrl = 'https://singingbirdapps.my.site.com/consent/s?unique_id=' + newLead.uniqueCodeEncrypted__c;
            email.setSubject('Welcome & Your Subscription Preferences');
            String customEmailBody = 'Hello,\n\nWe respect your inbox. \nWhile you currently won\'t receive regular updates from us, there might be critical notifications or alerts in the future.\nIf you prefer not to receive any emails from us at all \nYou can unsubscribe here: ' + unsubscribeUrl + '\n\nThank you for choosing us.\nWarm regards,\nSinging Bird Apps.';
            email.setPlainTextBody(customEmailBody);
            emailList.add(email);
        }
        Messaging.sendEmail(emailList);
    }
    // Helper method to retrieve the organization-wide email address
    private static String getOrgWideEmailAddressId() {
        OrgWideEmailAddress orgWideEmail = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'contact@singingbirdapps.com' LIMIT 1];
        if (orgWideEmail != null) {
            return orgWideEmail.Id;
        } else {
            // Handle the case where the organization-wide email address is not found
            // You can log an error or take appropriate action here.
            return null;
        }
    }
}