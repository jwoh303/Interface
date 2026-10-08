package com.koreab2b.mro.seller.mpds.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("sellerMpDsOrderProgressManageDao")
@Transactional
public class SellerMpDsOrderProgressManageDaoImpl implements SellerMpDsOrderProgressManageDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMpDsOrderProgressManageDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("seller.mpds.selectSellerMpDsOrderProgressManageList", formData);
	}

	
	//납품실적등록	
	@SuppressWarnings("unchecked")
	public String updateSelectedDataDiReg(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "납품실적등록이 정상적으로 처리되었습니다.";		
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.insert("seller.mpds.updateSelectedDataDiReg_1", formData);
				sqlSessionTemplate.insert("seller.mpds.updateSelectedDataDiReg_2", formData);
			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("납품실적등록에 실패하였습니다.");
		}
	return _rtnMsg;
		
	}	
	
	// 납품실적취소
	@SuppressWarnings("unchecked")
	public String updateSelectedDataDiCancel(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "납품실적취소가 정상적으로 처리되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
	
				sqlSessionTemplate.insert("seller.mpds.updateSelectedDataDiCancelReg_1", formData);
				sqlSessionTemplate.insert("seller.mpds.updateSelectedDataDiCancelReg_2", formData);
					
			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("납품실적취소에 실패하였습니다.");
		}
		
	return _rtnMsg;
		
	}	
	
	
	// 송장취소
	@SuppressWarnings("unchecked")
	public String updateSelectedDataIvCancel(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "송장취소가 정상적으로 처리되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
	
				sqlSessionTemplate.insert("seller.mpds.updateSelectedDataIvCancelReg_1", formData);
				sqlSessionTemplate.insert("seller.mpds.updateSelectedDataIvCancelReg_2", formData);
					
			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("송장취소에 실패하였습니다.");
		}
	return _rtnMsg;
		
	}	
	
}
