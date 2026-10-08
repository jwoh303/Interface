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

@Repository("MasterMpRqBulkQuotationSelAgentPopDao")
@Transactional
public class MasterMpRqBulkQuotationSelAgentPopDaoImpl implements MasterMpRqBulkQuotationSelAgentPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBulkQuotationSelAgentPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";

	// 협력사 조회
	@Override
	public List<Map<String, String>> selectdata(Map<String, String> param) {
		return sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqBulkQuotationSelAgent", param);
	}
	
	// 우선 협력사 조회
	@Override
	public List<Map<String, String>> selectdata2(Map<String, String> param) {
		return sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqBulkQuotationSelAgent2", param);
	}	
	
	// 우선 협력사 삭제
	@Override
	public String deletedata(Map<String, String> formData, List<Object> gridData) {
		_rtnMsg = "저장완료 되었습니다.";
		try{
			
			for(int i = 0 ; i < gridData.size(); i++) {
				formData.putAll((Map<String,String>)gridData.get(i));
				
				LOGGER.debug("deleteMasterMpRqBulkQuotationSelAgent param : {} ", formData);
				
				// KEP_BURQ_RFQ 에 delete
				sqlSessionTemplate.update("master.mprq.deleteMasterMpRqBulkQuotationSelAgent", formData);
			}

		
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("실패하였습니다.");
		}
		return _rtnMsg;
	}

	// 우선 협력사 저장
	@Override
	public String insertdata(Map<String, String> formData, List<Object> gridData) {
		_rtnMsg = "저장완료 되었습니다.";
		try{
			
			for(int i = 0 ; i < gridData.size(); i++) {
				formData.putAll((Map<String,String>)gridData.get(i));
				
				LOGGER.debug("insertMasterMpRqBulkQuotationSelAgent param : {} ", formData);
				
				// KEP_BURQ_RFQ 에 delete
				sqlSessionTemplate.update("master.mprq.insertMasterMpRqBulkQuotationSelAgent", formData);
			}

		
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("실패하였습니다.");
		}
		return _rtnMsg;
	}

	// 견적에 선택 협력사 추가
	@Override
	public String insertRfqdata(Map<String, String> formData, List<Object> gridData) {
		_rtnMsg = "저장완료 되었습니다.";
		try{
			String[] itemArr = ((String) formData.get("st_item_key_id")).split("@@");
			
			for(int i = 0; i< itemArr.length;  i++) {
				formData.put("ITEM_KEY_ID", itemArr[i]);
				
				for(int j = 0 ; j < gridData.size(); j++) {
					formData.putAll((Map<String,String>)gridData.get(j));
					
					LOGGER.debug("insertMasterMpRqBulkQuotationSelAgentRfq param : {} ", formData);
					// 미등록 협력사만 등록
					int cnt = sqlSessionTemplate.selectOne("master.mprq.selectMasterMpRqBulkQuotationSelAgentCnt", formData);
					if( cnt == 0) {
						// KEP_BURQ_RFQ 에 insert
						sqlSessionTemplate.update("master.mprq.insertMasterMpRqBulkQuotationSelAgentRfq", formData);
					}
				}
			}
		
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	
}
