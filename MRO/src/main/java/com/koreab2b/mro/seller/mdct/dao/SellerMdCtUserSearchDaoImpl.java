package com.koreab2b.mro.seller.mdct.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("sellerMdCtUserSearchDao")
@Transactional
public class SellerMdCtUserSearchDaoImpl implements SellerMdCtUserSearchDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMdCtUserSearchDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mdct.selectSellerMdCtUserSearchList", formData);
	}

	// 리뉴얼용 조회 (페이징 없음)
	public List<Map<String,String>> selectList_v2(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mdct.selectSellerMdCtUserSearchList_v2", formData);
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> formData) {

		String _rtnMsg = "";
		String[] st_change_user_id =  formData.get("st_checked_id").split("\\|");
		try {
			_rtnMsg = "OK";

			for (int i=0; i < st_change_user_id.length; i++) {
				formData.put("st_change_user_id", st_change_user_id[i].toString());
				
				//로그 생성///////////////////////////////////////////////
				String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("seller.mdct.updateSellerMdCtUserSearchList").getBoundSql(formData).getSql();
				String attr_01 = "";
				for(Map.Entry<String, String>entry: formData.entrySet()){
					attr_01 += entry.getKey() + "="+entry.getValue() + "/";
				}
				Map<String, String> data = new HashMap<String, String>();
				data.putAll(formData);
				data.put("SYSTEM", "KOREAB2B");
				data.put("MENU", "사용자조회(협력사)");
				data.put("LOG_TYPE", "사용자 삭제");				
				data.put("ATTR_01", strSql+"/"+attr_01);
				data.put("ATTR_02", "");
				data.put("ATTR_03", "");
				sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
				//////////////////////////////////////////////////////
				
				
				sqlSessionTemplate.update("seller.mdct.updateSellerMdCtUserSearchList", formData);
			}
		} catch(Exception e) {
			_rtnMsg = "ERR";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("사용자 삭제에 실패하였습니다");
		}
		return _rtnMsg;
	}
	
}
