package com.koreab2b.mro.master.mpvo.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpVoStateDownloadDao")
@Transactional
public class MasterMpVoStateDownloadDaoImpl implements MasterMpVoStateDownloadDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		param.put("arry_buyer_code", CommonUtil.StrToArray(CommonUtil.nvl((String) param.get("st_buyer_code"), ""), "@"));
		return sqlSessionTemplate.selectList("master.mpvo.selectMasterMpVoStateDownloadList", param);
	}

}
