public class LeadEncryptionService {

    public static void setUniqueEncryptedCodes(List<Lead> leads) {
        for (Lead newLead : leads) {
            if (newLead.uniqueCodeEncrypted__c == null) {
                // Create a crypto key for AES encryption
                Blob cryptoKey = Crypto.generateAesKey(128);

                // Encrypt the email address to generate the unique ID
                String encryptedEmail = EncodingEmail.encryptWithAES(newLead.Email, cryptoKey);

                // Set the encrypted email as the unique ID
                newLead.uniqueCodeEncrypted__c = encryptedEmail;

                // Debug statement to show the generated unique code
                System.debug('Generated Unique Code: ' + encryptedEmail);
            }
        }
    }
}