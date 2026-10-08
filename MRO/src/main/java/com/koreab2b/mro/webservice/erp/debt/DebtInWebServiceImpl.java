package com.koreab2b.mro.webservice.erp.debt;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.xml.namespace.QName;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.esp.grpeccfi.k2pkbb.DTGRPFI0610Con;
import com.esp.grpeccfi.k2pkbb.DTGRPFI0610ConResponse;
import com.esp.grpeccfi.k2pkbb.DTResHeader;
import com.esp.grpeccfi.k2pkbb.SIGRPFI0610SO;
import com.esp.grpeccfi.k2pkbb.SIGRPFI0610SOService;
import com.koreab2b.mro.util.ObjectConverter;
import com.koreab2b.mro.webservice.erp.ERPAuth;
import com.koreab2b.mro.webservice.erp.ERPHeader;

@Repository("debtInWebServiceImpl")
public class DebtInWebServiceImpl implements DebtInWebService {

	private static final Logger LOGGER = LoggerFactory.getLogger(DebtInWebServiceImpl.class);

	@Autowired
	private ERPAuth auth;

	@Autowired
	private ERPHeader header;

	@Value("#{erpProps['fa.debt_in.webservice.interface.id']}")
	private String webserviceInfId;
	
	@Value("#{erpProps['fa.debt_in.webservice.url']}")
	private String webserviceUri;

	public List<Map<String, String>> addList(List<Map<String, String>> pHeaderList, List<Map<String, String>> pApLineList,
			List<Map<String, String>> pGlLineList, List<Map<String, String>> pTaxLineList) {
		DTGRPFI0610Con _dtGRPFI0610Con = new DTGRPFI0610Con();
		DebtInBody _debtInBody = new DebtInBody();

		_dtGRPFI0610Con.setHeader(header.getHeader(webserviceInfId));
		_dtGRPFI0610Con.setBody(_debtInBody.getBody(pHeaderList, pApLineList, pGlLineList, pTaxLineList));

		SIGRPFI0610SOService _siGRPFI0610SOService = null;
		
		try {
			_siGRPFI0610SOService = new SIGRPFI0610SOService(new URL(webserviceUri) , new QName("http://grpeccfi.esp.com/k2pkbb", "SI_GRP_FI0610_SOService"));
		} catch (MalformedURLException e) {
			String _error = "ERP 채무전표 입력 주소 생성을 실패했습니다.";
			LOGGER.error(_error);
			throw new RuntimeException(_error);
		}
		
		SIGRPFI0610SO _siGRPFI0610SO = _siGRPFI0610SOService.getHTTPPort();

		DTGRPFI0610ConResponse _dtGRPFI0610ConResponse = _siGRPFI0610SO.siGRPFI0610SO(_dtGRPFI0610Con);
		DTResHeader _dtResHeader = _dtGRPFI0610ConResponse.getHeader();

		List<Map<String, String>> _listMap = new ArrayList<Map<String, String>>();

		_listMap.add(ObjectConverter.ObjectToMap(_dtResHeader));
		_listMap.addAll(ObjectConverter.listObjectToListMap(_dtGRPFI0610ConResponse.getBody().getITRESULT()));

		return _listMap;
	}
}
