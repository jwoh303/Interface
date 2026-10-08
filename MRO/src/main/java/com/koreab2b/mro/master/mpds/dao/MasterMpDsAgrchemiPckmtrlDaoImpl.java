package com.koreab2b.mro.master.mpds.dao;

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

@Repository("masterMpDsAgrchemiPckmtrlDao")
@Transactional
public class MasterMpDsAgrchemiPckmtrlDaoImpl implements MasterMpDsAgrchemiPckmtrlDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMpDsAgrchemiPckmtrlDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mpds.selectMasterMpDsAgrchemiPckmtrlList", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}

	// 리스트 조회(Sub)
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectListSub(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mpds.selectMasterMpDsAgrchemiPckmtrlListSub", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}

	
	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "저장완료.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				sqlSessionTemplate.update("master.mpds.insertMasterMpDsAgrchemiPckmtrl", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "삭제완료";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.mpds.deleteMasterMpDsAgrchemiPckmtrl", formData);
				logger.error("deleteMasterMpDsAgrchemiPckmtrl 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 요청에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	

}
