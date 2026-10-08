package com.koreab2b.mro.webservice.erp.reverse;

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

import com.esp.grpeccfi.k2pkbb.DTGRPFI0250Con;
import com.esp.grpeccfi.k2pkbb.DTGRPFI0250ConResponse;
import com.esp.grpeccfi.k2pkbb.DTResHeader;
import com.esp.grpeccfi.k2pkbb.SIGRPFI0250SO;
import com.esp.grpeccfi.k2pkbb.SIGRPFI0250SOService;
import com.koreab2b.mro.util.ObjectConverter;
import com.koreab2b.mro.webservice.erp.ERPAuth;
import com.koreab2b.mro.webservice.erp.ERPHeader;

@Repository("reverseInWebServiceImpl")
public class ReverseInWebServiceImpl implements ReverseInWebService {

	private static final Logger LOGGER = LoggerFactory.getLogger(ReverseInWebServiceImpl.class);

	@Autowired
	private ERPAuth auth;

	@Autowired
	private ERPHeader header;

	@Value("#{erpProps['fa.reverse_in.webservice.interface.id']}")
	private String webserviceInfId;

	@Value("#{erpProps['fa.reverse_in.webservice.url']}")
	private String webserviceUri;
	
	public List<Map<String, String>> addList(List<Map<String, String>> pReverseList) {
		DTGRPFI0250Con _dtGRPFI0250Con = new DTGRPFI0250Con();
		ReverseInBody _reverseInBody = new ReverseInBody();

		_dtGRPFI0250Con.setHeader(header.getHeader(webserviceInfId));
		_dtGRPFI0250Con.setBody(_reverseInBody.getBody(pReverseList));

		SIGRPFI0250SOService _siGRPFI0250SOService = null;
		
		try {
			_siGRPFI0250SOService = new SIGRPFI0250SOService(new URL(webserviceUri), new QName("http://grpeccfi.esp.com/k2pkbb", "SI_GRP_FI0250_SOService"));
		} catch (MalformedURLException e) {
			String _error = "ERP 역분개전표 입력 주소 생성을 실패했습니다.";
			LOGGER.error(_error);
			throw new RuntimeException(_error);
		}
		
		SIGRPFI0250SO _siGRPFI0250SO = _siGRPFI0250SOService.getHTTPPort();

		DTGRPFI0250ConResponse _dtGRPFI0250ConResponse = _siGRPFI0250SO.siGRPFI0250SO(_dtGRPFI0250Con);
		DTResHeader _dtResHeader = _dtGRPFI0250ConResponse.getHeader();

		List<Map<String, String>> _listMap = new ArrayList<Map<String, String>>();

		_listMap.add(ObjectConverter.ObjectToMap(_dtResHeader));
		_listMap.addAll(ObjectConverter.listObjectToListMap(_dtGRPFI0250ConResponse.getBody().getITRESULT()));

		return _listMap;
	}
}
