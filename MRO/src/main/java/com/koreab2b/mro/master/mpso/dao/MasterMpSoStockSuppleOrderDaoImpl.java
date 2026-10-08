package com.koreab2b.mro.master.mpso.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderInfoDao;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.DateTimeUtil;

@Repository("masterMpSoStockSuppleOrderDao")
@Transactional
public class MasterMpSoStockSuppleOrderDaoImpl implements MasterMpSoStockSuppleOrderDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoStockSuppleOrderDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Autowired
	private BuyerMpSoOrderInfoDao buyerMpSoOrderInfoDao;
	
	private String _rtnMsg = "";
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mpso.selectMasterMpSoStockSuppleOrderList", param);
	}
	
	// 재고보충재고량 수정
	@SuppressWarnings("unchecked")
	public String modifyMasterMpSoSoStockSuppleOrderCardQty(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "수정완료.";
		
		try{
			String st_wms_code = formData.get("st_wms_code");
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				formData.put("st_wms_code", st_wms_code);
				// STEP1
				sqlSessionTemplate.update("master.mpso.updateMasterMpSoSoStockSuppleOrderCardQty", formData);
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}

	// 저장
	@SuppressWarnings("unchecked")
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "발주완료.";
		
		// 발주 등록에 필요한 파라미터 세팅
		String st_com_code				= CommonUtil.nvl((String) formData.get("st_wms_code"),"");
		String st_purchaser_id			= CommonUtil.nvl((String) formData.get("st_user_id"),"");
		String st_purchase_dept				= CommonUtil.nvl((String) formData.get("st_user_dept_code"),"");

		String st_po_create_date		= DateTimeUtil.getFormatString("yyyyMMdd");
		String st_gr_flag					= "N";

		String st_location_code			= CommonUtil.nvl((String) formData.get("st_user_dept_code"),"");
		
		String st_stck_query				= "";
		String st_vmi_query				= "";
		
		String st_user_id					= "";
		String st_process_type			= "";
		String st_remark					= "";
		String st_pr_no					= "";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// ICOMCART Table에 보충재고량 수정
				formData.put("st_wms_code", st_com_code);
				formData.put("st_user_id", st_user_id);
				
				// 보충재고량 수정
				sqlSessionTemplate.update("master.mpso.updateMasterMpSoSoStockSuppleOrderCardQty", formData);
				// 입고예정재고 업데이트
				sqlSessionTemplate.update("master.mpso.updateMasterMpSoSoStockSuppleOrderWmsStck", formData);
				sqlSessionTemplate.update("master.mpso.updateMasterMpSoSoStockSuppleOrderWmsStck_cqdt", formData);
				
				// 발주 생성에 필요한 데이터 가공
				st_process_type = formData.get("PROCESS_TYPE");
				if("1".equals(st_process_type)){
					st_stck_query += formData.get("BUYER_ITEM_NO") + "@@" + formData.get("CONTRACT_NO") + "@@"
							+ formData.get("CONTRACT_SEQ") + "@@" + formData.get("RD_DATE") + "@@" + formData.get("USER_ID") + "^||^";
				}else{
					st_vmi_query += formData.get("BUYER_ITEM_NO") + "@@" + formData.get("CONTRACT_NO") + "@@"
							+ formData.get("CONTRACT_SEQ") + "@@" + formData.get("RD_DATE") + "@@" + formData.get("AGENT") + "@@" + formData.get("USER_ID") + "^||^";
				}
			}
			
			// 발주 생성에 필요한 납품요청일(VMI = 납품요청일 + 협력사) 별 데이터 분기
			Map<String,String> stck_hm = null;
			Map<String,String> vmi_hm  = null;
			Object [] stck_rdDates = null;
			Object [] vmi_rdDates  = null;
			
			if(!st_stck_query.trim().equals("")){
				stck_hm			= dividePerRecvDate(st_stck_query);
				stck_rdDates	= stck_hm.keySet().toArray();
			}
			if(!st_vmi_query.trim().equals("")){
				vmi_hm			= dividePerRecvDateAgent(st_vmi_query);
				vmi_rdDates	= vmi_hm.keySet().toArray();
			}
			
			// 발주 생성  ( 재고)
			if(stck_rdDates != null){
				
				Map<String,Object> stckMap = null;
				String[] arr_query_cart = null;
				String cartInfo = "";
				String rdDate = "";
				
				List<Map<String,String>> podtList = null;
				Map<String,String> podtMap = null;
				String st_po_no = null;
				String st_subject = null;
			    String temp = "";
			    int    st_po_seq = 1;
			    List<Map<String,String>> pohdList = new ArrayList<Map<String,String>>();
			    Map<String,String> pohdMap = null;
				
				for(int i=0; i<stck_rdDates.length; i++){
					// PR_NO 생성
					st_pr_no = buyerMpSoOrderInfoDao.getOrderNo(st_com_code,"PR");
					
					cartInfo = String.valueOf(stck_hm.get(stck_rdDates[i]));
					rdDate	= String.valueOf(stck_rdDates[i]).substring(0,8);
					arr_query_cart = CommonUtil.StrToArray(cartInfo, "@@");

					stckMap = new HashMap<String, Object>();
					
					// ICOMPRDT 정보 세팅
					stckMap.put("st_pr_no", st_pr_no);								// PR_NO
					stckMap.put("st_rd_date", rdDate);								// RD_DATE
					stckMap.put("st_location_code", st_location_code);			// DELY_TO_LOCATION
					stckMap.put("st_recv_flag", "GA");								// RECV_FLAG
					stckMap.put("st_purchaser_id", st_purchaser_id);			// PURCHASER_ID
					stckMap.put("st_purchase_dept", st_purchase_dept);		// PURCHASE_DEPT
					stckMap.put("st_buyer", st_com_code);							// BUYER
					stckMap.put("arr_query_cart", arr_query_cart);				// arr_query_cart
					
					// ICOMPRHD 정보 세팅
					stckMap.put("st_remark", st_remark);							// REMARK
					stckMap.put("st_gr_flag", st_gr_flag);							// GR_FLAG
					
					// ICOMPRDT 테이블에 정보 저장
					sqlSessionTemplate.update("master.mpso.insertMasterMpSoStockSuppleOrder_prdt", stckMap);
					// ICOMPRHD 테이블에 정보 저장
					sqlSessionTemplate.update("master.mpso.insertMasterMpSoStockSuppleOrder_prhd", stckMap);
					// ICOMCART 테이블 정보 삭제
					sqlSessionTemplate.update("master.mpso.deleteMasterMpSoStockSuppleOrder_cartInfo", stckMap);
					
					// 발주생성 모듈( 직발주 , 요청접수 발주 , 결재완료시 발주 )  , 선입고 플래그는 PRHD.DCO_TYPE를 조회해서 체크함
					podtList = sqlSessionTemplate.selectList("master.mpso.selectNewProxyPoCreate", stckMap);
					
					pohdList.clear();
					LOGGER.debug("pohdList.size() = " + pohdList.size());

					
					for(int inx= 0; inx < podtList.size() ; inx++){
						podtMap = podtList.get(inx);
					    
					    if(!temp.equals((String)podtMap.get("CONDITION"))) {
					    	temp = (String)podtMap.get("CONDITION");	// PO 분리 생성 조건
					    	
					    	st_po_no = buyerMpSoOrderInfoDao.getOrderNo(st_com_code,"PO");
					    	st_subject = CommonUtil.nvl((String) podtMap.get("PR_SUBJECT"), "");
					    	st_po_seq = 1;
					    	
					    	pohdMap = new HashMap<String, String>();
					    	pohdMap.put("st_buyer", st_com_code);
					    	pohdMap.put("st_po_no", st_po_no);
					    	pohdMap.put("st_seller", CommonUtil.bnvl(podtMap.get("SELLER")));
					    	pohdMap.put("st_dely_to_location", CommonUtil.bnvl(podtMap.get("DELY_TO_LOCATION")));
					    	pohdMap.put("st_ref_add_user_id", CommonUtil.bnvl(podtMap.get("CHANGE_USER_ID")));
					    	pohdMap.put("st_agent",CommonUtil.bnvl(podtMap.get("AGENT")));
					    	pohdMap.put("st_px_remark", CommonUtil.bnvl(podtMap.get("REMARK")));
					    	pohdMap.put("st_gr_flag", CommonUtil.bnvl(podtMap.get("DOC_TYPE")));
					    	pohdMap.put("st_change_user_name", CommonUtil.bnvl(podtMap.get("CHANGE_USER_NAME")));
					    	pohdMap.put("st_change_user_tel", CommonUtil.bnvl(podtMap.get("CHANGE_USER_TEL")));
					    	
					    	pohdList.add(pohdMap);  // podt가 몇개가 만들어 지는지 그 값을 넣어준다.
					    }else {
					    	st_po_seq++;
					    }
					    
					    podtMap.put("st_buyer", st_com_code);
					    podtMap.put("st_po_no", st_po_no);
					    podtMap.put("st_po_seq", String.valueOf(st_po_seq));
					    
					    // podt 파라미터 세팅 및 초기화
					    podtMap.put("SELLER", CommonUtil.bnvl(podtMap.get("SELLER")));
					    podtMap.put("BUYER_ITEM_NO", CommonUtil.bnvl(podtMap.get("BUYER_ITEM_NO")));
					    podtMap.put("SELLER_ITEM_NO", CommonUtil.bnvl(podtMap.get("SELLER_ITEM_NO")));
					    podtMap.put("DESCRIPTION", CommonUtil.bnvl(podtMap.get("DESCRIPTION")));
					    podtMap.put("SPECIFICATION", CommonUtil.bnvl(podtMap.get("SPECIFICATION")));
					    podtMap.put("HS_NO", CommonUtil.bnvl(podtMap.get("HS_NO")));
					    podtMap.put("UNIT_MEASURE", CommonUtil.bnvl(podtMap.get("UNIT_MEASURE")));
					    podtMap.put("RECV_QTY", CommonUtil.bnvl(podtMap.get("RECV_QTY")));
					    podtMap.put("TARGET_PRICE", CommonUtil.bnvl(podtMap.get("TARGET_PRICE")));
					    podtMap.put("RD_DATE", CommonUtil.bnvl(podtMap.get("RD_DATE")));
					    podtMap.put("DOM_EXP_FLAG", CommonUtil.bnvl(podtMap.get("DOM_EXP_FLAG")));
					    podtMap.put("MAKER_CODE", CommonUtil.bnvl(podtMap.get("MAKER_CODE")));
					    podtMap.put("MAKER_NAME", CommonUtil.bnvl(podtMap.get("MAKER_NAME")));
					    podtMap.put("ORIGIN_CODE", CommonUtil.bnvl(podtMap.get("ORIGIN_CODE")));
					    podtMap.put("PR_NO", CommonUtil.bnvl(podtMap.get("PR_NO")));
					    podtMap.put("PR_SEQ", CommonUtil.bnvl(podtMap.get("PR_SEQ")));
					    podtMap.put("CONTRACT_NO", CommonUtil.bnvl(podtMap.get("CONTRACT_NO")));
					    podtMap.put("CONTRACT_SEQ", CommonUtil.bnvl(podtMap.get("CONTRACT_SEQ")));
					    podtMap.put("PAY_TERMS", CommonUtil.bnvl(podtMap.get("PAY_TERMS")));
					    podtMap.put("DELY_TO_LOCATION_CD", CommonUtil.bnvl(podtMap.get("DELY_TO_LOCATION_CD")));
					    podtMap.put("DELY_TO_LOCATION", CommonUtil.bnvl(podtMap.get("DELY_TO_LOCATION")));
					    podtMap.put("REF_PR_NO", CommonUtil.bnvl(podtMap.get("REF_PR_NO")));
					    podtMap.put("PURCHASER_DEPT", CommonUtil.bnvl(podtMap.get("PURCHASER_DEPT")));
					    podtMap.put("AGENT_PRICE", CommonUtil.bnvl(podtMap.get("AGENT_PRICE")));
					    podtMap.put("AGENT_ITEM_AMT", CommonUtil.bnvl(podtMap.get("AGENT_ITEM_AMT")));
					    podtMap.put("REMARK", CommonUtil.bnvl(podtMap.get("REMARK")));
					    podtMap.put("BYIT_COMORG_CODE", CommonUtil.bnvl(podtMap.get("BYIT_COMORG_CODE")));
					    podtMap.put("PROCESS_TYPE", CommonUtil.bnvl(podtMap.get("PROCESS_TYPE")));
					    podtMap.put("CATEG_ID", CommonUtil.bnvl(podtMap.get("CATEG_ID")));
					    podtMap.put("ORIGIN_AGENT", CommonUtil.bnvl(podtMap.get("ORIGIN_AGENT")));
					    podtMap.put("ACCOUNT_TYPE", CommonUtil.bnvl(podtMap.get("ACCOUNT_TYPE")));
					    podtMap.put("BUDGET_DEPT", CommonUtil.bnvl(podtMap.get("BUDGET_DEPT")));
					    podtMap.put("LEGACY_PO_NO", CommonUtil.bnvl(podtMap.get("LEGACY_PO_NO")));
					    podtMap.put("LEGACY_PO_SEQ", CommonUtil.bnvl(podtMap.get("LEGACY_PO_SEQ")));
					    podtMap.put("CMS_CATLG_ID", CommonUtil.bnvl(podtMap.get("CMS_CATLG_ID")));
					    
					    if(!"2".equals((String)podtMap.get("PROCESS_TYPE"))){
					    	podtMap.put("ORIGIN_AGENT", "");
					    }else{
					    	podtMap.put("LEGACY_PO_NO", "");
					    	podtMap.put("LEGACY_PO_SEQ", "");
					    }
					    
					    sqlSessionTemplate.update("master.mpso.insertNewProxyPoCreate_dt", podtMap);
					}
					
					// POHD 생성시작 ==> pohdList 수 만큼 헤드 생성
					for(int inx= 0; inx < pohdList.size() ; inx++){
						pohdMap = pohdList.get(inx);
						pohdMap.put("st_user_id", st_purchaser_id);
						pohdMap.put("st_po_create_date", st_po_create_date);
						pohdMap.put("st_subject", st_subject);
						
						sqlSessionTemplate.update("master.mpso.insertNewProxyPoCreate_hd", pohdMap);						
					}
				}
			}
			
			// 발주 생성  ( VMI)
			if(vmi_rdDates != null){
				
				Map<String,Object> vmiMap = null;
				String cartInfo = "";
				String rdDate = "";
				String[] arr_query_cart = null;
				
				String st_po_no = "";
				
				for(int i=0; i< vmi_rdDates.length; i++){
					// PO_NO 생성
					st_po_no = buyerMpSoOrderInfoDao.getOrderNo(st_com_code,"PO");
					
					cartInfo = String.valueOf(vmi_hm.get(vmi_rdDates[i]));
					rdDate	= String.valueOf(vmi_rdDates[i]).substring(0,8);
					arr_query_cart = CommonUtil.StrToArray(cartInfo, "@@");
					
					vmiMap = new HashMap<String, Object>();
					
					// ICOMPRDT 정보 세팅
					vmiMap.put("st_po_no", st_po_no);								// PR_NO
					vmiMap.put("st_rd_date", rdDate);								// RD_DATE
					vmiMap.put("st_buyer", st_com_code);							// BUYER
					vmiMap.put("st_user_id", st_purchaser_id);					// PURCHASER_ID
					vmiMap.put("arr_query_cart", arr_query_cart);				// arr_query_cart
					
					// EDIVPODT 테이블 정보 저장
					sqlSessionTemplate.update("master.mpso.insertMasterMpSoStockSuppleOrder_vmi", vmiMap);
					// ICOMCART 테이블 정보 삭제
					sqlSessionTemplate.update("master.mpso.deleteMasterMpSoStockSuppleOrder_cartInfo", vmiMap);
				}
			}
			
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	private Map<String,String> dividePerRecvDate(String query){
		String rows [] = CommonUtil.StrToArray(query , "^||^");
		String recv_date [] = new String[rows.length];
		String user_id [] = new String[rows.length];
		Map<String,String> hm = new HashMap<String, String>();

		for(int i=0; i< rows.length; i++){
			String [] data = rows[i].split("@@");
			recv_date[i] = data[3];
			user_id[i] = data[4];
			if(i>0){
				Set<String> keySet = hm.keySet();
				Object [] keys = keySet.toArray();
				boolean isEqual = false;
				for(int j=0; j < keys.length ; j++){
					if(keys[j].equals(recv_date[i]+user_id[i])){
						isEqual = true;
					}
				}
				
				if(isEqual){
					String temp = (String)hm.get(recv_date[i]+user_id[i]);
					hm.put(recv_date[i]+user_id[i],temp+"@@"+data[4]+data[0]+data[1]+data[2]);
				}else{
					hm.put(recv_date[i]+user_id[i],data[4]+data[0]+data[1]+data[2]);
				}
			}else{
				hm.put(recv_date[i]+user_id[i],data[4]+data[0]+data[1]+data[2]);
			}
			
			LOGGER.debug("query_catr[" + recv_date[i]+user_id[i] + "] :::;  " + hm.get(recv_date[i]+user_id[i]));
		}
		return hm;
	}
	
	private Map<String,String> dividePerRecvDateAgent(String query){
		String rows [] = CommonUtil.StrToArray(query , "^||^");
		String recv_date [] = new String[rows.length];
		String agent	 [] = new String[rows.length];
		String user_id [] = new String[rows.length];
		Map<String,String> hm = new HashMap<String, String>();

		for(int i=0; i< rows.length; i++){
			String [] data = rows[i].split("@@");
			recv_date[i] = data[3];
			agent[i]	 = data[4];	
			if(i>0){
				Set<String> keySet = hm.keySet();
				Object [] keys = keySet.toArray();
				boolean isEqual = false;
				for(int j=0; j < keys.length ; j++){
					if(keys[j].equals(recv_date[i]+agent[i]+user_id[i])){
						isEqual = true;
					}
				}
				
				if(isEqual){
					String temp = (String)hm.get(recv_date[i]+agent[i]+user_id[i]);
					hm.put(recv_date[i]+agent[i]+user_id[i],temp+"@@"+data[5]+data[0]+data[1]+data[2]);
				}else{
					hm.put(recv_date[i]+agent[i]+user_id[i],data[5]+data[0]+data[1]+data[2]);
				}
			}else{
				hm.put(recv_date[i]+agent[i]+user_id[i],data[5]+data[0]+data[1]+data[2]);
			}
			
			LOGGER.debug("query_catr[" + recv_date[i]+agent[i]+user_id[i] + "] :::;  " + hm.get(recv_date[i]+agent[i]+user_id[i]));
		}
		return hm;
	}
	
	
	// 삭제
	@SuppressWarnings("unchecked")
	@Transactional(rollbackFor=Exception.class, propagation=Propagation.REQUIRED)
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		
		_rtnMsg = "삭제완료";
		
		try{
			
			String st_wms_code = formData.get("st_wms_code");
			String st_user_id = formData.get("st_user_id");
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				formData.put("st_wms_code", st_wms_code);
				formData.put("st_user_id", st_user_id);
				
				sqlSessionTemplate.update("master.mpso.deleteMasterMpSoStockSuppleOrder", formData);

			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("견적 요청에 실패하였습니다.");
		}

		return _rtnMsg;		
		
	}	

}
