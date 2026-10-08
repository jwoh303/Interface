package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
//import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mpso.dao.MasterMpSoOrderInfoAlterBeforePopDao;

@Service("masterMpSoOrderInfoAlterBeforePopService")
public class MasterMpSoOrderInfoAlterBeforePopServiceImpl implements MasterMpSoOrderInfoAlterBeforePopService {
	
	@Autowired
	private MasterMpSoOrderInfoAlterBeforePopDao masterMpSoOrderInfoAlterBeforePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpSoOrderInfoAlterBeforePopDao.selectList(formData);
	}	
	public String getPrCardUseCheck(Map<String,String>  formData) {
		return masterMpSoOrderInfoAlterBeforePopDao.getPrCardUseCheck(formData);
	}
	public List<Map<String,String>> getSysopOrderTotalAmtMainPop(Map<String,Object>  formData)  {
		return masterMpSoOrderInfoAlterBeforePopDao.getSysopOrderTotalAmtMainPop(formData);
	}
	
	public List<Map<String,String>> getSysopOrderTotalBuyerAmtMainPop(Map<String,Object>  formData)  {
		return masterMpSoOrderInfoAlterBeforePopDao.getSysopOrderTotalBuyerAmtMainPop(formData);
	}	
	
	public List<Map<String,String>> getSysopOrderChangePoBeforeHDPop(Map<String,String>  formData)  {
		return masterMpSoOrderInfoAlterBeforePopDao.getSysopOrderChangePoBeforeHDPop(formData);
	}	
	
	public List<Map<String,String>> getSysopOrderChangePoBeforeDTPop(Map<String,Object>  formData) {
		return masterMpSoOrderInfoAlterBeforePopDao.getSysopOrderChangePoBeforeDTPop(formData);
	}	
	public List<Map<String,String>> getSysopOrderChangePoBeforeDTPop_v2(Map<String,Object>  formData) {
		return masterMpSoOrderInfoAlterBeforePopDao.getSysopOrderChangePoBeforeDTPop_v2(formData);
	}	
	public List<Map<String,String>> getSysopOrderChangePoBeforeDivisionDTPop(Map<String,Object>  formData) {
		return masterMpSoOrderInfoAlterBeforePopDao.getSysopOrderChangePoBeforeDivisionDTPop(formData);
	}		
	public List<Map<String,String>> getUnitMeasureInfo(Map<String,String>  formData) {
		return masterMpSoOrderInfoAlterBeforePopDao.getUnitMeasureInfo(formData);
	}	
	public List<Map<String,String>> getHubCode(Map<String,String>  formData) {
		return masterMpSoOrderInfoAlterBeforePopDao.getHubCode(formData);
	}	
	
	
	
	
	/**
	 * 주문정보수정 통합처리 로직 
	 */
	public String saveOrderChangeCombineLogic(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoOrderInfoAlterBeforePopDao.saveOrderChangeCombineLogic(formData,gridData);
	}	
	
	/**
	 * 주문정보수정 수량분할 통합처리 로직 
	 */
	public String saveOrderChangeDivisionCombineLogic(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoOrderInfoAlterBeforePopDao.saveOrderChangeDivisionCombineLogic(formData,gridData);
	}	
	
	public String saveSysopOrderChangeClear(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoOrderInfoAlterBeforePopDao.saveSysopOrderChangeClear(formData,gridData);
	}	
	public String saveSysopOrderChangeEnd(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoOrderInfoAlterBeforePopDao.saveSysopOrderChangeEnd(formData,gridData);
	}	
	public String setSysopOrderChangeBeforeDelete(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoOrderInfoAlterBeforePopDao.setSysopOrderChangeBeforeDelete(formData,gridData);
	}	
	
	public String setSysopOrderChangeBeforeSave(Map<String,String>  formData, List<Object> gridData){
		return masterMpSoOrderInfoAlterBeforePopDao.setSysopOrderChangeBeforeSave(formData,gridData);
	}	
	public String setSysopOrderChangeBeforeProcessTypeModify(Map<String,String>  formData, List<Object> gridData){
		return masterMpSoOrderInfoAlterBeforePopDao.setSysopOrderChangeBeforeProcessTypeModify(formData,gridData);
	}	
	public String setSysopOrderChangeBeforeAgentModify(Map<String,String>  formData, List<Object> gridData){
		return masterMpSoOrderInfoAlterBeforePopDao.setSysopOrderChangeBeforeAgentModify(formData,gridData);
	}	
	public String setCheckInterBizPoStatus(Map<String,String>  formData, List<Object> gridData){
		return masterMpSoOrderInfoAlterBeforePopDao.setCheckInterBizPoStatus(formData,gridData);
	}	 
	public double getBuyerRateInfo(Map<String,String>  formData, List<Object> gridData){
		return masterMpSoOrderInfoAlterBeforePopDao.getBuyerRateInfo(formData,gridData);
	}	
	public double getProcessTypeRateInfo(Map<String,String>  formData, List<Object> gridData){
		return masterMpSoOrderInfoAlterBeforePopDao.getProcessTypeRateInfo(formData,gridData);
	}	
	public double getBuyerStandardRate(Map<String,String>  formData, List<Object> gridData){
		return masterMpSoOrderInfoAlterBeforePopDao.getBuyerStandardRate(formData,gridData);
	}	
	public String getBuyerRateAdaptFlag(Map<String,String>  formData, List<Object> gridData){
		return masterMpSoOrderInfoAlterBeforePopDao.getBuyerRateAdaptFlag(formData,gridData);
	}	
	public List<Map<String, String>> getTotProcessTypeRateInfo(Map<String,String>  formData, List<Object> gridData){
		return masterMpSoOrderInfoAlterBeforePopDao.getTotProcessTypeRateInfo(formData,gridData);
	}	
	
	
	public double getBuyerRateInfo2(Map<String, String> pMap) {
		return masterMpSoOrderInfoAlterBeforePopDao.getBuyerRateInfo2(pMap);
	}	
	public double getKePBuyerRateInfo(Map<String, String> pMap) {
		return masterMpSoOrderInfoAlterBeforePopDao.getKePBuyerRateInfo(pMap);
	}	
	public String getBuyerRateAdaptFlag2(Map<String, String> pMap) {
		return masterMpSoOrderInfoAlterBeforePopDao.getBuyerRateAdaptFlag2(pMap);
	}	
	public double getProcessTypeRateInfo2(Map<String, String> pMap) {
		return masterMpSoOrderInfoAlterBeforePopDao.getProcessTypeRateInfo2(pMap);
	}	
	
	public String setSysopOrderUpdateEmegancyPo(Map<String,String>  formData,List<Object> gridData) {
		return masterMpSoOrderInfoAlterBeforePopDao.setSysopOrderUpdateEmegancyPo(formData,gridData);
		
	}	
	
	

}
