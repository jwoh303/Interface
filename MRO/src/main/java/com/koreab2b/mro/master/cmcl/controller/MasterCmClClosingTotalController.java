package com.koreab2b.mro.master.cmcl.controller;

import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.cmcl.service.MasterCmClClosingTotalService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterCmClClosingTotalController")
public class MasterCmClClosingTotalController {

	@Autowired
	private MasterCmClClosingTotalService masterCmClClosingTotalService;

	// 조회
	@RequestMapping(value = "/cmcl/getMasterCmClClosingTotalList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String searchMasterCmClClosingTotalList(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);

		List<Map<String,String>> _data = masterCmClClosingTotalService.getList(pMap);
		pModel.addAttribute("_data", CommonUtil.getListNvl(_data));

		return "master/cmcl/masterCmClClosingTotalList";
	}

	// 엑셀다운로드
	@RequestMapping(value = "/cmcl/excelMasterCmClClosingTotalList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0");
		
		List<Map<String,String>> _data = masterCmClClosingTotalService.getList(pMap);
		
		String title = "팀명|구분|매출|①수불출고원가|②조정원가|매출원가(①+②)|③비고";
		String headers = "DEPT_NAME|TYPE_TEXT|ITEM_AMT|W_AMT|J_AMT|WJ_AMT|REMARK";
		String excelHeader = title + "@@" + headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"마감집계표.xls");
	}

	// 저장
	@RequestMapping(value = "/cmcl/saveMasterCmClClosingTotalList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterCmClClosingTotal(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();

		String rtnMsg = masterCmClClosingTotalService.updateSelectedData(pMap);

		_response.put("msg", rtnMsg);
		return _response;

	}

	// 삭제
//	@RequestMapping(value = "/cmcl/delMasterCmClClosingTotalList.do", method = RequestMethod.POST)
//	@ResponseBody
//	public Map<String, Object> delMasterCmClClosingTotal(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
//		Map<String, Object> _response = new HashMap<String, Object>();
//
//		// gridData
//		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
//		// formData
//		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
//
//		String rtnMsg = masterCmClClosingTotalService.delSelectedData(formData, gridData);
//		_response.put("Message", rtnMsg);
//
//		return _response;
//	}

}
