package com.koreab2b.mro.common.mpiv.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderInfoDao;
import com.koreab2b.mro.util.CommonUtil;

@Repository("sellerMpIvObtnodrReceiptDetailPopDao")
@Transactional
public class SellerMpIvObtnodrReceiptDetailPopDaoImpl implements SellerMpIvObtnodrReceiptDetailPopDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvObtnodrReceiptDetailPopDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Autowired
	private BuyerMpSoOrderInfoDao buyerMpSoOrderInfoDao;

	// 수주접수 상세정보 조회
	public List<Map<String, String>> getDetailInfo(Map<String,String> formData) {
		
		return sqlSessionTemplate.selectList("common.mpiv.selectSellerMpIvObtnodrReceiptDetailPopInfo", formData);
		
	}
	// 수주접수 상세 리스트 조회
	public List<Map<String,String>> getDetailList(Map<String,String> formData){
			
		return sqlSessionTemplate.selectList("common.mpiv.selectSellerMpIvObtnodrReceiptDetailPopList", formData);
			
	}
	// 수주접수 상세 리스트 조회
	public List<Map<String,String>> getDetailList_v2(Map<String,Object> formData){
		List<String> list = CommonUtil.getStringArrary((String)formData.get("st_po_no"), ",");
		if(list.size() != 0){
			formData.put("st_po_no", list);
		}
		
		return sqlSessionTemplate.selectList("common.mpiv.selectSellerMpIvObtnodrReceiptDetailPopList_v2", formData);
		
	}
	
	// 발주서인쇄정보 조회
	public List<Map<String, String>> getOrderRecvHeader(Map<String,String> formData) {
		
		return sqlSessionTemplate.selectList("common.mpiv.selectSellerMpIvObtnodrReceiptOrderRectHeader", formData);
		
	}
	
	// 특수로직 (발주서인쇄, 분할납품제한 고객사) 조회
	public List<Map<String, String>> getSpecialLogicInfo(Map<String,String> formData) {
		
		return sqlSessionTemplate.selectList("common.mpiv.selectSpecialLogicInfo", formData);
		
	}
	
	
	// 수주접수 저장
	@SuppressWarnings("unchecked")
	public String saveSellerMpIvObtnodrReceiptDetailPop(Map<String,String> formData, List<Object> gridData) {
		String _rtnMsg = "";
		List<Map<String,String>>_list = null;
		List<Map<String,String>>_list2 = null;
		
		try{
			formData.putAll((Map<String, String>)gridData.get(0));	
			
			_list = sqlSessionTemplate.selectList("common.mpiv.getSellerMpivObtnodrReceiptOrderCheck",formData);
			
			String check_flag = CommonUtil.getListKeyValue(_list,"DUP_CNT","0");
			String credit_limit_flag = CommonUtil.getListKeyValue(_list2,"CREDIT_LIMIT_FLAG","");
			if(check_flag.equals("0")){

				String admin_flag1 = "Y"; // 현재 미사용. 아무값이나 들어가도 됨 2023.11.08 HSJ
				String st_buyer_po = "";
				
				for(int i=0; i < gridData.size(); i++){
					
					String delay_flag = "N"; // 납품예정일 지연 여부
					String long_ds_flag = "N"; // 장납기 여부
					String issue_ex_flag = "N"; // 이슈 등록 예외 여부
					
					formData.putAll((Map<String, String>)gridData.get(i));
					//여신한도 초과시 수주접수 불가능.
					_list2 = sqlSessionTemplate.selectList("common.mpiv.getSellerMpivCreditLimitSttsCheck",formData);
					if(credit_limit_flag.equals("Y")){
						_rtnMsg = "수주접수가 불가능한 상태입니다. \n"+CommonUtil.getListKeyValue(_list2,"USER_NAME_LOC","")+" ("
								+CommonUtil.getListKeyValue(_list2,"PHONE_NUMBER","")+")"+ "담당자에게 문의바랍니다.";
						throw new RuntimeException(_rtnMsg);
					}
					
					formData.put("st_ds_yn", CommonUtil.nvl(formData.get("st_ds_yn"),"N"));
					formData.put("admin_flag1", admin_flag1);
					
					sqlSessionTemplate.insert("common.mpiv.insertSellerMpivObtnodrReceiptOrder", formData);
					
					sqlSessionTemplate.update("common.mpiv.updateSellerMpivObtnodrProductInfo",formData);
					
					if("Y".equals(formData.get("st_ds_yn"))) {
						sqlSessionTemplate.update("common.mpiv.updateSellerMpivObtnodrMasterInfo",formData);
					}
					
					// 이슈 등록 예외 확인
					formData.put("PMNGTYPE", "F");
					issue_ex_flag = sqlSessionTemplate.selectOne("common.mpiv.selectSellerMpivObtnodrIssueRegExceptChk",  formData);
					if("N".equals(issue_ex_flag)) {
						// 납품예정일 지연 이슈 등록
						// PODT.ST_DATE vs PORS.SD_DATE 차이 구하기
						int st_date_diff = (Integer) sqlSessionTemplate.selectOne("common.mpiv.selectSellerMpivObtnodrDelayChk",  formData);
						if(st_date_diff > 0) {
							delay_flag = "Y";
						} else {
							delay_flag = "N";
						}
						
						// PODT.RD_DATE vs PORS.SD_DATE 차이 구하기
						int rd_date_diff = (Integer) sqlSessionTemplate.selectOne("common.mpiv.selectSellerMpivObtnodrRdDateChk",  formData);
						if(rd_date_diff > 0) {
							// 아무 액션 안함
						} else {
							delay_flag = "N";
						}
						
						if( "Y".equals(delay_flag) && !"Y".equals(formData.get("st_ds_yn")) ) { // 고객사 요청 분할납품(DS_YN=Y) 제외, 표준납기일 vs 납품예정일, 요구납기일 vs 납품예정일
							sqlSessionTemplate.insert("common.mpiv.insertSellerMpivObtnodrReceiptDelay", formData);
						}
					}
					
					// 이슈 등록 예외 확인
					formData.put("PMNGTYPE", "H");
					issue_ex_flag = sqlSessionTemplate.selectOne("common.mpiv.selectSellerMpivObtnodrIssueRegExceptChk",  formData);
					if("N".equals(issue_ex_flag)) {
						// 장납기 이슈 등록
						// 납품예정일이 발주생성일보다 30일이 넘으면 장납기 이슈로 등록(재확인일은 10 영업일 후로 세팅), 고객사 요청 분할납품(DS_YN=Y) 는 장납기에서 제외  
						int long_delay_diff_days = (Integer) sqlSessionTemplate.selectOne("common.mpiv.selectSellerMpivObtnodrLongDelayChk",  formData);
						if(long_delay_diff_days > 30 && !"Y".equals(formData.get("st_ds_yn"))) {
							long_ds_flag = "Y";
						} else {
							long_ds_flag = "N";
						}
						
						if( "Y".equals( long_ds_flag ) ) { // 장납기 FLAG = Y 이면 장납기 등록
							sqlSessionTemplate.insert("common.mpiv.insertSellerMpivObtnodrReceiptLongDelay", formData);	
						}
					}
	
					if(!st_buyer_po.equals(formData.get("st_buyer")+formData.get("st_po_no"))){
						st_buyer_po = formData.get("st_buyer")+formData.get("st_po_no");
						// ICOMPOHD 발주마스터정보 update
						sqlSessionTemplate.update("common.mpiv.updateSellerMpivObtnodrMasterInfo",formData);
						
						Map<String,String> _pMap2 = new HashMap<String,String>();
						
						_pMap2.put("BUYER",formData.get("st_buyer"));
						_pMap2.put("PO_NO", formData.get("st_po_no"));
						_pMap2.put("CODE", "PO_RECV_SB");
						_pMap2.put("USER_ID",formData.get("st_user_id"));		

						buyerMpSoOrderInfoDao.call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO(_pMap2); // 메일 발송 패키지
					}
					
				}
			} else {
				_rtnMsg = "이미 수주 접수가 완료된 발주건 입니다.";
				throw new RuntimeException(_rtnMsg);
			}	
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
		
	}
	
	//물질정보등록 
	@SuppressWarnings("unchecked") 
	public String saveSellerMpIvChemicalInfo(Map<String,String> formData, List<Object> gridData){
		String po_no = "";
		String buyer = "";
		String _rtnMsg = "";
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				if(!po_no.equals(formData.get("st_po_no")) || !buyer.equals(formData.get("st_buyer"))){ //buyer명이 다르거나,po_no가 다를때만 호출
					buyer = formData.get("st_buyer");
					po_no=formData.get("st_po_no");
					sqlSessionTemplate.insert("common.mpiv.insertSellerMpIvChemicalInfo", formData);
				}
			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
	}
	
	// 수주거부
	@SuppressWarnings("unchecked")
	public String saveSellerMpIvObtnodrReceiptDetailRejectPop(Map<String,String> formData, List<Object> gridData) {
		String _rtnMsg = "";
		List<Map<String,String>>_list = null;
		
		try{
			formData.putAll((Map<String, String>)gridData.get(0));
			
			_list = sqlSessionTemplate.selectList("common.mpiv.getSellerMpivObtnodrReceiptOrderCheck",formData);
			
			String check_flag = CommonUtil.getListKeyValue(_list,"DUP_CNT","0");
			if(check_flag.equals("0")){
				for(int i=0; i < gridData.size(); i++){
					formData.putAll((Map<String, String>)gridData.get(i));
					
					logger.debug("요청 파라미터 formData : {}", formData);
					
					if( !"".equals( CommonUtil.nvl(formData.get("st_reject_reason")) ) ) {
						sqlSessionTemplate.insert("common.mpiv.insertSellerMpivObtnodrReceiptReject", formData);	
					}
				}
			} else {
				_rtnMsg = "이미 수주 접수가 완료된 발주건 입니다.";
				throw new RuntimeException(_rtnMsg);
			}
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
	}
}
