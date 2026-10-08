package com.koreab2b.mro.common.wmgr.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.wmgr.dao.MasterWmGrStockGrCreDaoImpl;
import com.koreab2b.mro.util.CommonUtil;

@Repository("masterWmGrStockWarehousingManagerPopDao")
@Transactional
public class MasterWmGrStockWarehousingManagerPopDaoImpl implements MasterWmGrStockWarehousingManagerPopDao {
	private static final Logger logger = LoggerFactory.getLogger(MasterWmGrStockGrCreDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";

	// 조회
	public List<Map<String,String>> selectPop(Map<String,String> formData) {
		

		return sqlSessionTemplate.selectList("common.wmgr.selectMasterWmGrStockWarehousingManagerPopVMIPop", formData);
	

	}
	
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		
		if("VMI".equals(formData.get("GUBUN")))
		{
			return sqlSessionTemplate.selectList("common.wmgr.selectMasterWmGrStockWarehousingManagerPopVMIList", formData);
		}
		else
		{
			return sqlSessionTemplate.selectList("common.wmgr.selectMasterWmGrStockWarehousingManagerPopList", formData);
		}

	}
	
	
	// 저장
	@SuppressWarnings("unchecked")
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "";
		
		try{	
			
			if("STCK".equals(formData.get("GUBUN")))
			{
				//1updateIvdt
				sqlSessionTemplate.update("common.wmgr.updateMasterWmGrStockWarehousingManagerPopIvdt", formData);
				
				//2.updatePodt
				//3.delGrDt
				for(int i = 0 ; i<gridData.size() ; i++)
				{
					formData.putAll((Map<String, String>)gridData.get(i));
					
					sqlSessionTemplate.update("common.wmgr.updateMasterWmGrStockWarehousingManagerPopPodt", formData);
					sqlSessionTemplate.update("common.wmgr.deleteMasterWmGrStockWarehousingManagerPopGrDt", formData);
					sqlSessionTemplate.update("common.wmgr.updateMasterWmGrStockWarehousingManagerPopWmsStckForSTCK", formData);				
					
				}
				
			}
			else if("VMI".equals(formData.get("GUBUN")))
			{
				//1. updateEdidt
				sqlSessionTemplate.update("common.wmgr.updateMasterWmGrStockWarehousingManagerPopEdidt", formData);
				//2 updateWmsStckForVMI
				for(int i = 0 ; i<gridData.size() ; i++)
				{
					formData.putAll((Map<String, String>)gridData.get(i));
					sqlSessionTemplate.update("common.wmgr.updateMasterWmGrStockWarehousingManagerPopWmsStckForVMI", formData);		
				}
				
			}
			
			logger.error("deleteMasterWmGrStockGrCre 실행 완료");

		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("재고입고삭제에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	
	
}
