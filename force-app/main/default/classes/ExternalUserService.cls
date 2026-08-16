public with sharing class ExternalUserService {

    @AuraEnabled(cacheable=true)
    public static List<ExternalUserWrapper> getExternalUsers() {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://jsonplaceholder.typicode.com/users');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');

        try {
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                return ExternalUserWrapper.parse(res.getBody());
            } else {
                throw new AuraHandledException(
                    'Callout failed with status: ' + res.getStatusCode()
                );
            }
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving users: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static ExternalUserWrapper submitExternalUser(String name, String email) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://jsonplaceholder.typicode.com/users');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        Map<String, Object> body = new Map<String, Object>{
            'name' => name,
            'email' => email
        };
        req.setBody(JSON.serialize(body));

        try {
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 201 || res.getStatusCode() == 200) {
                return (ExternalUserWrapper) JSON.deserialize(res.getBody(), ExternalUserWrapper.class);
            } else {
                throw new AuraHandledException('Submit failed with status: ' + res.getStatusCode());
            }
        } catch (Exception e) {
            throw new AuraHandledException('Error submitting user: ' + e.getMessage());
        }
    }
}