package com.koreab2b.ltal.vo;

import java.util.List;

public class InvoiceVO {

	private InvoiceHeaderVO invHeader;
	private List<InvoiceItemVO> invItemList;
	
	public InvoiceHeaderVO getInvHeader() {
		return invHeader;
	}
	public void setInvHeader(InvoiceHeaderVO invHeader) {
		this.invHeader = invHeader;
	}
	public List<InvoiceItemVO> getInvItemList() {
		return invItemList;
	}
	public void setInvItemList(List<InvoiceItemVO> invItemList) {
		this.invItemList = invItemList;
	}
}