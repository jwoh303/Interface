package com.koreab2b.mro.master.mprq.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.ResultRowHandler;

@Repository("masterMpRqReqNegoReceiptDao")
@Transactional
public class MasterMpRqReqNegoReceiptDaoImpl implements MasterMpRqReqNegoReceiptDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqReqNegoReceiptDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	/*리스트 조회*/
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List< String > list = new ArrayList< String >( );
		list = CommonUtil.getStringArrary((String) param.get("st_buyer_code"),"@");
		if(list.size() > 0){
			param.put("st_buyerArr", list);
		}
		
		String pageflag = (String) param.get("pageflag");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			 sqlSessionTemplate.select("master.mprq.selectMasterMpRqReqNegoReceiptList", param, _resultHander);
			 resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqReqNegoReceiptList", param);
		}
		return resultList;
		
	}

	/*추가라운드*/
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "정상적으로 추가라운드 요청되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				/*STEP1 */
				int rqdt_flag = sqlSessionTemplate.update("master.mprq.updateRqdtRevision", formData);
				
				if (rqdt_flag != 1){
					_rtnMsg = "추가라운드 요청중 오류가 발생되었습니다.";
					throw new RuntimeException(_rtnMsg);
				}
				
				Map<String,String> _result = sqlSessionTemplate.selectOne("master.mprq.getMaxAgentRevision", formData);
				if (String.valueOf(_result.get("AGENT_REVISION")).equals("0")){
					_rtnMsg = "추가라운드 요청중 오류가 발생되었습니다.";
					throw new RuntimeException(_rtnMsg);
				}
				
				formData.put("PRE_AGENT_REVISION", String.valueOf(_result.get("PRE_AGENT_REVISION")));
				formData.put("AGENT_REVISION", String.valueOf(_result.get("AGENT_REVISION")));
				
				String AGENT_LIST = formData.get("AGENT_LIST");
				String AGENT[] = AGENT_LIST.split("__N@@");
				for (int k=0; k<AGENT.length;k++){
					formData.put("AGENT", AGENT[k]);
					if (k == 0){
						int qtdtChkFlag = sqlSessionTemplate.update("master.mprq.updateQtdtChkFlag", formData);
						if (qtdtChkFlag < 0){
							_rtnMsg = "추가라운드 요청중 오류가 발생되었습니다.";
							throw new RuntimeException(_rtnMsg);
						}
					}					
					/*
					 * if (formData.get("DSS_CHOICE").indexOf("A,B,C,S,Y") > -1 ){
					 * formData.put("DSS_FLAG", "Y");
					 * } else {
					 * formData.put("DSS_FLAG", "N"); 
					 * }
					 */
					
					sqlSessionTemplate.update("master.mprq.insertQtdtRound", formData);
				}
				
				sqlSessionTemplate.update("master.mprq.updateRqdtRoundRemark", formData);

				// 물질정보제출 취소 처리
				formData.put("st_cancel_note", "추가라운드");
				formData.put("USR_ID", formData.get("KEP_USER_ID"));
				sqlSessionTemplate.update("master.mprq.deleteMasterMpRqReqQuotReceipt_3", formData);
			}
			
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("추가 라운드 요청에 실패하였습니다.");
		}
		return _rtnMsg;
	}

	/*고객사 Nego견적제출*/
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String negoSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "고객사 Nego견적제출 하였습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				String buyer = formData.get("BUYER");
				int atob_unit_price = Integer.valueOf(CommonUtil.snvl(formData.get("ATOB_UNIT_PRICE")));
				int stoa_list_price = Integer.valueOf(CommonUtil.snvl(formData.get("STOA_LIST_PRICE")));
				int item_qty = Integer.valueOf(CommonUtil.snvl(formData.get("ITEM_QTY")));
				int buyer_rate =  Integer.valueOf(CommonUtil.snvl(formData.get("BUYER_RATE")));
				String pm_flag = formData.get("PM_FLAG");
				
				int remain_value	= atob_unit_price - stoa_list_price;

				int calc_rate = (1 - stoa_list_price / atob_unit_price)*100; 
				int result_rate = buyer_rate - calc_rate ;
				String usr_id = formData.get("USR_ID");
				
				String pm_query = "";
				
