package com.koreab2b.mro.buyer.mdam.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMdAmUserSearchDao")
@Transactional
public class BuyerMdAmUserSearchDaoImpl implements BuyerMdAmUserSearchDao {
	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmUserSearchDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("buyer.mdam.selectBuyerMdAmUserSearchList").getBoundSql(formData).getSql();
		String attr_01 = "";
		for(Map.Entry<String, String>entry: formData.entrySet()){
			attr_01 += entry.getKey() + "="+entry.getValue() + "/";
		}
		Map<String, String> data = new HashMap<String, String>();
		data.putAll(formData);
		data.put("SYSTEM", "KOREAB2B");
		data.put("MENU", "사용자조회(고객사)");
		data.put("LOG_TYPE", "조회");				
		data.put("ATTR_01", strSql+"/"+attr_01);
		data.put("ATTR_02", "");
		data.put("ATTR_03", "");
		sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
		
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmUserSearchList", formData);
	}
	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> formData) {

		String _rtnMsg = "";
		String statusText = "";
		String[] st_change_user_id =  formData.get("st_checked_id").split("\\|");
		if ( formData.get("st_status").equals("D")) {
			statusText = "삭제";
		} else {
			statusText = "복원";
		}

		try {
			for (int i=0; i < st_change_user_id.length; i++) {
				formData.put("st_change_user_id", st_change_user_id[i].toString());
				sqlSessionTemplate.update("buyer.mdam.updateBuyerMdAmUserSearchList",formData);
				
				//로그 생성///////////////////////////////////////////////
				String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("buyer.mdam.updateBuyerMdAmUserSearchList").getBoundSql(formData).getSql();
				String attr_01 = "";
				for(Map.Entry<String, String>entry: formData.entrySet()){
					attr_01 += entry.getKey() + "="+entry.getValue() + "/";
				}
				Map<String, String> data = new HashMap<String, String>();
				data.putAll(formData);
				data.put("SYSTEM", "KOREAB2B");
				data.put("MENU", "사용자조회(고객사)");
				data.put("LOG_TYPE", "사용자 삭제");				
				data.put("ATTR_01", strSql+"/"+attr_01);
				data.put("ATTR_02", "");
				data.put("ATTR_03", "");
				sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
				//////////////////////////////////////////////////////

			}
			_rtnMsg = "OK";
			
		} catch(Exception e) {
			_rtnMsg = "ERR";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("사용자 " + statusText + "이 실패하였습니다");
		}
		return _rtnMsg;
	}

}
