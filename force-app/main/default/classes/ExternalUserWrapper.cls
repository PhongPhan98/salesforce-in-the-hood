public class ExternalUserWrapper {
    @AuraEnabled public Integer id;
    @AuraEnabled public String name;
    @AuraEnabled public String username;
    @AuraEnabled public String email;
    @AuraEnabled public String phone;
    @AuraEnabled public String website;
    @AuraEnabled public Address address;
    @AuraEnabled public Company company;

    public class Address {
        @AuraEnabled public String city;
    }

    public class Company {
        @AuraEnabled public String name;
    }

    public static List<ExternalUserWrapper> parse(String jsonStr) {
        return (List<ExternalUserWrapper>) JSON.deserialize(
            jsonStr,
            List<ExternalUserWrapper>.class
        );
    }
}