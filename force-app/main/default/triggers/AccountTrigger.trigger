/* Create a new custom object called Team Members (API = SQX_Team_Members__c). You
should be able to add multiple team members to an Account record. */

trigger AccountTrigger on Account (after insert,before Update) {
   if(trigger.isAfter && trigger.isInsert){
        AccountTriggerHandler.afterInsert(trigger.new);
    }
   
    if(trigger.isBefore && trigger.isUpdate){
        AccountTriggerHandler.beforeUpdate(trigger.new);
    }

}