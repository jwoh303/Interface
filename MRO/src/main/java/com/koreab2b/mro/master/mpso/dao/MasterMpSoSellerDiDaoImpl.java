package com.koreab2b.mro.master.mpso.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMpSoSellerDiDao")
@Transactional
public class MasterMpSoSellerDiDaoImpl implements MasterMpSoSellerDiDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoSellerDiDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	// 리스트 조회
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> getMasterMpSoSellerDiList_v2(Map<String,Object> param) {
		
		ResultRowHandler _resultHander = new ResultRowHandler();
		sqlSessionTemplate.select("master.mpso.getMasterMpSoSellerDiList_v2", param, _resultHander);
		return (List<Map<String, String>>) _resultHander.getList();
	}

	// 저장
	@SuppressWarnings("unchecked")
	@Transactional
	public String saveMpSoSellerDiTaxType_v2(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "저장 완료되었습니다.";
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				if(!formData.get("ORG_TAX_TYPE").equals(formData.get("TAX_TYPE"))) { //과세구분 변경되었다면
					if(formData.get("TAX_TYPE").equals("11") || formData.get("TAX_TYPE").equals("12")) { //과세,면세의 경우 
						//카탈로그도 수정해줘야함.icombyit.tax_type
						sqlSessionTemplate.update("master.mpso.updateByitTaxType_v2", formData);
					}
				}
				
				//icomivdt 과세구분 수정해주기
				sqlSessionTemplate.update("master.mpso.updateIvDtTaxType_v2", formData);				
				
				//과세구분 이력 남기기
				sqlSessionTemplate.update("master.mpso.insertIvDtTaxTypeHist_v2", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	public List<Map<String,String>> getMasterMpSoSellerDiStockSumPopList_v2(Map<String,Object> param) {
		
		return sqlSessionTemplate.selectList("master.mpso.getMasterMpSoSellerDiStockSumPopList_v2", param);
	}
}
