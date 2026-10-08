package com.koreab2b.mro.common.wmgi.dao;

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
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.wmgr.dao.MasterWmGrStockGrCreDaoImpl;
import com.koreab2b.mro.util.CommonUtil;

@Repository("masterWmGiCartRegPopDao")
@Transactional
public class MasterWmGiCartRegPopDaoImpl implements MasterWmGiCartRegPopDao {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmGrStockGrCreDaoImpl.class);
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		List<String> listParam = new ArrayList<String>();
		String[] st_STDCATLG_ID_arr = ((String)formData.get("st_STDCATLG_ID_arr")).split("@");
		if(st_STDCATLG_ID_arr.length >0){
			formData.put("buyerCnt", "1");
		}
		for(int i=0; i<st_STDCATLG_ID_arr.length ; i++){
			logger.debug("test:"+st_STDCATLG_ID_arr[i]);
			listParam.add(st_STDCATLG_ID_arr[i]);
		}
		formData.put("buyerParam", listParam);
		return sqlSessionTemplate.selectList("common.wmgi.selectMasterWmGiCartRegPopList", formData);
	}
	
	//장바구니 담기 
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData){
		
		String rtnMsg = "";
		try{
			
			for(int i=0; i < gridData.size(); i++){
			
				formData.putAll((Map<String,String>)gridData.get(i));
				List<Map<String,Object>> _STCKCount  = sqlSessionTemplate.selectList("common.wmgi.selectMasterWmGiCartRegPop", formData);
				BigDecimal tempCount = new BigDecimal(_STCKCount.get(0).get("COUNTVALUE").toString());
				BigDecimal tempZero = new BigDecimal(0);
				
				if(tempCount.compareTo(tempZero)==0){
					
					sqlSessionTemplate.update("common.wmgi.insertMasterWmGiCartRegPopList", formData);	
					rtnMsg = "OK";
					rtnMsg += "장바구니에 저장되었습니다\n장바구니 화면으로 이동 하시겠습니까?";
				}else{
					rtnMsg = "장바구니에 이미 저장되어 있는 품목이 있습니다.";
				}
				
			}
			
		}catch(Exception se)	{
				
				rtnMsg = "장바구니 저장에 실패했습니다. 운영자에게 문의 하세요";
				throw new RuntimeException("장바구니 저장에 실패했습니다. 운영자에게 문의 하세요.");
			}
		
		return rtnMsg;
	}
}
