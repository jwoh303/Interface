package com.koreab2b.mro.common.mpiv.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("sellerMpIvProcessTypeChangePopDao")
@Transactional
public class SellerMpIvProcessTypeChangePopDaoImpl implements SellerMpIvProcessTypeChangePopDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvProcessTypeChangePopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 거래유형 변경 요청
	public String saveSellerMpIvProcessTypeChangeReq(Map<String,String> formData) {
		logger.debug("요청 파라미터 : {}", formData);
		String _rtnMsg = "OK";
		
		try{
			// 거래유형 변경 요청
			sqlSessionTemplate.update("common.mpiv.insertSellerMpIvProcessTypeChangeReq", formData);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("요청 등록을 실패하였습니다.");
		}
		return _rtnMsg;
	}
}
