package com.koreab2b.mro.common.wmst.dao;

import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterWmStAssmblDirectionsCreationPopDao")
@Transactional
public class MasterWmStAssmblDirectionsCreationPopDaoImpl implements MasterWmStAssmblDirectionsCreationPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		
		List<String> itemParam;
		itemParam = Arrays.asList( ((String)formData.get("st_sel_item_no")).split("@@"));
		
		
	    if(itemParam.size() >0 || !"".equals((String)formData.get("st_sel_item_no")) )
	    {
	    	formData.put("itemParam",itemParam);
	    }
		
		return sqlSessionTemplate.selectList("common.wmst.selectMasterWmStAssmblDirectionsCreationPopList", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectList2(Map<String,Object> formData) {
		
		List<String> itemParam;
		itemParam = Arrays.asList( ((String)formData.get("st_sel_item_no")).split("@@"));
		
		
	    if(itemParam.size() >0 || !"".equals((String)formData.get("st_sel_item_no")) )
	    {
	    	formData.put("itemParam",itemParam);
	    }
		
		return sqlSessionTemplate.selectList("common.wmst.selectMasterWmStAssmblDirectionsCreationPopList2", formData);
	}
	
	// 조회
	public List<Map<String,String>> getChangeList(Map<String,Object> formData) {
		
		return sqlSessionTemplate.selectList("common.wmst.selectMasterWmStAssmblDirectionsCreationPopChangeList", formData);
	}
	
	//조립지시
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData){
		String rtnMsg = "OK";
		
		try{
			
		//"KRKORE0001","AS");
			
			String orderno ="";
			//송장번호 생성을 위한 조회 
			List<Map<String,Object>>  _rtnListorderno= sqlSessionTemplate.selectList("common.wmst.selectMasterWmStAssmblDirectionsCreationPopORDERNO", formData);
			
			//현재 Company 코드에 해당하는 type의 코드가 존재하지 않는 경우 새로 번호를 생성한다.
			if(_rtnListorderno.size() !=1)
			{
				sqlSessionTemplate.update("common.wmst.insertMasterWmStAssmblDirectionsCreationPop", formData);
                int year_num = Calendar.getInstance().get(Calendar.YEAR);
                String year_str = String.valueOf(year_num);
                orderno = "AS"+year_str.substring(2,4) + "000001";
			}
			else
			{
				sqlSessionTemplate.update("common.wmst.updateMasterWmStAssmblDirectionsCreationPop", formData);
				orderno = _rtnListorderno.get(0).get("AS_NO").toString();
			}
			formData.put("ASNO", orderno);
			
			for(int i=0 ; i<gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				sqlSessionTemplate.update("common.wmst.selectMasterWmStAssmblDirectionsCreationPopInsertWmsAssemb", formData);
				
				sqlSessionTemplate.update("common.wmst.selectMasterWmStAssmblDirectionsCreationPopSubQty", formData);
				
				sqlSessionTemplate.update("common.wmst.selectMasterWmStAssmblDirectionsCreationPopBomQty", formData);
				
			}
		}catch(Exception e){
			rtnMsg = "ERR";
			throw new RuntimeException("견적 요청에 실패하였습니다.");
		}

		
		return rtnMsg;
	}
}
