package com.koreab2b.mro.common.mpds.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mdam.dao.BuyerMdAmBudgetCompilationDaoImpl;
import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpDsOrderCreationPopDao")
@Transactional
public class MasterMpDsOrderCreationPopDaoImpl implements MasterMpDsOrderCreationPopDao {
	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmBudgetCompilationDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mpds.selectMasterMpDsOrderCreationPopList", formData);
	}
	public List<Map<String,String>> moveList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mpds.selectMasterMpDsOrderCreationPopList_2", formData);
	}

	
	// 발주
	@SuppressWarnings("unchecked")
	public String insertSelectedData(Map<String,String> formData, List<Object> gridData) {

		String _rtnMsg = "발주 등록 완료";
		List<Map<String,String>>_list = null;
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
	
				sqlSessionTemplate.insert("common.mpds.insertDbOffPo", formData);
				String rd_date_all = formData.get("RD_DATE_ALL"); // 발주 요청일
				String ds_qty_all = formData.get("DS_QTY_ALL"); // 발주 수량
				
				String[] rd_date_arr = null;
				String[] ds_qty_arr = null;
				if( rd_date_all.indexOf("@@") > -1 ){
					rd_date_arr = rd_date_all.split("@@");
					ds_qty_arr = ds_qty_all.split("@@");

					for(int j=0; j<rd_date_arr.length; j++){
						formData.put("RD_DATE", rd_date_arr[j]);
						formData.put("DS_QTY", ds_qty_arr[j]);
						sqlSessionTemplate.update("common.mpds.insertDbOffIv",formData);
					}
				}else{
					formData.put("RD_DATE", rd_date_all);
					formData.put("DS_QTY", ds_qty_all);
					sqlSessionTemplate.update("common.mpds.insertDbOffIv",formData);
				}
				
			} // end of for
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("발주 등록에 실패하였습니다.");
		}
	return _rtnMsg;
		
	}	
}
