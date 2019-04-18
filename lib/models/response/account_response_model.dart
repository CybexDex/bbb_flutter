class AccountResponseModel {
  AccountResponseOwner owner;
  List whitelistedAccounts;
  String registrar;
  List ownerSpecialAuthority;
  String lifetimeReferrer;
  int lifetimeReferrerFeePercentage;
  int referrerRewardsPercentage;
  List activeSpecialAuthority;
  List blacklistingAccounts;
  AccountResponseActive active;
  int topNControlFlags;
  int networkFeePercentage;
  String referrer;
  String membershipExpirationDate;
  String name;
  AccountResponseOptions options;
  String id;
  List blacklistedAccounts;
  List whitelistingAccounts;
  String statistics;

  AccountResponseModel(
      {this.owner,
      this.whitelistedAccounts,
      this.registrar,
      this.ownerSpecialAuthority,
      this.lifetimeReferrer,
      this.lifetimeReferrerFeePercentage,
      this.referrerRewardsPercentage,
      this.activeSpecialAuthority,
      this.blacklistingAccounts,
      this.active,
      this.topNControlFlags,
      this.networkFeePercentage,
      this.referrer,
      this.membershipExpirationDate,
      this.name,
      this.options,
      this.id,
      this.blacklistedAccounts,
      this.whitelistingAccounts,
      this.statistics});

  AccountResponseModel.fromJson(Map<String, dynamic> json) {
    owner = json['owner'] != null
        ? new AccountResponseOwner.fromJson(json['owner'])
        : null;
    if (json['whitelisted_accounts'] != null) {
      whitelistedAccounts = new List();
      (json['whitelisted_accounts'] as List).forEach((v) {
        whitelistedAccounts.add(v);
      });
    }
    registrar = json['registrar'];
    ownerSpecialAuthority = json['owner_special_authority'].cast<int>();
    lifetimeReferrer = json['lifetime_referrer'];
    lifetimeReferrerFeePercentage = json['lifetime_referrer_fee_percentage'];
    referrerRewardsPercentage = json['referrer_rewards_percentage'];
    activeSpecialAuthority = json['active_special_authority'].cast<int>();
    if (json['blacklisting_accounts'] != null) {
      blacklistingAccounts = new List();
      (json['blacklisting_accounts'] as List).forEach((v) {
        blacklistingAccounts.add(v);
      });
    }
    active = json['active'] != null
        ? new AccountResponseActive.fromJson(json['active'])
        : null;
    topNControlFlags = json['top_n_control_flags'];
    networkFeePercentage = json['network_fee_percentage'];
    referrer = json['referrer'];
    membershipExpirationDate = json['membership_expiration_date'];
    name = json['name'];
    options = json['options'] != null
        ? new AccountResponseOptions.fromJson(json['options'])
        : null;
    id = json['id'];
    if (json['blacklisted_accounts'] != null) {
      blacklistedAccounts = new List();
      (json['blacklisted_accounts'] as List).forEach((v) {
        blacklistedAccounts.add(v);
      });
    }
    if (json['whitelisting_accounts'] != null) {
      whitelistingAccounts = new List();
      (json['whitelisting_accounts'] as List).forEach((v) {
        whitelistingAccounts.add(v);
      });
    }
    statistics = json['statistics'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.owner != null) {
      data['owner'] = this.owner.toJson();
    }
    if (this.whitelistedAccounts != null) {
      data['whitelisted_accounts'] =
          this.whitelistedAccounts.map((v) => v.toJson()).toList();
    }
    data['registrar'] = this.registrar;
    data['owner_special_authority'] = this.ownerSpecialAuthority;
    data['lifetime_referrer'] = this.lifetimeReferrer;
    data['lifetime_referrer_fee_percentage'] =
        this.lifetimeReferrerFeePercentage;
    data['referrer_rewards_percentage'] = this.referrerRewardsPercentage;
    data['active_special_authority'] = this.activeSpecialAuthority;
    if (this.blacklistingAccounts != null) {
      data['blacklisting_accounts'] =
          this.blacklistingAccounts.map((v) => v.toJson()).toList();
    }
    if (this.active != null) {
      data['active'] = this.active.toJson();
    }
    data['top_n_control_flags'] = this.topNControlFlags;
    data['network_fee_percentage'] = this.networkFeePercentage;
    data['referrer'] = this.referrer;
    data['membership_expiration_date'] = this.membershipExpirationDate;
    data['name'] = this.name;
    if (this.options != null) {
      data['options'] = this.options.toJson();
    }
    data['id'] = this.id;
    if (this.blacklistedAccounts != null) {
      data['blacklisted_accounts'] =
          this.blacklistedAccounts.map((v) => v.toJson()).toList();
    }
    if (this.whitelistingAccounts != null) {
      data['whitelisting_accounts'] =
          this.whitelistingAccounts.map((v) => v.toJson()).toList();
    }
    data['statistics'] = this.statistics;
    return data;
  }
}

