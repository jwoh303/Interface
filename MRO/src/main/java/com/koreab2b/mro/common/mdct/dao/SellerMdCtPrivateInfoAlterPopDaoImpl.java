package com.koreab2b.mro.common.mdct.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("sellerMdCtPrivateInfoAlterPopDao")
@Transactional
public class SellerMdCtPrivateInfoAlterPopDaoImpl implements SellerMdCtPrivateInfoAlterPopDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMdCtPrivateInfoAlterPopDaoImpl.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mdct.selectSellerMdCtPrivateInfoAlterPopList", formData);
	}
	
	// 저장
	public String updateSelectedData(Map<String,String> formData) {
		String _rtnMsg = "OK";
		try {
			sqlSessionTemplate.update("common.mdct.updateSellerMdCtPrivateInfoAlterPop", formData);
		} catch(Exception e) {
			_rtnMsg = "ERR";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("사용자 정보 수정이 실패하였습니다.");
		}
		
		return _rtnMsg;
	}
}
