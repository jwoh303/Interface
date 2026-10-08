package com.koreab2b.mro.common.wmst.dao;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterWmStAssmblCmpntsttmntCreationPopDao")
@Transactional
public class MasterWmStAssmblCmpntsttmntCreationPopDaoImpl implements MasterWmStAssmblCmpntsttmntCreationPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.wmst.selectMasterWmStAssmblCmpntsttmntCreationPopList", formData);
	}

	// 조회
	public List<Map<String,String>> selectBotList(Map<String,Object> formData) {
		
		List<String> itemParam;
		itemParam = Arrays.asList( ((String)formData.get("st_buyer_item_no_list")).split("@@"));
		
		
	    if(itemParam.size() >0 || !"".equals((String)formData.get("st_sel_item_no")) )
	    {
	    	formData.put("itemParam",itemParam);
	    }
		return sqlSessionTemplate.selectList("common.wmst.selectMasterWmStAssmblCmpntsttmntCreationPopList2", formData);
	}
	
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> formData,List<Object> gridData){
		
		String _rtnMsg = "OK";
		
		try{
			
			List<Map<String,String>>  rtnList= sqlSessionTemplate.selectList("common.wmst.existMasterWmStAssmblCmpntsttmntCreationPop", formData);
			if(rtnList.size() >0){
				_rtnMsg = "bomExist";
				return _rtnMsg;
			}
			for(int i= 0 ; i<gridData.size(); i++){
				
				formData.putAll((Map<String,String>)gridData.get(i));
				int resultWidt = sqlSessionTemplate.update("common.wmst.saveMasterWmStAssmblCmpntsttmntCreationPopBot", formData);
				
				if(resultWidt == 0){
				    _rtnMsg = "저장에 실패하였습니다.";
					throw new RuntimeException("저장에 실패하였습니다.");
				}
			}
			
			
		} catch (Exception e){
			    _rtnMsg = "저장에 실패하였습니다.";
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
}
