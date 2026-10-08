package com.koreab2b.mro.seller.mprq.dao;

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

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("sellerMpRqBulkQuotationReqDao")
@Transactional
public class SellerMpRqBulkQuotationReqDaoImpl implements SellerMpRqBulkQuotationReqDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMpRqBulkQuotationReqDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
 
	// 프로젝트 조회 (팝업)
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectProjectList(Map<String,String> param) {
		 // 조회될 견적 건 중 견적 마감 상태로 변경되어야 할 것들 먼저 변경
		 sqlSessionTemplate.update("seller.mprq.updateSelRfq", param);
		  
		 // 조회될 수 있는 프로젝트 중 견적 마감 상태로 변경되어야 할 것들 먼저 변경
		 sqlSessionTemplate.update("seller.mprq.updateSellerSelProject", param);
		  
		 return  sqlSessionTemplate.selectList("seller.mprq.selectSellerSelProject", param);
	}
	
	/*조회*/
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,String>  param) {
		Map<String, Object> param2 = new HashMap<String, Object>();

		param2.putAll(param);
		
		String str = (String) param.get("st_burq_rfq_no");
		
		String[] str_arr = str.split(",");
		
		List<String> burq_rfq_no_list = new ArrayList<String>();
		for(int i = 0; i < str_arr.length; i++) {
			burq_rfq_no_list.add(str_arr[i]);
		}
		logger.debug("selectProjectList burq_rfq_no_list : {} ", burq_rfq_no_list);
		param2.put("st_burq_rfq_no_all", burq_rfq_no_list);
		
		logger.debug("selectProjectList param : {} ", param2);
		
		// 조회될 견적 건 중 견적 마감 상태로 변경되어야 할 것들 먼저 변경
		 sqlSessionTemplate.update("seller.mprq.updateSelRfq", param);
		  
		 // 조회될 수 있는 프로젝트 중 견적 마감 상태로 변경되어야 할 것들 먼저 변경
		 sqlSessionTemplate.update("seller.mprq.updateSellerSelProject", param);
		
		return  sqlSessionTemplate.selectList("seller.mprq.selectSellerMpRqBulkQuotationReq", param2);
	}
	
	// 프로젝트 유의사항 조회
	@Override
	public List<Map<String, String>> selectPrjRemarkList(Map<String, String> param) {
		return sqlSessionTemplate.selectList("seller.mprq.selectProjectRemark", param);
	}

	// 견적포기
	@Override
	public String updateGiveupData(Map<String, String> param) {

		String _rtnMsg = "저장 중 에러가 발생하였습니다.";
		
		try{
			
			String query_str = CommonUtil.nvl(param.get("st_burq_rfq_no_list"),"");
			String str[] = query_str.split("@@");
			
			for(int i=0 ; i < str.length; i++){
				
				param.put("st_burq_rfq_no",str[i]);
				
				sqlSessionTemplate.update("seller.mprq.giveUpSellerMpRqBulkQuotationReq", param);
			}
				
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
	}

	// 견적 제출
	@Override
	public String saveData(Map<String, String> formData, List<Object> gridData) {
		
		String _rtnMsg = "저장완료 되었습니다.";
		
		try{
			for(int i = 0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				logger.debug("updateSellerMpRqBulkQuotationReq param : {} ", formData);
				
				sqlSessionTemplate.update("seller.mprq.updateSellerBulkQuotationSubmit", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("실패하였습니다.");
		}
		return _rtnMsg; 
	}

	
	// 임시저장
	@Override
	public String updateTempData(Map<String, String> formData, List<Object> gridData) {
		String _rtnMsg = "저장완료 되었습니다.";
		
		try{
			for(int i = 0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				logger.debug("updateSellerMpRqBulkQuotationReqTemp param : {} ", formData);
				
				sqlSessionTemplate.update("seller.mprq.updateSellerBulkQuotationTemp", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("실패하였습니다.");
		}
		return _rtnMsg; 
	}

	// 견적제출취소
	@Override
	public String updateCancelSubmit(Map<String, String> param) {
		String _rtnMsg = "저장 중 에러가 발생하였습니다.";
		
		try{
			
			String query_str = CommonUtil.nvl(param.get("st_query"),"");
			String str[] = query_str.split("@@");
			
			for(int i=0 ; i < str.length; i++){
				param.put("st_burq_rfq_no",str[i]);
				
				logger.debug("updateSellerMpRqBulkQuotationReqCancelSubmit param : {} ", param);
				
				sqlSessionTemplate.update("seller.mprq.updateSellerBulkQuotationSubmitCancle", param);
			}
				
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
	}
	
	// 동일단가 제출
	@Override
	public String updateSamePrice(Map<String, String> formData, List<Object> gridData) {
		String _rtnMsg = "저장완료 되었습니다.";
		
		try{
			for(int i = 0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				logger.debug("updateSellerMpRqBulkQuotationReqSamePrice saveData param : {} ", formData);
				
				sqlSessionTemplate.update("seller.mprq.updateSellerBulkQuotationSamePrice", formData);
			}
			
		} catch (Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("실패하였습니다.");
		}
		return _rtnMsg; 
	}

	// 물류 수수료율
	@Override
	public String selectLogisFee(Map<String, String> formData) {
		return sqlSessionTemplate.selectOne("seller.mprq.selectSellerLogisFee", formData);
	}

}
