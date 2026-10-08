package com.koreab2b.mro.master.wmgr.dao;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Repository("masterWmGrTrWarhsngProgressManageDao")
@Transactional
public class MasterWmGrTrWarhsngProgressManageDaoImpl implements MasterWmGrTrWarhsngProgressManageDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmGrTrWarhsngProgressManageDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		
		List<String> buyerParam;
		buyerParam = Arrays.asList( ((String)param.get("st_buyer_code")).split("@@"));
		
		
	    if(buyerParam.size() >0 || !"".equals((String)param.get("st_buyer_code")) )
	    {
	    	param.put("buyerParam",buyerParam);
	    	param.put("buyerCnt","1");
	    }
		return sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrTrWarhsngProgressManageList", param);
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "저장완료.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				sqlSessionTemplate.update("master.wmgr.insertMasterWmGrTrWarhsngProgressManage", formData);
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
				
				sqlSessionTemplate.update("master.wmgr.deleteMasterWmGrTrWarhsngProgressManage", formData);
				logger.error("deleteMasterWmGrTrWarhsngProgressManage 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 요청에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	

}
