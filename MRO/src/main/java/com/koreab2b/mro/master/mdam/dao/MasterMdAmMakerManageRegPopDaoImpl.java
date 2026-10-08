package com.koreab2b.mro.master.mdam.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdam.dao.MasterMdAmMakerManageRegPopDaoImpl;
import com.koreab2b.mro.util.CommonUtil;

@Repository("MasterMdAmMakerManageRegPopDao")
@Transactional
public class MasterMdAmMakerManageRegPopDaoImpl implements MasterMdAmMakerManageRegPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdAmMakerManageRegPopDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("master.mdam.selectMasterMdAmMakerManageRegPopList", formData);
	}
	
	/*등록*/
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData) {
		 _rtnMsg = "선택한 품목을 등록 했습니다.";
		
		try{

				sqlSessionTemplate.update("master.mdam.updateMasterMdAmMakerManageRegPop", formData);

			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("등록에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	/*등록*/
	@SuppressWarnings("unchecked")
	public String insertSelectedData(Map<String,String>  formData) {
		_rtnMsg = "선택한 품목을 등록 했습니다.";
		try{
			sqlSessionTemplate.update("master.mdam.insertMasterMdAmMakerManageRegPop", formData);
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("등록에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	/*대표 제조사 등록*/
	@SuppressWarnings("unchecked")
	public String insertSelectedMgData(Map<String,String>  formData) {
		_rtnMsg = "대표 제조사 등록 했습니다.";
		try{
			sqlSessionTemplate.update("master.mdam.insertMasterMdAmMgMakerManageRegPop", formData);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("등록에 실패하였습니다.");
		}
		return _rtnMsg;
	}	
	

}
