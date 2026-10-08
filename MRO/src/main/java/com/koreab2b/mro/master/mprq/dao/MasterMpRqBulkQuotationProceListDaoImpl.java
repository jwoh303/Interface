package com.koreab2b.mro.master.mprq.dao;

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

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("MasterMpRqQuotationBulkItemProceListDao")
@Transactional
public class MasterMpRqBulkQuotationProceListDaoImpl implements MasterMpRqBulkQuotationProceListDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBulkQuotationProceListDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		
		sqlSessionTemplate.update("master.mprq.updateBulkQuotationProceRFQ", param);
		
		//진행상태코드
		param.put("st_status_all", CommonUtil.getStringArrary((String) param.get("st_proce_status"), ","));
		LOGGER.debug("selectMasterMpRqBulkQuotationlist param : {} ", param);
		
		return sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqBulkQuotationProceList", param);
	}
	
	// 동일 단가 적용
	@Override
	public String updatePrice(Map<String, Object> param) {
		try{
			String[] itemArr = ((String) param.get("st_query")).split("@@");
			for(int i = 0; i < itemArr.length;  i++) {
				param.put("ITEM_KEY_ID", itemArr[i]);
				
				LOGGER.debug("updateMasterMpRqBulkQuotationSamePrice param : {} ", param);
				
				sqlSessionTemplate.update("master.mprq.updateBulkQuotationSamePrice", param);
			}

		} catch (Exception e){
			_rtnMsg = "Error";
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장 하던중 오류가 발생하였습니다. 담당자에게 문의 바랍니다.");
		}
		
		return _rtnMsg;
	}

	
	// 협력사 이메일 dm이력조회
	@Override
	public List<Map<String, String>> selectDmList(Map<String, String> param) {
		return sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqBulkQuotationDmHist", param);
	}

	// 엑셀다운
	public List<Map<String,String>> selectExcelList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqBulkQuotationProceExcelList", param);
	}
	
	// 협력사 목록
	@Override
	public List<Map<String, String>> selectAgentList(Map<String, Object> param) {
		return sqlSessionTemplate.selectList("master.mprq.selectAgent", param);
	}
}
