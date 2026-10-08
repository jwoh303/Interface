package com.koreab2b.mro.master.mdct.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mdct.service.MasterSapInterfaceManageService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.webservice.erp.buyer.BuyerWebService;
import com.koreab2b.mro.webservice.erp.customer.CustomerWebService;

@Controller("masterSapInterfaceManageController")
public class MasterSapInterfaceManageController {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCtBuyerRegManageController.class);
	
	@Value("#{erpProps['kep.company.cd']}")
	private String kepComCd;
	
	@Autowired
	private MasterSapInterfaceManageService masterSapInterfaceManageService;
	
	@Autowired
	private CustomerWebService customerInfo;
	
	@Autowired
	private BuyerWebService buyerInfo;
	
	// 조회
	@RequestMapping(value = "/mdct/getMasterSapInterfaceManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterSapInterfaceManageList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("getMasterSapInterfaceManageList Map 요청 파라미터 : formData", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterSapInterfaceManageService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
	//ERP에서 SAP코드 조회(단건)
	@RequestMapping(value = "/mdct/getMasterSapInterfaceManageSapCode.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> getMasterSapInterfaceManageSapCode(HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, String> _response = new HashMap<String, String>();
		logger.debug("getMasterSapInterfaceManageSapCode Map 요청 파라미터 : formData", pMap); 
		
		List<Map<String, String>> _searchList = new ArrayList<Map<String, String>>();
		Map<String, String> _search1 = new HashMap<String, String>();
		
		_search1.put("BUKRS", kepComCd);
		_search1.put("IRSNO", pMap.get("st_irsNo").replace("-", ""));
		_searchList.add(_search1);
		String _rtnMsg = "Err";
		List<Map<String, String>> mp = null;
		
		if (pMap.get("st_business_cond").equals("S")) {
			mp = buyerInfo.getList(_searchList);
			logger.debug("ERP로 부터 받은 구매처 정보 : {}", mp);
		} else {
			mp = customerInfo.getList(_searchList);
			logger.debug("ERP로 부터 받은 고객 정보 : {}", mp);
		}
	
		//Map<String, Object> mp = new HashMap<String, Object>();

		if (mp != null && mp.size() > 0) {
			_rtnMsg = "OK";
			_response.put("sapCode", mp.get(0).get("COMSAPCODE"));
		} else {
			_rtnMsg = "0";
		}
		_response.put("msg", _rtnMsg);
		return _response;
		
	}
	
	//ERP에서 SAP코드 조회(리스트)
	@RequestMapping(value = "/mdct/getMasterSapInterfaceManageSapCodeList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> getMasterSapInterfaceManageSapCodeList(HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, String> _response = new HashMap<String, String>();
		logger.debug("getMasterSapInterfaceManageSapCode Map 요청 파라미터 : formData  ====== {}", pMap); 
		
		List<Map<String, String>> _customerList = new ArrayList<Map<String, String>>();
		List<Map<String, String>> _buyerList = new ArrayList<Map<String, String>>();

		String[] _irsNo = pMap.get("st_irsNo").split("\\|");
		String[] _businessCond = pMap.get("st_business_cond").split("\\|");

		for (int i = 0; i < _irsNo.length; i++) {
			Map<String, String> _search = new HashMap<String, String>();
			_search.put("BUKRS", kepComCd);
			_search.put("IRSNO", _irsNo[i].replace("-", ""));

			if (_businessCond[i].equals("S")) {
				_buyerList.add(_search);
			} else {
				_customerList.add(_search);
			}
		}
				
		String _rtnMsg = "Err";
		List<Map<String, String>> _buyerSapList = new ArrayList<Map<String, String>>();
		List<Map<String, String>> _customerSapList = new ArrayList<Map<String, String>>();
		
		if (_buyerList.size() > 0) {
			_buyerSapList = buyerInfo.getList(_buyerList);
			logger.debug("=============buyerFromERP============{}", _buyerSapList);
		}
		
		if (_customerList.size() > 0) {
			_customerSapList = customerInfo.getList(_customerList);
			logger.debug("=============customerFromERP============{}", _customerSapList);
		}
		
		String _sapCodeList = "";
		String _irsNoList = "";
		if ((_buyerSapList != null && _buyerSapList.size() > 0 ) || (_customerSapList != null && _customerSapList.size() > 0 )) {
			_rtnMsg = "OK";

			for (int i = 0; i < _buyerSapList.size(); i++) {
				_sapCodeList +=  _buyerSapList.get(i).get("COMSAPCODE") + "|";
				_irsNoList +=  _buyerSapList.get(i).get("IRSNO") + "|";
			}
			
			for (int i = 0; i < _customerSapList.size(); i++) {
				_sapCodeList +=  _customerSapList.get(i).get("COMSAPCODE") + "|";
				_irsNoList +=  _customerSapList.get(i).get("IRSNO") + "|";
			}
		} else {
			_rtnMsg = "0";
		}
		_response.put("irsNo", _irsNoList);
		_response.put("sapCode", _sapCodeList);
		_response.put("msg", _rtnMsg);
		return _response;
	}

	// 저장
	@RequestMapping(value = "/mdct/saveMasterSapInterfaceManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterSapInterfaceManageList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData ==> {}", gridData);
		logger.debug("saveMasterMpRqItemReqStnd MultiValueMap 요청 파라미터 : formData ==> {}", formData); 

		String rtnMsg = masterSapInterfaceManageService.updateSelectedData(formData, gridData);
		Map<String, Object> mp = new HashMap<String, Object>();
		if (rtnMsg.equals("OK")) {
			mp.put("Code",1);
			_response.put("Result",mp);
			_response.put("Message", "SAP코드 저장이 완료되었습니다.");
		} else {
			mp.put("Code",0);
			_response.put("Result", mp);
			_response.put("Message", "SAP코드 저장이 실패하였습니다.");
		}
		
		return _response;
	}
}
