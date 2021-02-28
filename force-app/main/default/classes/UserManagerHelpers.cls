public class UserManagerHelpers {
  public static Boolean fromRest = String.valueOf(URL.getCurrentRequestUrl())
    .toLowerCase()
    .contains('services/apexrest');
  public class CustomError {
    public String nameEmpty = 'Name can not be empty';
    public String noName = 'Please provide a name';
    public String phoneNumberInvalid = 'That is not a valid phone Number. Format: "nnn-nnn-nnnn". Example: "444-333-4444"';
    public String duplicateName = 'There is another user with that name';
    public String noId = 'There was no Id provided';
    public String noUsers = 'There are no users';
    public String userNotFound = 'User not found';
    public String userWasDeleted = 'User was deleted before';
    public String invalidBillingState = 'Billing State should be a valid 2-character US state abbreviation. Example: Washington - WA';
    public String invalidBillingCountry = 'Billing Country could be only US, USA, United States, or be in blank';
  }

  public class UserResponse {
    public string msg;
    public Account user;
    public List<Account> users;
    public boolean success;
  }
  public static String userResponseMsgMapper(
    String errMsg,
    CustomError customError
  ) {
    if (errMsg.contains(customError.nameEmpty)) {
      return customError.nameEmpty;
    } else if (errMsg.contains(customError.noName)) {
      return customError.noName;
    } else if (errMsg.contains(customError.duplicateName)) {
      return customError.duplicateName;
    } else if (errMsg.contains(customError.phoneNumberInvalid)) {
      return customError.phoneNumberInvalid;
    } else if (errMsg.contains(customError.invalidBillingState)) {
      return customError.invalidBillingState;
    } else if (errMsg.contains(customError.invalidBillingCountry)) {
      return customError.invalidBillingCountry;
    }
    return errMsg;
  }
  public static String getUserId(RestRequest req) {
    return req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
  }
  public static boolean checkUserNumber(string phoneNumber) {
    if (phoneNumber == null) {
      return false;
    }
    String regExPhone = '^[0-9]\\d{2}-\\d{3}-\\d{4}$';
    Boolean valid = Pattern.matches(regExPhone, phoneNumber);
    if (valid == true) {
      return true;
    }
    return false;
  }
  public static boolean checkBillingCountry(string billingCountry) {
    if (billingCountry == null) {
      return false;
    }
    List<String> validBillingCountry = new List<String>{
      'US',
      'USA',
      'United States'
    };
    Set<String> validBillingCountrySet = new Set<String>();
    validBillingCountrySet.addAll(validBillingCountry);
    if (validBillingCountrySet.contains(billingCountry)) {
      return true;
    }
    return false;
  }
  public static boolean checkBillingState(string billingState) {
    if (billingState == null) {
      return false;
    }
    List<String> twoCharacterUsStateAbrev = new List<String>{
      'AL',
      'AK',
      'AS',
      'AZ',
      'AR',
      'CA',
      'CO',
      'CT',
      'DE',
      'DC',
      'FL',
      'GA',
      'GU',
      'HI',
      'ID',
      'IL',
      'IN',
      'IA',
      'KS',
      'KY',
      'LA',
      'ME',
      'MD',
      'MA',
      'MI',
      'MN',
      'MS',
      'MO',
      'MT',
      'NE',
      'NV',
      'NH',
      'NJ',
      'NM',
      'NY',
      'NC',
      'ND',
      'MP',
      'OH',
      'OK',
      'OR',
      'PA',
      'PR',
      'RI',
      'SC',
      'SD',
      'TN',
      'TX',
      'UT',
      'VT',
      'VA',
      'VI',
      'WA',
      'WV',
      'WI',
      'WY'
    };
    Set<String> twoCharacterUsStateAbrevSet = new Set<String>();
    twoCharacterUsStateAbrevSet.addAll(twoCharacterUsStateAbrev);
    if (twoCharacterUsStateAbrevSet.contains(billingState)) {
      return true;
    }
    return false;
  }
  public static void validateNewAccountName(Account a) {
    Boolean fromRest = UserManagerHelpers.fromRest;
    UserManagerHelpers.CustomError customError = new UserManagerHelpers.CustomError();
    if (String.isBlank(a.Name) == true) {
      a.Name.addError(customError.nameEmpty);
      return;
    } else if (a.Name == 'null Household') {
      if (fromRest == true) {
        // From Api Rest
        a.Name.addError(customError.noName);
        return;
      }
    } else if (a.Name.trim() == 'Household') {
      if (fromRest == true) {
        a.Name.addError(customError.nameEmpty);
        return;
      }
    }
  }
}
