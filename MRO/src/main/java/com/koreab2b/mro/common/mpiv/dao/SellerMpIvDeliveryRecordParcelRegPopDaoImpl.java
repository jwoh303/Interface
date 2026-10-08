package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.seller.mpiv.controller.SellerMpIvDeliveryRecordRegController;

@Repository("sellerMpIvDeliveryRecordParcelRegPopDao")
@Transactional
public class SellerMpIvDeliveryRecordParcelRegPopDaoImpl implements SellerMpIvDeliveryRecordParcelRegPopDao {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvDeliveryRecordRegController.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectNew(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mpiv.selectSellerMpIvDeliveryParcelRegPop", formData);
	}
	
	// 택배사정보저장
	public String saveParcel(Map<String, String> formData) {

			String _rtnMsg = "";
			
			try{
				// ICOMIVHD UPDATE				
				sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordParcelRegIvhd", formData);
				
			}catch(Exception e){
				logger.error("SQL ERROR : ", e);
				throw new RuntimeException("택배사정보 저장 중 에러가 발생하였습니다.");
			}
			
			return _rtnMsg;
		}

}
