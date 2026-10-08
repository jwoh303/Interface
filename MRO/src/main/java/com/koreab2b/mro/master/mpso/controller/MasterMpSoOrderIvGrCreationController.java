package com.koreab2b.mro.master.mpso.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mpso.service.MasterMpSoOrderIvGrCreationService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpSoOrderIvGrCreationController")
public class MasterMpSoOrderIvGrCreationController {
 

	@Autowired
	private MasterMpSoOrderIvGrCreationService masterMpSoOrderIvGrCreationService;
	
	// 조회 PG_06_M_008_00
	///kr/sysop/proxbuy/order/buyer_gr/BuyerOrderCreation.jsp
	///kr/sysop/proxbuy/order/buyer_gr/buyer_order_bulk_action.jsp
	@RequestMapping(value = "/mpso/getMasterMpSoOrderIvGrCreationList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpSoOrderIvGrCreationList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
 

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpSoOrderIvGrCreationService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 엑셀다운로드 - 사용안함
	@RequestMapping(value = "/mpso/excelMasterMpSoOrderIvGrCreationList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpSoOrderIvGrCreationService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
	
	
	// 엑셀 업로딩검증 을 위한 저장 
	//kr/sysop/proxbuy/order/buyer_gr/popup_UploadingResult.jsp
	///kr/sysop/proxbuy/order/buyer_gr/buyer_order_bulk_action.jsp
	//setSaveGridtoDB
	@RequestMapping(value = "/mpso/saveMasterMpSoOrderIvGrCreationListExcelCheck.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpSoOrderIvGrCreationExcelCheck(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMpSoOrderIvGrCreationService.updateSelectedDataExcelCheck(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	
	
	// 엑셀 업로딩검증 결과 조회
	//kr/sysop/proxbuy/order/buyer_gr/popup_UploadingResult.jsp 
	@RequestMapping(value = "/mpso/getMasterMpSoOrderIvGrCreationListExcelResult.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpSoOrderIvGrCreationListExcelResult(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
 

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpSoOrderIvGrCreationService.searchMasterMpSoBuyerOrderCreationListExcelResult(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
	
	// 엑셀 업로딩검증 결과를 저장
	//kr/sysop/proxbuy/order/buyer_gr/popup_UploadingResult.jsp
	///kr/sysop/proxbuy/order/buyer_gr/buyer_order_bulk_action.jsp
	//confirmDel
	@RequestMapping(value = "/mpso/saveMasterMpSoOrderIvGrCreationListExcelCheckResult.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpSoOrderIvGrCreationListExcelCheckResult(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMpSoOrderIvGrCreationService.updateMasterMpSoBuyerOrderCreationListExcelCheckResult(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	
	
	
	
	

		
	// 주문생성 저장
	///kr/sysop/proxbuy/order/buyer_gr/buyer_order_bulk_action.jsp
	//OrderCreatelist
	@RequestMapping(value = "/mpso/saveMasterMpSoOrderIvGrCreationList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpSoOrderIvGrCreation(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMpSoOrderIvGrCreationService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 삭제
	///kr/sysop/proxbuy/order/buyer_gr/buyer_order_bulk_action.jsp
	//del
	@RequestMapping(value = "/mpso/delMasterMpSoOrderIvGrCreationList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMpSoOrderIvGrCreation(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpSoOrderIvGrCreationService.delSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	
	
	// 저장
	///kr/sysop/proxbuy/order/buyer_gr/buyer_order_bulk_action.jsp
	//del
	@RequestMapping(value = "/mpso/savingMasterMpSoOrderIvGrCreationList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> savingMasterMpSoOrderIvGrCreation(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpSoOrderIvGrCreationService.savingSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	
	
	//setOrderCreatePoomList
	// PM번호 생성 - 결재 전처리
	///kr/sysop/proxbuy/etc/sysop_proxybuy_etc_master_kep_price_change_mng_robin_submit.jsp
	///kr/sysop/proxbuy/etc/sysop_proxybuy_etc_master_kep_price_change_mng_robin_submit_reg1.jsp
	//setSysopKepmgpOfReg
	@RequestMapping(value = "/mpso/getPmNoMasterMpSoOrderIvGrCreationList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getPmNoMasterMpSoBuyerOrderCreation(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpSoOrderIvGrCreationService.getPmNoMasterMpSoBuyerOrderCreationList(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	
	// 결재 후처리
	///kr/sysop/proxbuy/etc/sysop_proxybuy_confirm_pop.jsp
	///kr/sysop/proxbuy/etc/sysop_proxybuy_etc_master_kep_price_change_mng_robin_submit_pop_reg_of.jsp
	@RequestMapping(value = "/mpso/savePmNoAfterMasterMpSoOrderIvGrCreationList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> savePmNoAfterMasterMpSoOrderIvGrCreationList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpSoOrderIvGrCreationService.savePmNoAfterMasterMpSoBuyerOrderCreationList(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	

}
