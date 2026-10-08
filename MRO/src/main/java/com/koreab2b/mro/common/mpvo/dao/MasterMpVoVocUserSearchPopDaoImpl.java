package com.koreab2b.mro.common.mpvo.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpVoVocUserSearchPopDaoImpl")
@Transactional
public class MasterMpVoVocUserSearchPopDaoImpl  implements MasterMpVoVocUserSearchPopDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> getMasterMpVoVocUserSearchPop(Map<String,Object> formData) {
		formData.put("arry_user_name", CommonUtil.StrToArray(CommonUtil.nvl((String) formData.get("user_name"), ""), ","));
		return sqlSessionTemplate.selectList("common.mpvo.selectMasterMpVoVocUserSearchPop", formData);
	}

}
