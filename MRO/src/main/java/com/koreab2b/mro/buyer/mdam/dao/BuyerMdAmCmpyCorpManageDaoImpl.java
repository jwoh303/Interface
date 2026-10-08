package com.koreab2b.mro.buyer.mdam.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("buyerMdAmCmpyCorpManageDao")
@Transactional
public class BuyerMdAmCmpyCorpManageDaoImpl implements BuyerMdAmCmpyCorpManageDao {
	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmCmpyCorpManageDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmCmpyCorpManageList", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectPassList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmCmpyCorpManageIcogPass", formData);
	}
	
	// 저장
	public String updateSelectedData(Map<String,String> formData) {
		String _rtnMsg = "";
		String _acntbuyr = "";
		try {
			sqlSessionTemplate.update("buyer.mdam.updateBuyerMdAmCmpyCorpManage",formData);
			
			_acntbuyr = sqlSessionTemplate.selectOne("buyer.mdam.selectBuyerMdAmCmpyCorpManageAcntbuyr",formData);
			
			if (_acntbuyr.equals("0")) {
				sqlSessionTemplate.insert("buyer.mdam.insertBuyerMdAmCmpyCorpManageAcntbuyr", formData);
			} else {
				sqlSessionTemplate.update("buyer.mdam.updateBuyerMdAmCmpyCorpManageAcntbuyr", formData);
			}
			sqlSessionTemplate.delete("buyer.mdam.deleteBuyerMdAmCmpyCorpManageIcogPass", formData);
			
			if (formData.get("st_PR") != null) {
				formData.put("st_docu_type", "PR");
				formData.put("st_docu_text", formData.get("st_PR"));
				sqlSessionTemplate.insert("buyer.mdam.insertBuyerMdAmCmpyCorpManageIcogPass", formData);
			}
			if (formData.get("st_PX") != null) {
				formData.put("st_docu_type", "PX");
				formData.put("st_docu_text", formData.get("st_PX"));
				sqlSessionTemplate.insert("buyer.mdam.insertBuyerMdAmCmpyCorpManageIcogPass", formData);
			}
			if (formData.get("st_NG") != null) {
				formData.put("st_docu_type", "NG");
				formData.put("st_docu_text", formData.get("st_NG"));
				sqlSessionTemplate.insert("buyer.mdam.insertBuyerMdAmCmpyCorpManageIcogPass", formData);
			}
			if (formData.get("st_NS") != null) {
				formData.put("st_docu_type", "NS");
				formData.put("st_docu_text", formData.get("st_NS"));
				sqlSessionTemplate.insert("buyer.mdam.insertBuyerMdAmCmpyCorpManageIcogPass", formData);
			}
			_rtnMsg = "OK";
		} catch(Exception e) {
			_rtnMsg = "ERR";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("회원사법인 정보 수정에 실패하였습니다.");
		}
		
		return _rtnMsg;
	}
	
}
