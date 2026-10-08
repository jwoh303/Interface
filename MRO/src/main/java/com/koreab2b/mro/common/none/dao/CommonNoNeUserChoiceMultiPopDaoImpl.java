package com.koreab2b.mro.common.none.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("commonNoNeUserChoiceMultiPopDao")
@Transactional
public class CommonNoNeUserChoiceMultiPopDaoImpl implements CommonNoNeUserChoiceMultiPopDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> getCommonNoNeUserChoiceMultiPop(Map<String,String> formData) {
		/*로그 기록*/
		String st_comorg_type = formData.get("st_comorg_type");
		String strSql = "";
		if(st_comorg_type.equals("B2B")){
			strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("common.none.selectCommonNoNeUserChoiceMultiPopList").getBoundSql(formData).getSql();
		}else if(st_comorg_type.equals("SAFETY")){
			strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("common.none.selectCommonNoNeUserChoiceMultiSafetyPopList").getBoundSql(formData).getSql();
		}else{
			strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("common.none.selectCommonNoNeUserChoiceMultiKwayPopList").getBoundSql(formData).getSql();
		}
		String attr_01 = "";
		for(Map.Entry<String, String>entry: formData.entrySet()){
			attr_01 += entry.getKey() + "="+entry.getValue() + "/";
		}
		Map<String, String> data = new HashMap<String, String>();
		data.putAll(formData);
		data.put("SYSTEM", "KOREAB2B");
		data.put("MENU", "SMS사용자조회");
		data.put("LOG_TYPE", "SMS사용자조회");
		data.put("ATTR_01", strSql+"/"+attr_01);
		data.put("ATTR_02", formData.get("st_user_name")); // 검색한 사용자명
		data.put("ATTR_03", formData.get("st_com_name_loc")); // 검색한 회원사명
		sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
		if(st_comorg_type.equals("B2B")){
			return sqlSessionTemplate.selectList("common.none.selectCommonNoNeUserChoiceMultiPopList", formData);
		}else if(st_comorg_type.equals("SAFETY")){
			return sqlSessionTemplate.selectList("common.none.selectCommonNoNeUserChoiceMultiSafetyPopList", formData);
		}else{
			return sqlSessionTemplate.selectList("common.none.selectCommonNoNeUserChoiceMultiKwayPopList", formData);
		}
		
	}
}
