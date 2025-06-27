public with sharing class TwilioSMSService1 {
    @AuraEnabled
    public static void sendReminder(Id recordId) {
        if (recordId == null) {
            throw new AuraHandledException('No record ID provided.');
        }

        SBAPPS__Customer_Credit__c credit = [
            SELECT SBAPPS__Customer__r.Name,
                   SBAPPS__Customer__r.SBAPPS__Customer_Contact__c,
                   SBAPPS__Outstanding_Amount__c,
                   SBAPPS__Due_Date__c
            FROM SBAPPS__Customer_Credit__c
            WHERE Id = :recordId
            LIMIT 1
        ];
        String accountSid = Label.Twilio_Account_SID;



        String phone = credit.SBAPPS__Customer__r.SBAPPS__Customer_Contact__c;
        if (String.isBlank(phone)) {
            throw new AuraHandledException('No phone number found for the customer.');
        }

        String name = credit.SBAPPS__Customer__r.Name;
        String amount = credit.SBAPPS__Outstanding_Amount__c != null ? String.valueOf(credit.SBAPPS__Outstanding_Amount__c) : '0';
        String dueDate = credit.SBAPPS__Due_Date__c != null ? String.valueOf(credit.SBAPPS__Due_Date__c) : 'soon';

        String message = 'Hi ' + name + ', your payment of ₹' + amount + ' is due on ' + dueDate +
                         '. Please pay at your earliest convenience. - CoLiv Team';

        sendSMSAsync(phone, message);
    }

    @future(callout=true)
    public static void sendSMSAsync(String toPhoneNumber, String messageBody) {
        String fromPhoneNumber = '+19206949482'; // Optional: can move to custom label if needed
        String accountSid = Label.Twilio_Account_SID;

        Http http = new Http();
        HttpRequest req = new HttpRequest();

        // Secure endpoint using Named Credential + Label
        String endpoint = 'callout:SBAPPS__Twilio/2010-04-01/Accounts/' + accountSid + '/Messages.json';
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        // Encode the form data
        String body = 'To=' + EncodingUtil.urlEncode(toPhoneNumber, 'UTF-8') +
                      '&From=' + EncodingUtil.urlEncode(fromPhoneNumber, 'UTF-8') +
                      '&Body=' + EncodingUtil.urlEncode(messageBody, 'UTF-8');
        req.setBody(body);

        HttpResponse res = http.send(req);
        System.debug('Twilio SMS Response: ' + res.getBody());
    }
}