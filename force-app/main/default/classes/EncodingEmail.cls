public with sharing class EncodingEmail {
    public static String encryptWithAES(String clearText, Blob cryptoKey) {
        Blob data = Blob.valueOf(clearText);
        Blob encryptedData = Crypto.encryptWithManagedIV('AES128', cryptoKey, data);
        return EncodingUtil.base64Encode(encryptedData);
    }
    
}