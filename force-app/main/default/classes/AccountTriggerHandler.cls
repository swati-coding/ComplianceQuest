public class AccountTriggerHandler {
 
    // Create two team member whenever account is created
    
    public static void afterInsert(List<Account> accountList){
        List<SQX_Team_Members__c> teamMemberList = new List<SQX_Team_Members__c>();
        for(Account ac :accountList){
            SQX_Team_Members__c team1 = new SQX_Team_Members__c();
            team1.Name = 'Team Member 1';
            team1.AccountId__c = ac.id;
            SQX_Team_Members__c team2 = new SQX_Team_Members__c();
            team2.Name = 'Team Member 2';
            team2.AccountId__c = ac.id;
            teamMemberList.add(team1);
            teamMemberList.add(team2);
        }
        
        if(teamMemberList.size() > 0){
            insert teamMemberList;
        }
        
    }
    
    // Not allowed to activate account if team members not contain HR and Admin
    
    public static void beforeUpdate(List<Account> accountList){
        List<SQX_Team_Members__c> teamMembers = [SELECT Id,Name,Contact_Info__c,Member_Type__c,AccountId__c FROM SQX_Team_Members__c WHERE AccountId__c IN:accountList ];
        Map<Id,List<String>> acIdVSmemberType = new Map<Id,List<String>>();
        for(Account ac:accountList){
            for(SQX_Team_Members__c team:teamMembers){
                if(!acIdVSmemberType.containsKey(ac.Id)){
                    acIdVSmemberType.put(ac.id,new List<String>());
                }
                acIdVSmemberType.get(ac.id).add(team.Member_Type__c);
            }
        }
        for(Account ac:accountList){
            if(ac.Active__c){
                if(acIdVSmemberType.containsKey(ac.id)){
                    List<String> checType =acIdVSmemberType.get(ac.Id);
                    if(!(checType.contains('HR') && checType.contains('Admin')) ){
                        ac.addError('not allowed to activate account');
                    }
                }
                
            }
              
        }
        
    }
}