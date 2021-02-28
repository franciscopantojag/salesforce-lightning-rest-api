trigger AccountInsert on Account(before insert) {
  Account a = Trigger.new[0];
  Boolean fromRest = UserManagerHelpers.fromRest;
  UserManagerHelpers.CustomError customError = new UserManagerHelpers.CustomError();
  UserManagerHelpers.validateNewAccountName(a);

  if (a.Phone != null) {
    // A phone was provided
    if (UserManagerHelpers.checkUserNumber(a.Phone) != true) {
      a.Phone.addError(customError.phoneNumberInvalid);
      return;
    }
  }
  if (a.BillingState != null) {
    // A phone was provided
    if (UserManagerHelpers.checkBillingState(a.BillingState) != true) {
      a.BillingState.addError(customError.invalidBillingState);
      return;
    }
  }
  if (a.BillingCountry != null) {
    // A phone was provided
    if (!UserManagerHelpers.checkBillingCountry(a.BillingCountry)) {
      a.BillingCountry.addError(customError.invalidBillingCountry);
      return;
    }
  }

  List<Account> userList = [SELECT Id FROM Account WHERE Name = :a.name];

  if (userList.size() > 0) {
    a.Name.addError(customError.duplicateName);
    return;
  }
}
