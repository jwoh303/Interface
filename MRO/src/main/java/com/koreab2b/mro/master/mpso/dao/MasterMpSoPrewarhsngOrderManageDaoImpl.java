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

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderInfoDao;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.MailSmsUtil;

@Repository("masterMpSoPrewarhsngOrderManageDao")
@Transactional
public class MasterMpSoPrewarhsngOrderManageDaoImpl implements MasterMpSoPrewarhsngOrderManageDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoPrewarhsngOrderManageDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Autowired
	private BuyerMpSoOrderInfoDao buyerMpSoOrderInfoDao;
	
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		param.put("arry_buyer_code", CommonUtil.StrToArray(CommonUtil.nvl((String) param.get("st_buyer_code"), ""), "@"));
		return sqlSessionTemplate.selectList("master.mpso.selectMasterMpSoPrewarhsngOrderManageList", param);
	}

	// 선입고 요청 등록
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		LOGGER.debug("요청 파라미터 : {}", gridData);
		_rtnMsg = "저장완료.";
		
		try{
			String bs_no = "";
			String buyer_code = "";			
			
			for(int i=gridData.size()-1; i >= 0 ; i--){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				if( "I".equals(formData.get("sStatus"))){
					buyer_code = formData.get("BUYER_CODE");
					bs_no = buyerMpSoOrderInfoDao.getOrderNo(buyer_code,"BS");
					formData.put("BS_NO", bs_no);
					sqlSessionTemplate.update("master.mpso.insertMasterMpSoPrewarhsngOrderManage", formData);
				}else if( "U".equals(formData.get("sStatus"))){
					sqlSessionTemplate.update("master.mpso.updateMasterMpSoPrewarhsngOrderManage", formData);
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 선입고 요청 취소
	@SuppressWarnings("unchecked")
	public String updatePrewarhsngReqCancel(Map<String,String>  formData, List<Object> gridData) {
		LOGGER.debug("요청 파라미터 : {}", gridData);
		_rtnMsg = "저장완료.";
		
		try{
			for(int i=gridData.size()-1; i >= 0 ; i--){
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.update("master.mpso.updateMasterMpSoPrewarhsngReqCancel", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 선입고 관리 맵핑 등록(발주완료)
	@SuppressWarnings("unchecked")
	public String updatePrewarhsngMappingReg(Map<String,String>  formData, List<Object> gridData) {
		LOGGER.debug("요청 파라미터 : {}", gridData);
		_rtnMsg = "저장완료.";
		
		try{
			Map<String, String> pMap = new HashMap<String, String>();
			pMap.put("st_buyer", formData.get("st_buyer"));
			pMap.put("st_bs_no", formData.get("st_bs_no"));
			pMap.put("st_close_item_qty", formData.get("st_close_item_qty"));
			
			String st_po_no = "";
			for(int i=gridData.size()-1; i >= 0 ; i--){
				formData.putAll((Map<String, String>)gridData.get(i));
				st_po_no += formData.get("PO_NO") + "||" + formData.get("PO_SEQ") + "$$";
			}
			
			pMap.put("st_po_no", st_po_no);
			sqlSessionTemplate.update("master.mpso.updateMasterMpSoPrewarhsngMappingReg", pMap);
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 선입고 관리 맵핑 등록(부분발주완료)
	@SuppressWarnings("unchecked")
	public String updatePrewarhsngMappingPartialReg(Map<String,String>  formData, List<Object> gridData) {
		LOGGER.debug("요청 파라미터 : {}", gridData);
		_rtnMsg = "저장완료.";
		
		try{
			Map<String, String> pMap = new HashMap<String, String>();
			pMap.put("st_buyer", formData.get("st_buyer"));
			pMap.put("st_bs_no", formData.get("st_bs_no"));
			pMap.put("st_close_item_qty", formData.get("st_close_item_qty"));
			
			String st_po_no = "";
			for(int i=gridData.size()-1; i >= 0 ; i--){
				formData.putAll((Map<String, String>)gridData.get(i));
				st_po_no += formData.get("PO_NO") + "||" + formData.get("PO_SEQ") + "$$";
			}
			
			pMap.put("st_po_no", st_po_no);
			sqlSessionTemplate.update("master.mpso.updateMasterMpSoPrewarhsngMappingPartialReg", pMap);
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 선입고 관리 맵핑 취소(발주취소)
	public String updatePrewarhsngMappingCancelReg(Map<String,String>  formData) {
		LOGGER.debug("요청 파라미터 : {}", formData);
		_rtnMsg = "저장완료.";
		
		try{
			Map<String, String> pMap = new HashMap<String, String>();
			pMap.put("st_buyer", formData.get("st_buyer"));
			pMap.put("st_bs_no", formData.get("st_bs_no"));
			sqlSessionTemplate.update("master.mpso.updateMasterMpSoPrewarhsngMappingCancelReg", pMap);
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 선입고 관리 다건 맵핑 취소(다건발주취소)
	@SuppressWarnings("unchecked")
	public String updatePrewarhsngMappingGrpCancelReg(Map<String,String>  formData, List<Object> gridData) {
		LOGGER.debug("요청 파라미터 : {}", gridData);
		_rtnMsg = "저장완료.";
		
		try{
			for(int i=gridData.size()-1; i >= 0 ; i--){
				formData.putAll((Map<String, String>)gridData.get(i));
				sqlSessionTemplate.update("master.mpso.updateMasterMpSoPrewarhsngMappingGrpCancelReg", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	// 선입고 관리 거래명세서
	@SuppressWarnings("unchecked")
	public String updatesaveMasterMpSoPrewarhsngTranStatementReg(Map<String,String>  formData, List<Object> gridData) {
		LOGGER.debug("요청 파라미터 : {}", gridData);
		_rtnMsg = "저장완료.";
		
		try{
			String inv_no = "";
			String buyer_code = "";
			
			if(gridData != null && gridData.size() > 0){
				formData.putAll((Map<String, String>)gridData.get(0));
				buyer_code = formData.get("BUYER_CODE");
				inv_no = buyerMpSoOrderInfoDao.getOrderNo(buyer_code,"IB");
				
				for(int i=gridData.size()-1; i >= 0 ; i--){
					formData.putAll((Map<String, String>)gridData.get(i));
					formData.put("INV_NO", inv_no);
					formData.put("INV_SEQ", String.valueOf(i+1));
					
					sqlSessionTemplate.update("master.mpso.insertMasterMpSoPrewarhsngTranStatement_ivdt", formData);
				}
				
				formData.put("BUYER_CODE", buyer_code);
				formData.put("INV_NO", inv_no);
				
				sqlSessionTemplate.update("master.mpso.insertMasterMpSoPrewarhsngTranStatement_ivhd", formData);
				
				String checkRepetition = sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoPrewarhsngTranStatement_checkRepetition", formData);
				if(Integer.valueOf(checkRepetition) < 0){
					throw new Exception();
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("거래명세서 생성에 실패 하였습니다. 관리자에 문의 하여 주세요.");
		}
		return _rtnMsg;
	}
	
	// 선입고 관리 납품실적
	@SuppressWarnings("unchecked")
	public String updatesaveMasterMpSoPrewarhsngDeliveryEndReg(Map<String,String>  formData, List<Object> gridData) {
		LOGGER.debug("요청 파라미터 : {}", gridData);
		_rtnMsg = "저장완료.";
		
		try{
			if(gridData != null && gridData.size() > 0){
				
				Map<String, String> sendMailMap = new HashMap<String, String>();
				String com_type = "";
				
				for(int i=gridData.size()-1; i >= 0 ; i--){
					formData.putAll((Map<String, String>)gridData.get(i));
					sqlSessionTemplate.update("master.mpso.updateMasterMpSoPrewarhsngDeliveryEndReg", formData);
					
					com_type = sqlSessionTemplate.selectOne("master.mpso.selectMasterMpSoPrewarhsng_comType", formData);
					formData.put("COM_TYPE", com_type);
					
					if("X".equals(com_type)){
						
						// 고객사 메일 전송
						sendMailMap.put("MAILFORM_ID", "PRE_GR_END_MB");
						sendMailMap.put("SEND_COM_TYPE", "M");
						sendMailMap.put("RECV_COM_TYPE", "B");
						sendMailMap.put("SEND_COM_CODE", "KRKORE0001");
						sendMailMap.put("SEND_USER_ID", "KEP200300");
						sendMailMap.put("KEY1", formData.get("BUYER_CODE"));
						sendMailMap.put("KEY2", formData.get("BS_NO"));
						
						MailSmsUtil.mailSend(sendMailMap);
						
						// 협력사 메일 전송
						sendMailMap.put("MAILFORM_ID", "PRE_GR_END_MS");
						sendMailMap.put("SEND_COM_TYPE", "M");
						sendMailMap.put("RECV_COM_TYPE", "S");
						sendMailMap.put("SEND_COM_CODE", "KRKORE0001");
						sendMailMap.put("SEND_USER_ID", "KEP200300");
						sendMailMap.put("KEY1", formData.get("BUYER_CODE"));
						sendMailMap.put("KEY2", formData.get("BS_NO"));
						
						MailSmsUtil.mailSend(sendMailMap);
					}
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
}
