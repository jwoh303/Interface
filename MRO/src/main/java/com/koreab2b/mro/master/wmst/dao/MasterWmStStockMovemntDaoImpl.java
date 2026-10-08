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

@Repository("masterWmStStockMovemntDao")
@Transactional
public class MasterWmStStockMovemntDaoImpl implements MasterWmStStockMovemntDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmStStockMovemntDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		String pageflag = (String) param.get("pageflag");
		List<Map<String, String>> resultList = new ArrayList<Map<String,String>>();
		if("0".equals(pageflag)){
			sqlSessionTemplate.select("master.wmst.selectMasterWmStStockMovemntList", param,_resultHander);
			resultList = (List<Map<String, String>>)_resultHander.getList();
		}else
		{
			resultList = sqlSessionTemplate.selectList("master.wmst.selectMasterWmStStockMovemntList", param);
		}
		return resultList;
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "저장완료.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				sqlSessionTemplate.update("master.wmst.insertMasterWmStStockMovemnt", formData);
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
				
				sqlSessionTemplate.update("master.wmst.deleteMasterWmStStockMovemnt", formData);
				logger.error("deleteMasterWmStStockMovemnt 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 요청에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	

}
