import 'dart:convert';

class AccountResponseModel {
  String id;
  DateTime membershipExpirationDate;
  String registrar;
  String referrer;
  String lifetimeReferrer;
  int networkFeePercentage;
  int lifetimeReferrerFeePercentage;
  int referrerRewardsPercentage;
  String name;
  Active owner;
  Active active;
  Options options;
  String statistics;
  List<dynamic> whitelistingAccounts;
  List<dynamic> blacklistingAccounts;
  List<dynamic> whitelistedAccounts;
  List<dynamic> blacklistedAccounts;
  String cashbackVb;
  List<dynamic> ownerSpecialAuthority;
  List<dynamic> activeSpecialAuthority;
  int topNControlFlags;

  AccountResponseModel({
    this.id,
    this.membershipExpirationDate,
    this.registrar,
    this.referrer,
    this.lifetimeReferrer,
    this.networkFeePercentage,
    this.lifetimeReferrerFeePercentage,
    this.referrerRewardsPercentage,
    this.name,
    this.owner,
    this.active,
    this.options,
    this.statistics,
    this.whitelistingAccounts,
    this.blacklistingAccounts,
    this.whitelistedAccounts,
    this.blacklistedAccounts,
    this.cashbackVb,
    this.ownerSpecialAuthority,
    this.activeSpecialAuthority,
    this.topNControlFlags,
  });

  factory AccountResponseModel.fromRawJson(String str) =>
      AccountResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AccountResponseModel.fromJson(Map<String, dynamic> json) =>
      new AccountResponseModel(
        id: json["id"],
        membershipExpirationDate:
            DateTime.parse(json["membership_expiration_date"]),
        registrar: json["registrar"],
        referrer: json["referrer"],
        lifetimeReferrer: json["lifetime_referrer"],
        networkFeePercentage: json["network_fee_percentage"],
        lifetimeReferrerFeePercentage: json["lifetime_referrer_fee_percentage"],
        referrerRewardsPercentage: json["referrer_rewards_percentage"],
        name: json["name"],
        owner: Active.fromJson(json["owner"]),
        active: Active.fromJson(json["active"]),
        options: Options.fromJson(json["options"]),
        statistics: json["statistics"],
        whitelistingAccounts:
            new List<dynamic>.from(json["whitelisting_accounts"].map((x) => x)),
        blacklistingAccounts:
            new List<dynamic>.from(json["blacklisting_accounts"].map((x) => x)),
        whitelistedAccounts:
            new List<dynamic>.from(json["whitelisted_accounts"].map((x) => x)),
        blacklistedAccounts:
            new List<dynamic>.from(json["blacklisted_accounts"].map((x) => x)),
        cashbackVb: json["cashback_vb"],
        ownerSpecialAuthority: new List<dynamic>.from(
            json["owner_special_authority"].map((x) => x)),
        activeSpecialAuthority: new List<dynamic>.from(
            json["active_special_authority"].map((x) => x)),
        topNControlFlags: json["top_n_control_flags"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "membership_expiration_date":
            membershipExpirationDate.toIso8601String(),
        "registrar": registrar,
        "referrer": referrer,
        "lifetime_referrer": lifetimeReferrer,
        "network_fee_percentage": networkFeePercentage,
        "lifetime_referrer_fee_percentage": lifetimeReferrerFeePercentage,
        "referrer_rewards_percentage": referrerRewardsPercentage,
        "name": name,
        "owner": owner.toJson(),
        "active": active.toJson(),
        "options": options.toJson(),
        "statistics": statistics,
        "whitelisting_accounts":
            new List<dynamic>.from(whitelistingAccounts.map((x) => x)),
        "blacklisting_accounts":
            new List<dynamic>.from(blacklistingAccounts.map((x) => x)),
        "whitelisted_accounts":
            new List<dynamic>.from(whitelistedAccounts.map((x) => x)),
        "blacklisted_accounts":
            new List<dynamic>.from(blacklistedAccounts.map((x) => x)),
        "cashback_vb": cashbackVb,
        "owner_special_authority":
            new List<dynamic>.from(ownerSpecialAuthority.map((x) => x)),
        "active_special_authority":
            new List<dynamic>.from(activeSpecialAuthority.map((x) => x)),
        "top_n_control_flags": topNControlFlags,
      };
}

class Active {
  int weightThreshold;
  List<dynamic> accountAuths;
  List<List<dynamic>> keyAuths;
  List<dynamic> addressAuths;

  Active({
    this.weightThreshold,
    this.accountAuths,
    this.keyAuths,
    this.addressAuths,
  });

  factory Active.fromRawJson(String str) => Active.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Active.fromJson(Map<String, dynamic> json) => new Active(
        weightThreshold: json["weight_threshold"],
        accountAuths:
            new List<dynamic>.from(json["account_auths"].map((x) => x)),
        keyAuths: new List<List<dynamic>>.from(json["key_auths"]
            .map((x) => new List<dynamic>.from(x.map((x) => x)))),
        addressAuths:
            new List<dynamic>.from(json["address_auths"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "weight_threshold": weightThreshold,
        "account_auths": new List<dynamic>.from(accountAuths.map((x) => x)),
        "key_auths": new List<dynamic>.from(
            keyAuths.map((x) => new List<dynamic>.from(x.map((x) => x)))),
        "address_auths": new List<dynamic>.from(addressAuths.map((x) => x)),
      };
}

class ActiveSpecialAuthorityClass {
  ActiveSpecialAuthorityClass();

  factory ActiveSpecialAuthorityClass.fromRawJson(String str) =>
      ActiveSpecialAuthorityClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ActiveSpecialAuthorityClass.fromJson(Map<String, dynamic> json) =>
      new ActiveSpecialAuthorityClass();

  Map<String, dynamic> toJson() => {};
}

class Options {
  String memoKey;
  String votingAccount;
  int numWitness;
  int numCommittee;
  List<dynamic> votes;
  List<dynamic> extensions;

  Options({
    this.memoKey,
    this.votingAccount,
    this.numWitness,
    this.numCommittee,
    this.votes,
    this.extensions,
  });

  factory Options.fromRawJson(String str) => Options.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Options.fromJson(Map<String, dynamic> json) => new Options(
        memoKey: json["memo_key"],
        votingAccount: json["voting_account"],
        numWitness: json["num_witness"],
        numCommittee: json["num_committee"],
        votes: new List<dynamic>.from(json["votes"].map((x) => x)),
        extensions: new List<dynamic>.from(json["extensions"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "memo_key": memoKey,
        "voting_account": votingAccount,
        "num_witness": numWitness,
        "num_committee": numCommittee,
        "votes": new List<dynamic>.from(votes.map((x) => x)),
        "extensions": new List<dynamic>.from(extensions.map((x) => x)),
      };
}
