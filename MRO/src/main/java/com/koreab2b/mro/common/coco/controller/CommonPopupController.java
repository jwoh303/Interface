package com.koreab2b.mro.common.coco.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.MapUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.application.annotation.NoLoginCheck;
import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoExternalService;
import com.koreab2b.mro.common.coco.service.CommonPopupService;
import com.koreab2b.mro.common.ibsheet.IBSheetResponseUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mprq.service.BuyerMpRqQuotationNegoHistoryPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("CommonPopupController")
public class CommonPopupController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonPopupController.class);

	@Autowired
	private CommonPopupService commonPopupService;

	@Autowired
	private BuyerMpSoExternalService buyerMpSoExternalService;
	@Autowired
	private BuyerMpRqQuotationNegoHistoryPopService buyerMpRqQuotationNegoHistoryPopService;
	/**
	 * 광동제약 주문내역 조회
	 * @param pMap
	 * @param req
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/common/getKwangdongGWList.do", method =  {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getKwangdongGWList(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		JSONObject jObj		= null;
		JSONArray jObjList	= new JSONArray();
		
		List<Map<String,String>> rtn	= buyerMpSoExternalService.getKwangdongGWList(pMap);
		
		for(Map<String, String> tMap : rtn) {
			jObj	= new JSONObject();
			jObj.putAll(tMap);
			jObjList.add(jObj);
		}
		
		_response.put("data", jObjList);
		
		return _response;
	}

	@NoLoginCheck
	@RequestMapping(value = "/common/setKwangdongApproval.do", method =  {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> setKwangdongApproval(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String rtnMsg	= buyerMpSoExternalService.setKwangdongApproval(pMap);
		
		_response.put("message", rtnMsg);
		
		return _response;
	}
	
	/**
	 * 우편번호 조회(팝업)
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/zipCodeSearchPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String zipCodeSearchPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("zipCodeSearch 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _sido_data = commonPopupService.getSidoCodeList();
		pModel.addAttribute("sido_data", _sido_data);
		return "common/popup/zipCodeSearchPop";
	}

	/**
	 * 공통 우편번호 조회(팝업)
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/commonZipCodeSearchPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String commonZipCodeSearchPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("commonZipCodeSearchPop 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _sido_data = commonPopupService.getSidoCodeList();
		pModel.addAttribute("sido_data", _sido_data);
		return "common/popup/commonZipCodeSearchPop";
	}
	
	/**
	 * 우편번호 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/zipCodeSearchList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> zipCodeSearch(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("zipCodeSearch 요청 파라미터 for jsp : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = commonPopupService.zipCodeSearch(pMap); 
		_response.put("data", _data);
		return  _response;
	}
	
	/**
	 * 우편번호 시구군 목록 조회
	 * @param pMap
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/common/sigunguList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> sigunguList(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("sigunguList 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _sigungu_data = commonPopupService.getSigunguCodeList(pMap);
		_response.put("sigungu_data", _sigungu_data);
		return  _response; 
	}
	
	/**
	 * 공통 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/commonList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String commonList(HttpServletRequest req,ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("commonList 요청 파라미터 for jsp : {}", pMap); 
		/*로그관련 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("REG_ID", _sessionInfo.getUserId());
			pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		}else{
			pMap.put("REG_ID","");
			pMap.put("REG_IP", "");
		}

		List<Map<String, String>> _data = commonPopupService.commonList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAttribute("result","S");
		if(pMap.get("codeGubun").equals("comCode2PopHaev")) {
			pMap.put("codeGubun", "comCode2PopSearch");
		}
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/"+pMap.get("codeGubun");
	}
	/**
	 * 공통 조회 v2 (JSON 응답)
	 * @param pModel
	 * @param pMap
	 * @param req
	 * @return
	 */
	// 리뉴얼 버전 JSON API 조회
	@RequestMapping(value = "/common/commonList_v2.do", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> commonListV2(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("commonList_v2 요청 파라미터 : {}", pMap);

		/*로그관련 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("REG_ID", _sessionInfo.getUserId());
			pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		} else {
			pMap.put("REG_ID", "");
			pMap.put("REG_IP", "");
		}

		// 기존 레거시 쿼리로 조회
		List<Map<String, String>> data = commonPopupService.commonList(pMap);

		// IBSheetResponseUtil을 사용하여 표준 DoSearch 응답 생성
		Map<String, Object> result = IBSheetResponseUtil.createSuccessResponse(data);

		// 디버깅용 로그 출력 (필요시 주석 처리)
		// IBSheetResponseUtil.logResponse(result, "[DoSearch] 공통팝업 조회");

		return result;
	}
	
	/*
	 * ibsheet 용 commonList
	 * 
	 */
	@RequestMapping(value = "/common/commonList_v3.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> commonList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("REG_ID", _sessionInfo.getUserId());
			pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		}else{
			pMap.put("REG_ID","");
			pMap.put("REG_IP", "");
		}

		Map<String,String> param = new HashMap<String, String>();
		//Map<String,Object> 를 Map<String,String>으로 변환
		for(Map.Entry<String, Object> entry : pMap.entrySet()){
			param.put(entry.getKey(), entry.getValue() == null ? null : entry.getValue().toString());
		}
		
		List<Map<String, String>> _data = commonPopupService.commonList(param); 
		if(pMap.get("codeGubun").equals("comCode2PopHaev")) {
			pMap.put("codeGubun", "comCode2PopSearch");
		}
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 공통 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/positionCodePop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String positionCodePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
			return "common/popup/positionCodePop_v2";
	}
	@RequestMapping(value = "/common/getPositionCodePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getPositionCodePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("getPositionCodePop 요청 파라미터 for jsp : {}", pMap); 
		pMap.put("codeGubun", CommonUtil.nvl((String)  pMap.get("codeGubun"),"positionCodePop"));
		List<Map<String, String>> _data = commonPopupService.commonList(pMap); 
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/positionCodePop";
	}
	@RequestMapping(value = "/common/getPositionCodePop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getPositionCodePop_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getPositionCodePop_v2 요청 파라미터 : {}", pMap);
		
		List<Map<String,String>> _data = commonPopupService.commonList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 공통 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/commonFolderList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String commonFolderList(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("commonFolderList 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = commonPopupService.commonList(pMap); 
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAttribute("result","S"); 
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/"+pMap.get("folder")+"/"+pMap.get("codeGubun");
	}		
	@RequestMapping(value = "/common/commonFolderList_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> commonFolderList(HttpServletRequest req,ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("commonFolderList_v2 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = commonPopupService.commonList_v2(pMap); 

		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAttribute("result","S"); 
		// 화면에서 보낸값에 의한 화면 전환
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}	
	/**
	 * 공통 조회
	 * 회원사정보
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/getAgentInfoDiaplayPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getAgentInfoDiaplayPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("getAgentInfoDiaplayPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data1 = commonPopupService.getAgentInfoDiaplayPop(pMap); 
		List<Map<String, String>> _data2 = null;
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String com_code = _sessionInfo.getComCode();
		String com_type = _sessionInfo.getBusinessCond();
		String agent_open_flag = _sessionInfo.getAgentOpenFlag();
		/*로그관련 셋팅*/
		pMap.put("REG_ID", _sessionInfo.getUserId());
		pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		
		if("M".equals(com_type)){
			_data2 = commonPopupService.getUserInfoDiaplayListPopCase1(pMap);
		}else if("S".equals(com_type)){
			_data2 = commonPopupService.getUserInfoDiaplayListPopCase2(pMap);
		}else{
			if("N".equals(agent_open_flag)){
				pMap.put("st_com_code", com_code);
				_data2 = commonPopupService.getUserInfoDiaplayListPopCase2(pMap);
			}else{
				_data2 = commonPopupService.getUserInfoDiaplayListPopCase1(pMap);
			}
		}
		
		pModel.addAttribute("data1", CommonUtil.getListNvl(_data1)); 
		pModel.addAttribute("data2",CommonUtil.getListNvl( _data2)); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/"+pMap.get("codeGubun");
	}
	
	
	@RequestMapping(value = "/common/agentUserInfoDisplayPop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getAgentUserInfoDisplayPop_v2(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("getAgentUserInfoDisplayPop_v2 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data2 = null;
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String com_code = _sessionInfo.getComCode();
		String com_type = _sessionInfo.getBusinessCond();
		String agent_open_flag = _sessionInfo.getAgentOpenFlag();
		/*로그관련 셋팅*/
		pMap.put("REG_ID", _sessionInfo.getUserId());
		pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		
		if("M".equals(com_type)){
			_data2 = commonPopupService.getUserInfoDiaplayListPopCase1(pMap);
		}else if("S".equals(com_type)){
			_data2 = commonPopupService.getUserInfoDiaplayListPopCase2(pMap);
		}else{
			if("N".equals(agent_open_flag)){
				pMap.put("st_com_code", com_code);
				_data2 = commonPopupService.getUserInfoDiaplayListPopCase2(pMap);
			}else{
				_data2 = commonPopupService.getUserInfoDiaplayListPopCase1(pMap);
			}
		}
		
		pModel.addAttribute("data2",CommonUtil.getListNvl( _data2)); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/"+pMap.get("codeGubun");
	}
	
	/**
	 * 공통 조회
	 * 회원사정보
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/getAgentInfoExDiaplay.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getAgentInfoDiaplay(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("getAgentInfoDiaplay 요청 파라미터 for jsp : {}", pMap); 

		List<Map<String, String>> _data1 = commonPopupService.getAgentInfoExDiaplayPop(pMap); 
		List<Map<String, String>> _data2 = null;

		String com_type = "B";
		String referer		= req.getHeader("REFERER");

		/*로그관련 셋팅*/
		pMap.put("REG_ID", "BQMS");
		pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		
		_data2 = commonPopupService.getUserInfoDiaplayListPopCase3(pMap);
		
		pModel.addAttribute("data1", CommonUtil.getListNvl(_data1)); 
		pModel.addAttribute("data2",CommonUtil.getListNvl( _data2)); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/agentInfoDisplayExternPop";
	}
	
	/**
	 * 공통 조회
	 * 거래명세서정보
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/getInvoiceDisplayPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getInvoiceDisplayPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("getInvoiceDisplayPop 요청 파라미터 for jsp : {}", pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String user_id = _sessionInfo.getUserId();
		
		pMap.put("USER_ID", user_id);
		
		List<Map<String, String>> _data1 = commonPopupService.getInvoiceDisplayPop1(pMap); 
		List<Map<String, String>> _data2 = commonPopupService.getInvoiceDisplayPop2(pMap); 
		pModel.addAttribute("data1", CommonUtil.getListNvl(_data1)); 
		pModel.addAttribute("data2", CommonUtil.getListNvl(_data2)); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/"+pMap.get("codeGubun");
	}			
	
	/**
	 * 공통 조회
	 * ICOMCOD1
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/commonIcomcod1List.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String commonIcomcod1List(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("commonIcomcod1List 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = commonPopupService.commonIcomcod1List(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/"+pMap.get("codeGubun");
	}	
	/**
	 * 공통 조회
	 * ICOMCOD1 조건입력 가능 화면
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/getIcomcod1WhereList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getIcomcod1WhereList(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("getIcomcod1WhereList 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = commonPopupService.getIcomcod1WhereList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/"+pMap.get("codeGubun");
	}
	/**
	 * 공통 조회
	 * ICOMCOD2
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/getIcomcod2List.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String commonIcomcod2List(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("commonIcomcod2List 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = commonPopupService.getIcomcod2List(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/"+pMap.get("codeGubun");
	}
	@RequestMapping(value = "/common/getIcomcod2List_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getIcomcod2List_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getIcomcod2List_v2 요청 파라미터 : {}", pMap);

		List<Map<String,String>> _data = commonPopupService.getIcomcod2List_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 공통 조회
	 * ICOMCOD1 ~~ ICOMCOD5
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/icomcdpopList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String icomcdpopList(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("icomcdpopList 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = commonPopupService.icomcdpopList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/"+pMap.get("codeGubun");
	}			
	/**
	 * KeP담당자
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/kepManagerPop.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String kepManagerPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("icomcdpopList 요청 파라미터 for jsp : {}", pMap); 
		Map<String, String> _data = commonPopupService.kepManagerPop(pMap); 
		pModel.addAttribute("data", _data); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/kepManagerPop";
	}
	
	/**
	 * 부서 상세정보 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/coco/getCommonCoCoDepartmentDetailViewPop.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String commonCoCoDepartmentDetailViewPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("commonCoCoDepartmentDetailViewPop 요청 파라미터 for jsp : {}", pMap);
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_com_code", CommonUtil.nvl((String)  pMap.get("st_com_code"),_sessionInfo.getComCode()));
		pMap.put("st_dept", CommonUtil.nvl((String)  pMap.get("st_dept"),_sessionInfo.getDepartment()));
		List<Map<String,String>> _data = commonPopupService.commonCoCoDepartmentDetailViewPop(pMap); // 조회된 결과
		pModel.addAttribute("data", _data);
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/coco/commonCoCoDepartmentDetailViewPop";
	}
	
	/**
	 * 계정항목 선택 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/coco/getCommonCoCoAccountItemPop.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String commonCoCoAccountItemPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("commonCoCoAccountItemPop 요청 파라미터 for jsp : {}", pMap);
		List<Map<String,String>> _data = commonPopupService.commonCoCoAccountItemPop(); // 조회된 결과
		pModel.addAttribute("data", _data);
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/coco/commonCoCoAccountItemPop";
	}
	
	/**
	 * 국가코드 검색 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/coco/getCommonCoCoNationCodePop.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String commonCoCoNationCodePop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("commonCoCoNationCodePop 요청 파라미터 for jsp : {}", pMap);
		String country_search = pMap.get("country_search") == null ? "대한민국" : pMap.get("country_search");
		pMap.put("country_search", country_search);
		List<Map<String,String>> _data = commonPopupService.commonCoCoNationCodePop(pMap); // 조회된 결과
		pModel.addAttribute("data", _data);
		pModel.addAttribute("country_search", country_search);
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/coco/commonCoCoNationCodePop";
	}
	
	/**
	 * 고객사 등록정보 중 업종구분표 선택 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/coco/getCommonCoCoBuyerBusnstypeClassifyPop.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoBuyerBusnstypeClassifyPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("getCommonCoCoBuyerBusnstypeClassifyPop 요청 파라미터 for jsp : {}", pMap);
		List<Map<String,String>> _data = commonPopupService.getCommonCoCoBuyerBusnstypeClassifyPop(pMap); // 조회된 결과
		pModel.addAttribute("data", _data);
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/coco/commonCoCoBuyerBusnstypeClassifyPop";
	}
	
	/**
	 * 제품조달방법-거래유형별 선택 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/coco/getCommonCoCoGoodsDlvyClssifyPop.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoGoodsDlvyClssifyPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("getCommonCoCoGoodsDlvyClssifyPop 요청 파라미터 for jsp : {}", pMap);
		String st_com_code = CommonUtil.nvl(req.getParameter("st_buyer_code"), "");
		pMap.put("st_com_code", st_com_code);
		List<Map<String,String>> _data = commonPopupService.getCommonCoCoGoodsDlvyClssifyPop(pMap); // 조회된 결과
		if(!"".equals(st_com_code)){
			Map<String, String> cmpy_info = commonPopupService.getCmpyInfoPop(pMap);
			pModel.addAttribute("cmpy_info", cmpy_info);
		}
		pModel.addAttribute("data", _data);
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/coco/commonCoCoGoodsDlvyClssifyPop";
	}
	
	/**
	 * 제품조달방법-거래유형별 선택 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/coco/getCommonCoCoGoodsDlvyClssifyPop2.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoGoodsDlvyClssifyPop2(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("getCommonCoCoGoodsDlvyClssifyPop2 요청 파라미터 for jsp : {}", pMap);
		String st_com_code = CommonUtil.nvl(req.getParameter("st_buyer_code"), "");
		
		pMap.put("st_com_code", st_com_code);
		pMap.put("st_gubun", CommonUtil.nvl((String)  pMap.get("st_gubun"),"N"));
		
		List<Map<String,String>> _data = commonPopupService.getCommonCoCoGoodsDlvyClssifyPop(pMap); // 조회된 결과
		if(!"".equals(st_com_code)){
			Map<String, String> cmpy_info = commonPopupService.getCmpyInfoPop(pMap);
			pModel.addAttribute("cmpy_info", cmpy_info);
		}
		pModel.addAttribute("data", _data);
		pModel.addAllAttributes(pMap);
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/coco/commonCoCoGoodsDlvyClssifyPop2";
	}
	
	/**
	 * 취급가능품목 선택 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/coco/getCommonCoCoTranGoodsPop.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoTranGoodsPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("getCommonCoCoTranGoodsPop 요청 파라미터 for jsp : {}", pMap);
		List<Map<String,String>> _data = commonPopupService.getCommonCoCoTranGoodsPop(); // 조회된 결과
		pModel.addAttribute("data", _data);

		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/coco/commonCoCoTranGoodsPop";
	}

	/**
	 * 취급가능품목 선택 팝업 (JSON 응답 - 레이어 팝업용)
	 */
	@NoLoginCheck
	@RequestMapping(value = "/coco/getCommonCoCoTranGoodsListJson.do", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCommonCoCoTranGoodsListJson(HttpServletRequest req) {
		LOGGER.debug("getCommonCoCoTranGoodsListJson 요청");
		Map<String, Object> response = new HashMap<String, Object>();
		List<Map<String, String>> data = commonPopupService.getCommonCoCoTranGoodsPop();
		response.put("data", CommonUtil.getListNvl(data));
		response.put("totalCount", data != null ? data.size() : 0);
		return response;
	}
	
	/**
	 * 물류센터 카테고리 조회 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/coco/getCommonCoCoLogisticCenterCatalogPop.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoLogisticCenterCatalogPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("getCommonCoCoLogisticCenterCatalogPop 요청 파라미터 for jsp : {}", pMap);
		List<Map<String,String>> _data = commonPopupService.getCommonCoCoLogisticCenterCatalogPop(pMap); // 조회된 결과
		pModel.addAttribute("data", _data);
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/coco/commonCoCoLogisticCenterCatalogPop";
	}
	
	/**
	 * 발주부서 조회 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/coco/getCommonCoCoOrderDepartmentSearchPop.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoOrderDepartmentSearchPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("getCommonCoCoOrderDepartmentSearchPop 요청 파라미터 for jsp : {}", pMap);
		List<Map<String,String>> _data = commonPopupService.getCommonCoCoOrderDepartmentSearchPop(pMap); // 조회된 결과
		pModel.addAttribute("data", _data);
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/coco/commonCoCoOrderDepartmentSearchPop";
	}
	@RequestMapping(value = "/coco/getCommonCoCoOrderDepartmentSearchPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCommonCoCoOrderDepartmentSearchPop_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		
		List<Map<String, String>> _data = commonPopupService.getCommonCoCoOrderDepartmentSearchPop_v2(pMap); 
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/**
	 * 고객사/협력사 조회 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/coco/getCommonCoCoCompanyPop.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoCompanyPop(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletRequest req) {
		LOGGER.debug("getCommonCoCoCompanyPop 요청 파라미터 for jsp : {}", pMap);
		
		pMap.put("com_type", CommonUtil.nvl((String)  pMap.get("com_type"),""));
		pMap.put("multi_flag", CommonUtil.nvl((String)  pMap.get("multi_flag"),""));
		pMap.put("safety_flag", CommonUtil.nvl((String)  pMap.get("safety_flag"),""));
		pMap.put("com_name_arry", CommonUtil.StrToArray(CommonUtil.nvl((String)  pMap.get("com_name"),""),","));
		
		List<Map<String,String>> _data = commonPopupService.getCommonCoCoCompanyPop(pMap); // 조회된 결과
		pModel.addAttribute("data", _data);
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/coco/commonCoCoCompanyPop";
	}
	
	/**
	 * 사용자 선택 2 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/coco/getCommonCoCoUserChoice2Pop.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoUserChoice2Pop(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletRequest req) {
		LOGGER.debug("getCommonCoCoUserChoice2Pop 요청 파라미터 for jsp : {}", pMap);
		
		pMap.put("st_user_name", CommonUtil.nvl((String)  pMap.get("st_user_name"),""));
		pMap.put("st_com_name", CommonUtil.nvl((String)  pMap.get("st_com_name"),""));
		pMap.put("st_com_code", CommonUtil.nvl((String)  pMap.get("st_com_code"),""));
		
		List<Map<String,String>> _data = commonPopupService.getCommonCoCoUserChoice2Pop(pMap); // 조회된 결과
		
		pModel.addAttribute("data", _data);
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/coco/commonCoCoUserChoice2Pop";
	}
	
	/**
	 * 예산부서 코드
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/coco/getCommonCoCoBudgetDepartmentCodePop.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoBudgetDepartmentCodePop(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletRequest req) {
		LOGGER.debug("getCommonCoCoBudgetDepartmentCodePop 요청 파라미터 for jsp : {}", pMap);
		
		pMap.put("st_com_code", CommonUtil.nvl((String)  pMap.get("st_com_code"),""));
		pMap.put("st_bdgt_dept_name", CommonUtil.nvl((String)  pMap.get("st_bdgt_dept_name"),""));
		
		List<Map<String,String>> _data = commonPopupService.getCommonCoCoBudgetDepartmentCodePop(pMap); // 조회된 결과
		
		pModel.addAttribute("data", _data);
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/coco/commonCoCoBudgetDepartmentCodePop";
	}
	
	/**
	 * 부서별계정 선택 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/coco/getCommonCoCoBudgetDepartmentCodeDiffPop.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoBudgetDepartmentCodeDiffPop(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletRequest req) {
		LOGGER.debug("getCommonCoCoBudgetDepartmentCodeDiffPop 요청 파라미터 for jsp : {}", pMap);
		
		pMap.put("st_com_code", CommonUtil.nvl((String)  pMap.get("st_com_code"),""));
		pMap.put("st_bdgt_dept_name", CommonUtil.nvl((String)  pMap.get("st_bdgt_dept_name"),""));
		
		List<Map<String,String>> _data = commonPopupService.getCommonCoCoBudgetDepartmentCodeDiffPop(pMap); // 조회된 결과
		
		pModel.addAttribute("data", _data);
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/coco/commonCoCoBudgetDepartmentCodeDiffPop";
	}
	
	/**
	 * 담당팀구분 선택 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/coco/getCommonCoCoTeamClassifyPop.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoTeamClassifyPop(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletRequest req) {
		LOGGER.debug("getCommonCoCoTeamClassifyPop 요청 파라미터 for jsp : {}", pMap);
		
		List<Map<String,String>> _data = commonPopupService.getCommonCoCoTeamClassifyPop(pMap); // 조회된 결과
		
		pModel.addAttribute("data", _data);
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/coco/commonCoCoTeamClassifyPop";
	}
	
	/**
	 * 기존카탈로그 선택 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/coco/getCommonCoCoExistingCatalogPop.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoExistingCatalogPop(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletRequest req) {
		LOGGER.debug("getCommonCoCoExistingCatalogPop 요청 파라미터 for jsp : {}", pMap);
		
		Map<String, String> _buyer_info = commonPopupService.getSysopCatalogBuyerInfo(pMap);	// 고객사 정보 조회
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap.put("st_session_com_code", _sessionInfo.getComCode());
		pMap.put("st_business_cond", _sessionInfo.getBusinessCond());
		pMap.put("st_byca_comorg_code", _buyer_info.get("BYCA_COMORG_CODE"));
		
		List<Map<String,String>> _data = commonPopupService.getCommonCoCoExistingCatalogPop(pMap); // 조회된 결과
		
		pModel.addAttribute("buyer_info", _buyer_info);
		pModel.addAttribute("data", _data);
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/coco/commonCoCoExistingCatalogPop";
	}
	
	
	
	/**
	 * 관리 고객사 지정 최초 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/showAdminSafetyCompanyCodePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showAdminSafetyCompanyCodePop(ModelMap pModel,   HttpServletRequest req , @RequestParam Map<String, String> pMap) {
 

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
 
		pMap.put("userid", _sessionInfo.getUserId()); 
		pMap.put("buyer", _sessionInfo.getComCode() );		
		
		
		List<Map<String, String>> _dataLeft = null;
		List<Map<String, String>> _dataRight = commonPopupService.getAdminSafetyCompanyCodeRightList(pMap); 
		
		
		pModel.addAttribute("dataLeft", CommonUtil.getListNvl(_dataLeft)); 
		pModel.addAttribute("dataRight", CommonUtil.getListNvl(_dataRight)); 
		pModel.addAttribute("result","S"); 
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/AdminSafetyCompanyCodePop";
	}
	
	
	/**
	 * 관리 고객사 지정 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/getAdminSafetyCompanyCodePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getAdminSafetyCompanyCodePop(ModelMap pModel,   HttpServletRequest req , @RequestParam Map<String, String> pMap) {
 

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
 
		pMap.put("userid", _sessionInfo.getUserId()); 
		pMap.put("buyer", _sessionInfo.getComCode() );		
		
		
		List<Map<String, String>> _dataLeft = commonPopupService.getAdminSafetyCompanyCodeLeftList(pMap); 
		List<Map<String, String>> _dataRight = commonPopupService.getAdminSafetyCompanyCodeRightList(pMap); 
		
		
		pModel.addAttribute("dataLeft", CommonUtil.getListNvl(_dataLeft)); 
		pModel.addAttribute("dataRight", CommonUtil.getListNvl(_dataRight)); 
		pModel.addAttribute("result","S"); 
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/AdminSafetyCompanyCodePop";
	}
	
	/**
	 * 관리 고객사 지정 등록,삭제
	 * @param pModel
	 * @param pMap 
	 * @return
	 */	
	@RequestMapping(value = "/common/saveAdminSafetyCompanyCode.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveAdminSafetyCompanyCode(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>(); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
 
		pMap.put("userid", _sessionInfo.getUserId()); 
		pMap.put("buyer", _sessionInfo.getComCode() );		
		
		String msg = commonPopupService.saveAdminSafetyCompanyCode(pMap);
		
		msg = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	/**
	 * 공급유형별 협력사 검색 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpso/getMasterMpSoAgntcmpyTypePop.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpSoAgntcmpyTypePop(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletRequest req) {
		LOGGER.debug("getMasterMpSoAgntcmpyTypePop 요청 파라미터 for jsp : {}", pMap);
		
		pMap.put("st_warehouse_code", CommonUtil.nvl((String)  pMap.get("st_warehouse_code"),""));
		pMap.put("st_process_type", CommonUtil.nvl((String)  pMap.get("st_process_type"),""));
		
		List<Map<String,String>> _data = commonPopupService.getMasterMpSoAgntcmpyTypePop(pMap); // 조회된 결과
		
		pModel.addAttribute("data", _data);
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/mpso/masterMpSoAgntcmpyTypePop";
	}
	
	/**
	 * 물류센터 검색 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpso/getMasterMpSoWmsSearchPop.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpSoWmsSearchPop(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletRequest req) {
		LOGGER.debug("getMasterMpSoWmsSearchPop 요청 파라미터 for jsp : {}", pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_com_code", CommonUtil.nvl((String)  pMap.get("st_com_code"),_sessionInfo.getComCode()));
		
		List<Map<String,String>> _data = commonPopupService.getMasterMpSoWmsSearchPop(pMap); // 조회된 결과
		
		pModel.addAttribute("data", _data);
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/mpso/masterMpSoWmsSearchPop";
	}
	
	/**
	 * 부서선택 팝업 ( 특수로직 유무 조회 )
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/getDeptCodeAdminCowayYn.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getDeptCodeAdminCowayYn(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		
		List<Map<String, String>> _data = null;
		String st_coway_yn = commonPopupService.getDeptCodeAdminCowayYn(pMap); // 조회된 결과
		String st_open = pMap.get("st_open");
		
		if(!"Y".equals(st_coway_yn) && "Y".equals(st_open)){
			_data = commonPopupService.commonList(pMap); 
		}
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		pModel.addAttribute("st_coway_yn", st_coway_yn);
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/deptCodeAdminPop";
	}
	
	/**
	 * 고객사 그리고 일정기간동안 해당 협력사의 발주여부 체크
	 * @param pMap
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/common/getCheckedPoAgentList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getCheckedPoAgentList(@RequestParam Map<String, Object> pMap, HttpServletRequest req) {
		LOGGER.debug("getCheckedPoAgentList 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		String _checkFlag = commonPopupService.getCheckedPoAgentList(pMap);
		_response.put("check_flag", _checkFlag);
		return  _response; 
	}
	
	/**
	 * 고객사 그리고 해당 부서의 관리고객사와 일정기간동안 거래중인 협력사의 발주여부 체크
	 * @param pMap
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/common/getCheckedPoAgentDeptList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getCheckedPoAgentDeptList(@RequestParam Map<String, Object> pMap, HttpServletRequest req) {
		LOGGER.debug("getCheckedPoAgentDeptList 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		String _checkFlag = commonPopupService.getCheckedPoAgentDeptList(pMap);
		_response.put("check_flag", _checkFlag);
		return  _response; 
	}
	
	/**
	 * 코웨이 대표코드 조회(팝업)
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/getZcodeList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getZcodeList(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("getZcodeList 요청 파라미터 for jsp : {}", pMap);
		List<Map<String, String>> _data = commonPopupService.getZcodeList(pMap);
		StringBuffer sb = new StringBuffer();
		sb.append("<option value='' >-- 선택 --</option>");
		for (Map<String, String> map : _data) {
			sb.append("<option value=\"");
			sb.append(map.get("ZCODE"));
			sb.append("&");
			sb.append(map.get("BCODE"));
			sb.append("&");
			sb.append(String.valueOf(map.get("COWAY_BUDAM_PRICE")));
			sb.append("&");
			sb.append(map.get("ZNAME"));
			sb.append("&");
			sb.append(map.get("GONGJE"));
			sb.append("&");
			sb.append(map.get("LMENGE"));
			sb.append("&");
			sb.append(map.get("SMENGE"));
			sb.append("\"");
			sb.append(map.get("ZCODE").equals(pMap.get("st_zcode"))?" selected":"");
			sb.append(">");
			sb.append(map.get("ZCODE"));
			sb.append(" ").append(map.get("ZNAME"));
			sb.append(" ").append(map.get("MAKTX"));
			sb.append("</option>");
		}
		pModel.putAll(pMap);
		pModel.put("data", _data);
		pModel.put("zcodeList", sb.toString());
		return "common/popup/zcodeSelectPop";
	}
	
	/**
	 * k tag 업데이트
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/updateKtagList.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> updateKtagList(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/common/updateKtagList.do 요청 파라미터 for jsp : {}", pMap); 
		Map<String, String> _response = new HashMap<String, String>();
		
		String flag = commonPopupService.updateKtagList(pMap);
		
		_response.put("msg", flag);
				
		return _response;
	}
	
	/**
	 * 공통 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/getCode2PopSearchPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCode2PopSearchPop(HttpServletRequest request, ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("getPositionCodePop 요청 파라미터 for jsp : {}", pMap); 
/*		제니퍼 모니터링 자동조회 막고자 주석 HSJ 2021.04.12
		pMap.put("codeGubun", CommonUtil.nvl((String)  pMap.get("codeGubun"),"comCode2PopSearch"));
		pMap.put("st_buyer", CommonUtil.nvl((String)  pMap.get("st_buyer"),""));
		pMap.put("st_type", CommonUtil.nvl((String)  pMap.get("st_type"),""));
		pMap.put("st_code", CommonUtil.nvl((String)  pMap.get("st_code"),""));
		pMap.put("st_text", CommonUtil.nvl((String)  pMap.get("st_text"),""));
		pMap.put("st_text4", CommonUtil.nvl((String)  pMap.get("st_text4"),""));
		List<Map<String, String>> _data = commonPopupService.commonList(pMap); 
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		// 화면에서 보낸값에 의한 화면 전환
*/
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/comCode2PopSearch_v2";
		}else{
			return "common/popup/comCode2PopSearch";
		}
	}
	
	/**
	 * 공통 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/getCode3PopSearchPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCode3PopSearchPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("getPositionCodePop 요청 파라미터 for jsp : {}", pMap); 
		pMap.put("codeGubun", CommonUtil.nvl((String)  pMap.get("codeGubun"),"comCode3PopSearch"));
		pMap.put("st_buyer", CommonUtil.nvl((String)  pMap.get("st_buyer"),""));
		pMap.put("st_type", CommonUtil.nvl((String)  pMap.get("st_type"),""));
		pMap.put("st_code1", CommonUtil.nvl((String)  pMap.get("st_code1"),""));
		pMap.put("st_code2", CommonUtil.nvl((String)  pMap.get("st_code2"),""));
		pMap.put("st_text1", CommonUtil.nvl((String)  pMap.get("st_text1"),""));
		pMap.put("st_text2", CommonUtil.nvl((String)  pMap.get("st_text2"),""));
		List<Map<String, String>> _data = commonPopupService.commonList(pMap); 
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/comCode3PopSearch";
	}
	
	/**
	 * 공통 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/getCode4PopSearchPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCode4PopSearchPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		LOGGER.debug("getCode4PopSearchPop 요청 파라미터 for jsp : {}", pMap); 
		pMap.put("codeGubun", CommonUtil.nvl((String) pMap.get("codeGubun"), "comCode4PopSearch"));
		pMap.put("st_buyer", CommonUtil.nvl((String) pMap.get("st_buyer"),""));
		pMap.put("st_type", CommonUtil.nvl((String) pMap.get("st_type"),""));
		pMap.put("st_gbn", CommonUtil.nvl((String) pMap.get("st_gbn"),""));
		pMap.put("st_code1", CommonUtil.nvl((String) pMap.get("st_code1"),""));
		pMap.put("st_code2", CommonUtil.nvl((String) pMap.get("st_code2"),""));
		pMap.put("st_text1", CommonUtil.nvl((String) pMap.get("st_text1"),""));
		pMap.put("st_text2", CommonUtil.nvl((String) pMap.get("st_text2"),""));
		List<Map<String, String>> _data = commonPopupService.commonList(pMap); 
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		// 화면에서 보낸값에 의한 화면 전환
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/comCode4PopSearch_v2";
		}else{
			return "common/popup/comCode4PopSearch";
		}
	}
	
	/**
	 * 공지사항게시판상세
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/getCoCoNoticeListPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCoCoNoticeListPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("codeGubun", "buyerNoNeNoticeListPop");
		pMap.put("st_buyer", _sessionInfo.getComCode());//고객사코드 셋팅
		
		List<Map<String, String>> _data = commonPopupService.commonList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/commonCoCoNoticeListPop";
	}
	
	/**
	 * 납품가능지역
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/getDeliveryAreaPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getDeliveryAreaPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		List<Map<String, String>> _data = commonPopupService.getDeliAreaList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/commonDeliveryAreaPop";
	}
	
	/**
	 * 예산부서 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/coco/getCommonCoCoBudgetDeptPop.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoBudgetDeptPop(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletRequest req) {
		LOGGER.debug("getCommonCoCoBudgetDeptPop 요청 파라미터 for jsp : {}", pMap);
		
		pMap.put("st_com_code", CommonUtil.nvl((String)  pMap.get("st_com_code"),""));
		pMap.put("st_bdgt_dept_name", CommonUtil.nvl((String)  pMap.get("st_bdgt_dept_name"),""));
		
		List<Map<String,String>> _data = commonPopupService.getCommonCoCoBudgetDeptPop(pMap); // 조회된 결과
		
		pModel.addAttribute("data", _data);
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/coco/commonCoCoBudgetDeptPop";
	}
	
	/**
	 * 계정 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/coco/getCommonCoCoAccountPop.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoAccountPop(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletRequest req) {
		LOGGER.debug("getCommonCoCoAccountPop 요청 파라미터 for jsp : {}", pMap);
		
		pMap.put("st_com_code", CommonUtil.nvl((String)  pMap.get("st_com_code"),""));
		pMap.put("st_account_name", CommonUtil.nvl((String)  pMap.get("st_account_name"),""));
		
		List<Map<String,String>> _data = commonPopupService.getCommonCoCoAccountPop(pMap); // 조회된 결과
		
		pModel.addAttribute("data", _data);
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/coco/commonCoCoAccountPop";
	}
	@RequestMapping(value = "/coco/getCommonCoCoAccountPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCommonCoCoAccountPop_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		pMap = CommonUtil.xss_kep_filter_v2(pMap);
		pMap = IBSheetUtil.removeSlash(pMap);
		// 화면 조회
		List<Map<String, String>> _data = commonPopupService.getCommonCoCoAccountPop(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 공통 조회
	 * 물류비 책정 사유
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/getLogisFeeReasonPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getLogisFeeReasonPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("getLogisFeeReasonPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data1 = commonPopupService.getLogisFeeReasonPop(pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		/*로그관련 셋팅*/
		pMap.put("REG_ID", _sessionInfo.getUserId());
		pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		
		pModel.addAttribute("data1", CommonUtil.getListNvl(_data1)); 
		
		return "common/popup/logisFeeReasonPop";
	}
	/**
	 * 예산부서별 주문금액
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/getBudegtOrderAmtPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBudegtOrderAmtPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("getBudegtOrderAmtPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = commonPopupService.getBudegtOrderAmtPop(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/budegtOrderAmtPop";
	}
	/**
	 * 우편번호 조회(도로명주소 API 사용)
	 * @param pModel
	 * @return
	 */	
	@RequestMapping(value = "/common/newZipCodeSearchPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String newZipCodeSearchPop(ModelMap pModel, HttpServletRequest req) {
		String _main_url = "common/popup/newZipCodeSearchPop";
		return _main_url;
	}
	/**
	 * 고객사 사용자 메일 수신 선택 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/getUserMailRecvChoicePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getUserMailRecvChoicePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		List<Map<String, String>> _data = commonPopupService.getUserMailRecvChoicePop(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/commonUserMailRecvChoicePop";
	}
	/**
	 * 견적입찰상세화면
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/getNsAgentInfoPop.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getNsAgentInfoPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("kepNsAgentInfoPop 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>>_data = commonPopupService.getNsAgentInfoPop(pMap); 
		pModel.addAttribute("data", _data); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/commonNsAgentInfoPop";
	}
	/**
	 * 견적상세팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/getQuotDetailInfoPop.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getQuotDetailInfoPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("getQuotDetailInfoPop 요청 파라미터 for jsp : {}", pMap); 
		String st_buyer = pMap.get("st_buyer");
		Map<String, String> p04402705 = CommonUtil.getSpecialCheckReturnMap(st_buyer,"P04-4027-05");
		String st_col = CommonUtil.nvl(p04402705.get("COL01_DATA"),"A");
		
		pMap.put("st_col", st_col);
		
		List<Map<String, String>>_data = commonPopupService.getQuotDetailInfoPop(pMap); 
		pModel.addAttribute("data", _data); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/commonQuotDetailInfoPop";
	}
	/**
	 * 견적상세팝업 -> 견적단가 상세팝업_v2
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/getQuotDetailInfoPop_v2.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getQuotDetailInfoPop_v2(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		
		String st_buyer = pMap.get("st_buyer");
		Map<String, String> p04402705 = CommonUtil.getSpecialCheckReturnMap(st_buyer,"P04-4027-05");
		String st_col = "A";
		if(!MapUtils.isEmpty(p04402705)) {
			st_col = CommonUtil.nvl(p04402705.get("COL01_DATA"),"A");
		}
		
		
		pMap.put("st_col", st_col);
		
		LOGGER.debug("getQuotDetailInfoPop_v2 요청 파라미터 for jsp : {}", pMap); 
		
		// 상품정보
		Map<String, String>_itemdata = commonPopupService.getQuotDetailInfoPop2(pMap); 
		pModel.addAttribute("itemdata", _itemdata); 
		
		
		// 견적제안 이력
		List<Map<String, String>> _negodata = buyerMpRqQuotationNegoHistoryPopService.getList(pMap);
		pModel.addAttribute("negodata", CommonUtil.getListNvl(_negodata));

		
		// 제출상세
		List<Map<String, String>>_data = commonPopupService.getQuotDetailInfoPop(pMap); 
		pModel.addAttribute("data", _data); 
		
		
		pModel.addAllAttributes(pMap);
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/commonQuotDetailInfoPop_v2";
	}
	/**
	 * 고객사 납품가능지역 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/getBuyerDelyAreaInfoPop.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerDelyAreaInfoPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("getBuyerDelyAreaInfoPop 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>>_data = commonPopupService.getBuyerDelyAreaInfoPop(pMap); 
		pModel.addAttribute("data", _data); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/commonBuyerDelyAreaInfoPop";
	}
	/**
	 * 네고이력 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/getNegoLogInfo.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getNegoLogInfo(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("getNegoLogInfo 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>>_data = commonPopupService.getNegoLogInfo(pMap); 
		pModel.addAttribute("data", _data); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/commonNegoLogInfoPop";
	}
	/**
	 * 개인정보처리방침 - 협력사리스트
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/pop_privacy_seller.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String pop_privacy_seller(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if(_sessionInfo != null){
			pMap.put("SESSION_COM_CODE", _sessionInfo.getComCode());
		}else {
			pMap.put("SESSION_COM_CODE", "");
		}
		
		List<Map<String, String>> _data = null;
		
		_data = commonPopupService.getPrivacySeller(pMap); 
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/pop_privacy_seller";
	}
	/**
	 * 공통 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/commonDlyLocationList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String commonDlyLocationList(HttpServletRequest req,ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("commonList 요청 파라미터 for jsp : {}", pMap); 
		/*로그관련 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("REG_ID", _sessionInfo.getUserId());
			pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		}else{
			pMap.put("REG_ID","");
			pMap.put("REG_IP", "");
		}
		if(pMap.get("codeGubun").equals("delLocationPop")) {
			String[] arrayDely = ((String) pMap.get("st_delyto_field")).split("/");
			pMap.put("RESULT_IN_Dely", arrayDely);
		}
		List<Map<String, String>> _data = commonPopupService.commonDlyLocationList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAttribute("result","S"); 
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/delLocationPop";
	}
	@NoLoginCheck
	@RequestMapping(value = "/common/commonDlyLocationList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> commonDlyLocationList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		LOGGER.debug("commonList 요청 파라미터 for jsp : {}", pMap); 
		/*로그관련 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("REG_ID", _sessionInfo.getUserId());
			pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		}else{
			pMap.put("REG_ID","");
			pMap.put("REG_IP", "");
		}
		if(pMap.get("codeGubun").equals("delLocationPop")) {
			String[] arrayDely = ((String) pMap.get("st_delyto_field")).split("/");
			pMap.put("RESULT_IN_Dely", arrayDely);
		}
		List<Map<String, String>> _data = commonPopupService.commonDlyLocationList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 공통 조회
	 * 협력사별 발주관리 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/getAgentPoMngPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getAgentPoMngPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("getAgentPoMngPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data1 = commonPopupService.getAgentInfoDiaplayPop(pMap); 
		List<Map<String, String>> _data2 = null;
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		/*로그관련 셋팅*/
		pMap.put("REG_ID", _sessionInfo.getUserId());
		pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		
		_data2 = commonPopupService.getUserInfoDiaplayListPopCase1(pMap);
		
		pModel.addAttribute("data1", CommonUtil.getListNvl(_data1)); 
		pModel.addAttribute("data2",CommonUtil.getListNvl( _data2)); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/mpso/"+pMap.get("codeGubun");
	}
	
	/**
	 * 회원가입 회원사 검색 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/getComCodeList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getComCodeList(HttpServletRequest req,ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("comCodeList 요청 파라미터 for jsp : {}", pMap); 

		List<Map<String, String>> _data = commonPopupService.getComCodeList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/main/comCodeListPop";
	}
	
	@RequestMapping(value = "/common/getCompanyInfo_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCompanyInfo_v2(HttpServletRequest req,ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("getCompanyInfo_v2 요청 파라미터 for jsp : {}", pMap); 

		List<Map<String, String>> _data = commonPopupService.getCompanyInfo_v2(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/main/renewal_kep_manager";
	}
	@NoLoginCheck
	@RequestMapping(value = "/common/getKepManager_v2.do", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getKepManager_v2(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("getKepManager_v2 요청 파라미터 : {}", pMap);
		Map<String, Object> response = new HashMap<String, Object>();
		List<Map<String, String>> data = commonPopupService.getKepManager_v2(pMap);
		response.put("data", CommonUtil.getListNvl(data));
		return response;
	}
	
	/**
	 * 회원가입 회원사 검색 (JSON 응답 - 레이어 팝업용)
	 */
	@NoLoginCheck
	@RequestMapping(value = "/common/getComCodeListJson.do", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getComCodeListJson(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("getComCodeListJson 요청 파라미터 : {}", pMap);
		Map<String, Object> response = new HashMap<String, Object>();
		List<Map<String, String>> data = commonPopupService.getComCodeList(pMap);
		response.put("data", CommonUtil.getListNvl(data));
		response.put("totalCount", data != null ? data.size() : 0);
		return response;
	}

	// BQMS 배송조회 팝업 링크
	@RequestMapping(value = "/common/show_pop_bqms_invoice.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String show_pop_bqms_invoice(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/bqmsInvoiceSearchPop";
	}
	
	// BQMS 배송조회 팝업 링크
	@RequestMapping(value = "/common/get_pop_bqms_invoice.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String get_pop_bqms_invoice(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
		List<Map<String, String>> _data = null;
		
		_data = commonPopupService.getBqmsInvoiceSearch(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/bqmsInvoiceSearchPop";
	}
	
	/**
	 * 회원 조회 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/getUserInfoSearchPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getUserInfoSearchPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		LOGGER.debug("getUserInfoSearchPop 요청 파라미터 for jsp : {}", pMap); 
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/getUserInfoSearchPop_v2";
		}else{
			return "common/popup/getUserInfoSearchPop";
		}
	}
	
	/**
	 * 회원 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/getUserList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getUserList(HttpServletRequest req,ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("userList 요청 파라미터 for jsp : {}", pMap); 
		/*로그관련 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("REG_ID", _sessionInfo.getUserId());
			pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		}else{
			pMap.put("REG_ID","");
			pMap.put("REG_IP", "");
		}

		List<Map<String, String>> _data = commonPopupService.getUserList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/getUserInfoSearchPop";
	}
	@RequestMapping(value = "/common/getUserList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getUserList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getUserList_v2 요청 파라미터 : {}", pMap);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("REG_ID", _sessionInfo.getUserId());
			pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		}else{
			pMap.put("REG_ID","");
			pMap.put("REG_IP", "");
		}
		
		List<Map<String,String>> _data = commonPopupService.getUserList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 납품가능지역 - 리뉴얼
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/getDeliveryAreaPop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getDeliveryAreaPop_v2(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		List<Map<String, String>> _data = commonPopupService.getDeliAreaList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/commonDeliveryAreaPop_v2";
	}
	
	/**
	 * DOC_NO로 파일 리스트 가져가기 - 리뉴얼
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/common/getFileList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, String>> getFileList_v2(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		List<Map<String, String>> fileData = new ArrayList<Map<String,String>>();
		pMap.put("docNo", pMap.get("DOC_NO"));
		fileData = commonPopupService.getFileList_v2(pMap);

		return fileData;	
	}
//	@RequestMapping(value = "/common/getSellerMpRqFile_v2.do", method = RequestMethod.POST)
//	public String getCustomerAmountDay(ModelMap pModel,HttpServletRequest req, @RequestParam Map<String, String> pMap) {
//		List<Map<String, String>> fileData = new ArrayList<Map<String,String>>();
//		fileData = commonPopupService.getSellerMpRqFile_v2(pMap);
//		
//		pModel.addAttribute("fileData", fileData);
//
//		return "common/popup/fileUploadPop_v2";	
//	}
	/**
	 * 견적상세팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/getBuyerQuotDetailInfoPop_v2.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerQuotDetailInfoPop_v2(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, String> pMap) {
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_session_com_code", _sessionInfo.getComCode());//고객사코드 셋팅		
		pMap.put("st_user_id", _sessionInfo.getUserId());
		
		LOGGER.debug("getBuyerQuotDetailInfoPop_v2 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String, String>_data = commonPopupService.getQuotDetailInfoPop_v2(pMap); 
		pModel.addAttribute("data", _data); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/mprq/buyerMpRqQuotaDetailPop_v2";
	}
	@RequestMapping(value = "/common/getBuyerQuotDetailInfoPopSYS_v2.do",method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerQuotDetailInfoPopSYS_v2(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, String> pMap) {
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_session_com_code", _sessionInfo.getComCode());//고객사코드 셋팅		
		pMap.put("st_user_id", _sessionInfo.getUserId());
		
		LOGGER.debug("getBuyerQuotDetailInfoPop_v2 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String, String>_data = commonPopupService.getQuotDetailInfoPopSYS_v2(pMap); 
		pModel.addAttribute("data", _data); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/mprq/buyerMpRqQuotaDetailPopSYS_v2";
	}
	/*
	 * 견적 상세 팝업 - 전체 품목 - 상품 정보 
	 * 
	 */
	@RequestMapping(value = "/common/getBuyerMpRqDetailAllPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerMpRqDetailAllPop_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getBuyerMpRqDetailAllPop_v2 요청 파라미터 : {}", pMap);

		List<Map<String,String>> _data = commonPopupService.getQuotDetailAllPop_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}
