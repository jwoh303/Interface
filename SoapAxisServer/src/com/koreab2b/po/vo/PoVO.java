package com.koreab2b.po.vo;

import java.util.List;

import com.koreab2b.common.WsHeaderVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;

public class PoVO {

	private EKKO poHeader;
	
	private List<EKPO> poDetail;
	
	private List<EKET> poDelyPlan;
	
	private WsHeaderVO wsHeader;

	public EKKO getPoHeader() {
		return poHeader;
	}

	public void setPoHeader(EKKO poHeader) {
		this.poHeader = poHeader;
	}

	public List<EKPO> getPoDetail() {
		return poDetail;
	}

	public void setPoDetail(List<EKPO> poDetail) {
		this.poDetail = poDetail;
	}

	public List<EKET> getPoDelyPlan() {
		return poDelyPlan;
	}

	public void setPoDelyPlan(List<EKET> poDelyPlan) {
		this.poDelyPlan = poDelyPlan;
	}

	public WsHeaderVO getWsHeader() {
		if(wsHeader == null) {
			return new WsResultConstants().WsResult(WS_RESULT.OK);
		}
		return wsHeader;
	}
	public void setWsHeader(WsHeaderVO wsHeader) {
		if(wsHeader == null) {
			this.wsHeader = new WsResultConstants().WsResult(WS_RESULT.OK);
		}
		this.wsHeader = wsHeader;
	}
	
	/**
	 * 데이터를 xml 구조로 리턴한다.
	 * @return
	 */
	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		
		xml.append("         <arg0>");
		
		xml.append(poHeader.getXml());
		
		for(EKPO ekpo : poDetail) {
			xml.append(ekpo.getXml());
		}
		
		if (poDelyPlan != null) {
			for(EKET eket : poDelyPlan) {
				xml.append(eket.getXml());
			}
		}
		
		xml.append("         </arg0>");
		
		return xml.toString();
	}
}
