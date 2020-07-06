/**
 * OpportunitiesSelector - Selector class for Opportunity object
 * @author Juan Vaz
 */
public with sharing class OpportunitiesSelector {

    /**
     * Retrieves all the Opportunities filtered by stage
     * @param stage opportunity stage
     * @return list of opportunites having the stage passed in
     */
    public List<Opportunity> getOpportunitiesByStage(String stage){
        String query =  'SELECT id, Stage__c, Amount__c '+
                        'FROM Opportunity ';
                        
        if(String.isNotBlank(stage)){
            query += ' WHERE Stage__c =: stage';
        }                        

        return Database.query(query);
    }

}