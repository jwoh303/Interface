package com.koreab2b.mro.common.mpds.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mdam.dao.BuyerMdAmBudgetDaoImpl;


@Repository("masterMpDsOrderInfoConfirmPopDao")
@Transactional
public class MasterMpDsOrderInfoConfirmPopDaoImpl implements MasterMpDsOrderInfoConfirmPopDao {
	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmBudgetDaoImpl.class);
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData) {
		return sqlSessionTemplate.selectList("common.mpds.selectMasterMpDsOrderInfoConfirmPopList", formData);
	}
	
	//주문취소	
	public String delOrderInfo(Map<String, String> formData) {
		
		String _rtnMsg = "정상적으로 주문이 취소되었습니다.";
		
		try{
			sqlSessionTemplate.update("common.mpds.delMasterMpDsOrderInfoConfirmPop", formData);
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("수정에 실패하였습니다. 다시 확인하여 주십시요.");
		}
		return _rtnMsg;
	}

	//주문수정	
	public String updateOrderInfo(Map<String, String> formData){
		
		String _rtnMsg = "정상적으로 수정이 이루어 졌습니다.";
		
		try{
			
			String st_rd_date_all = formData.get("st_rd_date_all");
			String st_ds_qty_all = formData.get("st_ds_qty_all");
			String st_atos_remark = formData.get("st_atos_remark");
			String st_atoa_remark = formData.get("st_atoa_remark");
			// 비고가 없을경우
			formData.put("st_atos_remark", (st_atos_remark == null)? "":st_atos_remark);
			formData.put("st_atoa_remark", (st_atoa_remark == null)? "":st_atoa_remark);

			
			if("".equals(st_rd_date_all)){	// 납품계획이 없을경우
				sqlSessionTemplate.update("common.mpds.updateMasterMpDsOrderInfoConfirmPop_pstmt1", formData);
				sqlSessionTemplate.update("common.mpds.updateMasterMpDsOrderInfoConfirmPop_pstmt2", formData);
			}else{ // 납품계획이 있을경우
				
				sqlSessionTemplate.update("common.mpds.masterMpDsOrderInfoConfirmPop_div_pstmt3", formData);
				sqlSessionTemplate.update("common.mpds.masterMpDsOrderInfoConfirmPop_pstmt5", formData);
				
				String[] st_rd_date_arr = st_rd_date_all.split("@@");
				String[] st_ds_qty_arr = st_ds_qty_all.split("@@");
				
				int totsize = st_rd_date_arr.length;
				String div_ds_qty = "";
				int tot_ds_qty = 0;
				for(int i=0; i<totsize; i++){
					div_ds_qty = st_ds_qty_arr[i];
					tot_ds_qty = Integer.valueOf(tot_ds_qty) + Integer.valueOf(div_ds_qty);
					formData.put("st_rd_date", st_rd_date_arr[i]);
					formData.put("st_ds_qty",div_ds_qty );
					
					sqlSessionTemplate.update("common.mpds.masterMpDsOrderInfoConfirmPop_div_pstmt4", formData);
				}
				formData.put("st_tot_ds_qty", String.valueOf(tot_ds_qty));
				String st_po_status = formData.get("st_po_status");
				
				if("PO".equals(st_po_status)){
					sqlSessionTemplate.update("common.mpds.updateMasterMpDsOrderInfoConfirmPop_pstmt8_po", formData);
					
				}else if("DS".equals(st_po_status)){
					sqlSessionTemplate.update("common.mpds.updateMasterMpDsOrderInfoConfirmPop_pstmt8_ds", formData);
					
				}else if("IV".equals(st_po_status)){
					sqlSessionTemplate.update("common.mpds.updateMasterMpDsOrderInfoConfirmPop_pstmt8_iv", formData);
					
				}
				
			}
			
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("수정에 실패하였습니다. 다시 확인하여 주십시요.");
		}
		return _rtnMsg;
	}
	
	//발주생성
	public String insertOrderInfo(Map<String, String> formData){
		
		String _rtnMsg = "정상적으로 발주생성되었습니다.";
		
		try{
			String st_rd_date_all = formData.get("st_rd_date_all");
			String st_ds_qty_all = formData.get("st_ds_qty_all");
			
			if("".equals(st_rd_date_all)){	// 납품계획이 없을경우
				sqlSessionTemplate.update("common.mpds.insertMasterMpDsOrderInfoConfirmPop_pstmt1", formData);
				sqlSessionTemplate.update("common.mpds.insertMasterMpDsOrderInfoConfirmPop_pstmt2", formData);
			}else{ // 납품계획이 있을경우
				sqlSessionTemplate.update("common.mpds.masterMpDsOrderInfoConfirmPop_div_pstmt3", formData);
				sqlSessionTemplate.update("common.mpds.masterMpDsOrderInfoConfirmPop_pstmt5", formData);
				
				String[] st_rd_date_arr = st_rd_date_all.split("@@");
				String[] st_ds_qty_arr = st_ds_qty_all.split("@@");
				
				int totsize = st_rd_date_arr.length;
				String div_ds_qty = "";
				int tot_ds_qty = 0;
				for(int i=0; i<totsize; i++){
					div_ds_qty = st_ds_qty_arr[i];
					tot_ds_qty = Integer.valueOf(tot_ds_qty) + Integer.valueOf(div_ds_qty);
					formData.put("st_rd_date", st_rd_date_arr[i]);
					formData.put("st_ds_qty",div_ds_qty);
					
					sqlSessionTemplate.update("common.mpds.masterMpDsOrderInfoConfirmPop_div_pstmt9", formData);
				}

				formData.put("st_tot_ds_qty", String.valueOf(tot_ds_qty));
				String st_po_status = formData.get("st_po_status");
				
				if("PR".equals(st_po_status)){
					sqlSessionTemplate.update("common.mpds.insertMasterMpDsOrderInfoConfirmPop_pstmt8_pr", formData);
					
				}else if("DS".equals(st_po_status)){
					sqlSessionTemplate.update("common.mpds.insertMasterMpDsOrderInfoConfirmPop_pstmt8_ds", formData);
					
				}else if("IV".equals(st_po_status)){
					sqlSessionTemplate.update("common.mpds.insertMasterMpDsOrderInfoConfirmPop_pstmt8_iv", formData);
					
				}
			}

			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("발주생성에 실패하였습니다. 다시 확인하여 주십시요.");
		}
		return _rtnMsg;
	}

}
