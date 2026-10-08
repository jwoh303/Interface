package com.koreab2b.mro.master.mdct.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;


@Repository("masterMdCtNewCustomerBidManageDao")
@Transactional
public class MasterMdCtNewCustomerBidManageDaoImpl implements MasterMdCtNewCustomerBidManageDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCtNewCustomerBidManageDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 잠재고객 입찰등록 조회
	public List<Map<String,String>> getDetailList(Map<String,String> formData) {
		LOGGER.debug("formData : {}", formData);
		if(CommonUtil.nvl(formData.get("st_s_revision"),"").equals("")){
			return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtNewCustomerBidList",formData);
		}else{
			return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtNewCustomerRevisionBid",formData);	
		}
		
	}

	// 잠재고객 입찰등록
	public String saveMasterMdCtNewCustomerBidList(Map<String,String> formData) {
		String rtnMsg = "Ok";
		try{
			//잠재고객사 입찰등록
			LOGGER.debug("formData : {}", formData);
			if(formData.get("st_data_gbn").equals("reg")){
				//잠재고객사 입찰등록일 경우 상태값 업데이트
				sqlSessionTemplate.update("master.mdct.saveMasterMdCtNewCustomerBidStatus", formData);	
			}
			//잠재고객사 입찰정보 등록.
			sqlSessionTemplate.update("master.mdct.saveMasterMdCtNewCustomerBidList", formData);
		}catch(Exception e){
			rtnMsg = "입찰등록 처리중 오류가 발생 하였습니다.";
			throw new RuntimeException();
		}
		
		return rtnMsg;
	}
	// 잠재고객 입찰 취소
	public String cancleMasterMdCtNewCustomerBidList(Map<String,String> formData) {
		String rtnMsg = "Ok";
		try{
			//잠재고객사 입찰등록일 경우 상태값 업데이트
			sqlSessionTemplate.update("master.mdct.cancleMasterMdCtNewCustomerBidList", formData);			

		}catch(Exception e){
			rtnMsg = "입찰취소 처리중 오류가 발생 하였습니다.";
			throw new RuntimeException();
		}
		
		return rtnMsg;
	}
	// 잠재고객 셋업조회
	public List<Map<String,String>> getSetupList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtNewCustomerSetupList",formData);
	}
	// 잠재고객 셋업등록
	public String saveMasterMdCtNewCustomerSetList(Map<String,String> formData) {
		String rtnMsg = "Ok";
		try{
			//잠재고객사 입찰등록
			LOGGER.debug("formData : {}", formData);
			if(CommonUtil.nvl(formData.get("st_data_gbn"),"").equals("reg")){
				//잠재고객사 입찰등록일 경우 상태값 업데이트
				sqlSessionTemplate.update("master.mdct.saveMasterMdCtNewCustomerBidStatus", formData);	
			}
			//잠재고객사 입찰정보 등록.
			sqlSessionTemplate.update("master.mdct.saveMasterMdCtNewCustomerSetList", formData);
		}catch(Exception e){
			rtnMsg = "입찰등록 처리중 오류가 발생 하였습니다.";
			throw new RuntimeException();
		}
		
		return rtnMsg;
	}
	// 잠재고객 셋업 취소
	public String cancleMasterMdCtNewCustomerSetList(Map<String,String> formData) {
		String rtnMsg = "Ok";
		try{
			//잠재고객사 입찰등록일 경우 상태값 업데이트
			sqlSessionTemplate.update("master.mdct.cancleMasterMdCtNewCustomerSetList", formData);			

		}catch(Exception e){
			rtnMsg = "입찰취소 처리중 오류가 발생 하였습니다.";
			throw new RuntimeException();
		}
		
		return rtnMsg;
	}
	// 잠재고객 계약 조회
	public List<Map<String,String>> getConList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("master.mdct.selectMasterMdCtNewCustomerConList",formData);
	}
	// 잠재고객 계약등록
	public String saveMasterMdCtNewCustomerConList(Map<String,String> formData) {
		String rtnMsg = "Ok";
		try{
			//잠재고객사 입찰등록
			LOGGER.debug("formData : {}", formData);
				if(CommonUtil.nvl(formData.get("st_data_gbn"),"").equals("reg")){
				//잠재고객사 입찰등록일 경우 상태값 업데이트
				sqlSessionTemplate.update("master.mdct.saveMasterMdCtNewCustomerBidStatus", formData);	
			}
			//잠재고객사 입찰정보 등록.
			sqlSessionTemplate.update("master.mdct.saveMasterMdCtNewCustomerConList", formData);
		}catch(Exception e){
			rtnMsg = "입찰등록 처리중 오류가 발생 하였습니다.";
			throw new RuntimeException();
		}
		
		return rtnMsg;
	}
	// 잠재고객 계약 취소
	public String cancleMasterMdCtNewCustomerConList(Map<String,String> formData) {
		String rtnMsg = "Ok";
		try{
			//잠재고객사 입찰등록일 경우 상태값 업데이트
			sqlSessionTemplate.update("master.mdct.cancleMasterMdCtNewCustomerConList", formData);			

		}catch(Exception e){
			rtnMsg = "입찰취소 처리중 오류가 발생 하였습니다.";
			throw new RuntimeException();
		}
		
		return rtnMsg;
	}
}
