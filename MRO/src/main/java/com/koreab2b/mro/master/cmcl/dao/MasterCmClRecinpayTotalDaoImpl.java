package com.koreab2b.mro.master.cmcl.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterCmClRecinpayTotalDao")
@Transactional
public class MasterCmClRecinpayTotalDaoImpl implements MasterCmClRecinpayTotalDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.cmcl.selectMasterCmClRecinpayTotalList", param, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}

	// 저장
//	@SuppressWarnings("unchecked")
//	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
//		
//		_rtnMsg = "저장완료.";
//		
//		try{
//			for(int i=0; i < gridData.size(); i++){
//				formData.putAll((Map<String, String>)gridData.get(i));
//				
//				// STEP1
//				sqlSessionTemplate.update("master.cmcl.insertMasterCmClRecinpayTotal", formData);
//			}
//			
//		} catch (Exception e){
//			logger.error("SQL ERROR : ", e);
//				throw new RuntimeException("저장에 실패하였습니다.");
//		}
//		
//		return _rtnMsg;
//	}
	
	
	// 삭제
//	@SuppressWarnings("unchecked")
//	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
//	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
//		
//		_rtnMsg = "삭제완료";
//		
//		try{
//			for(int i=0; i < gridData.size(); i++){
//				formData.putAll((Map<String, String>)gridData.get(i));		
//				
//				sqlSessionTemplate.update("master.cmcl.deleteMasterCmClRecinpayTotal", formData);
//				logger.error("deleteMasterCmClRecinpayTotal 실행 완료");
//
//			}
//		}catch(Exception e){
//			logger.error("SQL ERROR : ", e);
//			throw new RuntimeException("견적 요청에 실패하였습니다.");
//		}
//
//		return _rtnMsg;		
//	}	

}
