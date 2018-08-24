trigger My_PrescriptionTrigger on My_Prescription__c (before update)  {
    if(Trigger.isBefore && Trigger.isUpdate) {
        My_Prescription_TH.beforeUpdate(Trigger.newMap);
    }
}