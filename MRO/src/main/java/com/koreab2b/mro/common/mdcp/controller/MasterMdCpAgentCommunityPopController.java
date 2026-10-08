package com.koreab2b.mro.common.mdcp.controller;

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
import com.koreab2b.mro.common.mdcp.service.MasterMdCpAgentCommunityPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCpAgentCommunityPopController")
public class MasterMdCpAgentCommunityPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCpAgentCommunityPopController.class);

	@Autowired
	private MasterMdCpAgentCommunityPopService masterMdCpAgentCommunityPopService;
	
	// 협력사 커뮤니티 검색조건 조회
	@RequestMapping(value = "/mdcp/getMasterMdCpAgentCommunityInfoList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCpAgentCommunityInfoList(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		List<Map<String,String>> _data = masterMdCpAgentCommunityPopService.getMasterMdCpAgentCommunityInfoList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "common/popup/coco/commonCoCoAgentCommunitySelectPop";
	}

	// 협력사 커뮤니티 리스트 조회
	@RequestMapping(value = "/mdcp/getMasterMdCpAgentCommunityPopList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCpAgentCommunityPopList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = masterMdCpAgentCommunityPopService.getMasterMdCpAgentCommunityPopList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);	
	}

	// 협력사 커뮤니티 상세팝업 내용 조회
	@RequestMapping(value = "/mdcp/searchMasterMdCpAgentCommunityDetailList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String searchMasterMdCpAgentCommunityDetailList(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		List<Map<String,String>> _data = masterMdCpAgentCommunityPopService.getMasterMdCpAgentCommunityInfoList(pMap);
		List<Map<String,String>> _data2 = null;
		if("Y".equals(pMap.get("st_comment_flag"))){
			_data2 = masterMdCpAgentCommunityPopService.selectMasterMdCpAgentCommunityPopContext(pMap);
			
		}
		pModel.addAttribute("data2", CommonUtil.getListNvl(_data2));
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		return "common/popup/coco/commonCoCoAgentCommunityInsertPop";
	}

	// 협력사 커뮤니티 상세팝업 댓글 조회
	@RequestMapping(value = "/mdcp/selectMasterMdCpAgentCommunityPopComment.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> selectMasterMdCpAgentCommunityPopComment(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		List<Map<String,String>> _data = masterMdCpAgentCommunityPopService.selectMasterMdCpAgentCommunityPopComment(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 협력사 커뮤니티 상세팝업 내용 등록
	@RequestMapping(value = "/mdcp/insertMasterMdCpAgentCommunityPopList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> insertMasterMdCpAgentCommunityPopList(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> _msg = new HashMap<String, Object>();
		
		String msg = masterMdCpAgentCommunityPopService.insertMasterMdCpAgentCommunityPopList(pMap);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return _response;
	}

	// 협력사 커뮤니티 상세팝업 내용 삭제
	@RequestMapping(value = "/mdcp/deleteMasterMdCpAgentCommunityPopList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> deleteMasterMdCpAgentCommunityPopList(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> _msg = new HashMap<String, Object>();
		
		String msg = masterMdCpAgentCommunityPopService.deleteMasterMdCpAgentCommunityPopList(pMap);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return _response;
	}
	
	// 협력사 커뮤니티 상세팝업 내용 수정
	@RequestMapping(value = "/mdcp/updateMasterMdCpAgentCommunityPopList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> updateMasterMdCpAgentCommunityPopList(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> _msg = new HashMap<String, Object>();
		 
		String msg = masterMdCpAgentCommunityPopService.updateMasterMdCpAgentCommunityPopList(pMap);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return _response;
	}
	
	// 협력사 커뮤니티 상세팝업 댓글 등록
	@RequestMapping(value = "/mdcp/insertMasterMdCpAgentCommunityPopComment.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> insertMasterMdCpAgentCommunityPopComment(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> _msg = new HashMap<String, Object>();
		
		String msg = masterMdCpAgentCommunityPopService.insertMasterMdCpAgentCommunityPopComment(pMap);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return _response;
	}
	
	// 협력사 커뮤니티 댓글 상세 조회
	@RequestMapping(value = "/mdcp/searchMasterMdCpAgentCommunityCommentDetail.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String searchMasterMdCpAgentCommunityCommentDetail(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		List<Map<String,String>> _data = masterMdCpAgentCommunityPopService.selectMasterMdCpAgentCommunityPopComment(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		return "common/popup/coco/commonCoCoAgentCommunityCommentDetail";
	}
	
}
