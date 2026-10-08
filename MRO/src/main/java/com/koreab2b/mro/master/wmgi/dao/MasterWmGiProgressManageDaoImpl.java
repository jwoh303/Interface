package com.koreab2b.mro.master.wmgi.dao;

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

@Repository("masterWmGiProgressManageDao")
@Transactional
public class MasterWmGiProgressManageDaoImpl implements MasterWmGiProgressManageDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmGiProgressManageDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List<String> buyerParam;
		buyerParam = Arrays.asList( ((String)param.get("st_buyer_code")).split("@@"));
		List<String> processParam;
		processParam = Arrays.asList( ((String)param.get("st_process_type")).split(","));
		
	    if(buyerParam.size() >1 || !"".equals((String)param.get("st_buyer_code")) )
	    {
	    	param.put("buyerParam",buyerParam);
	    	param.put("buyerCnt","1");
	    }
	    param.put("processParam",processParam);
		return sqlSessionTemplate.selectList("master.wmgi.selectMasterWmGiProgressManageList", param);
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "저장완료.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				sqlSessionTemplate.update("master.wmgi.insertMasterWmGiProgressManage", formData);
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
				
				sqlSessionTemplate.update("master.wmgi.deleteMasterWmGiProgressManage", formData);
				logger.error("deleteMasterWmGiProgressManage 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 요청에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	

}
