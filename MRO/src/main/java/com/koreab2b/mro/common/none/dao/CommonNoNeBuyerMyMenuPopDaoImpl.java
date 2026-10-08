package com.koreab2b.mro.common.none.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("commonNoNeBuyerMyMenuPopDaoImpl")
@Transactional
public class CommonNoNeBuyerMyMenuPopDaoImpl implements CommonNoNeBuyerMyMenuPopDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.none.selectCommonNoNeBuyerMyMenuPopList", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectMyMenuList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.none.selectBuyerMyMenuList", formData);
	}
	
	// 저장
	public String insertCommonNoNeBuyerMyMenu(Map<String,String> pMap) {
		
		//선택된 디폴트결재선외 초기화
		pMap.put("st_prty_key", "MYMENU_LIST");
		sqlSessionTemplate.update("common.none.deleteBuyerMyMenu_all", pMap);
		
		Map<String,String> param = null;
		
		String user_id = (String) pMap.get("st_user_id");
		String[] arry_prty_value = CommonUtil.StrToArray((String) pMap.get("arry_prty_value"), "||");
		
		for(int inx = 0 ; inx < arry_prty_value.length ; inx++){
			param = new HashMap<String, String>();
			param.put("st_user_id", user_id);
			param.put("st_prty_key", "MYMENU_LIST");
			param.put("st_prty_seq", String.valueOf(inx+1));
			param.put("st_prty_value", arry_prty_value[inx]);
			param.put("st_use_flag", "Y");
			sqlSessionTemplate.update("common.none.insertBuyerMyMenu", param);
		}
		
		return "INSERT_OK";
	}

}
