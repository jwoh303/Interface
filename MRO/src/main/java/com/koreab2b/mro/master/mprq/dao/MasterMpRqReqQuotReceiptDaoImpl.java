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

@Repository("masterMpRqReqQuotReceiptDao")
@Transactional
public class MasterMpRqReqQuotReceiptDaoImpl implements MasterMpRqReqQuotReceiptDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqReqQuotReceiptDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private String _rtnMsg = "";
	
	/*리스트 조회*/
	@SuppressWarnings("unchecked")
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		List< String > _list = new ArrayList< String >( );
		_list = CommonUtil.getStringArrary((String) param.get("st_buyer_code"),"@");
		if(_list.size() > 0){
			param.put("st_buyerArr", _list);
		}
		
		String pageflag = (String) param.get("pageflag");
		ResultRowHandler _resultHander = new ResultRowHandler();
		List<Map<String, String>> resultList = null;
		if("0".equals(pageflag)){
			 sqlSessionTemplate.select("master.mprq.selectMasterMpRqReqQuotReceiptList", param, _resultHander);
			 resultList = (List<Map<String, String>>)_resultHander.getList();
		}else{
			resultList =  sqlSessionTemplate.selectList("master.mprq.selectMasterMpRqReqQuotReceiptList", param);
		}
		return resultList;
	}

	/*저장*/
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "저장했습니다.";
		
		try{
			if("Y".equals(formData.get("st_rpa_yn"))) { // RPA 사용자
				// 고객사 카탈로그 등록여부 검색 및 수정
				String rpa_reg_yn  = sqlSessionTemplate.selectOne("master.mprq.selectMasterMpRqQuotReceiptForRpa1", formData);
				
				formData.put("RPA_REG_YN", rpa_reg_yn);
				
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqReqQuotReceiptForRPA1", formData);
				
				// 최근 실적가격, 고객사코드, 품목코드 검색 및 수정(시장가격은 RPA가 다나와에서 검색해서 입력)
				Map<String,String> _result = sqlSessionTemplate.selectOne("master.mprq.selectMasterMpRqQuotReceiptForRpa2", formData);

				if(_result != null) { // 실적 없을 수 있으니 null 처리
					formData.put("RPA_BUYER", _result.get("RPA_BUYER"));
					formData.put("RPA_ITEM_NO", _result.get("RPA_ITEM_NO"));
					formData.put("RPA_HIST_PRICE", String.valueOf(_result.get("RPA_HIST_PRICE")));
					
					sqlSessionTemplate.update("master.mprq.updateMasterMpRqReqQuotReceiptForRPA2", formData);
				}
			}else{
				for(int i=0; i < gridData.size(); i++){
					formData.putAll((Map<String, String>)gridData.get(i));		
					sqlSessionTemplate.update("master.mprq.updateMasterMpRqReqQuotReceipt", formData);
					
					//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
					formData.put("DOC_NO", formData.get("IMAGE_KEY"));
					sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
				}	
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	/*품목재정비 요청*/
	@SuppressWarnings("unchecked")
	public String updateItemChgReqData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "품목정비 요청되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqItemChgReq", formData);
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqKepItemMdReq", formData);//품목정비 요청 이력 기존 데이터 삭제
				sqlSessionTemplate.update("master.mprq.insertMasterMpRqKepItemMdReq", formData);//품목정비 요청 이력 신규 등록
				
				//품목정비요청 운영특이사항 입력.
				formData.put("ADMIN_REMARK", "[품목정비요청] " + formData.get("ITEM_CHG_REQ_NOTE"));
				formData.put("st_image_key", formData.get("ITEM_CHG_REQ_IMAGE_KEY"));
				sqlSessionTemplate.update("master.mprq.insertMasterMpRqReqQuotAdminRemark", formData);
				
				sqlSessionTemplate.update("master.mprq.insertMasterMpRqKepItemMdReqKepMail", formData);//고객사 담당 운영자에게 메일 발송
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("요청 실패하였습니다.");
		}
		return _rtnMsg;
	}

	/*견적요청*/
