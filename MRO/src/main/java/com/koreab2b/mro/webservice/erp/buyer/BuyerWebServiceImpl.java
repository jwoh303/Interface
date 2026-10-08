package com.koreab2b.mro.webservice.erp.buyer;

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

import com.esp.grpeccfi.k2pkbb.DTGRPFI0450Con;
import com.esp.grpeccfi.k2pkbb.DTGRPFI0450ConResponse;
import com.esp.grpeccfi.k2pkbb.DTResHeader;
import com.esp.grpeccfi.k2pkbb.SIGRPFI0450SO;
import com.esp.grpeccfi.k2pkbb.SIGRPFI0450SOService;
import com.koreab2b.mro.util.ObjectConverter;
import com.koreab2b.mro.webservice.erp.ERPAuth;
import com.koreab2b.mro.webservice.erp.ERPHeader;

@Repository("buyerWebService")
public class BuyerWebServiceImpl implements BuyerWebService {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerWebServiceImpl.class);

	@Autowired
	private ERPAuth auth;

	@Autowired
	private ERPHeader header;

	@Value("#{erpProps['fa.buyer.webservice.interface.id']}")
	private String webserviceInfId;

	@Value("#{erpProps['fa.buyer.webservice.url']}")
	private String webserviceUri;

	public List<Map<String, String>> getList(List<Map<String, String>> pSearchList) {
		DTGRPFI0450Con _dtGRPFI0450Con = new DTGRPFI0450Con();
		BuyerBody _buyerBody = new BuyerBody();

		_dtGRPFI0450Con.setHeader(header.getHeader(webserviceInfId));
		_dtGRPFI0450Con.setBody(_buyerBody.getBody(pSearchList));

		SIGRPFI0450SOService _siGRPFI0450SOService = null;
		
		try {
			_siGRPFI0450SOService = new SIGRPFI0450SOService(new URL(webserviceUri), new QName("http://grpeccfi.esp.com/k2pkbb","SI_GRP_FI0450_SOService"));
		} catch (MalformedURLException e) {
			String _error = "ERP 구매처 정보 요청 주소 생성을 실패했습니다.";
			LOGGER.error(_error);
			throw new RuntimeException(_error);
		}
		
		SIGRPFI0450SO _siGRPFI0450SO = _siGRPFI0450SOService.getHTTPPort();

		DTGRPFI0450ConResponse _dtGRPFI0450ConResponse = _siGRPFI0450SO.siGRPFI0450SO(_dtGRPFI0450Con);
		DTResHeader _dtResHeader = _dtGRPFI0450ConResponse.getHeader();

		if (!header.getSuccessCode().equals(_dtResHeader.getZResultCd())
				&& !("E".equals(_dtResHeader.getZResultCd()) && "No data selected".equals(_dtResHeader.getZResultMsg()))) {
			String _error = "ERP 로부터 구매처 정보 수신이 실패했습니다.";
			LOGGER.error(_error);
			throw new RuntimeException(_error);
		}

		return ObjectConverter.listObjectToListMap(_dtGRPFI0450ConResponse.getBody().getSRECV());
	}
}
