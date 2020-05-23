public with sharing class VoucherController {
	@AuraEnabled(Cacheable=true)
    public static Voucher__c[] getAllVouchers() {
        return[SELECT Active__c,Certification__c,Name,
               Validity__c,Voucher_Cost__c,Voucher_ID__c 
               FROM Voucher__c];
    }
    
    @AuraEnabled(Cacheable=true)
    public static Voucher__c[] searchVouchers(String searchTerm) {
        // Return all bears when no search term
        searchTerm = searchTerm.trim();
        if (searchTerm == '') {
            return getAllVouchers();
        }
        // Prepare query paramters
        searchTerm = '%'+ searchTerm +'%';
        // Execute search query
        return[SELECT Active__c,Certification__c,Name,
               Validity__c,Voucher_Cost__c,Voucher_ID__c 
               FROM Voucher__c
               WHERE Name LIKE :searchTerm 
               ORDER BY Name];
    }
}