package com.koreab2b.mro.common.cmco.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterCmCoBuyerAgntcmpyPopDao")
@Transactional
public class MasterCmCoBuyerAgntcmpyPopDaoImpl implements MasterCmCoBuyerAgntcmpyPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		formData.put("arry_com_name", CommonUtil.StrToArray(CommonUtil.nvl((String) formData.get("st_com_name"), ""), ","));
		return sqlSessionTemplate.selectList("common.cmco.selectMasterCmCoBuyerAgntcmpyPopList", formData);
	}
	
}
