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

@Repository("MasterMpRqBulkQuotationItemInfoRegPopDao")
@Transactional
public class MasterMpRqBulkQuotationItemInfoRegPopDaoImpl implements MasterMpRqBulkQuotationItemInfoRegPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBulkQuotationItemInfoRegPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 엑셀 업로드(고객사용)
	@SuppressWarnings("unchecked")
	public String batchdata(Map<String, String> param, List<Object> gridData) {
		
		_rtnMsg = "저장완료 되었습니다.";
	
		try{
			// 업로드 전 초기화
			sqlSessionTemplate.update("master.mprq.initBntTrxlBuRqItemInfoReg", param);
			
			for(int i = 0; i < gridData.size(); i++){
				param.putAll((Map<String, String>)gridData.get(i));
				
				LOGGER.debug("batchMasterMpRqBulkQuotationItemInfoReg param : {} ", param);
				
				sqlSessionTemplate.update("master.mprq.setBntTrxlBuRqItemInfoReg", param);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("실패하였습니다.");
		}
		return _rtnMsg; 
	}
	
	@Override
	public List<Map<String, String>> selectdata(Map<String, String> param) {
		List<Map<String, String>> _rtn = new ArrayList<Map<String, String>>();
		try{
			_rtn = sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqBulkQuotationItemInfoReg", param);
		
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("실패하였습니다.");
		}
		return _rtn;
	}

	@Override
	public String savedata(Map<String, String> param) {
		_rtnMsg = "저장완료 되었습니다.";
		try{
			
			LOGGER.debug("saveMasterMpRqBulkQuotationItemInfoReg.savedata param : {} ", param);

			// KEP_BURQ_RFQ 에 insert
			sqlSessionTemplate.update("master.mprq.updateMasterMpRqBulkQuotationItemInfoReg", param);
			
			//BNTTRXL 초기화
			sqlSessionTemplate.update("master.mprq.initBntTrxlBuRqItemInfoReg", param);
		
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("실패하였습니다.");
		}
		return _rtnMsg;
	}	



}