//	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	@SuppressWarnings("unchecked")
	public String orderSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "정상적으로 협력사에게 견적요청 하였습니다.";
		List< String > _list = new ArrayList< String >( );
		List< String > _list2 = new ArrayList< String >( );
		try{
			String st_session_user_id =formData.get("USR_ID");
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				formData.put("QTDT_INS",formData.get("PICKUP_AGENT_ID"));
				_list = CommonUtil.getStringArrary((String) formData.get("PICKUP_AGENT_ID"),",");
				_list2 = CommonUtil.getStringArrary((String) formData.get("PICKUP_AGENT_DSS"),",");
				
				String _itemDupChk  = sqlSessionTemplate.selectOne("master.mprq.getQuoDupChk", formData); 
				if (!"0".equals(_itemDupChk)){
					_rtnMsg = "선택하신 품목은 이미 협력사에 견적요청 한 품목입니다.\n\n견적요청상태가 바뀌었으므로 다시 조회 후에 실행하시기 바랍니다.";
					return _rtnMsg;
				}
				
				for (int k=0; k < _list.size(); k++ ){
					formData.put("PICKUP_AGENT_ID", _list.get(k));
					LOGGER.debug("PICKUP_AGENT_DSS : {}", _list2.get(k).substring(10,11));
					formData.put("PICKUP_AGENT_DSS", _list2.get(k).substring(10,11));
					formData.put("STOA_LIST_PRICE","");
					formData.put("LEAD_TIME","");
					formData.put("SEL_USER_ID","");
					formData.put("SEL_USER_NAME","");
					formData.put("SEL_USER_TEL","");
					formData.put("SEL_TAX_TYPE","");
					formData.put("SEL_MIN_ORDER_QTY","");
					formData.put("SEL_PUR_UNIT_QTY","");
					formData.put("SEL_SELLER_AREA","");
					formData.put("SEL_SELLER_ITEM_NO","");
					formData.put("ADD_USER_ID",st_session_user_id);
					//gpl단가일경우 
					if(_list2.get(k).substring(10,11).equals("G")){
						List<Map<String,String>> agentUserInfo = null;
						agentUserInfo = sqlSessionTemplate.selectList("master.mprq.getMasterMpRqReqAgentUserInfo", formData);
						LOGGER.debug("agentUserInfo.size() : {}", agentUserInfo.size());
						Map<String,String> mp = (Map<String,String>)agentUserInfo.get(0);
						String[] str = _list2.get(k).split("@@");
						LOGGER.debug("_list2.get(k) : {}", _list2.get(k));
						LOGGER.debug("_list2.get(k) : {}", str.length);
						LOGGER.debug("str[1] : {}", str[1]);
						LOGGER.debug("str[2] : {}", str[2]);
						formData.put("STOA_LIST_PRICE", str[1]);
						formData.put("LEAD_TIME",str[2]);
						formData.put("SEL_USER_ID",CommonUtil.nvl(mp.get("USER_ID"),"G"));
						formData.put("SEL_USER_NAME",CommonUtil.nvl(mp.get("USER_NAME_LOC"),""));
						formData.put("SEL_USER_TEL",CommonUtil.nvl(mp.get("PHONE_NUMBER"),""));
						formData.put("SEL_TAX_TYPE",str[3]);
						formData.put("SEL_MIN_ORDER_QTY",str[4]);
						formData.put("SEL_PUR_UNIT_QTY",str[5]);
						formData.put("SEL_SELLER_AREA",str[6]);
						formData.put("SEL_SELLER_ITEM_NO",str[7]);
					}
					
					sqlSessionTemplate.update("master.mprq.orderMasterMpRqReqQuotReceipt_1", formData);
				}
				
				// MSDS 대상 품목은 ATOS_REMARK 에 MSDS 제출 요구 문구 추가 2026.04.30 
				String _msdsItemChk  = sqlSessionTemplate.selectOne("master.mprq.getMsdsItemChk", formData); 
				if ("Y".equals(_msdsItemChk)){
					formData.put("MSDS_REMARK", "※ 해당 품목은 MSDS 대상 제품이오니 견적 제출 시 MSDS 첨부 요청드립니다.");
				}else{
					formData.put("MSDS_REMARK", "");
				}
				
				sqlSessionTemplate.update("master.mprq.orderMasterMpRqReqQuotReceipt_2", formData);
				
				//첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경) 
				formData.put("DOC_NO", formData.get("IMAGE_KEY"));
				sqlSessionTemplate.update("common.fileUploadFlagUpdate", formData);
			}			
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 요청에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}
	
	
	/*삭제*/
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "견적을 취소 하였습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				// 견적 취소 처리
				sqlSessionTemplate.update("master.mprq.deleteMasterMpRqReqQuotReceipt_1", formData);
				LOGGER.error("deleteMasterMpRqReqQuotReceipt_1 실행 완료");
				
				// 물질정보제출 취소 처리
				formData.put("st_cancel_note", "견적취소");
				sqlSessionTemplate.update("master.mprq.deleteMasterMpRqReqQuotReceipt_3", formData);
				LOGGER.error("deleteMasterMpRqReqQuotReceipt_3 실행 완료");
				
				/* 견적 취소 메일 전송 (고객사 특수로직 관리) */
				boolean qt_cancel_mail_flag = CommonUtil.getSpecialCheckReturn(formData.get("BUYER"),"P04-4056-01");
				
				if(qt_cancel_mail_flag == true){
					sqlSessionTemplate.update("master.mprq.insertMasterMpRqQtCancelMail", formData); //Mail Send
				}
				
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

	/*전략소싱팀 추가라운드*/
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String updateSoMasterMpRqReqNegoReceipt(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "저장 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				sqlSessionTemplate.update("master.mprq.updateSoMasterMpRqReqNegoReceipt", formData);
				LOGGER.error("updateSoMasterMpRqReqNegoReceipt 실행 완료");

			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}
	/*표준카탈로그매핑*/
	public String saveMasterMpRqStndCatalgListPop(Map<String,String>  formData){
		
		try{
				if(CommonUtil.nvl(formData.get("st_catalg_yn"),"N").equals("Y")){
					sqlSessionTemplate.update("master.mprq.updateMasterMdCmStndCatalg", formData);
				}else{
					sqlSessionTemplate.update("master.mprq.updateMasterMpRqStndCatalg", formData);
				}
		          
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("표준카탈로그 매핑 실패하였습니다.");
		}
		return null;
		 
	}
	// MSDS 정보 조회
	public List<Map<String,String>> getMsdsInfo(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("master.mprq.selectMsdsInfo", formData);
	}
	/*견적이관*/
	@SuppressWarnings("unchecked")
	public String updateMasterMpRqReqQuotTrans(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "견적이관 처리 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				//견적이관 저장
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqReqQuotTrans", formData);
				
				if("N".equals(formData.get("st_smart_dept_yn"))) { // SMART팀은 문자 발송 X
					//견적이관시 이관 대상자에게 SMS 서비스
					sqlSessionTemplate.update("master.mprq.insertArreoSmsQuotTrans", formData);	
				}
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("견적이관에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	//고객사 납품가능지역 저장
	@SuppressWarnings("unchecked")
	public String saveMasterMpRqDelyArea(Map<String,String>  formData) {
		_rtnMsg = "OK";
		try {
			sqlSessionTemplate.update("master.mprq.updateMasterMpRqDelyArea", formData);
		} catch (Exception e) {
			_rtnMsg = "Err";
			throw new RuntimeException("에러가 발생하였습니다.");
		}
		return _rtnMsg;
	}
	/*SG 지정*/
	@SuppressWarnings("unchecked")
	public String updateMasterMpRqSGInfo(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "처리 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqSGInfo", formData);
				sqlSessionTemplate.update("master.mprq.insertMasterMpRqSgDHist", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("처리 실패하였습니다.");
		}
		return _rtnMsg;
	}
	/*SG 지정취소*/
	@SuppressWarnings("unchecked")
	public String updateMasterMpRqSGCancle(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "처리 되었습니다..";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqSGCancle", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("처리 실패하였습니다.");
		}
		return _rtnMsg;
	}
	/*품목정비 제출*/
	@SuppressWarnings("unchecked")
	public String updateMasterMpRqItmCheSend(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "품목정비 제출되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				//KEPRQDT 품목정비 제출자 업데이트
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqItmCheSend", formData);
				//KEP_ITEM_MD_REQ 품목정비 제출자 이력 업데이트
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqItmMdSend", formData);
				//품목정비제출 운영특이사항 입력.
				formData.put("st_image_key", "");
				sqlSessionTemplate.update("master.mprq.insertMasterMpRqReqQuotAdminRemark", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("처리 실패하였습니다.");
		}
		return _rtnMsg;
	}
	/* 견적특이사항 메일 발송 */
	@SuppressWarnings("unchecked")
	public String insertAddNoteSendMail(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "메일 발송되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				sqlSessionTemplate.update("master.mprq.insertMasterMpRqAddNoteSendMail", formData);//고객사 담당 운영자에게 메일 발송
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("발송 실패하였습니다.");
		}
		return _rtnMsg;
	}
	/*운영비고 일괄 입력*/
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String saveMasterMpRqReqQuotAdminRemark(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "운영 특이사항 입력 완료 했습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				formData.put("st_image_key", "");
				sqlSessionTemplate.update("master.mprq.insertMasterMpRqReqQuotAdminRemark", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장 실패하였습니다.");
		}
		return _rtnMsg;		
		
	}
	/*SG지정 재요청 사유*/
	@SuppressWarnings("unchecked")
	public String updateMasterMpRqSgDReq(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "SG지정 재요청 되었습니다.";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				//KEPRQDT SG지정 정보 초기화
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqSgDInit", formData);
				//KEP_SG_D_REQ SG지정 재요청 이력 업데이트
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqSgDReq", formData);
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("처리 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	/*DB클린징 등록 상품이미지 복사*/
	@SuppressWarnings("unchecked")
	public String updateMasterMpRqDbCleansingImageCopy(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "선택하신 행의 상품이미지가 복사되었습니다.";
		
		try{
			String imgfile_name = "";
			String imgfile_dir = "";
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));		
				
				if(i==0) {
					imgfile_name = formData.get("IMGFILE_NAME");
					imgfile_dir = formData.get("IMGFILE_DIR");
				}
				
				formData.put("IMGFILE_NAME", imgfile_name);
				formData.put("IMGFILE_DIR", imgfile_dir);
				
				//KEPRQDT 이미지파일, 이미지경로 복사
				sqlSessionTemplate.update("master.mprq.updateMasterMpRqDbCleansingImageCopy", formData);
			}
			
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("처리 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	/*DB클린징(이미지포함) 복사*/
	@SuppressWarnings("unchecked")
	public String updateMasterMpRqDbCleansingCopy(Map<String,String>  formData, List<Object> gridData) {
		_rtnMsg = "선택하신 행의 DB클랜징 정보가 복사되었습니다.";
		
		try{
			Map<String,String> _result = null;
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				if(i==0) {
					_result = sqlSessionTemplate.selectOne("master.mprq.selectMasterMpRqDbCleansingCopy", formData);
				}else {
					if(_result != null) { // 결과 없을 수 있으니 null 확인
						formData.put("DESCRIPTION", CommonUtil.nvl(_result.get("DESCRIPTION")));
						formData.put("SPECIFICATION", CommonUtil.nvl(_result.get("SPECIFICATION")));
						formData.put("UNIT_MEASURE", CommonUtil.nvl(_result.get("UNIT_MEASURE")));
						formData.put("MAKER_CODE", CommonUtil.nvl(_result.get("MAKER_CODE")));
						formData.put("MAKER_NAME", CommonUtil.nvl(_result.get("MAKER_NAME")));
						formData.put("ORIGIN_CODE", CommonUtil.nvl(_result.get("ORIGIN_CODE")));
						formData.put("ORIGIN_NAME", CommonUtil.nvl(_result.get("ORIGIN_NAME")));
						formData.put("CMS_CATEG_ID", CommonUtil.nvl(_result.get("CMS_CATEG_ID")));
						formData.put("ITEM_DETAIL_DESC", CommonUtil.nvl(_result.get("ITEM_DETAIL_DESC")));
						formData.put("DESCRIPTION_ENG", CommonUtil.nvl(_result.get("DESCRIPTION_ENG")));
						formData.put("SPECIFICATION_ENG", CommonUtil.nvl(_result.get("SPECIFICATION_ENG")));
						formData.put("IMGFILE_DIR", CommonUtil.nvl(_result.get("IMGFILE_DIR")));
						formData.put("IMGFILE_NAME", CommonUtil.nvl(_result.get("IMGFILE_NAME")));
						formData.put("ATTB1_NM", CommonUtil.nvl(_result.get("ATTB1_NM")));
						formData.put("ATTB2_NM", CommonUtil.nvl(_result.get("ATTB2_NM")));
						formData.put("ATTB3_NM", CommonUtil.nvl(_result.get("ATTB3_NM")));
						formData.put("ATTB4_NM", CommonUtil.nvl(_result.get("ATTB4_NM")));
						formData.put("ATTB5_NM", CommonUtil.nvl(_result.get("ATTB5_NM")));
						formData.put("ATTB6_NM", CommonUtil.nvl(_result.get("ATTB6_NM")));
						formData.put("ATTB7_NM", CommonUtil.nvl(_result.get("ATTB7_NM")));
						formData.put("ATTB8_NM", CommonUtil.nvl(_result.get("ATTB8_NM")));
						formData.put("ATTB9_NM", CommonUtil.nvl(_result.get("ATTB9_NM")));
						formData.put("ATTB10_NM", CommonUtil.nvl(_result.get("ATTB10_NM")));
						formData.put("ATTB11_NM", CommonUtil.nvl(_result.get("ATTB11_NM")));
						formData.put("ATTB12_NM", CommonUtil.nvl(_result.get("ATTB12_NM")));
						formData.put("ATTB13_NM", CommonUtil.nvl(_result.get("ATTB13_NM")));
						formData.put("ATTB14_NM", CommonUtil.nvl(_result.get("ATTB14_NM")));
						formData.put("ATTB15_NM", CommonUtil.nvl(_result.get("ATTB15_NM")));
						formData.put("ATTB16_NM", CommonUtil.nvl(_result.get("ATTB16_NM")));
						formData.put("ATTB17_NM", CommonUtil.nvl(_result.get("ATTB17_NM")));
						formData.put("ATTB18_NM", CommonUtil.nvl(_result.get("ATTB18_NM")));
						formData.put("ATTB19_NM", CommonUtil.nvl(_result.get("ATTB19_NM")));
						formData.put("ATTB20_NM", CommonUtil.nvl(_result.get("ATTB20_NM")));
						formData.put("SG_ID", CommonUtil.nvl(_result.get("SG_ID")));
						formData.put("MAKER_PART_NO", CommonUtil.nvl(_result.get("MAKER_PART_NO ")));
						sqlSessionTemplate.update("master.mprq.updateMasterMpRqDbCleansingCopy", formData);
					}
				}
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("처리 실패하였습니다.");
		}
		return _rtnMsg;
	}
}
