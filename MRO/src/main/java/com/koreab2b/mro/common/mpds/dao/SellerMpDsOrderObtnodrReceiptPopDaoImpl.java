package com.koreab2b.mro.common.mpds.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("sellerMpDsOrderObtnodrReceiptPopDao")
@Transactional
public class SellerMpDsOrderObtnodrReceiptPopDaoImpl implements SellerMpDsOrderObtnodrReceiptPopDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMpDsOrderObtnodrReceiptPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpds.selectSellerMpDsOrderObtnodrReceiptPopList", formData);
	}
	
	//수주접수
	public String regDsData(Map<String, String> formData){
		
		String _rtnMsg = "접수 완료 되었습니다.";
		
		try{
				sqlSessionTemplate.update("common.mpds.regDsDataSellerMpDsOrderObtnodrReceiptPop_1", formData);
				sqlSessionTemplate.update("common.mpds.regDsDataSellerMpDsOrderObtnodrReceiptPop_2", formData);

		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("접수하던중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다");
		}
		return _rtnMsg;
	}		
	
}
