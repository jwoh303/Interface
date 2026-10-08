package com.koreab2b.mro.master.mpif.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@SuppressWarnings("unchecked")
@Repository("masterMpIfErrMngDao")
@Transactional
public class MasterMpIfErrMngDaoImpl implements MasterMpIfErrMngDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMpIfErrMngDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public List<Map<String,String>> selectList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;
	    
		sqlSessionTemplate.select("master.mpif.selectMasterMpifErrList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String insertTotal(Map<String,Object> param) {
		
		Map<String, String> formData = new HashMap<String,String>();
		
		formData.put("BUYER_ID", "ALL");
		formData.put("IF_TYPE", " ");
		formData.put("TASK_GUBUN", " ");
		
		try{
			sqlSessionTemplate.insert("master.mpif.insertMasterMpIfErrMngTotal", formData);
		}catch(Exception e) {
			logger.error("SQL ERROR : ", e);
			_rtnMsg = "현재 전체 집계 중 입니다.";
			throw new RuntimeException("현재 전체 집계 중 입니다.");
		}
		
		return _rtnMsg;
	}
	
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String insertSubTotal(Map<String, String> formData, List<Object> gridData) {
		
		try{
			
			for ( int i=0; i < gridData.size(); i++ ) {
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.insert("master.mpif.insertMasterMpIfErrMngTotal", formData);
			}
			
		}catch(Exception e) {
			logger.error("SQL ERROR : ", e);
			_rtnMsg = "선택하신 항목이 현재 집계 중 입니다.";
			throw new RuntimeException("선택하신 항목이 현재 집계 중 입니다.");
		}
		
		return _rtnMsg;
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectNewList(Map<String, Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		    
		sqlSessionTemplate.select("master.mpif.selectMasterNewMpifErrList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();
		
		return resultList;
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, String>> selectMpifNewErrMngPop(Map<String, Object> pMap) {
		return sqlSessionTemplate.selectList("master.mpif.selectMpifNewErrMngPop", pMap);
	}

	
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String saveMpifNewErrMngPop(Map<String, String> formData) {
		String _rtnMsg = "OK";
		String recvFlag = "";
		try {
			recvFlag = formData.get("st_recv_flag");
			
			if("A".equals(recvFlag)){
				sqlSessionTemplate.update("master.mpif.updateReceiptMpifNewErrMngPop", formData);
			}else if("P".equals(recvFlag)){
				sqlSessionTemplate.update("master.mpif.updateCompleteMpifNewErrMngPop", formData);
			}else if("S".equals(recvFlag)){
				sqlSessionTemplate.update("master.mpif.updatejobNoteMpifNewErrMngPop", formData);
			}
		} catch (Exception e) {
			_rtnMsg = "Err";
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("처리 하던중 오류가 발생하였습니다.");
		}
		return _rtnMsg;
	}
	
}
