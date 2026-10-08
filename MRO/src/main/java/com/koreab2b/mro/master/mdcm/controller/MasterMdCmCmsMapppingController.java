package com.koreab2b.mro.master.mdcm.controller;

import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCmsMapppingService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmCmsMapppingController")
public class MasterMdCmCmsMapppingController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmCmsMapppingController.class);

	@Autowired
	private MasterMdCmCmsMapppingService masterMdCmCmsMapppingService;
	
	// 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmCmsMapppingList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterMdCmCmsMapppingList(HttpServletRequest req , HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterMdCmCmsMapppingService.getList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mdcm/excelMasterMdCmCmsMapppingList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public void excelMasterMdCmCmsMapppingList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){

		List<Map<String,String>> _data = masterMdCmCmsMapppingService.getList(pMap); 
		IBSheetUtil.excelOut(req, res, _data);
		 
	}
		
	// CMS매핑
	@RequestMapping(value = "/mdcm/saveMasterMdCmCmsMapppingList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCmCmsMappping(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		logger.debug("saveMasterMpRqItemReqStnd MultiValueMap 요청 파라미터 : formData", pMap); 
		String rtnMsg = masterMdCmCmsMapppingService.updateSelectedData(pMap);

		/* 성공시코드 1 , 실패시 0 */
		/*Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);*/
		_response.put("Message", rtnMsg);
		
		return _response;
		
	}

	// 삭제
	@RequestMapping(value = "/mdcm/delMasterMdCmCmsMapppingList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMdCmCmsMappping(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("delMasterMdCmCmsMappping MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdCmCmsMapppingService.delSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 파일업로드
	@RequestMapping(value = "/mdcm/batchMasterMdCmCmsMapppingList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> batchMasterMdCmCmsMappping(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("batchMasterMdCmCmsMappping MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdCmCmsMapppingService.batchSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

}
