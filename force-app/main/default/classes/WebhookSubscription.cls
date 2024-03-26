/**
 * @description       : 
 * @author            : marco.casanova@vurpix.com
 * @group             : 
 * @last modified on  : 03-26-2024
 * @last modified by  : marco.casanova@vurpix.com
**/
@restResource(urlMapping='/pushDetails')//with this
global class WebhookSubscription {
	@HttpPost
    global static void handleNotification(){
        try{
            RestRequest request = RestContext.request;
        	Blob requestbody = request.requestBody; 
            RestResponse response = RestContext.response;

            
            JSONParser parser = JSON.createParser(request.requestBody.toString());
            pusher ps;
            //head_commit hc;
            
            String repo;

        
            
            while(parser.nextToken() != null){
                if(parser.getText() == 'pusher'){
                    system.debug('inside pusher');
                    parser.nextToken();
                    ps = (Pusher)parser.readValueAs(Pusher.class);
                    system.debug(ps);
                }
                /*
                if(parser.getText() == 'head_commit'){
                    system.debug('inside head_commit');
                    parser.nextToken();
                    hc = (Head_commit)parser.readValueAs(Head_commit.class);
                    system.debug(hc);
                }
                if(parser.getText() == 'full_name'){
                    system.debug('inside full_name');
                    parser.nextToken();
                    repo = parser.getText();
                    system.debug(repo);
                }
                */
            }

            GitHub_PushDetails__c detail = new GitHub_PushDetails__c(
                Commiter_Name__c = ps != null ? ps.name : '',
                Commiter_Email__c = ps != null ? ps.email : ''
                
                
            /*
                Commit_Message__c = ps != null ? hc.message : '',
                Commit_Timestamp__c = ps != null ? hc.timestamp : '',
                Commited_URL__c = ps != null ? hc.url : '',
                Repository_Name__c = ps != null ? repo : '',
                Added_Components__c = hc != null && hc.added != null ? String.join(hc.added, ',') : '',
                Removed_Components__c = hc != null && hc.removed != null ? String.join(hc.removed, ',') : '',
                Modified_components__c = hc != null && hc.modified != null ? String.join(hc.modified, ',') : ''
            */
            );
            insert detail;
            response.statusCode = 200;
            response.responseBody = Blob.valueOf(JSON.serialize(new SFDCResponse('Success','Processed Sucesssfully')));



        }catch(exception e){
 			system.debug('exception'+e.getMessage());
        }

    }
    public class SFDCResponse{
        String response;
        String message;
        public SFDCResponse(String resp, String msg){
            response = resp;
            message = msg;
        }
    }
    public class Pusher{
        public String name;
        public String email;
        public pusher(String name, String email){
            name = name;
            email = email;
        }
    }
    /*
    public class Head_commit{
        String message;
        String url; 
        String added;
        String removed;
        String modified;

        public Head_commit(String message, String url ,String added, String removed, String modified){
            message = message;
            url = url;
            added = added;
            removed = removed;
            modified = modified;  
        }
    }
    */
    
}