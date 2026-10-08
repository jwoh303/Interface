package com.koreab2b.mro.master.wmst.dao;

import java.util.ArrayList;
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

@Repository("masterWmStStockDao")
@Transactional
public class MasterWmStStockDaoImpl implements MasterWmStStockDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmStStockDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		
		String pageflag = (String) param.get("pageflag");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> rtnList = new ArrayList<Map<String,String>>();
		if("0".equals(pageflag)){
			 sqlSessionTemplate.select("master.wmst.selectMasterWmStStockList", param, _resultHander);
			 rtnList = (List<Map<String, String>>)_resultHander.getList();
		}
		else{
			rtnList = sqlSessionTemplate.selectList("master.wmst.selectMasterWmStStockList", param);
		}
		
		String rtnSum = "";
		if(rtnList.size() >0 ){
			rtnSum = sqlSessionTemplate.selectOne("master.wmst.selectMasterWmStStockSum", param);
			rtnList.get(0).put("SUMVALUE", rtnSum);
		}
		return rtnList;
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "저장완료.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				sqlSessionTemplate.update("master.wmst.insertMasterWmStStock", formData);
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
				
				sqlSessionTemplate.update("master.wmst.deleteMasterWmStStock", formData);
				logger.error("deleteMasterWmStStock 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 요청에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	

}
