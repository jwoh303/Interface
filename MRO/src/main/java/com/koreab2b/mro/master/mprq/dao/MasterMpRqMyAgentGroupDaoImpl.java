package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterMpRqMyAgentGroupDao")
@Transactional
public class MasterMpRqMyAgentGroupDaoImpl implements MasterMpRqMyAgentGroupDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	public List<Map<String,Object>> selectGroupList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqMyAgentGroupList", formData);
	}

	public List<Map<String,Object>> selectGroupAgentList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqMyAgentGroupAgentList", formData);
	}

	public List<Map<String,Object>> selectSearchAgentList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqMyAgentGroupSearchAgentList", formData);
	}

	public int selectGroupCnt(Map<String,Object> formData) {
		return (Integer) sqlSessionTemplate.selectOne("master.mprq.selectMasterMpRqMyAgentGroupCnt", formData);
	}

	public int selectGroupOwnCnt(Map<String,Object> formData) {
		return (Integer) sqlSessionTemplate.selectOne("master.mprq.selectMasterMpRqMyAgentGroupOwnCnt", formData);
	}

	public String selectGroupCodeByName(Map<String,Object> formData) {
		return (String) sqlSessionTemplate.selectOne("master.mprq.selectMasterMpRqMyAgentGroupCodeByName", formData);
	}

	public String selectGroupNewCode(Map<String,Object> formData) {
		return (String) sqlSessionTemplate.selectOne("master.mprq.selectMasterMpRqMyAgentGroupNewCode", formData);
	}

	public List<String> selectGroupAgentCodeList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqMyAgentGroupAgentCodeList", formData);
	}

	public int insertGroup(Map<String,Object> formData) {
		return sqlSessionTemplate.update("master.mprq.insertMasterMpRqMyAgentGroup", formData);
	}

	public int insertGroupAgent(Map<String,Object> formData) {
		return sqlSessionTemplate.update("master.mprq.insertMasterMpRqMyAgentGroupAgent", formData);
	}

	public int deleteGroupAgentAll(Map<String,Object> formData) {
		return sqlSessionTemplate.update("master.mprq.deleteMasterMpRqMyAgentGroupAgentAll", formData);
	}

	public int deleteGroup(Map<String,Object> formData) {
		return sqlSessionTemplate.update("master.mprq.deleteMasterMpRqMyAgentGroup", formData);
	}

}
