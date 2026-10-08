package com.koreab2b.mro.master.mdpp.controller;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mdpp.service.MasterMdPpPropListService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdPpPropListController")
public class MasterMdPpPropListController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdPpPropListController.class);

	@Autowired
	private MasterMdPpPropListService masterMdPpPropListService;
	
	// 조회
	@RequestMapping(value = "/mdpp/getMasterMdPpPropList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdPpPropList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdPpPropListService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 상세 팝업
	@RequestMapping(value = "/mdpp/getMasterMdPpPropDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdPpPropDetailPop(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletRequest pRequest) {
		String st_req_user_id = CommonUtil.nvl((String) pMap.get("st_req_user_id"), "");
		String st_pp_no = CommonUtil.nvl((String) pMap.get("st_pp_no"), "");
		
		pMap.put("st_req_user_id", st_req_user_id);
		pMap.put("st_pp_no", st_pp_no);
		
		List<Map<String, String>> _data = masterMdPpPropListService.getMasterMdPpPropDetailPop(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 

		pModel.addAttribute("st_req_user_id", st_req_user_id);
		pModel.addAttribute("st_pp_no", st_pp_no);
		
		return "common/popup/mdpp/masterMdPpPropDetailPop";
	}
	
	// 제안 평가 팝업
	@RequestMapping(value = "/mdpp/getMasterMdPpPropArpsPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdPpPropArpsPop(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletRequest pRequest) {
		String st_arps_id = CommonUtil.nvl((String) pMap.get("st_arps_id"), "");
		String st_pp_no = CommonUtil.nvl((String) pMap.get("st_pp_no"), "");
		
		pMap.put("st_arps_id", st_arps_id);
		pMap.put("st_pp_no", st_pp_no);
		
		List<Map<String, String>> _data = masterMdPpPropListService.getMasterMdPpPropArpsPop(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		pModel.addAttribute("st_arps_id", st_arps_id);
		pModel.addAttribute("st_pp_no", st_pp_no);
		
		return "common/popup/mdpp/masterMdPpPropArpsPop";
	}
	
	// 저장
	@RequestMapping(value = "/mdpp/saveMasterMdPpPropArps.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdPpPropArps(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = masterMdPpPropListService.saveMasterMdPpPropArps(pMap);
		
		_response.put("msg", flag);

		return  _response;
	}
	
	// 불채택 
	@RequestMapping(value = "/mdpp/rejectMasterMdPpPropArps.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> rejectMasterMdPpPropArps(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = masterMdPpPropListService.rejectMasterMdPpPropArps(pMap);
		
		_response.put("msg", flag);

		return  _response;
	}
	
	// 불채택 사유 팝업
	@RequestMapping(value = "/mdpp/getMasterMdPpPropRejectPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdPpPropRejectPop(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletRequest pRequest) {
		String st_pp_no = CommonUtil.nvl((String) pMap.get("st_pp_no"), "");
		String st_pp_seq = CommonUtil.nvl((String) pMap.get("st_pp_seq"), "");
		
		pMap.put("st_pp_no", st_pp_no);
		pMap.put("st_pp_seq", st_pp_seq);
		
		List<Map<String, String>> _data = masterMdPpPropListService.getMasterMdPpPropRejectPop(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 

		pModel.addAttribute("st_pp_no", st_pp_no);
		pModel.addAttribute("st_pp_seq", st_pp_seq);
		
		return "common/popup/mdpp/masterMdPpPropRejectPop";
	}
		
	// 엑셀다운로드
	@RequestMapping(value = "/mdpp/excelMasterMdPpPropList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdPpPropListService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
}
