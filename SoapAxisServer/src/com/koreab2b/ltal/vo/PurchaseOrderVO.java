package com.koreab2b.ltal.vo;

import java.util.List;

public class PurchaseOrderVO {

	private PurchaseOrderHeaderVO poHeader;
	private List<PurchaseOrderItemVO> poItemList;
	
	public PurchaseOrderHeaderVO getPoHeader() {
		return poHeader;
	}
	public void setPoHeader(PurchaseOrderHeaderVO poHeader) {
		this.poHeader = poHeader;
	}
	public List<PurchaseOrderItemVO> getPoItemList() {
		return poItemList;
	}
	public void setPoItemList(List<PurchaseOrderItemVO> poItemList) {
		this.poItemList = poItemList;
	}
}
