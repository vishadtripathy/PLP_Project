public with sharing class EmployeeController {
    
    @AuraEnabled(Cacheable=true)
    public static Employee__c[] getAllEmployees() {
        return [SELECT Comments__c,Employee_Email__c,
                Employee_ID__c,Experience__c,
                Name,Primary_Skill__c,Secondary_Skill__c 
                FROM Employee__c ORDER BY Name];
    }

    @AuraEnabled(Cacheable=true)
    public static Employee__c[] searchEmployees(String searchTerm) {
        // Return all bears when no search term
        searchTerm = searchTerm.trim();
        if (searchTerm == '') {
            return getAllEmployees();
        }
        // Prepare query paramters
        searchTerm = '%'+ searchTerm +'%';
        // Execute search query
        return [SELECT Comments__c,Employee_Email__c,
                Employee_ID__c,Experience__c,
                Name,Primary_Skill__c,Secondary_Skill__c 
                FROM Employee__c
                WHERE Name LIKE :searchTerm
                ORDER BY Name];
    }
}