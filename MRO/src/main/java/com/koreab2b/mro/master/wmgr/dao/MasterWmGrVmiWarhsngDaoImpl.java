package com.koreab2b.mro.master.wmgr.dao;

import java.math.BigDecimal;
import java.util.ArrayList;
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

@Repository("masterWmGrVmiWarhsngDao")
@Transactional
public class MasterWmGrVmiWarhsngDaoImpl implements MasterWmGrVmiWarhsngDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmGrVmiWarhsngDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrVmiWarhsngList", param);
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = ""; 
		try{
			
			String _strOS = System.getProperty("os.name").toLowerCase();
			List<Map<String ,String>> _checkGr = new ArrayList<Map<String,String>>();
			
			for(int i=0; i < gridData.size(); i++){
				
				formData.putAll((Map<String, String>)gridData.get(i));
				
				//입고가 진행되었는지 체크 
				if(_strOS.indexOf("win") >= 0){
					
					_checkGr = sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrVmiEDIVPODT", formData);
					if(_checkGr.size() >0 ){
						
						_rtnMsg = "existStock";
						throw new RuntimeException("발주번호 "+formData.get("VPO_NO")+"는 기 입고 대상 입니다.");
						
					}
				}					  
				//발주정보 업데이트   updateEDIVPODT
				logger.debug("update직전:{}",formData);
			   sqlSessionTemplate.update("master.wmgr.updateEDIVPODT", formData);
				
				List<Map<String,String>> updateRtn = new ArrayList<Map<String,String>>();
				//재고정보 업데이트를 위해 데이타 select 
				logger.debug("SLEELCT:{}"+formData);
				updateRtn =sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrVmiWarhsngFor", formData);
				
				for(int j=0; j<updateRtn.size() ; j++)
				{
					//Map<String, String> temp = new HashMap<String,String>();
					formData.putAll((Map<String, String>)updateRtn.get(j));
					//조회해서 나온값을 재고에 업뎃 WMSSTCK
					sqlSessionTemplate.update("master.wmgr.updateMasterWmGrVmiWarhsngForWMSSTCK", formData);
				}
			}

			
		} catch (Exception e){
			if(_rtnMsg.equals("existStock")){
				throw new RuntimeException("발주번호 "+formData.get("VPO_NO")+"는 기 입고 대상 입니다.");
			}else{
				logger.error("SQL ERROR : ", e);
				_rtnMsg = "VMI 입고 등록에 실패 하였습니다.";
					throw new RuntimeException("VMI 입고 등록에 실패 하였습니다.");
			}
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
				
				sqlSessionTemplate.update("master.wmgr.deleteMasterWmGrVmiWarhsng", formData);
				logger.error("deleteMasterWmGrVmiWarhsng 실행 완료");

			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 요청에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	

}
