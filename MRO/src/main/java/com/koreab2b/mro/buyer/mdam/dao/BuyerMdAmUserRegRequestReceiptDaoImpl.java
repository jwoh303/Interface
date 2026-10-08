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

@Repository("buyerMdAmUserRegRequestReceiptDao")
@Transactional
public class BuyerMdAmUserRegRequestReceiptDaoImpl implements BuyerMdAmUserRegRequestReceiptDao {
	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmUserRegRequestReceiptDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		String strSql = sqlSessionTemplate.getConfiguration().getMappedStatement("buyer.mdam.selectBuyerMdAmUserRegRequestReceiptList").getBoundSql(formData).getSql();
		String attr_01 = "";
		for(Map.Entry<String, String>entry: formData.entrySet()){
			attr_01 += entry.getKey() + "="+entry.getValue() + "/";
		}
		Map<String, String> data = new HashMap<String, String>();
		data.putAll(formData);
		data.put("SYSTEM", "KOREAB2B");
		data.put("MENU", "사용자등록요청접수");
		data.put("LOG_TYPE", "조회");				
		data.put("ATTR_01", strSql+"/"+attr_01);
		data.put("ATTR_02", "");
		data.put("ATTR_03", "");
		sqlSessionTemplate.update("master.mdam.insertMasterMdAmLogManageList", data);
		
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmUserRegRequestReceiptList", formData);
	}
	
	// 저장
	public String updateSelectedData(Map<String,String> formData) {

		String _rtnMsg = "";
		String statusText = "";
		String[] st_change_user_id =  formData.get("st_checked_id").split("\\|");
		String[] st_com_code = {"",};
		if ( formData.get("st_status").equals("D")) {
			statusText = "거절";
		} else {
			statusText = "승인";
		}

		try {
			for (int i=0; i < st_change_user_id.length; i++) {
				
				// @@로 고객사코드와 대상ID 분리
				st_com_code = st_change_user_id[i].toString().split("@@");
				
				formData.put("st_change_user_id", st_com_code[0].toString());
				formData.put("st_com_code", st_com_code[1].toString());
				
				if (formData.get("st_status").equals("D")) {
					sqlSessionTemplate.update("buyer.mdam.updateBuyerMdAmUserRegRequestReceiptReject",formData);
					sqlSessionTemplate.update("buyer.mdam.insertMasterMdAmUserRejectMail", formData); // 거절알림 메일 추가 2022.08.05 HSJ
				} else {
					sqlSessionTemplate.update("buyer.mdam.updateBuyerMdAmUserRegRequestReceiptConfirm",formData);
					formData.put("st_auth_id",  "ROLE_BGEN001");
//					String _authChk =  sqlSessionTemplate.selectOne("buyer.mdam.getBuyerMdAmUserRegRequestReceiptUserAuth",formData);
//					if (Integer.parseInt(_authChk) > 0) {
//						sqlSessionTemplate.update("buyer.mdam.updateBuyerMdAmUserRegRequestReceiptUserAuth",formData);
//					} else {
//						sqlSessionTemplate.insert("buyer.mdam.insertBuyerMdAmUserRegRequestReceiptUserAuth",formData);
//					}
					
					Map<String, String> _pMap = new HashMap<String, String>();
					_pMap.put("COM_CODE", formData.get("st_com_code"));
					_pMap.put("USER_ID", formData.get("st_change_user_id"));
					
					sqlSessionTemplate.update("master.mdcp.SP_PROC_USERAUTH_GEN", _pMap);
				}
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
