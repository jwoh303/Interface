package com.koreab2b.mro.common.mpds.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mdam.dao.BuyerMdAmBudgetDaoImpl;
import com.koreab2b.mro.util.CommonUtil;

@Repository("sellerMpDsTranStatementCreationPopDao")
@Transactional
public class SellerMpDsTranStatementCreationPopDaoImpl implements SellerMpDsTranStatementCreationPopDao {
	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmBudgetDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpds.selectSellerMpDsTranStatementCreationPopList", formData);
	}

	//송장생성
	public String invoiceOrderInfo(Map<String, String> formData){
		
		String _rtnMsg = "송장생성 완료 되었습니다.";
		
		try{
				sqlSessionTemplate.update("common.mpds.invoiceSellerMpDsTranStatementCreationPop_1", formData);
				sqlSessionTemplate.update("common.mpds.invoiceSellerMpDsTranStatementCreationPop_2", formData);

		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("송장생성 하던중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");
		}
		return _rtnMsg;
	}	
	
	
}
