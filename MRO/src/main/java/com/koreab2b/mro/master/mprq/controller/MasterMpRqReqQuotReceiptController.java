package com.koreab2b.mro.master.mprq.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mprq.service.MasterMpRqReqQuotReceiptService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpRqReqQuotReceiptController")
public class MasterMpRqReqQuotReceiptController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqReqQuotReceiptController.class);

	@Autowired
	private MasterMpRqReqQuotReceiptService masterMpRqReqQuotReceiptService;
	
	
	/*조회*/
	@RequestMapping(value = "/mprq/searchMasterMpRqReqQuotReceiptList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpRqReqQuotReceiptList(HttpServletRequest req,@RequestParam Map<String, Object> pMap) {
		//LOGGER.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMpRqReqQuotReceiptService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/*엑셀다운로드*/
	@RequestMapping(value = "/mprq/excelMasterMpRqReqQuotReceiptList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpRqReqQuotReceiptService.getList(pMap);
		IBSheetUtil.excelOut(req,res,_data);
	}

	
	/*저장*/
	@RequestMapping(value = "/mprq/updateMasterMpRqReqQuotReceipt.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqReqQuotReceipt(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMpRqReqQuotReceiptService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}

	/*품목재정비 요청*/
	@RequestMapping(value = "/mprq/updateMasterMpRqItemChgReq.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqItemChgReq(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		//LOGGER.debug("요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMpRqReqQuotReceiptService.updateItemChgReqData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	/*견적요청*/
	@RequestMapping(value = "/mprq/orderMasterMpRqReqQuotReceipt.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> orderMasterMpRqReqQuotReceipt(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMpRqReqQuotReceiptService.orderSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

	/*삭제*/
	@RequestMapping(value = "/mprq/delMasterMpRqReqQuotReceipt.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMpRqReqQuotReceipt(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		//LOGGER.debug("delMasterMpRqReqQuotReceipt MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMpRqReqQuotReceiptService.delSelectedData(formData, gridData);
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message",rtnMsg);
		
		return _response;
	}
	/*전략소싱팀 추가라운드*/
	@RequestMapping(value = "/mprq/updateSoMasterMpRqReqNegoReceipt.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSoMasterMpRqReqNegoReceipt(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		//LOGGER.debug("updateSoMasterMpRqReqNegoReceipt MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMpRqReqQuotReceiptService.updateSoMasterMpRqReqNegoReceipt(formData, gridData);
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message",rtnMsg);
		
		return _response;
	}
	/**
	 * 표준카탈로그 매핑.
	 */
	@RequestMapping(value = "/mprq/saveMasterMpRqStndCatalgListPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqStndCatalgListPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String msg = masterMpRqReqQuotReceiptService.saveMasterMpRqStndCatalgListPop(pMap);
		
		msg = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	/**
	 * MSDS여부 확인.
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getMsdsInfo.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMsdsInfo(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		//LOGGER.debug("/mdcm/getSgInfo.do 요청 파라미터 for jsp : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMpRqReqQuotReceiptService.getMsdsInfo(pMap); 
		_response.put("data", _data);
		return _response;
	}
	/*견적이관*/
	@RequestMapping(value = "/mprq/updateMasterMpRqReqQuotTrans.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqReqQuotTrans(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMpRqReqQuotReceiptService.updateMasterMpRqReqQuotTrans(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	// 고객사 납품가능 지역 저장
	@RequestMapping(value = "/mprq/saveMasterMpRqDelyArea.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqDelyArea(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String _rtnMsg = masterMpRqReqQuotReceiptService.saveMasterMpRqDelyArea(pMap);

		_response.put("msg", _rtnMsg);
		return _response;
	}
	
	/*SG 지정*/
	@RequestMapping(value = "/mprq/updateMasterMpRqSGInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqSGInfo(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		//LOGGER.debug("요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpRqReqQuotReceiptService.updateMasterMpRqSGInfo(formData, gridData);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	/*품목정비제출*/
	@RequestMapping(value = "/mprq/updateMasterMpRqItmCheSend.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqItmCheSend(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		//LOGGER.debug("요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpRqReqQuotReceiptService.updateMasterMpRqItmCheSend(formData, gridData);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	/*SG 지정취소*/
	@RequestMapping(value = "/mprq/updateMasterMpRqSGCancle.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqSGCancle(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		//LOGGER.debug("요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpRqReqQuotReceiptService.updateMasterMpRqSGCancle(formData, gridData);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	/* 견적특이사항 메일 발송 */
	@RequestMapping(value = "/mprq/insertMasterMpRqAddNoteSendMail.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insertMasterMpRqAddNoteSendMail(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		//LOGGER.debug("요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpRqReqQuotReceiptService.insertAddNoteSendMail(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	/*운영비고일괄 입력*/
	@RequestMapping(value = "/mprq/saveMasterMpRqReqQuotAdminRemark.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqReqQuotAdminRemark(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		//LOGGER.debug("delMasterMpRqReqQuotReceipt MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMpRqReqQuotReceiptService.saveMasterMpRqReqQuotAdminRemark(formData, gridData);
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message",rtnMsg);
		
		return _response;
	}
	
	/*SG지정 재요청*/
	@RequestMapping(value = "/mprq/updateMasterMpRqSgDReq.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqSgDReq(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		//LOGGER.debug("요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpRqReqQuotReceiptService.updateMasterMpRqSgDReq(formData, gridData);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	/*DB클린징 등록 상품이미지 복사*/
	@RequestMapping(value = "/mprq/updateMasterMpRqDbCleansingImageCopy.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqDbCleansingImageCopy(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		//LOGGER.debug("요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMpRqReqQuotReceiptService.updateMasterMpRqDbCleansingImageCopy(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	/*DB클린징(이미지포함) 복사*/
	@RequestMapping(value = "/mprq/updateMasterMpRqDbCleansingCopy.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqDbCleansingCopy(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		//LOGGER.debug("요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMpRqReqQuotReceiptService.updateMasterMpRqDbCleansingCopy(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
}
