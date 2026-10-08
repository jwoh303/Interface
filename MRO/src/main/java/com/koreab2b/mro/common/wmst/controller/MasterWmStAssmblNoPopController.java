package com.koreab2b.mro.common.wmst.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.wmst.service.MasterWmStAssmblNoPopService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterWmStAssmblNoPopController")
public class MasterWmStAssmblNoPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmStAssmblNoPopController.class);

	@Autowired
	private MasterWmStAssmblNoPopService masterWmStAssmblNoPopService;
	
	/**
	 * 조립지시서 상단 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmst/showMasterWmStAssmblNoPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String commonList(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("commonList 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterWmStAssmblNoPopService.getPop(pMap);
		
		pModel.addAttribute("data",_data);
		logger.debug("보낸값 for jsp : {}", pModel); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/wmst/masterWmStAssmblNoPop";
	}	
	
	/**
	 * 조립지시서 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmst/getMasterWmStAssmblNoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void getMasterWmStAssmblNoPop(HttpServletRequest req, HttpServletResponse pRes ,@RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		List<Map<String,String>> _data = masterWmStAssmblNoPopService.getList(pMap);
//		return IBSheetUtil.addResut(req, _data , pMap);
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, pRes);	
	}
	
	// 조립취소 
	@RequestMapping(value = "/wmst/cancleMasterWmStAssmblNoPop.do", method = RequestMethod.POST)
	@ResponseBody
	@Transactional
	public Map<String, Object> updateMasterWmGrTrGrCre(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = "";
		rtnMsg = masterWmStAssmblNoPopService.updateSelectedData(formData, gridData);

		Map<String, Object> mp = new HashMap<String, Object>();
		
		if("OK".equals(rtnMsg)){
			mp.put("Code",1);
		}else if("NO_AVAIL_QTY".equals(rtnMsg)){
			mp.put("Code",2);
		}else{
			mp.put("Code",0);
		}


		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}	
	
	// 조립완료
	@RequestMapping(value = "/wmst/saveMasterWmStAssmblNoPop.do", method = RequestMethod.POST)
	@ResponseBody
	@Transactional
	public Map<String, Object> updateMasterWmGrTrGrCreCom(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = "";
		rtnMsg = masterWmStAssmblNoPopService.updateSelectedDataCom(formData, gridData);

		Map<String, Object> mp = new HashMap<String, Object>();
		
		if("OK".equals(rtnMsg)){
			mp.put("Code",3);
		}else{
			mp.put("Code",4);
		}


		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}	
	
}
