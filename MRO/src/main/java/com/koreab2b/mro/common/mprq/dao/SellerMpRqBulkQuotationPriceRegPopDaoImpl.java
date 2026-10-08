package com.koreab2b.mro.common.mprq.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("SellerMpRqBulkQuotationPriceRegPopDao")
@Transactional
public class SellerMpRqBulkQuotationPriceRegPopDaoImpl implements SellerMpRqBulkQuotationPriceRegPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(SellerMpRqBulkQuotationPriceRegPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 엑셀 업로드(고객사용)
	@SuppressWarnings("unchecked")
	public String batchdata(Map<String, String> param, List<Object> gridData) {
		
		_rtnMsg = "저장완료 되었습니다.";
	
		try{
			for(int i = 0; i < gridData.size(); i++){
				param.putAll((Map<String, String>)gridData.get(i));
				
				LOGGER.debug("batchSellerMpRqBulkQuotationPriceReg param : {} ", param);
				
				// 업로드 전 초기화
				if(i == 0){
					sqlSessionTemplate.update("master.mprq.initBntTrxlBuRqPriceReg", param);
				}
				
				sqlSessionTemplate.update("master.mprq.setBntTrxlBuRqPriceReg", param);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("실패하였습니다.");
		}
		return _rtnMsg; 
	}
	
	// 업로드 결과 확인
	@Override
	public List<Map<String, String>> selectdata(Map<String, String> param) {
		List<Map<String, String>> _rtn = new ArrayList<Map<String, String>>();
		try{
			_rtn = sqlSessionTemplate.selectList("master.mprq.selectSellerMpRqBulkQuotationPriceReg", param);
		
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("실패하였습니다.");
		}
		return _rtn;
	}

	// 등록
	@Override
	public String savedata(Map<String, String> param) {
		_rtnMsg = "저장완료 되었습니다.";
		try{
			List<Map<String, String>> _list = sqlSessionTemplate.selectList("master.mprq.selectSellerMpRqBulkQuotationPriceReg", param);
			
			for(int i = 0; i< _list.size(); i++) {
				param.putAll(_list.get(i));

				LOGGER.debug("saveSellerMpRqBulkQuotationPriceReg.savedata param : {} ", param);
				
				// KEP_BURQ_ITEM 에 update
				sqlSessionTemplate.update("master.mprq.updateSellerMpRqBulkQuotationPriceReg", param);
				
			}
			
			//BNTTRXL 초기화
			sqlSessionTemplate.update("master.mprq.initBntTrxlBuRqPriceReg", param);
		
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("실패하였습니다.");
		}
		return _rtnMsg;
	}	



}
