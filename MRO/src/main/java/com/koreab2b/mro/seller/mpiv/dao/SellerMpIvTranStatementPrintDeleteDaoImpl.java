package com.koreab2b.mro.seller.mpiv.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("sellerMpIvTranStatementPrintDeleteDao")
@Transactional
public class SellerMpIvTranStatementPrintDeleteDaoImpl implements SellerMpIvTranStatementPrintDeleteDao {
//	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvTranStatementPrintDeleteDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("seller.mpiv.selectSellerMpIvTranStatementPrintDeleteList", pMap);
	}
	
	public List<Map<String,String>> selectExcelList(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("seller.mpiv.selectSellerMpIvTranStatementPrintDeleteExcelList", pMap);
	}	
}
