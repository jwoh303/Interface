package com.koreab2b.mro.common.wmgr.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterWmGrStockGrDetailPopDao")
@Transactional
public class MasterWmGrStockGrDetailPopDaoImpl implements MasterWmGrStockGrDetailPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		
		if("VMI".equals(formData.get("name_gubun")))
		{
			return sqlSessionTemplate.selectList("common.wmgr.selectMasterWmGrStockGrDetailVMIPopList", formData);
		}
		else
		{
			return sqlSessionTemplate.selectList("common.wmgr.selectMasterWmGrStockGrDetailPopList", formData);
		}

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
				
			   sqlSessionTemplate.update("master.wmgr.updateEDIVPODT", formData);
				

			}
			List<Map<String,String>> updateRtn = new ArrayList<Map<String,String>>();
			//재고정보 업데이트를 위해 데이타 select 
		
			updateRtn =sqlSessionTemplate.selectList("master.wmgr.selectMasterWmGrVmiWarhsngFor", formData);
			
			for(int j=0; j<updateRtn.size() ; j++)
			{
				//Map<String, String> temp = new HashMap<String,String>();
				formData.putAll((Map<String, String>)updateRtn.get(j));
				//조회해서 나온값을 재고에 업뎃 WMSSTCK
				sqlSessionTemplate.update("master.wmgr.updateMasterWmGrVmiWarhsngForWMSSTCK", formData);
			}

			
		} catch (Exception e){
			if(_rtnMsg.equals("existStock")){
				throw new RuntimeException("발주번호 "+formData.get("VPO_NO")+"는 기 입고 대상 입니다.");
			}else{
			
				_rtnMsg = "VMI 입고 등록에 실패 하였습니다.";
					throw new RuntimeException("VMI 입고 등록에 실패 하였습니다.");
			}
		}
		return _rtnMsg;
	}
	
}
