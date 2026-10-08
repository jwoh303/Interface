package com.koreab2b.mro.common.mpiv.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderInfoDao;

@Repository("sellerMpIvPrewarhsngOrderRegPopDao")
@Transactional
public class SellerMpIvPrewarhsngOrderRegPopDaoImpl implements SellerMpIvPrewarhsngOrderRegPopDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvPrewarhsngOrderRegPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Autowired
	private BuyerMpSoOrderInfoDao buyerMpSoOrderInfoDao;
	
	// 선입고 요청 등록
	@SuppressWarnings("unchecked")
	public String saveSellerMpIvPrewarhsngOrderReg(Map<String,String> formData) {
		logger.debug("요청 파라미터 : {}", formData);
		String _rtnMsg = "OK";
		
		try{
			String buyer_code = "";	
			String bs_no = "";
			String inv_no = "";
			
			// 선입고 요청 등록 채번
			buyer_code = formData.get("st_buyer_code");
			bs_no = buyerMpSoOrderInfoDao.getOrderNo(buyer_code,"BS");
			formData.put("BS_NO", bs_no);
			
			sqlSessionTemplate.update("common.mpiv.insertSellerMpIvPrewarhsngOrderMngReg", formData);
			
			// 선입고 거래명세서 등록 채번
			inv_no = buyerMpSoOrderInfoDao.getOrderNo(buyer_code,"IB");
			formData.put("INV_NO", inv_no);
			formData.put("INV_SEQ", "1");
			
			sqlSessionTemplate.update("common.mpiv.insertSellerMpIvPrewarhsngOrderIvdtReg", formData);
			sqlSessionTemplate.update("common.mpiv.insertSellerMpIvPrewarhsngOrderIvhdReg", formData);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("선입고 요청 등록을 실패하였습니다.");
		}
		return _rtnMsg;
	}
}
