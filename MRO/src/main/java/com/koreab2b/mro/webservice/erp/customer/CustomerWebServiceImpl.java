package com.koreab2b.mro.webservice.erp.customer;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;
import java.util.Map;

import javax.xml.namespace.QName;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.esp.grpeccfi.k2pkbb.DTGRPFI0070Con;
import com.esp.grpeccfi.k2pkbb.DTGRPFI0070ConResponse;
import com.esp.grpeccfi.k2pkbb.DTResHeader;
import com.esp.grpeccfi.k2pkbb.SIGRPFI0070SO;
import com.esp.grpeccfi.k2pkbb.SIGRPFI0070SOService;
import com.koreab2b.mro.util.ObjectConverter;
import com.koreab2b.mro.webservice.erp.ERPAuth;
import com.koreab2b.mro.webservice.erp.ERPHeader;

@Repository("customerWebService")
public class CustomerWebServiceImpl implements CustomerWebService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CustomerWebServiceImpl.class);

	@Autowired
	private ERPAuth auth;

	@Autowired
	private ERPHeader header;

	@Value("#{erpProps['fa.customer.webservice.interface.id']}")
	private String webserviceInfId;
	
	@Value("#{erpProps['fa.customer.webservice.url']}")
	private String webserviceUri;

	public List<Map<String, String>> getList(List<Map<String, String>> pSearchList) {
		DTGRPFI0070Con _dtGRPFI0070Con = new DTGRPFI0070Con();
		CustomerBody _customerBody = new CustomerBody();
		
		_dtGRPFI0070Con.setHeader(header.getHeader(webserviceInfId));
		_dtGRPFI0070Con.setBody(_customerBody.getBody(pSearchList));

		SIGRPFI0070SOService _siGRPFI0070SOService = null;
		
		try {
			_siGRPFI0070SOService = new SIGRPFI0070SOService(new URL(webserviceUri), new QName("http://grpeccfi.esp.com/k2pkbb", "SI_GRP_FI0070_SOService"));
		} catch (MalformedURLException e) {
			String _error = "ERP 고객 정보 요청 주소 생성을 실패했습니다.";
			LOGGER.error(_error);
			throw new RuntimeException(_error);
		}
		
		SIGRPFI0070SO _siGRPFI0070SO = _siGRPFI0070SOService.getHTTPPort();

		DTGRPFI0070ConResponse _dtGRPFI0070ConResponse = _siGRPFI0070SO.siGRPFI0070SO(_dtGRPFI0070Con);
		DTResHeader _dtResHeader = _dtGRPFI0070ConResponse.getHeader();

		if (!header.getSuccessCode().equals(_dtResHeader.getZResultCd()) && !("E".equals(_dtResHeader.getZResultCd()) && "No data selected".equals(_dtResHeader.getZResultMsg()))) {
			String _error = "ERP 로부터 고객 정보 수신이 실패했습니다.";
			LOGGER.error(_error);
			throw new RuntimeException(_error);
		}

		return ObjectConverter.listObjectToListMap(_dtGRPFI0070ConResponse.getBody().getBRECV());
	}
}
