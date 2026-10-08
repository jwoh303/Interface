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

@Repository("sellerMdCtUserRegRequestReceiptDao")
@Transactional
public class SellerMdCtUserRegRequestReceiptDaoImpl implements SellerMdCtUserRegRequestReceiptDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMdCtUserRegRequestReceiptDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mdct.selectSellerMdCtUserRegRequestReceiptList", formData);
	}
	
	// 저장
	public String updateSelectedData(Map<String,String> formData) {

		String _rtnMsg = "";
		String statusText = "";
		String[] st_change_user_id =  formData.get("st_checked_id").split("\\|");
		if ( formData.get("st_status").equals("D")) {
			statusText = "거절";
		} else {
			statusText = "승인";
		}
		
		try {
			for (int i=0; i < st_change_user_id.length; i++) {
				formData.put("st_change_user_id", st_change_user_id[i].toString());		
	
				if (formData.get("st_status").equals("D")) {
					sqlSessionTemplate.update("seller.mdct.updateSellerMdCtUserRegRequestReceiptReject",formData);
				} else {
					sqlSessionTemplate.update("seller.mdct.updateSellerMdCtUserRegRequestReceiptConfirm",formData);
					
					formData.put("st_auth_id",  "ROLE_SGEN001");
//					String _authChk =  sqlSessionTemplate.selectOne("seller.mdct.getSellerMdCtUserRegRequestReceiptUserAuth",formData);
//					if (Integer.parseInt(_authChk) > 0) {
//						sqlSessionTemplate.update("seller.mdct.updateSellerMdCtUserRegRequestReceiptUserAuth",formData);
//					} else {
//						sqlSessionTemplate.insert("seller.mdct.insertSellerMdCtUserRegRequestReceiptUserAuth",formData);
//					}
					
					Map<String, String> _pMap = new HashMap<String, String>();
					_pMap.put("COM_CODE", formData.get("st_com_code"));
					_pMap.put("USER_ID", formData.get("st_change_user_id"));
					
					//sqlSessionTemplate.selectOne("master.mdcp.SP_PROC_USERAUTH_GEN", _pMap);
				}
				
				_rtnMsg = "OK";
			}
		} catch(Exception e) {
			_rtnMsg = "ERR";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("사용자 " + statusText + "이 실패하였습니다");
		}
		
		return _rtnMsg;
	}
}