//				int max_seq = 0;
				
				if(buyer.equals("KRDOOD0001")) {

					if(remain_value<=0  || result_rate > 0  ) {
						formData.put("BUYER_RATE_FLAG", "Y");
						formData.put("DOOS_PM_FLAG", "PM");

					}else {
						if(result_rate >0 ){ 
							formData.put("BUYER_RATE_FLAG", "Y");
						}else{ 
							formData.put("BUYER_RATE_FLAG", "N");
						}
						formData.put("DOOS_PM_FLAG", pm_flag);
					}
				}else {

					int quotation_sum = item_qty*stoa_list_price;
					if(quotation_sum>=500000 || remain_value<=0 || result_rate > 0) {
						formData.put("PM_FLAG", "PM");
					}else{
						formData.put("PM_FLAG", "NO");
					}
					if(result_rate >0 ){ 
						formData.put("BUYER_RATE_FLAG", "Y");
					}else{ 
						formData.put("BUYER_RATE_FLAG", "N");
					}
				}
				
				String seq  = sqlSessionTemplate.selectOne("master.mprq.getMaxAgentRevision_2", formData);
				formData.put("SEQ", seq);

				
				if("NO".equals(formData.get("PM_FLAG"))){
					LOGGER.debug("SQL Start!! IF");
					sqlSessionTemplate.update("master.mprq.negoMasterMpRqReqNegoReceipt_pstmt", formData);
					LOGGER.debug("negoMasterMpRqReqNegoReceipt_pstmt Passed");
					sqlSessionTemplate.update("master.mprq.negoMasterMpRqReqNegoReceipt_pstmt3", formData);
					LOGGER.debug("negoMasterMpRqReqNegoReceipt_pstmt3 Passed");
					sqlSessionTemplate.update("master.mprq.negoMasterMpRqReqNegoReceipt_pstmt1", formData);
					LOGGER.debug("negoMasterMpRqReqNegoReceipt_pstmt1 Passed");
					sqlSessionTemplate.update("master.mprq.negoMasterMpRqReqNegoReceipt_pstmt2", formData);
					LOGGER.debug("negoMasterMpRqReqNegoReceipt_pstmt2 Passed");
				}else{
					LOGGER.debug("SQL Start!! ELSE");
					sqlSessionTemplate.update("master.mprq.negoMasterMpRqReqNegoReceipt_pstmt3", formData);
					LOGGER.debug("negoMasterMpRqReqNegoReceipt_pstmt3 Passed");
					if("Y".equals(formData.get("BUYER_RATE_FLAG"))){
						formData.put("STATUS", "C");
					}else{
						formData.put("STATUS", "R");	 
					} 
					sqlSessionTemplate.update("master.mprq.negoMasterMpRqReqNegoReceipt_pstmt4", formData);
					LOGGER.debug("negoMasterMpRqReqNegoReceipt_pstmt4 Passed");
					sqlSessionTemplate.update("master.mprq.negoMasterMpRqReqNegoReceipt_pstmt5", formData);
					LOGGER.debug("negoMasterMpRqReqNegoReceipt_pstmt5 Passed");

					/*pm_query=formData.get("BYCA_COMORG_CODE")+"@@";
					pm_query+=formData.get("REG_ITEM_NO")+"@@";
					pm_query+=formData.get("AGENT_CODE")+"@@";
					pm_query+=formData.get("CONTRACT_NO")+"@@";
					pm_query+=formData.get("CONTRACT_SEQ")+"@@";
					pm_query+=formData.get("BUYER")+"@@";
					pm_query+=formData.get("QUOTATION_NO")+"@@";
					pm_query+=formData.get("QUOTATION_SEQ")+"@@";
					pm_query+=formData.get("REVISION") ;
					pm_query+= "^||^";*/
					
//					(pm_query, formData., max_seq, "SO");
					
					String result = setSysopIcomTrxlUploadReg1(pm_query, formData, usr_id, "SO");
					if(!"OK".equals(result)){
						throw new RuntimeException("고객사 Nego견적제출에 실패하였습니다.");
					}
				}
			}			
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("고객사 Nego견적제출에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}

	
	public String setSysopIcomTrxlUploadReg1( String query, Map<String,String> data, String reg_user_id, String trxl_gubun ){

	    String result = null;
//		String quotation_query = "";
//	    String  XPROQUERY[] =    query.split("^||^");

//        for(int i = 0; i<XPROQUERY.length; i++){
			/*
			pm[0]==KRKEPBG001
			pm[1]==NO_CODE11
			pm[2]==KRKEPS0001
			pm[3]==PC01000001
			pm[4]==000176
			pm[5]==KRKEPB0004
			pm[6]==RE07000018
			pm[7]==000001
			pm[8]==1
			*/

//        	String  str[] =    XPROQUERY[i].split("@@");
//	        	
//			quotation_query = String.valueOf(str[5])+String.valueOf(str[6])+String.valueOf(str[7])+String.valueOf(str[8]);


/*			data.put("BYCA_COMORG_CODE",   String.valueOf(str[0]));  // BYCA_COMORG_CODE
			data.put("BUYER_ITEM_NO",  String.valueOf(str[1]));  // BUYER_ITEM_NO
			data.put("AGENT_CODE",  String.valueOf(str[2]));  // AGENT_CODE
			data.put("CONTRACT_NO",  String.valueOf(str[3]));  // CONTRACT_NO
			data.put("CONTRACT_SEQ", String.valueOf(str[4]));  // CONTRACT_SEQ
//			data.put("CONTRACT_SEQ",  seq);  // BUYER
			data.put("ST_BUYER", String.valueOf(str[5]));  // ST_BUYER
			data.put("REG_USER_ID",  reg_user_id);             // reg_user_id
*/
			data.put("TRXL_GUBUN",  trxl_gubun);              // trxl_gubun
//			data.put("TRXL_IDX",    String.valueOf((i+1)));              // TRXL_SEQ
			data.put("TRXL_SEQ",   data.get("BUYER")+data.get("QUOTATION_NO")+data.get("QUOTATION_SEQ")+data.get("REVISION"));              // TRXL_SEQ

			sqlSessionTemplate.update("master.mprq.setSysopIcomTrxlUploadReg1", data);
			LOGGER.debug("setSysopIcomTrxlUploadReg1 Passed");
//		}
        result = "OK";
        		
		return result;

	}
	
	/*삭제(견적 취소)*/
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "견적을 취소 하였습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.mprq.deleteMasterMpRqReqNegoReceipt_1", formData);
				LOGGER.error("deleteMasterMpRqReqNegoReceipt_1 실행 완료");

				/*프로시저 실행*/
				sqlSessionTemplate.selectList("master.mprq.procQtItemCatalogDelete", formData);
				LOGGER.error("procQtItemCatalogDelete 실행 완료");
				
				if(!"SUCCESS".equals(formData.get("RESULT"))){
					_rtnMsg = "프로시저[PROC_QT_ITEM_CATALOG_DELETE]가 실행되지 못했습니다..";
					throw new RuntimeException(_rtnMsg);
//					return _rtnMsg;
				}
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 요청에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	
	
	// 네고정비 요청
	@SuppressWarnings("unchecked")
	public String updateNegoItemChgReqData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "요청되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqKepNegoItemMdReq", formData);//네고정비 요청 이력 기존 데이터 삭제
				sqlSessionTemplate.update("master.mprq.insertMasterMpRqKepNegoItemMdReq", formData);//네고정비 요청 이력 신규 등록
				
				//네고정비요청 운영특이사항 입력.
				formData.put("ADMIN_REMARK", "[네고정비요청] " + formData.get("NEGO_ITEM_CHG_REQ_NOTE"));
				formData.put("st_image_key", formData.get("NEGO_ITEM_CHG_REQ_IMAGE_KEY"));
				sqlSessionTemplate.update("master.mprq.insertMasterMpRqReqQuotAdminRemark", formData);
				
				sqlSessionTemplate.update("master.mprq.insertMasterMpRqKepNegoItemMdReqKepMail", formData);//고객사 담당 운영자에게 메일 발송
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("요청 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 네고정비 제출
	@SuppressWarnings("unchecked")
	public String updateMasterMpRqNegoItmCheSend(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "처리 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				//KEP_NEGO_ITEM_MD_REQ 네고정비 제출자 이력 업데이트
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqNegoItmMdSend1", formData);
				// KEPRQDT 삭제예정일 초기화
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqNegoItmMdSend2", formData);
				//네고제출 운영특이사항 입력.
				formData.put("st_image_key", "");
				sqlSessionTemplate.update("master.mprq.insertMasterMpRqReqQuotAdminRemark", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("처리 실패하였습니다.");
		}
		return _rtnMsg;
	}
}
