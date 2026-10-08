package com.koreab2b.mro.common.wmco.dao;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterWmCoTranStatementPopDao")
@Transactional
public class MasterWmCoTranStatementPopDaoImpl implements MasterWmCoTranStatementPopDao {
	
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		
		List<String> ivkParam;
		ivkParam = Arrays.asList( ((String)formData.get("st_ivk_list")).split("@@"));

	    if(ivkParam.size() >0 || !"".equals((String)formData.get("st_ivk_list")) )
	    {		
	    	formData.put("ivkParam",ivkParam);
	    	formData.put("ivkParamCnt","1");
	    }
	    ResultRowHandler _resultHander = new ResultRowHandler();
	    List<Map<String, String>> resultList = new ArrayList<Map<String,String>>();
	    sqlSessionTemplate.select("common.wmco.selectMasterWmCoTranStatementPopList", formData,_resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();
		
		//SLOGIC-BEGIN(P08-0000011) 		
		if(resultList !=null &&resultList.size()>0){
			
			Map<String, String> _map = null;
			Map<String, String> _tempMap = new HashMap<String,String>();
			String  deptMap = "";
			
			for(int i=0 ; i<resultList.size(); i++){
				
				_map =CommonUtil.getSpecialCheckReturnSheetMap(resultList.get(i).get("BUYER"));
				
				if(_map != null){
					
					resultList.get(i).put("SLG_ID", _map.get("SLG_ID"));
					
					if("P08-0000011-23".equals(_map.get("SLG_ID"))){
						
						_tempMap.put("st_warehouse_code", (String)formData.get("st_warehouse_code"));
						_tempMap.put("st_ik_no_temp", resultList.get(i).get("INV_NO"));
						_tempMap.put("st_buyer", resultList.get(i).get("BUYER"));
						deptMap = CommonUtil.getSpecialCheckReturnSheetMapByDept( _tempMap );
						
						
						resultList.get(i).put("DEPTCD", deptMap);
					}
					
				}
			}
		}
		//SLOGIC-END
		
		return resultList;

	}
	
}
