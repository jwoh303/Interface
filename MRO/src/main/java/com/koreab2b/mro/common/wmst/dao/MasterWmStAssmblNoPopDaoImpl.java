package com.koreab2b.mro.common.wmst.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterWmStAssmblNoPopDao")
@Transactional
public class MasterWmStAssmblNoPopDaoImpl implements MasterWmStAssmblNoPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = new ArrayList<Map<String,String>>();
		sqlSessionTemplate.select("common.wmst.selectMasterWmStAssmblNoPopList", formData,_resultHander);
		resultList = (List<Map<String, String>>)_resultHander.getList();
		return resultList;
	}

	//상단조회 
	public List<Map<String,String>> selectPopList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.wmst.selectMasterWmStAssmblNoPopUpList", formData);
	}
	
	//조립취소
	public String updateSelectedData(Map<String,String> formData,List<Object> gridData){
		String _rtnMsg = "OK";
		String possible_delete = "N";
		int cnt = 0;
		try{
			
			Map<String,String> rtnMap = sqlSessionTemplate.selectOne("common.wmst.selectMasterWmStAssmblNoPopSelStck", formData);
			
			possible_delete = rtnMap.get("BOM_AVAIL_QTY");
			
			if("N".equals(formData.get("st_complete_flag")) || "Y".equals(possible_delete)){
				
				if("N".equals(formData.get("st_complete_flag"))){
					
					cnt = sqlSessionTemplate.update("common.wmst.updateMasterWmStAssmblNoPopsubQtyN", formData);
					if(cnt < 1){
						_rtnMsg = "조립 취소 오류 (UPDATE WMSSTCK SUB_ID) ==> AS_NO : " +formData.get("st_as_no");
						throw new RuntimeException("조립 취소 오류 (UPDATE WMSSTCK SUB_ID) ==> AS_NO : " +formData.get("st_as_no"));
					}
					cnt =sqlSessionTemplate.update("common.wmst.updateMasterWmStAssmblNoPopbomQtyN", formData);
					if(cnt < 1){
						_rtnMsg = "조립 취소 오류 (UPDATE WMSSTCK BOM_ID) ==> AS_NO : " +formData.get("st_as_no");
						throw new RuntimeException("조립 취소 오류 (UPDATE WMSSTCK BOM_ID) ==>" +formData.get("st_as_no"));
					}
					
				}else if("Y".equals(formData.get("st_complete_flag"))){
					
					cnt =sqlSessionTemplate.update("common.wmst.updateMasterWmStAssmblNoPopsubQtyY", formData);
					if(cnt < 1){
						_rtnMsg = "조립 취소 오류 (UPDATE WMSSTCK SUB_ID) ==> AS_NO : " +formData.get("st_as_no");
						throw new RuntimeException("조립 취소 오류 (UPDATE WMSSTCK SUB_ID) ==> AS_NO : " +formData.get("st_as_no"));
					}
					cnt =sqlSessionTemplate.update("common.wmst.updateMasterWmStAssmblNoPopbomQtyY", formData);
					if(cnt < 1){
						_rtnMsg = "조립 취소 오류 (UPDATE WMSSTCK BOM_ID) ==> AS_NO : " +formData.get("st_as_no");
						throw new RuntimeException("조립 취소 오류 (UPDATE WMSSTCK BOM_ID) ==>" +formData.get("st_as_no"));
					}
					
				}
				
				cnt =sqlSessionTemplate.update("common.wmst.updateMasterWmStAssmblNoPopAssemb", formData);
				if(cnt < 1){
					_rtnMsg = "조립 취소 오류 (UPDATE WMSASSEMB)==> AS_NO : " +formData.get("st_as_no");
					throw new RuntimeException("조립 취소 오류 (UPDATE WMSASSEMB) ==> AS_NO : " +formData.get("st_as_no"));
				}
				
			}else{
				_rtnMsg = "NO_AVAIL_QTY";
			}
			


			
		} catch (Exception e){
			   
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	
	
	//조립완료
	public String updateSelectedDataCom(Map<String,String> formData,List<Object> gridData){
		String _rtnMsg = "OK";
		
		try{
			
			sqlSessionTemplate.update("common.wmst.updateMasterWmStAssmblNoPopDate", formData);
			
			if("ASS".equals(formData.get("st_work_type"))){
				
				sqlSessionTemplate.update("common.wmst.updateMasterWmStAssmblNoPopSubQtyAss", formData);
				
				sqlSessionTemplate.update("common.wmst.updateMasterWmStAssmblNoPopBomQtyAss", formData);

			}else{
				
				sqlSessionTemplate.update("common.wmst.updateMasterWmStAssmblNoPopSubQty", formData);
				
				sqlSessionTemplate.update("common.wmst.updateMasterWmStAssmblNoPopBomQty", formData);

			}
			
		} catch (Exception e){
			_rtnMsg = "NO";
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		
		return _rtnMsg;
	}
}
