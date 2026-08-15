@isTest
private class ExternalUserServiceTest {

    @isTest
    static void testGetExternalUsers_Success() {
        String mockBody = '[{"id":1,"name":"Leanne Graham","username":"Bret",' +
            '"email":"Sincere@april.biz","phone":"1-770-736-8031",' +
            '"website":"hildegard.org","address":{"city":"Gwenborough"},' +
            '"company":{"name":"Romaguera-Crona"}}]';

        Test.setMock(HttpCalloutMock.class, new ExternalUserCalloutMock(200, mockBody));

        Test.startTest();
        List<ExternalUserWrapper> result = ExternalUserService.getExternalUsers();
        Test.stopTest();

        System.assertEquals(1, result.size());
        System.assertEquals('Leanne Graham', result[0].name);
    }

    @isTest
    static void testGetExternalUsers_ErrorResponse() {
        Test.setMock(HttpCalloutMock.class, new ExternalUserCalloutMock(500, '{}'));

        Test.startTest();
        Boolean errorThrown = false;
        try {
            ExternalUserService.getExternalUsers();
        } catch (AuraHandledException e) {
            errorThrown = true;
        }
        Test.stopTest();

        System.assert(errorThrown, 'Expected an AuraHandledException on 500 response');
    }

    @isTest
    static void testGetExternalUsers_EmptyList() {
        Test.setMock(HttpCalloutMock.class, new ExternalUserCalloutMock(200, '[]'));

        Test.startTest();
        List<ExternalUserWrapper> result = ExternalUserService.getExternalUsers();
        Test.stopTest();

        System.assertEquals(0, result.size());
    }
}