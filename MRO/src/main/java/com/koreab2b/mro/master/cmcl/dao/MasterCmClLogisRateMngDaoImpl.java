package com.koreab2b.mro.master.cmcl.dao;


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

@Repository("masterCmClLogisRateMngDao")
@Transactional
public class MasterCmClLogisRateMngDaoImpl implements MasterCmClLogisRateMngDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClLogisRateMngDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked") 
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();		
		sqlSessionTemplate.select("master.cmcl.selectMasterLogisRateMngList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}

	//저장	
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "저장하였습니다.";
		
		
		try{
						
			for(int i=gridData.size()-1; i >= 0 ; i--){
				formData.putAll((Map<String, String>)gridData.get(i));	
				
				sqlSessionTemplate.update("master.cmcl.updateMasterCmClLogisRateMngList", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}

	//삭제	
	@SuppressWarnings("unchecked")
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		String _rtnMsg = "삭제하였습니다.";
				
		try{
						
			for(int i=gridData.size()-1; i >= 0 ; i--){
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.update("master.cmcl.deleteMasterCmClLogisRateMngList", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("삭제 실패하였습니다.");
		}
		return _rtnMsg;
	}

	// 예외기준 조회
	public List<Map<String, String>> selectFeeList(Map<String, Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();		
		sqlSessionTemplate.select("master.cmcl.selectMasterLogisRateMngFeeList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}

	
}
