trigger AccountUpdate on Account(before update) {
  Account oldAccount = Trigger.old[0];
  Account newAccount = Trigger.new[0];
  Boolean fromRest = UserManagerHelpers.fromRest;
  UserManagerHelpers.CustomError customError = new UserManagerHelpers.CustomError();
  UserManagerHelpers.validateNewAccountName(newAccount);

  if (newAccount.Phone != null) {
    // A phone was provided
    if (UserManagerHelpers.checkUserNumber(newAccount.Phone) != true) {
      newAccount.Phone.addError(customError.phoneNumberInvalid);
      return;
    }
  }
  if (newAccount.BillingState != null) {
    // A phone was provided
    if (UserManagerHelpers.checkBillingState(newAccount.BillingState) != true) {
      newAccount.BillingState.addError(customError.invalidBillingState);
      return;
    }
  }
  if (newAccount.BillingCountry != null) {
    // A phone was provided
    if (!UserManagerHelpers.checkBillingCountry(newAccount.BillingCountry)) {
      newAccount.BillingCountry.addError(customError.invalidBillingCountry);
      return;
    }
  }

  List<Account> userList = [
    SELECT Id
    FROM Account
    WHERE Name = :newAccount.name
  ];

  if (userList.size() > 1) {
    newAccount.Name.addError(customError.duplicateName);
    return;
  } else if (userList.size() == 1) {
    if (userList[0].Id != oldAccount.Id) {
      newAccount.Name.addError(customError.duplicateName);
      return;
    }
  }
}
