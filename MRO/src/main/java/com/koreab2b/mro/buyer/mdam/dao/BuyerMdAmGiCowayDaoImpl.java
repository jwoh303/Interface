package com.koreab2b.mro.buyer.mdam.dao;

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

@Repository("buyerMdAmGiCowayDao")
@Transactional
public class BuyerMdAmGiCowayDaoImpl implements BuyerMdAmGiCowayDao {
	private static final Logger LOGGER  = LoggerFactory.getLogger(BuyerMdAmGiCowayDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectBuyerMdAmBudgetCompilationList", formData);
	}
	
	// 예산 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		String _rtnMsg = "선택한 예산 목록을 저장하였습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				String flag = formData.get("db_flag");
				if("INSERT".equals(flag)){
					sqlSessionTemplate.update("buyer.mdam.insertBuyerMdAmBudgetCompilation", formData);
				}else{
					sqlSessionTemplate.update("buyer.mdam.updateBuyerMdAmBudgetCompilation", formData);
				}
			}
		}catch(Exception e){
			LOGGER .error("SQL ERROR : ", e);
			throw new RuntimeException("예산 목록 저장에 실패하였습니다.");
		}
		return _rtnMsg;
		
	}

	// 예산 삭제
	@SuppressWarnings("unchecked")
	public String deleteSelectedData(Map<String,String> formData, List<Object> gridData) {
		String _rtnMsg = "선택한 예산 목록을 삭제하였습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.update("buyer.mdam.deleteBuyerMdAmBudgetCompilation", formData);
			}
		}catch(Exception e){
			LOGGER .error("SQL ERROR : ", e);
			throw new RuntimeException("예산 목록 삭제에 실패하였습니다.");
		}
	return _rtnMsg;
		
	}

	@Override
	public List<Map<String, String>> getPrDetail(Map<String, String> param) {
		return sqlSessionTemplate.selectList("buyer.mdam.getPrDetail", param);
	}

	@Override
	public List<Map<String, String>> getReqUserInfo(Map<String, String> map) {
		return sqlSessionTemplate.selectList("buyer.mdam.getReqUserInfo", map);
	}

	@Override
	public List<Map<String, String>> getRecvUserInfo(Map<String, String> map) {
		return sqlSessionTemplate.selectList("buyer.mdam.getRecvUserInfo", map);
	}

	@Override
	public List<Map<String, String>> getPassUserInfo(Map<String, String> map) {
		return sqlSessionTemplate.selectList("buyer.mdam.getPassUserInfo", map);
	}

	@Override
	public List<Map<String, String>> getReqDeptInfo(Map<String, String> map) {
		return sqlSessionTemplate.selectList("buyer.mdam.getReqDeptInfo", map);
	}

	@Override
	public List<Map<String, String>> getHqUserInfo(Map<String, String> map) {
		return sqlSessionTemplate.selectList("buyer.mdam.getHqUserInfo", map);
	}

	@Override
	public HashMap<String, String> getOriPrInfo(Map<String, String> map) {
		return sqlSessionTemplate.selectOne("buyer.mdam.getOriPrInfo", map);
	}

	@Override
	public List<Map<String, String>> getGiReqExcelList(Map<String, Object> map) {
		return sqlSessionTemplate.selectList("buyer.mdam.getGiReqExcelList", map);
	}

	@Override
	public void deleteGsysDeliveryDisplaySum(Map<String, String> pMap) {

		sqlSessionTemplate.update("buyer.mdam.deleteGsysDeliveryDisplaySum", pMap);
	}

	@Override
	public void insertGsysDeliveryDisplay(Map<String, String> pMap) {
		sqlSessionTemplate.update("buyer.mdam.insertGsysDeliveryDisplay", pMap);
	}

	@Override
	public void insertGsysDeliveryDisplaySum(Map<String, String> pMap) {

		sqlSessionTemplate.update("buyer.mdam.insertGsysDeliveryDisplaySum", pMap);
	}

	@Override
	public void updateGsysDeliveryDisplayPrInfo(Map<String, String> pMap) {
		sqlSessionTemplate.update("buyer.mdam.updateGsysDeliveryDisplayPrInfo", pMap);
	}

	@Override
	public List<Map<String, String>> selectGsysDeliveryDispaly(Map<String, String> pMap) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectGsysDeliveryDisplay", pMap);
	}

	@Override
	public void insertGsysDeliveryDisplayBatch(List<Map<String, String>> pList) {
		int length	= pList.size();
		
		if( length <= 50 ) {
			sqlSessionTemplate.insert("buyer.mdam.insertGsysDeliveryDisplayBatch", pList);
		} else {
			List<Map<String, String>> tList	= new ArrayList<Map<String,String>>();
			for( int i = 0 ; i < length ; i++) {
				if ( i%50 == 0 && i > 0) {
					sqlSessionTemplate.insert("buyer.mdam.insertGsysDeliveryDisplayBatch", tList);
					
					tList = new ArrayList<Map<String,String>>();
				}
				
				tList.add(pList.get(i));
			}
			
			sqlSessionTemplate.insert("buyer.mdam.insertGsysDeliveryDisplayBatch", tList);
		}
	}

	@Override
	public void insertGsysDeliveryDisplaySumBatch(List<Map<String, String>> pList) {
		int length	= pList.size();
		
		if( length <= 50 ) {
			sqlSessionTemplate.insert("buyer.mdam.insertGsysDeliveryDisplaySumBatch", pList);
		} else {
			List<Map<String, String>> tList	= new ArrayList<Map<String,String>>();
			for( int i = 0 ; i < length ; i++) {
				if ( i%50 == 0 && i > 0) {
					sqlSessionTemplate.insert("buyer.mdam.insertGsysDeliveryDisplaySumBatch", tList);
					
					tList = new ArrayList<Map<String,String>>();
				}
				
				tList.add(pList.get(i));
			}
			
			sqlSessionTemplate.insert("buyer.mdam.insertGsysDeliveryDisplaySumBatch", tList);
		}
	}

	@Override
	public void updateGsysDeliveryDisplaySumPrInfo(Map<String, String> pMap) {
		sqlSessionTemplate.update("buyer.mdam.updateGsysDeliveryDisplaySumPrInfo", pMap);
	}

	@Override
	public List<Map<String, String>> selectGsysDeliveryDispalySum(Map<String, String> pMap) {
		return sqlSessionTemplate.selectList("buyer.mdam.selectGsysDeliveryDisplaySum", pMap);
	}
	
	
	public void updateExcelInfo(List<Map<String, String>> pList) {
		
		for(int i = 0 ; i < pList.size() ; i++) {
			Map<String, String> tMap	= pList.get(i);
			
			sqlSessionTemplate.update("buyer.mdam.updateGsysExcelInfo", tMap);
		}
	}

	@Override
	public Map<String, String> selectGiDetailInfo(Map<String, String> pMap) {
		return sqlSessionTemplate.selectOne("buyer.mdam.selectGiDetailInfo", pMap);
	}
}
