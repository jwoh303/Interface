package com.koreab2b.mro.master.mpif.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.ResultRowHandler;

@SuppressWarnings("unchecked")
@Repository("masterMpIfSamsungDao")
@Transactional
public class MasterMpIfSamsungDaoImpl implements MasterMpIfSamsungDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterMpIfSamsungDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	public List<Map<String, String>> getSamsungPoList(Map<String, Object> pMap) {
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = null;

		sqlSessionTemplate.select("master.mpif.selectMasterMpIfSamsungPoList", pMap, _resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();

		return resultList;
	}

	@Override
	public String insertMasterMpifSamsungPoReturn(Map<String, String> formData, List<Object> gridData) {
		_rtnMsg = "처리완료.";
		
		try{
			System.out.println("Grid Size : " + gridData.size());
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				System.out.println("Grid Idx["+i+"] : " + formData);
				
				// STEP1
				sqlSessionTemplate.update("master.mpif.insertMasterMpifSamsungPoReturn", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("처리에 실패하였습니다.");
		}		
		
		return _rtnMsg;
	}
}