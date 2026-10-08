package com.koreab2b.mro.master.wmdl.controller;

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
import com.koreab2b.mro.master.wmdl.service.MasterWmDlDlvryConfirmService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterWmDlDlvryConfirmController")
public class MasterWmDlDlvryConfirmController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmDlDlvryConfirmController.class);

	@Autowired
	private MasterWmDlDlvryConfirmService masterWmDlDlvryConfirmService;
	
	// 조회
	@RequestMapping(value = "/wmdl/getMasterWmDlDlvryConfirmList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterWmDlDlvryConfirmList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterWmDlDlvryConfirmService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	
	// 조회
	@RequestMapping(value = "/wmdl/showMasterWmDlInvoiceNoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmDlInvoiceNoPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcd/showMasterWmDlInvoiceNoPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = masterWmDlDlvryConfirmService.getPop(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		logger.debug("/mdcd/showMasterWmDlInvoiceNoPop.do 요청 파라미터 for jsp : {}", _data); 
		return "common/popup/wmdl/masterWmDlInvoiceNoPop";
	}
	
	// 엑셀다운로드
	@RequestMapping(value = "/wmdl/excelMasterWmDlDlvryConfirmList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterWmDlDlvryConfirmService.getList(pMap);
		IBSheetUtil.excelOut(req, res, CommonUtil.getListNvl(_data));
	}
		
	// 저장
	@RequestMapping(value = "/wmdl/saveMasterWmDlDlvryConfirmList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterWmDlDlvryConfirm(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterWmDlDlvryConfirmService.updateSelectedData(formData, gridData);
		logger.debug("rtnMsg:"+rtnMsg);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		if("OK".equals(rtnMsg)){

			mp.put("Code",1);
		}else{
			mp.put("Code",0);
		}

		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 배송저장
	@RequestMapping(value = "/wmdl/saveMasterWmDlDlvryCenter.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterWmDlDlvryCenter(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterWmDlDlvryConfirmService.updateSelectedDataCenter(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		if("OK".equals(rtnMsg.substring(0, 2))){

			mp.put("Code",2);
			rtnMsg = rtnMsg.substring(2);
		}else{
			mp.put("Code",3);
		}
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

}
