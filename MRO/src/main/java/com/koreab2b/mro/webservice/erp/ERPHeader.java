package com.koreab2b.mro.webservice.erp;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.esp.grpeccfi.k2pkbb.DTReqHeader;
import com.koreab2b.mro.util.DateTimeUtil;

@Component
public class ERPHeader {

	@Value("#{erpProps['erp.success.code']}")
	private String successCode;

	@Value("#{erpProps['provider.system.id.financial.accounting']}")
	private String providerSysIdFinancialAccounting;

	@Value("#{erpProps['pi.user.id']}")
	private String piUserId;

	@Value("#{erpProps['consumer.system.id']}")
	private String consumerSysId;

	@Value("#{erpProps['consumer.system.user.id']}")
	private String consumerSysUserId;

	public DTReqHeader getHeader(String pWebserviceInfId) {
		DTReqHeader _dtReqHeader = new DTReqHeader();
		_dtReqHeader.setZProSysId(providerSysIdFinancialAccounting);
		_dtReqHeader.setZPiUser(piUserId);
		_dtReqHeader.setZConSysId(consumerSysId);
		_dtReqHeader.setZUserId(consumerSysUserId);
		_dtReqHeader.setZInterfaceId(pWebserviceInfId);
		_dtReqHeader.setZTimeId(DateTimeUtil.getFormatString("yyyyMMddHHmmssSSS"));
		return _dtReqHeader;
	}
	
	public String getSuccessCode() {
		return successCode;
	}
}
