trigger RejectionCommentsMandatory on Certification_Request__c (before update) 
{

  Map<Id, Certification_Request__c> rejectedStatements 
             = new Map<Id, Certification_Request__c>{};

  for(Certification_Request__c req: trigger.new)
  {
    /* 
      Get the old object record, and check if the approval status 
      field has been updated to rejected. If so, put it in a map 
      so we only have to use 1 SOQL query to do all checks.
    */
    Certification_Request__c oldCert = System.Trigger.oldMap.get(req.Id);

    if (oldCert.Status__c != 'Rejected' 
     && req.Status__c == 'Rejected')
    { 
      rejectedStatements.put(req.Id, req);  
    }
  }
   
  if (!rejectedStatements.isEmpty())  
  {
    // Get the most recent approval process instance for the object.
    // If there are some approvals to be reviewed for approval, then
    // get the most recent process instance for each object.
    List<Id> processInstanceIds = new List<Id>{};
    
    for (Certification_Request__c requests : [SELECT (SELECT ID
                                              FROM ProcessInstances
                                              ORDER BY CreatedDate DESC
                                              LIMIT 1)
                                      FROM Certification_Request__c
                                      WHERE ID IN :rejectedStatements.keySet()])
    {
        processInstanceIds.add(requests.ProcessInstances[0].Id);
    }
      
    // Now that we have the most recent process instances, we can check
    // the most recent process steps for comments.  
    for (ProcessInstance pi : [SELECT TargetObjectId,
                                   (SELECT Id, StepStatus, Comments 
                                    FROM Steps
                                    ORDER BY CreatedDate DESC
                                    LIMIT 1 )
                               FROM ProcessInstance
                               WHERE Id IN :processInstanceIds
                               ORDER BY CreatedDate DESC])   
    {                   
      if ((pi.Steps[0].Comments == null || 
           pi.Steps[0].Comments.trim().length() == 0))
      {
        rejectedStatements.get(pi.TargetObjectId).addError(
          'Operation Cancelled: Please provide a rejection reason!');
      }
    }  
  }
}