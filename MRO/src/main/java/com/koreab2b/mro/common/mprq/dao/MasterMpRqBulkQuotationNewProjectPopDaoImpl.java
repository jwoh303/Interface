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

@Repository("MasterMpRqBulkQuotationNewProjectPopDao")
@Transactional
public class MasterMpRqBulkQuotationNewProjectPopDaoImpl implements MasterMpRqBulkQuotationNewProjectPopDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBulkQuotationNewProjectPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 신규 프로젝트 저장
	@SuppressWarnings("unchecked")
	public Map<String, Object> insertData(Map<String, String> formData) {
		Map<String, Object> _rtn = new HashMap<String, Object>();
		String _burqNo ="";
		try{
			// STEP1 프로젝트 코드 채번
			_burqNo = sqlSessionTemplate.selectOne("master.mprq.selectMaxBurqNo",formData);
			if(_burqNo == null && _burqNo.equals("")) {
				_rtnMsg ="error";
				throw new RuntimeException("seq_error");
			}
			
			formData.put("BURQ_NO", _burqNo);
			
			LOGGER.debug("insertData  formData {} " , formData);
			
			// STEP2 프로젝트 관리 INSERT
			sqlSessionTemplate.update("master.mprq.insertBulkQuotationNewProject", formData);

		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e.getMessage());
			if(e.getMessage().equals("seq_error")) {
				throw new RuntimeException("프로젝트 코드 채번 시 오류가 발생하였습니다. 담당자에게 문의 바랍니다.");
			}else {
				throw new RuntimeException("프로젝트 등록 시 오류가 발생하였습니다. 담당자에게 문의 바랍니다.");
			}
			
		}
		
		_rtn.put("BURQ_NO", _burqNo);
		_rtn.put("_rtnMsg", _rtnMsg);
		return _rtn;
	}

	// 유의사항 저장
	@Override
	public String insertNoticeData(List<Object> gridData, Map<String, String> formData) {
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));

				LOGGER.debug("insertNoticeData  formData {} " , formData);
				
				sqlSessionTemplate.update("master.mprq.insertBulkQuotationNewProjectNotice", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("유의사항 저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}

	@Override
	public String insertBuyerData(List<Object> gridData, Map<String, String> formData) {
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));

				LOGGER.debug("insertBuyerData  formData {} " , formData);
				
				sqlSessionTemplate.update("master.mprq.insertBulkQuotationNewProjectBuyer", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("고객사코드 저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}

}
