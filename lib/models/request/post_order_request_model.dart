class PostOrderRequestModel {
	String transactionType;
	PostOrderRequestTransfer transfer;
	PostOrderRequestSellorder sellOrder;
	String transferTxId;
	String spotBXBT;
	String takeProfitPx;
	String cutLossPx;
	PostOrderRequestBuyorder buyOrder;
	int forceExpiration;
	String sellOrderTxId;
	String buyOrderTxId;

	PostOrderRequestModel({this.transactionType, this.transfer, this.sellOrder, this.transferTxId, this.spotBXBT, this.takeProfitPx, this.cutLossPx, this.buyOrder, this.forceExpiration, this.sellOrderTxId, this.buyOrderTxId});

	PostOrderRequestModel.fromJson(Map<String, dynamic> json) {
		transactionType = json['transactionType'];
		transfer = json['transfer'] != null ? new PostOrderRequestTransfer.fromJson(json['transfer']) : null;
		sellOrder = json['sellOrder'] != null ? new PostOrderRequestSellorder.fromJson(json['sellOrder']) : null;
		transferTxId = json['transferTxId'];
		spotBXBT = json['spotBXBT'];
		takeProfitPx = json['takeProfitPx'];
		cutLossPx = json['cutLossPx'];
		buyOrder = json['buyOrder'] != null ? new PostOrderRequestBuyorder.fromJson(json['buyOrder']) : null;
		forceExpiration = json['forceExpiration'];
		sellOrderTxId = json['sellOrderTxId'];
		buyOrderTxId = json['buyOrderTxId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['transactionType'] = this.transactionType;
		if (this.transfer != null) {
      data['transfer'] = this.transfer.toJson();
    }
		if (this.sellOrder != null) {
      data['sellOrder'] = this.sellOrder.toJson();
    }
		data['transferTxId'] = this.transferTxId;
		data['spotBXBT'] = this.spotBXBT;
		data['takeProfitPx'] = this.takeProfitPx;
		data['cutLossPx'] = this.cutLossPx;
		if (this.buyOrder != null) {
      data['buyOrder'] = this.buyOrder.toJson();
    }
		data['forceExpiration'] = this.forceExpiration;
		data['sellOrderTxId'] = this.sellOrderTxId;
		data['buyOrderTxId'] = this.buyOrderTxId;
		return data;
	}
}

class PostOrderRequestTransfer {
	PostOrderRequestTransferAmount amount;
	String signature;
	PostOrderRequestTransferFee fee;
	int txExpiration;
	String from;
	String to;
	int refBlockNum;
	int refBlockPrefix;

	PostOrderRequestTransfer({this.amount, this.signature, this.fee, this.txExpiration, this.from, this.to, this.refBlockNum, this.refBlockPrefix});

	PostOrderRequestTransfer.fromJson(Map<String, dynamic> json) {
		amount = json['amount'] != null ? new PostOrderRequestTransferAmount.fromJson(json['amount']) : null;
		signature = json['signature'];
		fee = json['fee'] != null ? new PostOrderRequestTransferFee.fromJson(json['fee']) : null;
		txExpiration = json['txExpiration'];
		from = json['from'];
		to = json['to'];
		refBlockNum = json['refBlockNum'];
		refBlockPrefix = json['refBlockPrefix'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.amount != null) {
      data['amount'] = this.amount.toJson();
    }
		data['signature'] = this.signature;
		if (this.fee != null) {
      data['fee'] = this.fee.toJson();
    }
		data['txExpiration'] = this.txExpiration;
		data['from'] = this.from;
		data['to'] = this.to;
		data['refBlockNum'] = this.refBlockNum;
		data['refBlockPrefix'] = this.refBlockPrefix;
		return data;
	}
}

class PostOrderRequestTransferAmount {
	int amount;
	String assetId;

	PostOrderRequestTransferAmount({this.amount, this.assetId});

	PostOrderRequestTransferAmount.fromJson(Map<String, dynamic> json) {
		amount = json['amount'];
		assetId = json['assetId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['amount'] = this.amount;
		data['assetId'] = this.assetId;
		return data;
	}
}

class PostOrderRequestTransferFee {
	int amount;
	String assetId;

	PostOrderRequestTransferFee({this.amount, this.assetId});

	PostOrderRequestTransferFee.fromJson(Map<String, dynamic> json) {
		amount = json['amount'];
		assetId = json['assetId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['amount'] = this.amount;
		data['assetId'] = this.assetId;
		return data;
	}
}

class PostOrderRequestSellorder {
	String seller;
	String signature;
	int fillOrKill;
	PostOrderRequestSellorderFee fee;
	PostOrderRequestSellorderMintoreceive minToReceive;
	PostOrderRequestSellorderAmounttosell amountToSell;
	int txExpiration;
	int expiration;
	int refBlockNum;
	int refBlockPrefix;

	PostOrderRequestSellorder({this.seller, this.signature, this.fillOrKill, this.fee, this.minToReceive, this.amountToSell, this.txExpiration, this.expiration, this.refBlockNum, this.refBlockPrefix});

	PostOrderRequestSellorder.fromJson(Map<String, dynamic> json) {
		seller = json['seller'];
		signature = json['signature'];
		fillOrKill = json['fill_or_kill'];
		fee = json['fee'] != null ? new PostOrderRequestSellorderFee.fromJson(json['fee']) : null;
		minToReceive = json['minToReceive'] != null ? new PostOrderRequestSellorderMintoreceive.fromJson(json['minToReceive']) : null;
		amountToSell = json['amountToSell'] != null ? new PostOrderRequestSellorderAmounttosell.fromJson(json['amountToSell']) : null;
		txExpiration = json['txExpiration'];
		expiration = json['expiration'];
		refBlockNum = json['refBlockNum'];
		refBlockPrefix = json['refBlockPrefix'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['seller'] = this.seller;
		data['signature'] = this.signature;
		data['fill_or_kill'] = this.fillOrKill;
		if (this.fee != null) {
      data['fee'] = this.fee.toJson();
    }
		if (this.minToReceive != null) {
      data['minToReceive'] = this.minToReceive.toJson();
    }
		if (this.amountToSell != null) {
      data['amountToSell'] = this.amountToSell.toJson();
    }
		data['txExpiration'] = this.txExpiration;
		data['expiration'] = this.expiration;
		data['refBlockNum'] = this.refBlockNum;
		data['refBlockPrefix'] = this.refBlockPrefix;
		return data;
	}
}

class PostOrderRequestSellorderFee {
	int amount;
	String assetId;

	PostOrderRequestSellorderFee({this.amount, this.assetId});

	PostOrderRequestSellorderFee.fromJson(Map<String, dynamic> json) {
		amount = json['amount'];
		assetId = json['assetId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['amount'] = this.amount;
		data['assetId'] = this.assetId;
		return data;
	}
}

class PostOrderRequestSellorderMintoreceive {
	int amount;
	String assetId;

	PostOrderRequestSellorderMintoreceive({this.amount, this.assetId});

	PostOrderRequestSellorderMintoreceive.fromJson(Map<String, dynamic> json) {
		amount = json['amount'];
		assetId = json['assetId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['amount'] = this.amount;
		data['assetId'] = this.assetId;
		return data;
	}
}

class PostOrderRequestSellorderAmounttosell {
	int amount;
	String assetId;

	PostOrderRequestSellorderAmounttosell({this.amount, this.assetId});

	PostOrderRequestSellorderAmounttosell.fromJson(Map<String, dynamic> json) {
		amount = json['amount'];
		assetId = json['assetId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['amount'] = this.amount;
		data['assetId'] = this.assetId;
		return data;
	}
}

class PostOrderRequestBuyorder {
	String seller;
	String signature;
	int fillOrKill;
	PostOrderRequestBuyorderFee fee;
	PostOrderRequestBuyorderMintoreceive minToReceive;
	PostOrderRequestBuyorderAmounttosell amountToSell;
	int txExpiration;
	int expiration;
	int refBlockNum;
	int refBlockPrefix;

	PostOrderRequestBuyorder({this.seller, this.signature, this.fillOrKill, this.fee, this.minToReceive, this.amountToSell, this.txExpiration, this.expiration, this.refBlockNum, this.refBlockPrefix});

	PostOrderRequestBuyorder.fromJson(Map<String, dynamic> json) {
		seller = json['seller'];
		signature = json['signature'];
		fillOrKill = json['fill_or_kill'];
		fee = json['fee'] != null ? new PostOrderRequestBuyorderFee.fromJson(json['fee']) : null;
		minToReceive = json['minToReceive'] != null ? new PostOrderRequestBuyorderMintoreceive.fromJson(json['minToReceive']) : null;
		amountToSell = json['amountToSell'] != null ? new PostOrderRequestBuyorderAmounttosell.fromJson(json['amountToSell']) : null;
		txExpiration = json['txExpiration'];
		expiration = json['expiration'];
		refBlockNum = json['refBlockNum'];
		refBlockPrefix = json['refBlockPrefix'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['seller'] = this.seller;
		data['signature'] = this.signature;
		data['fill_or_kill'] = this.fillOrKill;
		if (this.fee != null) {
      data['fee'] = this.fee.toJson();
    }
		if (this.minToReceive != null) {
      data['minToReceive'] = this.minToReceive.toJson();
    }
		if (this.amountToSell != null) {
      data['amountToSell'] = this.amountToSell.toJson();
    }
		data['txExpiration'] = this.txExpiration;
		data['expiration'] = this.expiration;
		data['refBlockNum'] = this.refBlockNum;
		data['refBlockPrefix'] = this.refBlockPrefix;
		return data;
	}
}

class PostOrderRequestBuyorderFee {
	int amount;
	String assetId;

	PostOrderRequestBuyorderFee({this.amount, this.assetId});

	PostOrderRequestBuyorderFee.fromJson(Map<String, dynamic> json) {
		amount = json['amount'];
		assetId = json['assetId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['amount'] = this.amount;
		data['assetId'] = this.assetId;
		return data;
	}
}

class PostOrderRequestBuyorderMintoreceive {
	int amount;
	String assetId;

	PostOrderRequestBuyorderMintoreceive({this.amount, this.assetId});

	PostOrderRequestBuyorderMintoreceive.fromJson(Map<String, dynamic> json) {
		amount = json['amount'];
		assetId = json['assetId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['amount'] = this.amount;
		data['assetId'] = this.assetId;
		return data;
	}
}

class PostOrderRequestBuyorderAmounttosell {
	int amount;
	String assetId;

	PostOrderRequestBuyorderAmounttosell({this.amount, this.assetId});

	PostOrderRequestBuyorderAmounttosell.fromJson(Map<String, dynamic> json) {
		amount = json['amount'];
		assetId = json['assetId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['amount'] = this.amount;
		data['assetId'] = this.assetId;
		return data;
	}
}
