package com.koreab2b.rfq.vo;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;

import com.koreab2b.common.WsHeaderVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;

@XmlAccessorType(XmlAccessType.FIELD)
public class RFQ_HEADER {

	@XmlElement(required=true)
	private String COMP_CD;
	@XmlElement(required=true)
	private String RFQ_NO;
	@XmlElement(required=true)
	private int RFQ_CNT;
	private String CANCEL_TYP;
	private String CANCEL_CAUSE;
	
	private WsHeaderVO wsHeader;
	
	public String getCOMP_CD() {
		return COMP_CD;
	}
	public void setCOMP_CD(String cOMP_CD) {
		COMP_CD = cOMP_CD;
	}
	public String getRFQ_NO() {
		return RFQ_NO;
	}
	public void setRFQ_NO(String rFQ_NO) {
		RFQ_NO = rFQ_NO;
	}
	public int getRFQ_CNT() {
		return RFQ_CNT;
	}
	public void setRFQ_CNT(int rFQ_CNT) {
		RFQ_CNT = rFQ_CNT;
	}
	public String getCANCEL_TYP() {
		return CANCEL_TYP;
	}
	public void setCANCEL_TYP(String cANCEL_TYP) {
		CANCEL_TYP = cANCEL_TYP;
	}
	public String getCANCEL_CAUSE() {
		return CANCEL_CAUSE;
	}
	public void setCANCEL_CAUSE(String cANCEL_CAUSE) {
		CANCEL_CAUSE = cANCEL_CAUSE;
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
}
