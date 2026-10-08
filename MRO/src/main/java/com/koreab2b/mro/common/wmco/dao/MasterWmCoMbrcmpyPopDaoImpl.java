package com.koreab2b.mro.common.wmco.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;

@Repository("masterWmCoMbrcmpyPopDao")
@Transactional
public class MasterWmCoMbrcmpyPopDaoImpl implements MasterWmCoMbrcmpyPopDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	
	// 조회
	public List<Map<String,String>> selectSingleList(Map<String,Object> formData) {
		
		return sqlSessionTemplate.selectList("common.wmco.selectMasterWmCoMbrcmpySinglePopList", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		List<Map<String,String>> rtnList = sqlSessionTemplate.selectList("common.wmco.selectMasterWmCoMbrcmpyPopList", formData);
		
		if(rtnList.size() >1){
	
			List<Map<String,String>>  rtnMap = sqlSessionTemplate.selectList("common.wmco.selectMasterWmCoMbrcmpyPopListSingle", formData);
			String buyerCont ="";
			
			for(int i=0 ; i<rtnMap.size() ; i++){
				
				if(i<rtnMap.size()-1 )
				{
					buyerCont +=  ((Map<String,String>)rtnMap.get(i)).get("BUYER");
					buyerCont += "@@";
				}else{
					buyerCont +=  ((Map<String,String>)rtnMap.get(i)).get("BUYER");
				}
				
			}
			rtnList.get(0).put("BUYER", buyerCont);
		}
		return rtnList;
	}
	
	// 조회
	public List<Map<String,String>> selectCountList(Map<String,Object> formData) {
		List<Map<String,String>> rtnList = new ArrayList<Map<String, String>>();
		String _jobTyep = CommonUtil.nvl((String)formData.get("st_job_type"));
		try{
			if ( "01".equals(_jobTyep) ) {
				// 선입고(입고등록)
				rtnList = sqlSessionTemplate.selectList("common.wmco.selectMasterWmCoMbrcmpyCountPopList_JOB_01", formData);
			}
			else if ( "02".equals(_jobTyep) ) {
				// 선입고(출고등록)
				rtnList = sqlSessionTemplate.selectList("common.wmco.selectMasterWmCoMbrcmpyCountPopList_JOB_02", formData);
			}
			else if ( "03".equals(_jobTyep) ) {
				// 선입고(배송확정)
				rtnList = sqlSessionTemplate.selectList("common.wmco.selectMasterWmCoMbrcmpyCountPopList_JOB_03", formData);
			}
			else {
				rtnList = sqlSessionTemplate.selectList("common.wmco.selectMasterWmCoMbrcmpyCountPopList", formData);
			}
		}catch(Exception e){
			throw new RuntimeException(e);
		}
		return rtnList;
	}
	
	
	// 조회
	public List<Map<String,String>> selectIKList(Map<String,Object> formData) {

		return sqlSessionTemplate.selectList("common.wmco.selectMasterWmCoMbrcmpyIKPopList", formData);
	}
	
	// 일괄출고지시 고객사 조회
	public List<Map<String,String>> selectBpIKList(Map<String,Object> formData) {

		return sqlSessionTemplate.selectList("common.wmco.selectMasterWmCoMbrcmpyBpIKPopList", formData);
	}
	
	// 조회
	public List<Map<String,String>> selectNewIKList(Map<String,Object> formData) {

		return sqlSessionTemplate.selectList("common.wmco.selectMasterWmCoMbrcmpyNewIKPopList", formData);
	}
}
