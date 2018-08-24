trigger EventTrigger on Event (after insert, after update)  {
    if(Trigger.isAfter && Trigger.isInsert) {
        Event_TH.afterInsert(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isUpdate) {
        Event_TH.afterUpdate(Trigger.new);
    }
}