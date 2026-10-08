package com.koreab2b.mro.master.mprq.controller;

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
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mprq.service.MasterMpRqBulkQuotationItemListService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("MasterMpRqBulkQuotationItemListController")
public class MasterMpRqBulkQuotationItemListController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBulkQuotationItemListController.class);

	@Autowired
	private MasterMpRqBulkQuotationItemListService MasterMpRqBulkQuotationItemListService;
	
	// 조회
	@RequestMapping(value = "/mprq/getMasterMpRqBulkQuotationItemList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public  Map<String, Object>  getMasterMpRqBulkQuotationItemList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		LOGGER.debug("searchMasterMpRqQuotationBulkList 요청 파라미터 : {}", pMap);
		
		List<Map<String,String>> _data = MasterMpRqBulkQuotationItemListService.getList(pMap);

		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 프로젝트 선택 팝업
	@RequestMapping(value = "/mprq/getMasterMpRqBulkQuotationSelProjectPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpRqBulkQuotationSelProjectPop(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getMasterMpRqBulkQuotationSelProjectPop 요청 파라미터 for jsp : {}", pMap); 

		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		
		List<Map<String, String>> _data = MasterMpRqBulkQuotationItemListService.getProject(pMap); 
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "/common/popup/mprq/masterMpRqBulkQuotationSelProjectPop";
	}
	
	// 엑셀다운로드
	@RequestMapping(value = "/mprq/excelMasterMpRqBulkQuotationItemList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String, String>> _data = MasterMpRqBulkQuotationItemListService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
	
	// 선택 품목 삭제
	@RequestMapping(value = "/mprq/delMasterMpRqBulkQuotationItemList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMpRqBulkQuotationItemList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		LOGGER.debug("delMasterMpRqBulkQuotationItem 요청 파라미터 : {}", pMap);
				 
		String rtnMsg = MasterMpRqBulkQuotationItemListService.deleteData(pMap);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Msg", rtnMsg);
		return _response;
		
	}

}
