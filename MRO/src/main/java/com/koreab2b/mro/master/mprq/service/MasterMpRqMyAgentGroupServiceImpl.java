package com.koreab2b.mro.master.mprq.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mprq.dao.MasterMpRqMyAgentGroupDao;

@Service("masterMpRqMyAgentGroupService")
public class MasterMpRqMyAgentGroupServiceImpl implements MasterMpRqMyAgentGroupService {

	private static final int MAX_GROUP_CNT = 50;

	private static final int MAX_AGENT_CNT = 100;

	@Autowired
	private MasterMpRqMyAgentGroupDao masterMpRqMyAgentGroupDao;

	public List<Map<String,Object>> getGroupList(Map<String,Object> formData) {
		return masterMpRqMyAgentGroupDao.selectGroupList(formData);
	}

	public List<Map<String,Object>> getGroupAgentList(Map<String,Object> formData) {
		return masterMpRqMyAgentGroupDao.selectGroupAgentList(formData);
	}

	public List<Map<String,Object>> getSearchAgentList(Map<String,Object> formData) {
		return masterMpRqMyAgentGroupDao.selectSearchAgentList(formData);
	}

	@Transactional
	public Map<String,Object> saveNewGroup(String userId, String groupName, boolean merge, List<String> agentCodes) {
		Map<String,Object> _param = new HashMap<String,Object>();
		_param.put("st_user_id", userId);
		_param.put("GROUP_NAME", groupName);

		String _groupCode = masterMpRqMyAgentGroupDao.selectGroupCodeByName(_param);
		List<String> _codes = new ArrayList<String>();
		if (_groupCode != null) {
			if (!merge) {
				return result("DUP", "이미 있는 그룹입니다. 이 그룹에 추가할까요?", _groupCode);
			}
			_param.put("GROUP_CODE", _groupCode);
			_codes.addAll(masterMpRqMyAgentGroupDao.selectGroupAgentCodeList(_param));
		} else if (masterMpRqMyAgentGroupDao.selectGroupCnt(_param) >= MAX_GROUP_CNT) {
			return result("ERR", "그룹은 " + MAX_GROUP_CNT + "개까지 만들 수 있습니다.", null);
		}

		List<String> _adds = new ArrayList<String>();
		for (String _code : agentCodes) {
			if (!_codes.contains(_code) && !_adds.contains(_code)) {
				_adds.add(_code);
			}
		}
		if (_codes.size() + _adds.size() > MAX_AGENT_CNT) {
			return result("ERR", "그룹 한 개에는 협력사를 " + MAX_AGENT_CNT + "개까지 담을 수 있습니다.", null);
		}

		if (_groupCode == null) {
			_groupCode = masterMpRqMyAgentGroupDao.selectGroupNewCode(_param);
			_param.put("GROUP_CODE", _groupCode);
			masterMpRqMyAgentGroupDao.insertGroup(_param);
		}
		int _seq = _codes.size();
		for (String _code : _adds) {
			_param.put("AGENT_CODE", _code);
			_param.put("SEQ", Integer.valueOf(++_seq));
			masterMpRqMyAgentGroupDao.insertGroupAgent(_param);
		}
		return result("OK", null, _groupCode);
	}

	@Transactional
	public Map<String,Object> saveGroupAgent(String userId, String groupCode, List<String> agentCodes) {
		Map<String,Object> _param = new HashMap<String,Object>();
		_param.put("st_user_id", userId);
		_param.put("GROUP_CODE", groupCode);
		if (masterMpRqMyAgentGroupDao.selectGroupOwnCnt(_param) == 0) {
			return result("ERR", "그룹을 찾을 수 없습니다. 다시 조회해 주세요.", null);
		}
		if (agentCodes.size() > MAX_AGENT_CNT) {
			return result("ERR", "그룹 한 개에는 협력사를 " + MAX_AGENT_CNT + "개까지 담을 수 있습니다.", null);
		}
		masterMpRqMyAgentGroupDao.deleteGroupAgentAll(_param);
		int _seq = 0;
		for (String _code : agentCodes) {
			_param.put("AGENT_CODE", _code);
			_param.put("SEQ", Integer.valueOf(++_seq));
			masterMpRqMyAgentGroupDao.insertGroupAgent(_param);
		}
		return result("OK", null, groupCode);
	}

	@Transactional
	public Map<String,Object> deleteGroup(String userId, String groupCode) {
		Map<String,Object> _param = new HashMap<String,Object>();
		_param.put("st_user_id", userId);
		_param.put("GROUP_CODE", groupCode);
		if (masterMpRqMyAgentGroupDao.selectGroupOwnCnt(_param) == 0) {
			return result("ERR", "그룹을 찾을 수 없습니다. 다시 조회해 주세요.", null);
		}
		masterMpRqMyAgentGroupDao.deleteGroupAgentAll(_param);
		masterMpRqMyAgentGroupDao.deleteGroup(_param);
		return result("OK", null, groupCode);
	}

	private Map<String,Object> result(String code, String msg, String groupCode) {
		Map<String,Object> _result = new HashMap<String,Object>();
		_result.put("result", code);
		_result.put("msg", msg);
		_result.put("GROUP_CODE", groupCode);
		return _result;
	}

}
