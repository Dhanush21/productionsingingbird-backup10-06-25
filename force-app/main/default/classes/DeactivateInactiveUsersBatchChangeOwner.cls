global class DeactivateInactiveUsersBatchChangeOwner implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    private List<String> deactivatedUserEmails = new List<String>();
    Map<Id, Id> userToManagerMap = new Map<Id, Id>();
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Retrieve the last login days value from the custom label
        Integer lastLoginDays = Integer.valueOf(Label.Last_Login_Date);
        
        // Calculate the last login date value
        Date lastLoginDate = Date.today().addDays(-lastLoginDays);
        
        // Query for the user records that have not logged in since the last login date
        String query = 'SELECT Id, Email, LastLoginDate,ManagerId FROM User WHERE IsActive = true AND Id = \'0055i000007QRZIAA4\' AND (LastLoginDate <= :lastLoginDate OR LastLoginDate = null)';
        //String query = 'SELECT Id, Email, LastLoginDate,ManagerId FROM User WHERE IsActive = true  AND (LastLoginDate <= :lastLoginDate OR LastLoginDate = null)';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<User> scope) {
        if (scope != null && !scope.isEmpty()) {
            System.debug('Batch job executing with scope: ' + scope);
            // Query for the Account records owned by the inactive users
            List<Account> accountsToUpdate = [SELECT Id, OwnerId FROM Account WHERE OwnerId IN :scope];
            // Query for the Contact records owned by the inactive user
            List<Contact> contactsToUpdate = [SELECT Id, OwnerId FROM Contact WHERE OwnerId IN :scope];
            // Query for the Opportunity records owned by the inactive user
            List<Opportunity> opportunitiesToUpdate = [SELECT Id, OwnerId FROM Opportunity WHERE OwnerId IN :scope];
            // Query for the Lead records owned by the inactive user
            List<Lead> leadsToUpdate = [SELECT Id, OwnerId FROM Lead WHERE OwnerId IN :scope];
            // Query for the Case records owned by the inactive user
            List<Case> casesToUpdate = [SELECT Id, OwnerId FROM Case WHERE OwnerId IN :scope];
            
            
            //Map<Id, Id> userToManagerMap = new Map<Id, Id>();
            // Build a map of user to manager Ids
            for (User u : scope) {
                userToManagerMap.put(u.Id, u.ManagerId);
            }
            // Update the Account records with the new OwnerIds
            for (Account acc : accountsToUpdate) {
                Id ownerId = acc.OwnerId;
                Id newOwnerId = userToManagerMap.get(ownerId);
                if (newOwnerId != null) {
                    acc.OwnerId = newOwnerId;
                }
            }
            //update accountsToUpdate;
            
            // Update the OwnerId field of the Contact records to the manager ID
            for (Contact con : contactsToUpdate) {
                Id managerId = userToManagerMap.get(con.OwnerId);
                if (managerId != null) {
                    con.OwnerId = managerId;
                }
            }
            //update contactsToUpdate;
            
            
            // Update the OwnerId field of the Opportunity records to the manager ID
            for (Opportunity opp : opportunitiesToUpdate) {
                Id managerId = userToManagerMap.get(opp.OwnerId);
                if (managerId != null) {
                    opp.OwnerId = managerId;
                }
            }
            
            // update opportunitiesToUpdate;
            
            // Update the OwnerId field of the Lead records to the manager ID
            for (Lead lead : leadsToUpdate) {
                Id managerId = userToManagerMap.get(lead.OwnerId);
                if (managerId != null) {
                    lead.OwnerId = managerId;
                }
            }
            
            //update leadsToUpdate;
            
            // Update the OwnerId field of the Case records to the manager ID
            for (Case caserec : casesToUpdate) {
                Id managerId = userToManagerMap.get(caserec.OwnerId);
                if (managerId != null) {
                    caserec.OwnerId = managerId;
                }
            }
            
            //update casesToUpdate;
            
            Database.update(accountsToUpdate, false);
            Database.update(contactsToUpdate, false);
            Database.update(opportunitiesToUpdate, false);
            Database.update(leadsToUpdate, false);
            Database.update(casesToUpdate, false);
            
            
            
            // Deactivate the user records that have not logged in since the last login date
            List<User> usersToUpdate = new List<User>();
            for (User u : scope) {
                u.IsActive = false;
                usersToUpdate.add(u);
                if (u.Email != null) {
                    deactivatedUserEmails.add(u.Email);
                }
            }
            // Update the inactive User records
            if (!usersToUpdate.isEmpty()) {
                System.debug('udpating record>>> usersToUpdate .'+usersToUpdate);
                // Database.SaveResult[] srList = Database.update(usersToUpdate, false);
                //System.enqueueJob(new UserUpdater(usersToUpdate));
                // Check the returned results for any errors
                /*for (Database.SaveResult sr : srList) {
if (!sr.isSuccess()) {
// Operation was not successful, so get all errors
for(Database.Error err : sr.getErrors()) {
System.debug('The following error has occurred.');
System.debug(err.getStatusCode() + ': ' + err.getMessage());
System.debug('User fields that affected this error: ' + err.getFields());
}
}
}*/
                
                //                   Database.update(usersToUpdate, false);
            }
            
            //update usersToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('Batch job finished.');
        // v3 starts	
        EmailTemplate emailTemplateOne  = [SELECT Id FROM EmailTemplate WHERE DeveloperName = : 'Mov_UserDeactivationNotifyUserThree' LIMIT 1];	
        EmailTemplate emailTemplateOneManager  = [SELECT Id FROM EmailTemplate WHERE DeveloperName = : 'Mov_UserDeactivationNotifyManagerThree' LIMIT 1];	
        // v3 ends
        
        
        
        // Send an email to the users whose accounts have been deactivated
        if (!deactivatedUserEmails.isEmpty()) {
            //Mov_UserDeactivationNotifyUserThree
            System.debug('Sending deactivation emails to: ' + deactivatedUserEmails);
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            for (String emailAddress : deactivatedUserEmails) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new List<String>{emailAddress});
                //email.setSubject('Your Salesforce account has been deactivated due to inactivity');
                //email.setPlainTextBody('Dear User,\n\nYour Salesforce account has been deactivated due to inactivity. Please contact your Salesforce administrator to reactivate your account.\n\nThank you,\nSalesforce Admin');
                // v3 starts commentthis  	
                email.setSubject('Your Salesforce account has been deactivated due to inactivity');
                email.setPlainTextBody('Dear User,\n\nYour Salesforce account has been deactivated due to inactivity. Please contact your Salesforce administrator to reactivate your account.\n\nThank you,\nSalesforce Admin');
                // v3 ends commentthis 	
                /* v3 starts	
email.setTemplateId(emailTemplateOne.Id);	
//email.setTargetObjectId(user.id); 	
email.setTargetObjectId(getUserByEmail(emailAddress).Id);
email.setSaveAsActivity(false);	
v3 ends*/ 
                
                emails.add(email);
            }
            Messaging.sendEmail(emails);
        }
        // Send an email to the manager
        if (!userToManagerMap.isEmpty()) {
            System.debug('Sending email to managers.');
            Set<Id> userIds = new Set<Id>(userToManagerMap.keySet());
            Map<Id, User> usersMap = new Map<Id, User>([SELECT Id, Name FROM User WHERE Id IN :userIds]);
            
            
            List<Messaging.SingleEmailMessage> managerEmails = new List<Messaging.SingleEmailMessage>();
            for (Id userId : userToManagerMap.keySet()) {
                Id managerId = userToManagerMap.get(userId);
                User manager = [SELECT Email FROM User WHERE Id = :managerId];
                User deactivatedUser = usersMap.get(userId); // Fetch the deactivated user from the pre-fetched map
                
                //Mov_UserDeactivationNotifyThree email template
                if (manager.Email != null) {
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(new List<String>{manager.Email});
                    //                email.setSubject('Your team member\'s Salesforce account has been deactivated due to inactivity');
                    //email.setPlainTextBody('Dear Manager,\n\nYour team member\'s Salesforce account has been deactivated due to inactivity. Please contact your Salesforce administrator to reactivate the user account.\n\nThank you,\nSalesforce Admin');
                    //               email.setPlainTextBody('Dear Manager,\n\nYour team member\'s Salesforce account has been deactivated due to inactivity. Please contact your Salesforce administrator to reactivate the user account.\n\nRecords owned by this user: ' + deactivatedUser.Name + ' have been assigned to you.\n\nThank you,\nSalesforce Admin');
                    
                    /* v3 starts commentthis  	
email.setSubject('Your team member\'s Salesforce account has been deactivated due to inactivity');
//email.setPlainTextBody('Dear Manager,\n\nYour team member\'s Salesforce account has been deactivated due to inactivity. Please contact your Salesforce administrator to reactivate the user account.\n\nThank you,\nSalesforce Admin');
email.setPlainTextBody('Dear Manager,\n\nYour team member\'s Salesforce account has been deactivated due to inactivity. Please contact your Salesforce administrator to reactivate the user account.\n\nRecords owned by this user: ' + deactivatedUser.Name + ' have been assigned to you.\n\nThank you,\nSalesforce Admin');

v3 ends commentthis */	
                    // v3 starts	
                    email.setTemplateId(emailTemplateOneManager.Id);	
                    email.setTargetObjectId(manager.id); 	
                    email.setSaveAsActivity(false);	
                    //v3 ends
                    managerEmails.add(email);
                }
            }
            Messaging.sendEmail(managerEmails);
        }   
    }    
}