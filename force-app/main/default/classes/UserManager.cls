@RestResource(urlMapping='/users/*')
global with sharing class UserManager {
  @HttpGet
  global static void getUsers() {
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    UserManagerHelpers.UserResponse userResponse = new UserManagerHelpers.UserResponse();
    UserManagerHelpers.CustomError customError = new UserManagerHelpers.CustomError();
    String userId = UserManagerHelpers.getUserId(req);
    res.addHeader('Content-Type', 'application/json');
    if (userId == 'users' || String.isEmpty(userId) == true) {
      List<Account> userList = [
        SELECT
          Name,
          Phone,
          BillingCountry,
          BillingState,
          BillingCity,
          BillingStreet
        FROM Account
      ];
      if (userList.size() == 0) {
        userResponse.msg = customError.noUsers;
      } else if (userList.size() > 0) {
        userResponse.users = userList;
        userResponse.msg = 'Here is the list of users';
      }
      userResponse.success = true;
      res.statusCode = 200;
      res.responseBody = Blob.valueOf(JSON.serializePretty(userResponse, true));
      return;
    }
    List<Account> userList = [
      SELECT
        Name,
        Phone,
        BillingCountry,
        BillingState,
        BillingCity,
        BillingStreet
      FROM Account
      WHERE Id = :userId
    ];
    if (userList.size() == 0) {
      userResponse.msg = customError.userNotFound;
      userResponse.success = false;
      res.statusCode = 404;
      res.responseBody = Blob.valueOf(JSON.serializePretty(userResponse, true));
      return;
    }
    userResponse.user = userList[0];
    userResponse.success = true;
    userResponse.msg = 'User found';
    res.statusCode = 200;
    res.responseBody = Blob.valueOf(JSON.serializePretty(userResponse, true));
    return;
  }
  @HttpDelete
  global static void deleteUser() {
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    UserManagerHelpers.UserResponse userResponse = new UserManagerHelpers.UserResponse();
    UserManagerHelpers.CustomError customError = new UserManagerHelpers.CustomError();
    String userId = UserManagerHelpers.getUserId(req);
    res.addHeader('Content-Type', 'application/json');
    if (userId == 'Users' || String.isEmpty(userId) == true) {
      userResponse.success = false;
      userResponse.msg = customError.noId;
      res.statusCode = 400;
      res.responseBody = Blob.valueOf(JSON.serializePretty(userResponse, true));
      return;
    }
    List<Account> userList = [SELECT Id FROM Account WHERE Id = :userId];
    if (userList.size() == 0) {
      userResponse.success = false;
      userResponse.msg = customError.userNotFound;
      res.statusCode = 404;
      res.responseBody = Blob.valueOf(JSON.serializePretty(userResponse, true));
      return;
    }
    Account thisUser = userList[0];
    delete thisUser;
    userResponse.success = true;
    userResponse.msg = 'User deleted successfully';
    res.statusCode = 200;
    res.responseBody = Blob.valueOf(JSON.serializePretty(userResponse, true));
    return;
  }
  @HttpPut
  global static void updateUser(
    String name,
    String phone,
    String billing_Country,
    String billing_State,
    String billing_City,
    String billing_Street
  ) {
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    UserManagerHelpers.UserResponse userResponse = new UserManagerHelpers.UserResponse();
    UserManagerHelpers.CustomError customError = new UserManagerHelpers.CustomError();
    String userId = UserManagerHelpers.getUserId(req);
    res.addHeader('Content-Type', 'application/json');
    if (userId == 'users' || String.isEmpty(userId)) {
      userResponse.success = false;
      userResponse.msg = customError.noId;
      res.statusCode = 400;
      res.responseBody = Blob.valueOf(JSON.serializePretty(userResponse, true));
      return;
    }
    List<Account> userList = [SELECT Id FROM Account WHERE Id = :userId];
    if (userList.size() == 0) {
      userResponse.success = false;
      userResponse.msg = customError.userNotFound;
      res.statusCode = 404;
      res.responseBody = Blob.valueOf(JSON.serializePretty(userResponse, true));
      return;
    }
    Account thisUser = new Account(
      Id = userId,
      Name = name + ' Household',
      Phone = phone,
      BillingCountry = billing_Country,
      BillingState = billing_State,
      BillingCity = billing_City,
      BillingStreet = billing_Street
    );
    try {
      update thisUser;
    } catch (Exception Err) {
      System.debug(Err);
      String errType = Err.getTypeName();
      String errMsg = Err.getMessage();
      userResponse.success = false;
      userResponse.msg = errMsg;
      res.statusCode = 500;
      if (errType == 'System.DmlException') {
        res.statusCode = 400;
        if (errMsg.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
          userResponse.msg = UserManagerHelpers.userResponseMsgMapper(
            errMsg,
            customError
          );
        }
      }
      res.responseBody = Blob.valueOf(JSON.serializePretty(userResponse, true));
      return;
    }
    userResponse.user = thisUser;
    userResponse.success = true;
    userResponse.msg = 'User updated Successfully';
    res.statusCode = 200;
    res.responseBody = Blob.valueOf(JSON.serializePretty(userResponse, true));
    return;
  }

  @HttpPost
  global static void createUser(
    String name,
    String phone,
    String billing_Country,
    String billing_State,
    String billing_City,
    String billing_Street
  ) {
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    UserManagerHelpers.UserResponse userResponse = new UserManagerHelpers.UserResponse();
    UserManagerHelpers.CustomError customError = new UserManagerHelpers.CustomError();
    res.addHeader('Content-Type', 'application/json');
    Account thisUser = new Account(
      Name = name + ' Household',
      Phone = phone,
      BillingCountry = billing_Country,
      BillingState = billing_State,
      BillingCity = billing_City,
      BillingStreet = billing_Street
    );
    try {
      insert thisUser;
    } catch (Exception Err) {
      System.debug(Err);
      String errType = Err.getTypeName();
      String errMsg = Err.getMessage();
      userResponse.success = false;
      userResponse.msg = errMsg;
      res.statusCode = 500;
      if (errType == 'System.DmlException') {
        res.statusCode = 400;
        if (errMsg.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
          userResponse.msg = UserManagerHelpers.userResponseMsgMapper(
            errMsg,
            customError
          );
        }
      }
      res.responseBody = Blob.valueOf(JSON.serializePretty(userResponse, true));
      return;
    }
    userResponse.user = thisUser;
    userResponse.success = true;
    userResponse.msg = 'User created successfully';
    res.statusCode = 200;
    res.responseBody = Blob.valueOf(JSON.serializePretty(userResponse, true));
    return;
  }
}