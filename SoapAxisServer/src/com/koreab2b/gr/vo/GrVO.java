package com.koreab2b.gr.vo;

import java.util.List;

import com.koreab2b.common.WsHeaderVO;
import com.koreab2b.common.WsResultConstants;
import com.koreab2b.common.WsResultConstants.WS_RESULT;
import com.koreab2b.po.vo.EKET;
import com.koreab2b.po.vo.EKPO;

public class GrVO {

	MKPF grHeader;
	List<MSEG> grDetail;
	
	private WsHeaderVO wsHeader;

	public MKPF getGrHeader() {
		return grHeader;
	}

	public void setGrHeader(MKPF grHeader) {
		this.grHeader = grHeader;
	}

	public List<MSEG> getGrDetail() {
		return grDetail;
	}

	public void setGrDetail(List<MSEG> grDetail) {
		this.grDetail = grDetail;
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
	
	public String getXml() {
		StringBuffer xml	= new StringBuffer();
		
		xml.append("         <arg0>");
		
		xml.append(grHeader.getXml());
		
		for(MSEG mseg : grDetail) {
			xml.append(mseg.getXml());
		}
		
		xml.append("         </arg0>");
		
		return xml.toString();
	}
}
