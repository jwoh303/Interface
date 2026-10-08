package com.koreab2b.mro.webservice.erp.bond;

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

import com.esp.grpeccfi.k2pkbb.DTGRPFI0150Con;
import com.esp.grpeccfi.k2pkbb.DTGRPFI0150ConResponse;
import com.esp.grpeccfi.k2pkbb.DTResHeader;
import com.esp.grpeccfi.k2pkbb.SIGRPFI0150SO;
import com.esp.grpeccfi.k2pkbb.SIGRPFI0150SOService;
import com.koreab2b.mro.util.ObjectConverter;
import com.koreab2b.mro.webservice.erp.ERPAuth;
import com.koreab2b.mro.webservice.erp.ERPHeader;

@Repository("bondInWebService")
public class BondInWebServiceImpl implements BondInWebService {

	private static final Logger LOGGER = LoggerFactory.getLogger(BondInWebServiceImpl.class);

	@Autowired
	private ERPAuth auth;

	@Autowired
	private ERPHeader header;

	@Value("#{erpProps['fa.bond_in.webservice.interface.id']}")
	private String webserviceInfId;
	
	@Value("#{erpProps['fa.bond_in.webservice.url']}")
	private String webserviceUri;

	public List<Map<String, String>> addList(List<Map<String, String>> pHeaderList, List<Map<String, String>> pArLineList,
			List<Map<String, String>> pGlLineList, List<Map<String, String>> pTaxLineList) {
		DTGRPFI0150Con _dtGRPFI0150Con = new DTGRPFI0150Con();
		BondInBody _bondInBody = new BondInBody();

		_dtGRPFI0150Con.setHeader(header.getHeader(webserviceInfId));
		_dtGRPFI0150Con.setBody(_bondInBody.getBody(pHeaderList, pArLineList, pGlLineList, pTaxLineList));

		SIGRPFI0150SOService _siGRPFI0150SOService = null;
		
		try {
			_siGRPFI0150SOService = new SIGRPFI0150SOService(new URL(webserviceUri), new QName("http://grpeccfi.esp.com/k2pkbb", "SI_GRP_FI0150_SOService"));
		} catch (MalformedURLException e) {
			String _error = "ERP 채권전표 입력 주소 생성을 실패했습니다.";
			LOGGER.error(_error);
			throw new RuntimeException(_error);
		}
		
		SIGRPFI0150SO _siGRPFI0150SO = _siGRPFI0150SOService.getHTTPPort();

		DTGRPFI0150ConResponse _dtGRPFI0150ConResponse = _siGRPFI0150SO.siGRPFI0150SO(_dtGRPFI0150Con);
		DTResHeader _dtResHeader = _dtGRPFI0150ConResponse.getHeader();

		List<Map<String, String>> _listMap = new ArrayList<Map<String, String>>();
		
		_listMap.add(ObjectConverter.ObjectToMap(_dtResHeader));
		_listMap.addAll(ObjectConverter.listObjectToListMap(_dtGRPFI0150ConResponse.getBody().getITRESULT()));

		return _listMap;
	}
}
