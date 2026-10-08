package com.koreab2b.mro.master.mprq.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mprq.service.MasterMpRqMyAgentGroupService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpRqMyAgentGroupController")
public class MasterMpRqMyAgentGroupController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqMyAgentGroupController.class);

	private static final int MAX_GROUP_NAME_LEN = 50;

	@Autowired
	private MasterMpRqMyAgentGroupService masterMpRqMyAgentGroupService;

	@RequestMapping(value = "/mprq/getMasterMpRqMyAgentGroupList.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqMyAgentGroupList(HttpServletRequest req) {
		Map<String, Object> _param = new HashMap<String, Object>();
		_param.put("st_user_id", getUserId(req));

		Map<String, Object> _response = new HashMap<String, Object>();
		_response.put("data", masterMpRqMyAgentGroupService.getGroupList(_param));
		return _response;
	}

	@RequestMapping(value = "/mprq/getMasterMpRqMyAgentGroupAgentList.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqMyAgentGroupAgentList(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("/mprq/getMasterMpRqMyAgentGroupAgentList.do 요청 파라미터 : {}", pMap);
		Map<String, Object> _param = new HashMap<String, Object>();
		_param.put("st_user_id", getUserId(req));
		_param.put("GROUP_CODE", CommonUtil.nvl(pMap.get("GROUP_CODE")).trim());
		_param.put("st_buyer", CommonUtil.nvl(pMap.get("st_buyer")).trim());

		Map<String, Object> _response = new HashMap<String, Object>();
		_response.put("data", masterMpRqMyAgentGroupService.getGroupAgentList(_param));
		return _response;
	}

	@RequestMapping(value = "/mprq/getMasterMpRqMyAgentGroupSearchAgentList.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqMyAgentGroupSearchAgentList(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("/mprq/getMasterMpRqMyAgentGroupSearchAgentList.do 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		String _agentName = CommonUtil.nvl(pMap.get("st_agent_name")).trim();
		if (_agentName.length() < 2) {
			_response.put("errMsg", "협력사명을 2자 이상 입력하세요.");
			_response.put("data", new ArrayList<Map<String, Object>>());
			return _response;
		}
		Map<String, Object> _param = new HashMap<String, Object>();
		_param.put("st_agent_name", _agentName);
		_param.put("st_buyer", CommonUtil.nvl(pMap.get("st_buyer")).trim());

		_response.put("data", masterMpRqMyAgentGroupService.getSearchAgentList(_param));
		return _response;
	}

	@RequestMapping(value = "/mprq/saveMasterMpRqMyAgentGroup.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqMyAgentGroup(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("/mprq/saveMasterMpRqMyAgentGroup.do 요청 파라미터 : {}", pMap);
		String _groupName = CommonUtil.nvl(pMap.get("GROUP_NAME")).trim();
		List<String> _agentCodes = splitCodes(pMap.get("AGENT_CODES"));
		if ("".equals(_groupName) || _groupName.length() > MAX_GROUP_NAME_LEN) {
			return error("그룹명은 1~" + MAX_GROUP_NAME_LEN + "자로 입력하세요.");
		}
		if (_agentCodes.isEmpty()) {
			return error("담을 협력사가 없습니다.");
		}
		try {
			return masterMpRqMyAgentGroupService.saveNewGroup(getUserId(req), _groupName, "Y".equals(pMap.get("MERGE_YN")), _agentCodes);
		} catch (Exception e) {
			LOGGER.error("나의협력사 그룹 등록 오류", e);
			return error("저장 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
		}
	}

	@RequestMapping(value = "/mprq/saveMasterMpRqMyAgentGroupAgent.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqMyAgentGroupAgent(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("/mprq/saveMasterMpRqMyAgentGroupAgent.do 요청 파라미터 : {}", pMap);
		String _groupCode = CommonUtil.nvl(pMap.get("GROUP_CODE")).trim();
		if ("".equals(_groupCode)) {
			return error("그룹을 선택하세요.");
		}
		try {
			return masterMpRqMyAgentGroupService.saveGroupAgent(getUserId(req), _groupCode, splitCodes(pMap.get("AGENT_CODES")));
		} catch (Exception e) {
			LOGGER.error("나의협력사 그룹 협력사 저장 오류", e);
			return error("저장 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
		}
	}

	@RequestMapping(value = "/mprq/deleteMasterMpRqMyAgentGroup.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteMasterMpRqMyAgentGroup(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("/mprq/deleteMasterMpRqMyAgentGroup.do 요청 파라미터 : {}", pMap);
		String _groupCode = CommonUtil.nvl(pMap.get("GROUP_CODE")).trim();
		if ("".equals(_groupCode)) {
			return error("그룹을 선택하세요.");
		}
		try {
			return masterMpRqMyAgentGroupService.deleteGroup(getUserId(req), _groupCode);
		} catch (Exception e) {
			LOGGER.error("나의협력사 그룹 삭제 오류", e);
			return error("삭제 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
		}
	}

	private String getUserId(HttpServletRequest req) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		return _sessionInfo.getUserId();
	}

	private List<String> splitCodes(String codes) {
		List<String> _list = new ArrayList<String>();
		String[] _arr = CommonUtil.nvl(codes).split(",");
		for (int i = 0; i < _arr.length; i++) {
			String _code = _arr[i].trim();
			if (!"".equals(_code) && !_list.contains(_code)) {
				_list.add(_code);
			}
		}
		return _list;
	}

	private Map<String, Object> error(String msg) {
		Map<String, Object> _response = new HashMap<String, Object>();
		_response.put("result", "ERR");
		_response.put("msg", msg);
		return _response;
	}

}
