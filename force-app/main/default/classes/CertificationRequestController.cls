public with sharing class CertificationRequestController {

    @AuraEnabled(Cacheable=true)
    public static Certification_Request__c[] getAllCertificationRequests() {
        return [SELECT Due_Date__c,Name,Status__c 
                FROM Certification_Request__c 
                ORDER BY Name];
    }
    
    @AuraEnabled(Cacheable=true)
    public static Certification_Request__c[] searchCertificationRequests(String searchTerm) {
        // Return all bears when no search term
        searchTerm = searchTerm.trim();
        if (searchTerm == '') {
            return getAllCertificationRequests();
        }
        // Prepare query paramters
        searchTerm = '%'+ searchTerm +'%';
        // Execute search query
        return [SELECT Due_Date__c,Name,Status__c 
                FROM Certification_Request__c
                WHERE Name LIKE :searchTerm
                ORDER BY Name];
    }
}