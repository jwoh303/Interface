package com.koreab2b.mro.master.cmcl.controller;


import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.cmcl.service.MasterCmClLogisRateMngUploadService;
import com.koreab2b.mro.util.CommonUtil;


@Controller("masterCmClLogisRateMngUploadController")
public class MasterCmClLogisRateMngUploadController {

	@Autowired
	private MasterCmClLogisRateMngUploadService masterCmClLogisRateMngUploadService;
	
	// 조회
	@RequestMapping(value = "/cmcl/getMasterCmClLogisRateMngUploadList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterCmClLogisRateMngUploadList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterCmClLogisRateMngUploadService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	@RequestMapping(value = "/cmcl/saveMasterCmClLogisRateMngUploadExcel.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> saveMasterCmClLogisRateMngUploadExcel(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterCmClLogisRateMngUploadService.saveExcelUploadData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	@RequestMapping(value = "/cmcl/saveMasterCmClLogisRateMngUploadList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> saveMasterCmClLogisRateMngUploadList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterCmClLogisRateMngUploadService.saveUploadList(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}

}