class AccountResponseOwner {
  List<Null> addressAuths;
  List<List> keyAuths;
  int weightThreshold;
  List<Null> accountAuths;

  AccountResponseOwner(
      {this.addressAuths,
      this.keyAuths,
      this.weightThreshold,
      this.accountAuths});

  AccountResponseOwner.fromJson(Map<String, dynamic> json) {
    if (json['address_auths'] != null) {
      addressAuths = new List();
      (json['address_auths'] as List).forEach((v) {
        addressAuths.add(v);
      });
    }
    if (json['key_auths'] != null) {
      keyAuths = new List<List>();
      (json['key_auths'] as List).forEach((v) {
        keyAuths.add(v);
      });
    }
    weightThreshold = json['weight_threshold'];
    if (json['account_auths'] != null) {
      accountAuths = new List();
      (json['account_auths'] as List).forEach((v) {
        accountAuths.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addressAuths != null) {
      data['address_auths'] = this.addressAuths;
    }
    if (this.keyAuths != null) {
      data['key_auths'] = this.keyAuths;
    }
    data['weight_threshold'] = this.weightThreshold;
    if (this.accountAuths != null) {
      data['account_auths'] = this.accountAuths;
    }
    return data;
  }
}

class AccountResponseActive {
  List<Null> addressAuths;
  List<List> keyAuths;
  int weightThreshold;
  List<Null> accountAuths;

  AccountResponseActive(
      {this.addressAuths,
      this.keyAuths,
      this.weightThreshold,
      this.accountAuths});

  AccountResponseActive.fromJson(Map<String, dynamic> json) {
    if (json['address_auths'] != null) {
      addressAuths = new List();
      (json['address_auths'] as List).forEach((v) {
        addressAuths.add(v);
      });
    }
    if (json['key_auths'] != null) {
      keyAuths = new List<List>();
      (json['key_auths'] as List).forEach((v) {
        keyAuths.add(v);
      });
    }
    weightThreshold = json['weight_threshold'];
    if (json['account_auths'] != null) {
      accountAuths = new List();
      (json['account_auths'] as List).forEach((v) {
        accountAuths.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addressAuths != null) {
      data['address_auths'] = this.addressAuths;
    }
    if (this.keyAuths != null) {
      data['key_auths'] = this.keyAuths;
    }
    data['weight_threshold'] = this.weightThreshold;
    if (this.accountAuths != null) {
      data['account_auths'] = this.accountAuths;
    }
    return data;
  }
}

class AccountResponseOptions {
  int numWitness;
  List<Null> extensions;
  String memoKey;
  String votingAccount;
  int numCommittee;
  List<Null> votes;

  AccountResponseOptions(
      {this.numWitness,
      this.extensions,
      this.memoKey,
      this.votingAccount,
      this.numCommittee,
      this.votes});

  AccountResponseOptions.fromJson(Map<String, dynamic> json) {
    numWitness = json['num_witness'];
    if (json['extensions'] != null) {
      extensions = new List();
      (json['extensions'] as List).forEach((v) {
        extensions.add(v);
      });
    }
    memoKey = json['memo_key'];
    votingAccount = json['voting_account'];
    numCommittee = json['num_committee'];
    if (json['votes'] != null) {
      votes = new List();
      (json['votes'] as List).forEach((v) {
        votes.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num_witness'] = this.numWitness;
    if (this.extensions != null) {
      data['extensions'] = this.extensions;
    }
    data['memo_key'] = this.memoKey;
    data['voting_account'] = this.votingAccount;
    data['num_committee'] = this.numCommittee;
    if (this.votes != null) {
      data['votes'] = this.votes;
    }
    return data;
  }
}
