trigger CertificationRequest on Certification_Request__c ( before insert , before update ) {
	//Before insert actions
	if( trigger.isBefore && trigger.isInsert )
    {
        //Fetch all records of Certification Requests in the org
        list<Certification_Request__c> allCertReq = [ SELECT Certification__c,Employee__c,Status__c,Voucher__c 
                                                      FROM Certification_Request__c ];

        for( Certification_Request__c newReq : trigger.new )
        {
            newReq.Status__c = 'Draft';
            for( Certification_Request__c oldReq : allCertReq )
            {
                if(( newReq.Certification__c == oldReq.Certification__c ) && ( newReq.Employee__c == oldReq.Employee__c ) && ( oldReq.Status__c != 'Rejected' ))
                {
                    if( oldReq.Status__c == 'Passed' )
                    	newReq.addError( 'Employee has already applied and cleared this Certification' );
                    else if( oldReq.Status__c == 'Failed' )
                        newReq.addError( 'Employee has already applied and failed in this Certification' );
                    else
                    	newReq.addError( 'This Certification Request has already been raised for this Employee' );
                    break;
                }
                
                if(( newReq.Employee__c == oldReq.Employee__c ) && ( oldReq.Status__c == 'Draft' ))
                {
                    newReq.addError( 'The Employee already has a pending Certification Request' );
            		break;
                }
            }
            if(newReq.Voucher__c != null )
            {
                Voucher__c voucherValue = [SELECT Active__c, Id 
                                          FROM Voucher__c
                                          WHERE Active__c = true AND Id = :newReq.Voucher__c ];
                voucherValue.Active__c = false;
                update voucherValue;
            }
        }
    }
    
    
    //Before Update actions
    if( trigger.isBefore && trigger.isUpdate )
    {
        for( Certification_Request__c request : trigger.new )
        {
            Certification_Request__c oldValue = Trigger.oldMap.get(request.Id);
            if( request.Status__c == 'Approved' && oldValue.Status__c != 'Approved' )
            {
                Voucher__c[] voucherValue = [SELECT Name, Id, Voucher_ID__c
                                           FROM Voucher__c 
                                           WHERE Active__c = true AND Certification__c = :request.Certification__c 
                                           ORDER BY Voucher_Cost__c DESC NULLS LAST LIMIT 1];
                if( !voucherValue.isEmpty() )
                {
                    request.Status__c = 'Assigned';
                    request.Voucher__c = voucherValue[0].Id;
                    voucherValue[0].Active__c = false;
                }
                update voucherValue;
            }
        }
    }
    	
}