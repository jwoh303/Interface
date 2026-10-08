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

@Repository("MasterMpRqBulkQuotationAddAgentPopDao")
@Transactional
public class MasterMpRqBulkQuotationAddAgentPopDaoImpl implements MasterMpRqBulkQuotationAddAgentPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBulkQuotationAddAgentPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";

	// 품목정보 조회	
	@Override
	public Map<String, String> selectItem(Map<String, String> param) {
		return sqlSessionTemplate.selectOne("master.mprq.selectMasterMpRqBulkQuotationAddAgentItem", param);
	}	
	
	@Override
	public List<Map<String, String>> selectdata(Map<String, String> param) {
		List<Map<String, String>> _rtn = new ArrayList<Map<String, String>>();
		try{
			_rtn = sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqBulkQuotationAddAgent", param);
		
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("실패하였습니다.");
		}
		return _rtn;
	}
	
	// 협력사 삭제
	@Override
	public String deletedata(Map<String, String> formData, List<Object> gridData) {
		_rtnMsg = "저장완료 되었습니다.";
		try{
			
			for(int i = 0 ; i < gridData.size(); i++) {
				formData.putAll((Map<String,String>)gridData.get(i));
				
				LOGGER.debug("deleteMasterMpRqBulkQuotationAddAgent param : {} ", formData);
				
				// KEP_BURQ_RFQ 에 delete
				sqlSessionTemplate.update("master.mprq.deleteMasterMpRqBulkQuotationAddAgent", formData);
			}

		
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("실패하였습니다.");
		}
		return _rtnMsg;
	}

	// 진행 현황
	@Override
	public List<Map<String, String>> selectListdata(Map<String, String> param) {
		return sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqBulkQuotationAddAgentList", param);
	}

}
