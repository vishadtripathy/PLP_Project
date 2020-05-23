trigger VoucherHandler on Voucher__c (after insert, before update) {
    
    if( trigger.isAfter && trigger.isInsert )
    {
        //list<Voucher__c> updateVouchers = new list<Voucher__c>();
        for( Voucher__c voucher : trigger.new )
        {
            if( voucher.Certification__c != null && voucher.Active__c == true )
            {
                Certification_Request__c[] certReq = [SELECT Id,Name 
                                                    FROM Certification_Request__c 
                                                    WHERE Certification__c = :voucher.Certification__c AND Voucher__c = null AND Status__c = 'Approved' 
                                                    ORDER BY CreatedDate ASC NULLS LAST LIMIT 1];
                
                if( !certReq.isEmpty() )
                {
                    Voucher__c updateVouchers = new Voucher__c( Id = voucher.Id , Active__c = false );
                    update updateVouchers;
                    
                    
                    certReq[0].Voucher__c = voucher.Id;
                    certReq[0].Status__c = 'Assigned';
                    update certReq;
                    
                    
                }
            }
        }
        //if( !updateVouchers.isEmpty() ) 
        //{
    	//	update updateVouchers;
        //}
    }
    
    if( trigger.isBefore && trigger.isUpdate )
    {
        for( Voucher__c voucher : trigger.new )
        {
            Certification_Request__c[] certReq = [SELECT Id,Name 
                                                FROM Certification_Request__c
                                                WHERE Voucher__c =: voucher.Id LIMIT 1];
            if( !certReq.isEmpty() )
            {
                voucher.addError( 'Editing cannot be done Voucher already in use' );
            }
        }
    }

}