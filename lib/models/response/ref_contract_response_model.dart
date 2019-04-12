class RefContractResponseModel {
	String chainId;
	List<RefContractResponseAvailableasset> availableAssets;
	List<RefContractResponseContract> contract;
	String refBlockId;

	RefContractResponseModel({this.chainId, this.availableAssets, this.contract, this.refBlockId});

	RefContractResponseModel.fromJson(Map<String, dynamic> json) {
		chainId = json['chainId'];
		if (json['availableAssets'] != null) {
			availableAssets = new List<RefContractResponseAvailableasset>();
			(json['availableAssets'] as List).forEach((v) { availableAssets.add(new RefContractResponseAvailableasset.fromJson(v)); });
		}
		if (json['contract'] != null) {
			contract = new List<RefContractResponseContract>();
			(json['contract'] as List).forEach((v) { contract.add(new RefContractResponseContract.fromJson(v)); });
		}
		refBlockId = json['refBlockId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['chainId'] = this.chainId;
		if (this.availableAssets != null) {
      data['availableAssets'] = this.availableAssets.map((v) => v.toJson()).toList();
    }
		if (this.contract != null) {
      data['contract'] = this.contract.map((v) => v.toJson()).toList();
    }
		data['refBlockId'] = this.refBlockId;
		return data;
	}
}

class RefContractResponseAvailableasset {
	String assetId;
	int precision;
	String assetName;

	RefContractResponseAvailableasset({this.assetId, this.precision, this.assetName});

	RefContractResponseAvailableasset.fromJson(Map<String, dynamic> json) {
		assetId = json['assetId'];
		precision = json['precision'];
		assetName = json['assetName'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['assetId'] = this.assetId;
		data['precision'] = this.precision;
		data['assetName'] = this.assetName;
		return data;
	}
}

class RefContractResponseContract {
	String commissionRate;
	String knockOutPrice;
	String remainingInventory;
	String underlying;
	String tradingStop;
	String conversionRate;
	String assetId;
	String contractId;
	String tradingStart;
	String assetName;
	String strikeLevel;
	String expiration;
	String settlementPrice;
	String status;

	RefContractResponseContract({this.commissionRate, this.knockOutPrice, this.remainingInventory, this.underlying, this.tradingStop, this.conversionRate, this.assetId, this.contractId, this.tradingStart, this.assetName, this.strikeLevel, this.expiration, this.settlementPrice, this.status});

	RefContractResponseContract.fromJson(Map<String, dynamic> json) {
		commissionRate = json['commissionRate'];
		knockOutPrice = json['knockOutPrice'];
		remainingInventory = json['remainingInventory'];
		underlying = json['underlying'];
		tradingStop = json['tradingStop'];
		conversionRate = json['conversionRate'];
		assetId = json['assetId'];
		contractId = json['contractId'];
		tradingStart = json['tradingStart'];
		assetName = json['assetName'];
		strikeLevel = json['strikeLevel'];
		expiration = json['expiration'];
		settlementPrice = json['settlementPrice'];
		status = json['status'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['commissionRate'] = this.commissionRate;
		data['knockOutPrice'] = this.knockOutPrice;
		data['remainingInventory'] = this.remainingInventory;
		data['underlying'] = this.underlying;
		data['tradingStop'] = this.tradingStop;
		data['conversionRate'] = this.conversionRate;
		data['assetId'] = this.assetId;
		data['contractId'] = this.contractId;
		data['tradingStart'] = this.tradingStart;
		data['assetName'] = this.assetName;
		data['strikeLevel'] = this.strikeLevel;
		data['expiration'] = this.expiration;
		data['settlementPrice'] = this.settlementPrice;
		data['status'] = this.status;
		return data;
	}
}
