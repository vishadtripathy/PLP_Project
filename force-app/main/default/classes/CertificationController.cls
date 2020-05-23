public with sharing class CertificationController {
	@AuraEnabled(Cacheable=true)
    public static Certification__c[] getAllCertifications() {
        return [SELECT Certification_Name__c,Name,Id
                FROM Certification__c 
                ORDER BY Name];
    }
    
    @AuraEnabled(Cacheable=true)
    public static Certification__c[] searchCertifications(String searchTerm) {
        // Return all bears when no search term
        searchTerm = searchTerm.trim();
        if (searchTerm == '') {
            return getAllCertifications();
        }
        // Prepare query paramters
        searchTerm = '%'+ searchTerm +'%';
        // Execute search query
        return [SELECT Certification_Name__c,Name,Id
                FROM Certification__c
                WHERE Name LIKE :searchTerm
                ORDER BY Name];
    }
}