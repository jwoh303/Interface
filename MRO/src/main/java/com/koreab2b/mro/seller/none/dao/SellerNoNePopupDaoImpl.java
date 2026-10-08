package com.koreab2b.mro.seller.none.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("sellerNoNePopupDao")
@Transactional
public class SellerNoNePopupDaoImpl implements SellerNoNePopupDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(SellerNoNeSaleshookProposalDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.none.selectSellerNoNePopupList", formData);
	}

	@Override
	public String insertSellerNoNePopupRead(Map<String, String> formData) {
		String _rtnMsg = "";
		int cnt=0;
		try{
			// 기간지난 팝업 중에 읽음 처리된 것들 제거
			sqlSessionTemplate.update("seller.none.deleteSellerNoNePopupRead", formData);
			
			// 등록되어있는지 조회해서 등록되어 있지 않은 경우 추가
			cnt = sqlSessionTemplate.selectOne("seller.none.selectSellerNoNePopupReadCnt", formData);
			if(cnt < 1) {
				sqlSessionTemplate.update("seller.none.insertSellerNoNePopupRead", formData);
			}
				
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("팝업 읽음 처리 중 에러가 발생하였습니다.");
		}
		
		return _rtnMsg;
	}
	

}
