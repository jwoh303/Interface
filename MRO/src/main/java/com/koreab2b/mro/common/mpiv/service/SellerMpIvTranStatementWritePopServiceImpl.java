package com.koreab2b.mro.common.mpiv.service;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.coco.dao.CommonInfoDao;
import com.koreab2b.mro.common.mpiv.dao.SellerMpIvTranStatementWritePopDao;
import com.koreab2b.mro.util.CommonUtil;

import doosan.bean.DetailBean;
import doosan.bean.HeaderBean;
import doosan.bean.InterfaceBean;
import doosan.info.Constant;
import doosan.svc.DoosanInterfaceService;

@Service("sellerMpIvTranStatementWritePopService")
public class SellerMpIvTranStatementWritePopServiceImpl implements SellerMpIvTranStatementWritePopService {
	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvTranStatementWritePopServiceImpl.class);

	@Autowired
	private CommonInfoDao commonInfoDao; 
	
	@Autowired
	private SellerMpIvTranStatementWritePopDao sellerMpIvTranStatementWritePopDao;

	// 기본정보 조회
	public Map<String,String> getInfo(Map<String,String>  pMap){
		
		List<Map<String, String>> detailInfo = sellerMpIvTranStatementWritePopDao.selectInfo(pMap);
		
		
		Map<String,String> map = (Map<String,String>)CommonUtil.getListNvl(detailInfo).get(0);

        logger.debug("SellerMpIvTranStatementWritePopServiceImpl 거래명세서작성 기본정보조회 출력 start ====================");
        
        Set<String> keySet = map.keySet();
        Iterator<String> iterator = keySet.iterator();
        
        while(iterator.hasNext()){
        	String key = iterator.next();
        	String value = map.get(key);
        	logger.debug("key : "+key+", value : "+value);
        }
        
        logger.debug("SellerMpIvTranStatementWritePopServiceImpl 거래명세서작성 기본정보조회 출력 end ====================");
        
        String rpt_url = "";
        
        map.put("USER_ID", pMap.get("st_user_id"));
        map.put("BUYER", pMap.get("st_buyer"));
        map.put("GBN", "WR"); // 거래명세서 작성여부 ( 작성일경우 : WR, 아닐경우 : "")
        	
        // 특수로직데이터를 이용해서 레포트 url 조회
        rpt_url = commonInfoDao.selectRptUrl(map);
        	
        logger.debug("rpt_url==============>> " + rpt_url);
        
        map.put("RPT_URL", rpt_url);

		return map;
	}
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,String> pMap) {
		return sellerMpIvTranStatementWritePopDao.selectList(pMap);
	}
	public List<Map<String,String>> getSellerMpIvTranStatementWritePop_v2(Map<String,Object> pMap) {
		return sellerMpIvTranStatementWritePopDao.getSellerMpIvTranStatementWritePop_v2(pMap);
	}
	
	// 구매사 차량정보 입력여부 조회 
	public String getSellerMpivBuyerCarInfo(Map<String,String>  pMap) {
		return sellerMpIvTranStatementWritePopDao.getSellerMpivBuyerCarInfo(pMap);
	}	
	
	// 거래명세서 작성 저장
	public Map<String, String> saveSellerMpIvTranStatementWritePop(Map<String, String> pMap){
		return sellerMpIvTranStatementWritePopDao.saveSellerMpIvTranStatementWritePop(pMap);
	}
	public Map<String, String> saveSellerMpIvTranStatementWritePop_v3(Map<String, String> pMap){
		return sellerMpIvTranStatementWritePopDao.saveSellerMpIvTranStatementWritePop_v3(pMap);
	}
	
	
	// 리스트조회_분할납품
	public List<Map<String,String>> getDoosanmecaList(Map<String,String> pMap) {
		return sellerMpIvTranStatementWritePopDao.selectDoosanmecaList(pMap);
	}
	public List<Map<String,String>> getSellerMpIvTranStatementWriteDoosanmecaPop_v2(Map<String,Object> pMap) {
		return sellerMpIvTranStatementWritePopDao.getSellerMpIvTranStatementWriteDoosanmecaPop_v2(pMap);
	}
	

	// 거래명세서 작성 저장_Doosanmeca
	public Map<String, String> saveSellerMpIvTranStatementWriteDoosanmecaPop(Map<String, String> pMap){
		return sellerMpIvTranStatementWritePopDao.saveSellerMpIvTranStatementWriteDoosanmecaPop(pMap);
	}
	public Map<String, String> saveSellerMpIvTranStatementWriteDoosanmecaPop_v3(Map<String, String> pMap){
		return sellerMpIvTranStatementWritePopDao.saveSellerMpIvTranStatementWriteDoosanmecaPop_v3(pMap);
	}
	
	// 리스트조회_두산인프라용 팝업
	public List<Map<String,String>> getDiList(Map<String,String> pMap) {
		return sellerMpIvTranStatementWritePopDao.selectDiList(pMap);
	}
	public List<Map<String,String>> getSellerMpIvTranStatementWriteDiPop_v2(Map<String,Object> pMap) {
		return sellerMpIvTranStatementWritePopDao.getSellerMpIvTranStatementWriteDiPop_v2(pMap);
	}
	
	// 리스트조회_두산인프라 팝업 PO LIST 조회
	public List<Map<String,String>> getLegacyPoList(Map<String,String>  pMap) {
		return sellerMpIvTranStatementWritePopDao.selectLegacyPoList(pMap);
	}
	
	@SuppressWarnings("unchecked")
	public String saveKrdhimInvoice(Map<String,String>  pMap){
		
		String rValue = "";
		String result = "NO";
		
		try{
			
			// 1. v_inv_hd = getInvHdList(buyer, inv_no, type);
			Map<String, String> hdMap = sellerMpIvTranStatementWritePopDao.getInvHdList(pMap);
			
			@SuppressWarnings("rawtypes")
			Vector vInvHd = new Vector();
			
			String[] hdObj = {
					  CommonUtil.nvl(String.valueOf(hdMap.get("SYS_GUBUN")))
					, CommonUtil.nvl(String.valueOf(hdMap.get("BARCD_NO")))
					, CommonUtil.nvl(String.valueOf(hdMap.get("MAN_EMPNO")))
					, CommonUtil.nvl(String.valueOf(hdMap.get("MAN_EMPNM")))
					, CommonUtil.nvl(String.valueOf(hdMap.get("REQ_DPTCD")))
					, CommonUtil.nvl(String.valueOf(hdMap.get("REQ_DPTNM")))
					, CommonUtil.nvl(String.valueOf(hdMap.get("REQ_DATE")))
					, CommonUtil.nvl(String.valueOf(hdMap.get("INCOMP_NM")))
					, CommonUtil.nvl(String.valueOf(hdMap.get("INCOMP_NO")))
					, CommonUtil.nvl(String.valueOf(hdMap.get("STATUS")))
					, CommonUtil.nvl(String.valueOf(hdMap.get("CARRYIN_NO")))
					, CommonUtil.nvl(String.valueOf(hdMap.get("CHECK_GB")))
			};
			
			vInvHd.addElement(hdObj);
			        
			// 2. v_inv_dt = getInvDtList(buyer, inv_no);
			List<Map<String,String>> dtList = sellerMpIvTranStatementWritePopDao.getInvDtList(pMap);
			
			@SuppressWarnings("rawtypes")
			Vector vInvDt = new Vector();
			int dtCnt = dtList.size();
			
			for(int i = 0; i < dtCnt; i++){
				Map<String, String> dtMap = dtList.get(i);
				
				String[] dtObj = {
						  CommonUtil.nvl(String.valueOf(dtMap.get("BARCD_NO_D")))
						, CommonUtil.nvl(String.valueOf(dtMap.get("ITEM")))
						, CommonUtil.nvl(String.valueOf(dtMap.get("ITEM_NM")))
						, CommonUtil.nvl(String.valueOf(dtMap.get("QTY")))
						, CommonUtil.nvl(String.valueOf(dtMap.get("UNIT")))
						, CommonUtil.nvl(String.valueOf(dtMap.get("BIGO")))
						, CommonUtil.nvl(String.valueOf(dtMap.get("PERIOD_DATE")))
						, CommonUtil.nvl(String.valueOf(dtMap.get("INAREA")))
						, CommonUtil.nvl(String.valueOf(dtMap.get("INCOMP_NMS")))
				};
				
				vInvDt.addElement(dtObj);
			}
			
			// 3. sendIVInfo(buyer, warehouse_code, v_inv_hd, v_inv_dt, sys_type, inv_no);
			
			HeaderBean			hdBean = new HeaderBean();
			List<DetailBean>	dbList = new ArrayList<DetailBean>();
			InterfaceBean		ifBean = new InterfaceBean();	 

			String[] hd_obj = (String[])vInvHd.elementAt(0);   

			hdBean.setSYS_GUBN(hd_obj[0]); 
			hdBean.setBARCD_NO(hd_obj[1]); 
			hdBean.setMAN_EMPNO(hd_obj[2]);
			hdBean.setMAN_EMPNM(hd_obj[3]);
			hdBean.setREQ_DPTCD(hd_obj[4]);
			hdBean.setREQ_DPTNM(hd_obj[5]);
			hdBean.setREQ_DATE(hd_obj[6]); 
			hdBean.setINCOMP_NM(hd_obj[7]);
			hdBean.setINCOMP_NO(hd_obj[8]);
			hdBean.setSTATUS(hd_obj[9]);
			hdBean.setCARRYIN_NO(hd_obj[10]);
			hdBean.setCHECK_GB(hd_obj[11]);  

			ifBean.setHeaderBean( hdBean );  

			for(int y=0; y<vInvDt.size(); y++) {   
				DetailBean dtBean = new DetailBean();
				String [] dt_obj = (String[])vInvDt.elementAt(y); 

				dtBean.setBARCD_NO(dt_obj[0]); 	
				dtBean.setITEM(dt_obj[1]);	 	
				dtBean.setITEM_NM(dt_obj[2]); 	
				dtBean.setQTY(dt_obj[3]); 		
				dtBean.setUNIT(dt_obj[4]);
				dtBean.setBIGO(dt_obj[5]);
				dtBean.setPERIOD_DATE(dt_obj[6]); 
				dtBean.setINAREA(dt_obj[7]); 		
	//			dtBean.setINCOMP_NMS(""); 	 

				dbList.add( dtBean );
			}
			
			// TODO : Dooan If Check
			String opType	= pMap.get("OP_TYPE");	//1 : DEVELOP / 2 : QUALITY / 3 : REAL
			Constant.setActionType(opType);
			
			logger.info("Doosan Server Info");
			logger.info("IP : " + Constant.getServerInfo());
			logger.info("OP_TYPE : " + Constant.getActionType());
			
			ifBean.setDetailBeanList( dbList );
			DoosanInterfaceService sample = new DoosanInterfaceService();
			rValue = sample.doService( ifBean );	// TODO : 테스트 후 주석 제거
			//rValue = "S";   
			
			if( rValue != null && rValue.equals("S")){
				// 3_1. result = updateIvdt( buyer, ik_no);
				result = sellerMpIvTranStatementWritePopDao.updateIvdt(pMap);
			}else{
				//오류처리.
			}
	 
			logger.info("전송완료.");		 
			logger.info("rValue =>"+rValue+"<=");		 
			logger.info("result =>"+result+"<=");		 
		}catch(Exception e){
			logger.info("전송예외.");		 
			logger.info("rValue =>"+rValue+"<=");		 
			logger.info("result =>"+result+"<=");		 

			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("두산 인터페이스 전송 중 에러가 발생했습니다.");
				 
		}
		
		return rValue;
	}

	// 물질정보제출 협력사 요청
	public Map<String, String> saveSellerMpIvTranStatementWriteChemicalInfo(Map<String, String> pMap){
		return sellerMpIvTranStatementWritePopDao.saveSellerMpIvTranStatementWriteChemicalInfo(pMap);
	}

	// 물류센터 고객사 체크
	@Override	
	public String getW001Flag(Map<String, String> pMap) {
		return sellerMpIvTranStatementWritePopDao.getW001Flag(pMap);		
	}
	
	// 거래명세서 작성 저장-품목별(다중)
	public Map<String, String> saveSellerMpIvTranStatementWriteItemPop(Map<String, String> pMap){
		return sellerMpIvTranStatementWritePopDao.saveSellerMpIvTranStatementWriteItemPop(pMap);
	}
	public Map<String, String> saveSellerMpIvTranStatementWriteItemPop_v3(Map<String, String> pMap){
		return sellerMpIvTranStatementWritePopDao.saveSellerMpIvTranStatementWriteItemPop_v3(pMap);
	}
	
	//거래명세서 작성 조회 - 일괄
	public List<Map<String,String>> getSellerMpIvTranStatementWriteListItemAll_v2(Map<String,String> pMap) {
		List<Map<String, String>> list = sellerMpIvTranStatementWritePopDao.getSellerMpIvTranStatementWriteListItemAll_v2(pMap);
		
		Map<String,String> map = (Map<String,String>)CommonUtil.getListNvl(list).get(0);
			
		String rpt_url = "";
	        
	    map.put("USER_ID", pMap.get("st_user_id"));
        map.put("BUYER", pMap.get("st_buyer_code"));
        map.put("GBN", ""); // 거래명세서 작성여부 ( 작성일경우 : WR, 아닐경우 : "")
        
        // 특수로직데이터를 이용해서 레포트 url 조회
        rpt_url = commonInfoDao.selectRptUrl(map);
        	
        logger.debug("rpt_url==============>> " + rpt_url);
	        
	    list.get(0).put("RPT_URL", rpt_url);
		return list;
	}
	
	// 거래명세서 작성 저장-일괄
	public Map<String, String> saveSellerMpIvTranStatementWriteAllPop(Map<String, String> pMap){
		String doc_type 		= "IV";
		pMap.put("doc_type", doc_type);
		String inv_no = sellerMpIvTranStatementWritePopDao.getOrderNo(pMap);
		pMap.put("st_inv_no", inv_no);
		
		return sellerMpIvTranStatementWritePopDao.saveSellerMpIvTranStatementWriteAllPop(pMap);
	}
	public Map<String, String> saveSellerMpIvTranStatementWriteAllPop_v3(Map<String, String> pMap){
		String doc_type 		= "IV";
		pMap.put("doc_type", doc_type);
		String inv_no = sellerMpIvTranStatementWritePopDao.getOrderNo(pMap);
		pMap.put("st_inv_no", inv_no);
		
		return sellerMpIvTranStatementWritePopDao.saveSellerMpIvTranStatementWriteAllPop_v3(pMap);
	}
}
