package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

public interface MasterMpRqMyAgentGroupService {

	public List<Map<String,Object>> getGroupList(Map<String,Object> formData);

	public List<Map<String,Object>> getGroupAgentList(Map<String,Object> formData);

	public List<Map<String,Object>> getSearchAgentList(Map<String,Object> formData);

	public Map<String,Object> saveNewGroup(String userId, String groupName, boolean merge, List<String> agentCodes);

	public Map<String,Object> saveGroupAgent(String userId, String groupCode, List<String> agentCodes);

	public Map<String,Object> deleteGroup(String userId, String groupCode);

}
