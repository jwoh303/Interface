package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqMyAgentGroupDao {

	public List<Map<String,Object>> selectGroupList(Map<String,Object> formData);

	public List<Map<String,Object>> selectGroupAgentList(Map<String,Object> formData);

	public List<Map<String,Object>> selectSearchAgentList(Map<String,Object> formData);

	public int selectGroupCnt(Map<String,Object> formData);

	public int selectGroupOwnCnt(Map<String,Object> formData);

	public String selectGroupCodeByName(Map<String,Object> formData);

	public String selectGroupNewCode(Map<String,Object> formData);

	public List<String> selectGroupAgentCodeList(Map<String,Object> formData);

	public int insertGroup(Map<String,Object> formData);

	public int insertGroupAgent(Map<String,Object> formData);

	public int deleteGroupAgentAll(Map<String,Object> formData);

	public int deleteGroup(Map<String,Object> formData);

}
