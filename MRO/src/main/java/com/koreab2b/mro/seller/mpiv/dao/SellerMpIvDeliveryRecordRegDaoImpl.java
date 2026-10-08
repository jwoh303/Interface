package com.koreab2b.mro.seller.mpiv.dao;

import java.util.ArrayList;
import java.util.Calendar;
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

@Repository("sellerMpIvDeliveryRecordRegDao")
@Transactional
public class SellerMpIvDeliveryRecordRegDaoImpl implements SellerMpIvDeliveryRecordRegDao {
	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvDeliveryRecordRegDaoImpl.class);

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> pMap) {
		return sqlSessionTemplate.selectList("seller.mpiv.selectSellerMpIvDeliveryRecordRegList", pMap);
	}
	@Override
	public List<Map<String, String>> getSellerMpIvDeliveryRecordRegList_v2(Map<String, Object> pMap) {
		List<String> list = CommonUtil.getStringArrary((String)pMap.get("st_po_no"), ",");
		if(list.size() != 0){
			pMap.put("st_po_no", list);
		}
		return sqlSessionTemplate.selectList("seller.mpiv.getSellerMpIvDeliveryRecordRegList_v2", pMap);
	}
	@Override
	public List<Map<String, String>> getSellerMpIvDeliveryRecordRegList_v3(Map<String, Object> pMap) {
		List<String> list = CommonUtil.getStringArrary((String)pMap.get("st_po_no"), ",");
		if(list.size() != 0){
			pMap.put("st_po_no", list);
		}
		return sqlSessionTemplate.selectList("seller.mpiv.getSellerMpIvDeliveryRecordRegList_v3", pMap);
	}
	
	//납품완료 조회
	@Override
	public List<Map<String, String>> getSellerMpIvDeliveryRecordRegEndList_v2(Map<String, Object> pMap) {
		List<String> list = CommonUtil.getStringArrary((String)pMap.get("st_po_no"), ",");
		if(list.size() != 0){
			pMap.put("st_po_no", list);
		}
		return sqlSessionTemplate.selectList("seller.mpiv.getSellerMpIvDeliveryRecordRegEndList_v2", pMap);
	}
	@Override
	public List<Map<String, String>> getSellerMpIvDeliveryRecordRegEndList_v3(Map<String, Object> pMap) {
		List<String> list = CommonUtil.getStringArrary((String)pMap.get("st_po_no"), ",");
		if(list.size() != 0){
			pMap.put("st_po_no", list);
		}
		return sqlSessionTemplate.selectList("seller.mpiv.getSellerMpIvDeliveryRecordRegEndList_v3", pMap);
	}
	
	
	// 저장
	public String updateSellerMpIvDeliveryRecordReg(Map<String,String> pMap) {

		String _rtnMsg = "납품실적등록 중 에러가 발생하였습니다.";
		
		Map<String,String> _map = null;
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		
		int res_cnt = 0;
		try{
			
			String query_str	= CommonUtil.nvl(pMap.get("st_query"),"");
			String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
			String _buyer = "";
			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				
				_map = new HashMap<String, String>();
				
				_map.put("buyer", 				str[0]);
				_map.put("po_no", 				str[1]);
				_map.put("po_seq", 				str[2]);
				_map.put("inv_no", 				str[3]);
				_map.put("inv_seq",				str[4]);
				_map.put("delivery_qty",		str[5]);
				_map.put("delivery_date",		str[6]);
				_map.put("image_key",			str[7]);
				_map.put("gr_auto_flag",		str[8]);
				_map.put("st_parcel_com_code",	str[9]);
				_map.put("st_parcel_inv_no",	str[10]);
				_map.put("st_parcel_yn",		str[11]);
				_map.put("st_parcel_changed",	str[12]);
				_map.put("st_user_id",	pMap.get("st_user_id"));
				
				_list.add(_map);
			}
			String grNo = "";
			int _seq = 0;
			for(int i=0; i < _list.size(); i++){

				Map<String,String> mp = (Map<String,String>)_list.get(i);
				// 1. ICOMIVDT UPDATE
				res_cnt = sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordRegIvdt", (Map<String, String>)_list.get(i));
				
				// 2. ICOMPODT UPDATE
				res_cnt = sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordRegPodt", (Map<String, String>)_list.get(i));
				
				// 3. ICOMPOHD SELETC - DOC_TYPE, PROCESS_TYPE
				_map = sqlSessionTemplate.selectOne("seller.mpiv.selectDeliveryRecordRegPohd",(Map<String, String>)_list.get(i));
				
				String doc_type = CommonUtil.nvl(_map.get("DOC_TYPE"));
				String process_type = CommonUtil.nvl(_map.get("PROCESS_TYPE"));
				
				// 4. ICOMIVHD UPDATE - if(docType.trim().equals("X") && processType.trim().equals("0")){ //kepmro 직납의 경우				
				if(doc_type.equals("X") && process_type.equals("0")){
					res_cnt = sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordRegIvhd", (Map<String, String>)_list.get(i));
				}else{
					//이미지키 처리
					res_cnt = sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordRegIvhd2", (Map<String, String>)_list.get(i));
				}
				
				// 협력사 납품 모두 완료 시 납기도래건수 카운트 제외되도록 수정
				res_cnt = sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordRegPors", (Map<String, String>)_list.get(i));
				
				//자동입고 처리여부 Y면 자동입고 처리.
				String st_gr_auto_flag = CommonUtil.nvl(mp.get("gr_auto_flag"),"N");
				logger.debug("st_gr_auto_flag============ : {}", st_gr_auto_flag);
				if(st_gr_auto_flag.equals("Y")){
					//자동입고 생성
					String _grQty = null;
					Map<String,String> _dataGrParam = null;
					_dataGrParam = new HashMap<String,String>() ;
					if(_buyer.equals("")){
						_buyer = mp.get("buyer");
						grNo = getOrderNo(mp.get("buyer"), "GR");
						_seq = 0;
						logger.debug("채번============ : {}", grNo);
					}
					if(!_buyer.equals(mp.get("buyer"))){
						grNo = getOrderNo(mp.get("buyer"), "GR");
						_seq = 0;
						logger.debug("고객사 변경 채번============ : {}", grNo);
					}
					_dataGrParam.put("BUYER", mp.get("buyer"));
					_dataGrParam.put("PO_NO", mp.get("po_no"));
					_dataGrParam.put("PO_SEQ", mp.get("po_seq"));
					_dataGrParam.put("INV_NO", mp.get("inv_no"));
					_dataGrParam.put("INV_SEQ", mp.get("inv_seq"));
					_dataGrParam.put("GR_NO", grNo);
					_dataGrParam.put("GR_SEQ", String.valueOf(_seq+1));
					_dataGrParam.put("GR_DATE", mp.get("delivery_date"));
					//거래명세서 수량가져옴. 해당 수량 그대로 입고데이터 생성.
					String invQty =  getInvQty(mp.get("buyer"),mp.get("inv_no"),mp.get("inv_seq"));
					_dataGrParam.put("GR_QTY", invQty);
					_seq++;
					// 입고등록 전 입고가능수량 체크 후 INSERT
					_grQty = (String)sqlSessionTemplate.selectOne("seller.mpiv.selectMasterMpSoSellerGrQtyCheck", _dataGrParam);
					logger.debug("_grQty ==>> " + _grQty);
					if(Integer.parseInt(_grQty) > 0){
						_rtnMsg = (i+1)+"번째 입고수량이 송장수량보다 많을 수 없습니다.\n 고객사 입고 취소 후 등록 가능합니다.";
						throw new RuntimeException(_rtnMsg);
					} else {
						//입고생성
						res_cnt = sqlSessionTemplate.insert("seller.mpiv.insertMasterMpSoSellerWarhsngProcGrdt", _dataGrParam);
						//UPDATE ICOMPODT
						res_cnt = sqlSessionTemplate.insert("seller.mpiv.updateMasterMpSoSellerWarhsngProcPodt", _dataGrParam);
						//UPDATE ICOMIVDT
						res_cnt = sqlSessionTemplate.insert("seller.mpiv.updateMasterMpSoSellerWarhsngProcIvdt", _dataGrParam);
						//UPDATE ICOMIVHD 입고일 업데이트
						res_cnt = sqlSessionTemplate.insert("seller.mpiv.updateMasterMpSoSellerWarhsngProcIvhd", _dataGrParam);
					}
					
				}
			}
				
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
		
	}
	// 저장
	public String updateSellerMpIvDeliveryRecordReg_v2(Map<String,String> pMap) {

		String _rtnMsg = "납품실적등록 중 에러가 발생하였습니다.";
		
		Map<String,String> _map = null;
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		
		int res_cnt = 0;
		try{
			
			String query_str	= CommonUtil.nvl(pMap.get("st_query"),"");
			String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
			String _buyer = "";
			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				
				_map = new HashMap<String, String>();
				
				_map.put("buyer", 				str[0]);
				_map.put("inv_no", 				str[1]);
				_map.put("delivery_date",		str[2]);
				_map.put("image_key",			str[3]);
				_map.put("gr_auto_flag",		str[4]);
				_map.put("st_parcel_com_code",	str[5]);
				_map.put("st_parcel_inv_no",	str[6]);
				_map.put("st_parcel_yn",		str[7]);
				_map.put("st_parcel_changed",	str[8]);
				_map.put("st_user_id",	pMap.get("st_user_id"));
				
				_list.add(_map);
			}
			String grNo = "";
			int _seq = 0;
			for(int i=0; i < _list.size(); i++){
				Map<String,String> mp = (Map<String,String>)_list.get(i);
				if(mp.get("st_parcel_yn").equals("Y")){ //택배면 택배사정보만 저장
					mp.put("parcel_com_code", mp.get("st_parcel_com_code"));
					mp.put("parcel_inv_no", mp.get("st_parcel_inv_no"));
					sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordParcelRegIvhd", mp);
				}else{ //자차면 전부 처리
					//IVDT에서 iv_seq ,po_no, po_seq 를 가져옴
					List<Map<String,String>> ivdtList = sqlSessionTemplate.selectList("seller.mpiv.selectDeliveryRecordRegIvdt",mp);
					for(int j = 0; j<ivdtList.size(); j++){
						mp.put("inv_seq", ivdtList.get(j).get("INV_SEQ"));
						mp.put("po_no", ivdtList.get(j).get("PO_NO"));
						mp.put("po_seq", ivdtList.get(j).get("PO_SEQ"));
						// 1. ICOMIVDT UPDATE
						res_cnt = sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordRegIvdt", mp);
						
						// 2. ICOMPODT UPDATE
						res_cnt = sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordRegPodt", mp);
						
						// 3. ICOMPOHD SELETC - DOC_TYPE, PROCESS_TYPE
						_map = sqlSessionTemplate.selectOne("seller.mpiv.selectDeliveryRecordRegPohd",mp);
						
						String doc_type = CommonUtil.nvl(_map.get("DOC_TYPE"));
						String process_type = CommonUtil.nvl(_map.get("PROCESS_TYPE"));
						
						// 4. ICOMIVHD UPDATE - if(docType.trim().equals("X") && processType.trim().equals("0")){ //kepmro 직납의 경우				
						if(doc_type.equals("X") && process_type.equals("0")){
							res_cnt = sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordRegIvhd", mp);
						}else{
							//이미지키 처리
							res_cnt = sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordRegIvhd2", mp);
						}
						
						// 협력사 납품 모두 완료 시 납기도래건수 카운트 제외되도록 수정
						res_cnt = sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordRegPors", mp);
						
						//자동입고 처리여부 Y면 자동입고 처리.
						String st_gr_auto_flag = CommonUtil.nvl(mp.get("gr_auto_flag"),"N");
						logger.debug("st_gr_auto_flag============ : {}", st_gr_auto_flag);
						if(st_gr_auto_flag.equals("Y")){
							//자동입고 생성
							String _grQty = null;
							Map<String,String> _dataGrParam = null;
							_dataGrParam = new HashMap<String,String>() ;
							if(_buyer.equals("")){
								_buyer = mp.get("buyer");
								grNo = getOrderNo(mp.get("buyer"), "GR");
								_seq = 0;
								logger.debug("채번============ : {}", grNo);
							}
							if(!_buyer.equals(mp.get("buyer"))){
								grNo = getOrderNo(mp.get("buyer"), "GR");
								_seq = 0;
								logger.debug("고객사 변경 채번============ : {}", grNo);
							}
							_dataGrParam.put("BUYER", mp.get("buyer"));
							_dataGrParam.put("PO_NO", mp.get("po_no"));
							_dataGrParam.put("PO_SEQ", mp.get("po_seq"));
							_dataGrParam.put("INV_NO", mp.get("inv_no"));
							_dataGrParam.put("INV_SEQ", mp.get("inv_seq"));
							_dataGrParam.put("GR_NO", grNo);
							_dataGrParam.put("GR_SEQ", String.valueOf(_seq+1));
							_dataGrParam.put("GR_DATE", mp.get("delivery_date"));
							//거래명세서 수량가져옴. 해당 수량 그대로 입고데이터 생성.
							String invQty =  getInvQty(mp.get("buyer"),mp.get("inv_no"),mp.get("inv_seq"));
							_dataGrParam.put("GR_QTY", invQty);
							_seq++;
							// 입고등록 전 입고가능수량 체크 후 INSERT
							_grQty = (String)sqlSessionTemplate.selectOne("seller.mpiv.selectMasterMpSoSellerGrQtyCheck", _dataGrParam);
							logger.debug("_grQty ==>> " + _grQty);
							if(Integer.parseInt(_grQty) > 0){
								_rtnMsg = (i+1)+"번째 입고수량이 송장수량보다 많을 수 없습니다.\n 고객사 입고 취소 후 등록 가능합니다.";
								throw new RuntimeException(_rtnMsg);
							} else {
								//입고생성
								res_cnt = sqlSessionTemplate.insert("seller.mpiv.insertMasterMpSoSellerWarhsngProcGrdt", _dataGrParam);
								//UPDATE ICOMPODT
								res_cnt = sqlSessionTemplate.insert("seller.mpiv.updateMasterMpSoSellerWarhsngProcPodt", _dataGrParam);
								//UPDATE ICOMIVDT
								res_cnt = sqlSessionTemplate.insert("seller.mpiv.updateMasterMpSoSellerWarhsngProcIvdt", _dataGrParam);
								//UPDATE ICOMIVHD 입고일 업데이트
								res_cnt = sqlSessionTemplate.insert("seller.mpiv.updateMasterMpSoSellerWarhsngProcIvhd", _dataGrParam);
							}
						}
					}
				}
			}
				
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
		
	}
	public String updateSellerMpIvDeliveryRecordReg_v3(Map<String,String> pMap) {

		String _rtnMsg = "납품실적등록 중 에러가 발생하였습니다.";
		
		Map<String,String> _map = null;
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		
		int res_cnt = 0;
		try{
			
			String query_str	= CommonUtil.nvl(pMap.get("st_query"),"");
			String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
			String _buyer = "";
			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				
				_map = new HashMap<String, String>();
				
				_map.put("buyer", 				str[0]);
				_map.put("inv_no", 				str[1]);
				_map.put("delivery_date",		str[2]);
				_map.put("image_key",			str[3]);
				_map.put("gr_auto_flag",		str[4]);
				_map.put("st_parcel_com_code",	str[5]);
				_map.put("st_parcel_inv_no",	str[6]);
				_map.put("st_parcel_yn",		str[7]);
				_map.put("st_parcel_changed",	str[8]);
				_map.put("st_user_id",	pMap.get("st_user_id"));
				
				_list.add(_map);
			}
			String grNo = "";
			int _seq = 0;
			for(int i=0; i < _list.size(); i++){
				Map<String,String> mp = (Map<String,String>)_list.get(i);
				if(mp.get("st_parcel_yn").equals("Y")){ //택배면 택배사정보만 저장
					mp.put("parcel_com_code", mp.get("st_parcel_com_code"));
					mp.put("parcel_inv_no", mp.get("st_parcel_inv_no"));
					sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordParcelRegIvhd", mp);
					List<Map<String,String>> ivdtList = sqlSessionTemplate.selectList("seller.mpiv.selectDeliveryRecordRegIvdt",mp);
					for(int j = 0; j<ivdtList.size(); j++){
						mp.put("inv_seq", ivdtList.get(j).get("INV_SEQ"));
						sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordParcelRegIvdt_v3", mp);
					}
				}else{ //자차면 전부 처리
					//IVDT에서 iv_seq ,po_no, po_seq 를 가져옴
					List<Map<String,String>> ivdtList = sqlSessionTemplate.selectList("seller.mpiv.selectDeliveryRecordRegIvdt",mp);
					for(int j = 0; j<ivdtList.size(); j++){
						mp.put("inv_seq", ivdtList.get(j).get("INV_SEQ"));
						mp.put("po_no", ivdtList.get(j).get("PO_NO"));
						mp.put("po_seq", ivdtList.get(j).get("PO_SEQ"));
						// 1. ICOMIVDT UPDATE
						res_cnt = sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordRegIvdt", mp);
						
						// 2. ICOMPODT UPDATE
						res_cnt = sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordRegPodt", mp);
						
						// 3. ICOMPOHD SELETC - DOC_TYPE, PROCESS_TYPE
						_map = sqlSessionTemplate.selectOne("seller.mpiv.selectDeliveryRecordRegPohd",mp);
						
						String doc_type = CommonUtil.nvl(_map.get("DOC_TYPE"));
						String process_type = CommonUtil.nvl(_map.get("PROCESS_TYPE"));
						
						// 4. ICOMIVHD UPDATE - if(docType.trim().equals("X") && processType.trim().equals("0")){ //kepmro 직납의 경우				
						if(doc_type.equals("X") && process_type.equals("0")){
							res_cnt = sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordRegIvhd", mp);
						}else{
							//이미지키 처리
							res_cnt = sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordRegIvhd2", mp);
						}
						
						// 협력사 납품 모두 완료 시 납기도래건수 카운트 제외되도록 수정
						res_cnt = sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordRegPors", mp);
						
						//자동입고 처리여부 Y면 자동입고 처리.
						String st_gr_auto_flag = CommonUtil.nvl(mp.get("gr_auto_flag"),"N");
						logger.debug("st_gr_auto_flag============ : {}", st_gr_auto_flag);
						if(st_gr_auto_flag.equals("Y")){
							//자동입고 생성
							String _grQty = null;
							Map<String,String> _dataGrParam = null;
							_dataGrParam = new HashMap<String,String>() ;
							if(_buyer.equals("")){
								_buyer = mp.get("buyer");
								grNo = getOrderNo(mp.get("buyer"), "GR");
								_seq = 0;
								logger.debug("채번============ : {}", grNo);
							}
							if(!_buyer.equals(mp.get("buyer"))){
								grNo = getOrderNo(mp.get("buyer"), "GR");
								_seq = 0;
								logger.debug("고객사 변경 채번============ : {}", grNo);
							}
							_dataGrParam.put("BUYER", mp.get("buyer"));
							_dataGrParam.put("PO_NO", mp.get("po_no"));
							_dataGrParam.put("PO_SEQ", mp.get("po_seq"));
							_dataGrParam.put("INV_NO", mp.get("inv_no"));
							_dataGrParam.put("INV_SEQ", mp.get("inv_seq"));
							_dataGrParam.put("GR_NO", grNo);
							_dataGrParam.put("GR_SEQ", String.valueOf(_seq+1));
							_dataGrParam.put("GR_DATE", mp.get("delivery_date"));
							//거래명세서 수량가져옴. 해당 수량 그대로 입고데이터 생성.
							String invQty =  getInvQty(mp.get("buyer"),mp.get("inv_no"),mp.get("inv_seq"));
							_dataGrParam.put("GR_QTY", invQty);
							_seq++;
							// 입고등록 전 입고가능수량 체크 후 INSERT
							_grQty = (String)sqlSessionTemplate.selectOne("seller.mpiv.selectMasterMpSoSellerGrQtyCheck", _dataGrParam);
							logger.debug("_grQty ==>> " + _grQty);
							if(Integer.parseInt(_grQty) > 0){
								_rtnMsg = (i+1)+"번째 입고수량이 송장수량보다 많을 수 없습니다.\n 고객사 입고 취소 후 등록 가능합니다.";
								throw new RuntimeException(_rtnMsg);
							} else {
								//입고생성
								res_cnt = sqlSessionTemplate.insert("seller.mpiv.insertMasterMpSoSellerWarhsngProcGrdt", _dataGrParam);
								//UPDATE ICOMPODT
								res_cnt = sqlSessionTemplate.insert("seller.mpiv.updateMasterMpSoSellerWarhsngProcPodt", _dataGrParam);
								//UPDATE ICOMIVDT
								res_cnt = sqlSessionTemplate.insert("seller.mpiv.updateMasterMpSoSellerWarhsngProcIvdt", _dataGrParam);
								//UPDATE ICOMIVHD 입고일 업데이트
								res_cnt = sqlSessionTemplate.insert("seller.mpiv.updateMasterMpSoSellerWarhsngProcIvhd", _dataGrParam);
							}
						}
					}
				}
			}
				
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException(_rtnMsg);
		}
		
		return _rtnMsg;
		
	}

	// 택배사정보저장
	public String updateSellerMpIvDeliveryRecordParcelReg(Map<String,String>  pMap){

		String _rtnMsg = "";
		Map<String,String> _map = null;
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		
		try{
			
			String query_str	= CommonUtil.nvl(pMap.get("st_query"),"");
			String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
			
			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				
				_map = new HashMap<String, String>();
				
				_map.put("buyer", 			str[0]);
				_map.put("inv_no", 			str[1]);
				_map.put("parcel_com_code",	str[2]);
				_map.put("parcel_inv_no",	str[3]);
				_map.put("st_user_id",		pMap.get("st_user_id"));
				
				_list.add(_map);
			}
			
			for(int i=0; i < _list.size(); i++){
				
				// ICOMIVHD UPDATE				
				sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordParcelRegIvhd", (Map<String, String>)_list.get(i));
			}
				
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("택배사정보 저장 중 에러가 발생하였습니다.");
		}
		
		return _rtnMsg;
	}
		
	//채번
	public String getOrderNo(String comCode, String docType){

		String orderNo = "";
		Map<String,String> _map = new HashMap<String,String>();
		
		try{
			
			_map.put("st_com_code", comCode);
			_map.put("st_doc_type", docType);
			
			// 기존 고객사화면에서 사용하는 쿼리 사용
			orderNo = CommonUtil.nvl((String)sqlSessionTemplate.selectOne("buyer.wmgr.selectBuyerWmGrWarehousingGrNo", _map));
			
			if(orderNo.equals("")){
				sqlSessionTemplate.insert("buyer.wmgr.insertBuyerWmGrWarehousingGrNo", _map);
				
				orderNo = "" + Calendar.getInstance().get(Calendar.YEAR);
				orderNo = _map.get("st_doc_type") + orderNo.substring(2,4) + "000001";
				
			} else {
				sqlSessionTemplate.update("buyer.wmgr.updateBuyerWmGrWarehousingGrNo", _map);
			}
			
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("입고번호 생성 중 에러가 발생하였습니다.");
		}
		
		return orderNo;
	}
	//채번
	public String getInvQty(String buyer, String invioce, String invioceSeq){

		String invQty = "";
		Map<String,String> _map = new HashMap<String,String>();
		
		try{
			
			_map.put("buyer", buyer);
			_map.put("invioce", invioce);
			_map.put("invioceSeq", invioceSeq);
			
			invQty = CommonUtil.nvl((String)sqlSessionTemplate.selectOne("seller.mpiv.selectMasterMpSoSellerInvQty", _map));
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("입고번호 생성 중 에러가 발생하였습니다.");
		}
		
		return invQty;
	}
	
	// 거래명세서 삭제
	public String delSellerMpIvDeliveryRecordInvoiceList_v2(Map<String,String>  pMap){
		
		String _rtnMsg = "";
		Map<String, String> map;
		Map<String, String> map_hd;
		List<Map<String, String>> list	= new ArrayList<Map<String, String>>();
		
		int res_cnt = 0;
		
		try{
			
//			String seller		= CommonUtil.nvl(pMap.get("st_seller"),"");
			String user_id		= CommonUtil.nvl(pMap.get("st_user_id"),"");
			String query_str	= CommonUtil.nvl(pMap.get("st_query"),"");
			
			String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
			
			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				
				map = new HashMap<String, String>();
				
				map.put("buyer", 	str[0]);
				map.put("inv_no", 	str[1]);
				map.put("ds_date", 	str[2]);
				map.put("seller", 	str[3]);
				map.put("user_id", 	user_id);
						
				list.add(map);
			}
			
			map_hd = list.get(0);
			for(int i=0; i < list.size(); i++){
				Map<String,String> _map = list.get(i);
			
				// 거래명세서 삭제 전 입고여부 확인 후 삭제처리
				String del_chk = sqlSessionTemplate.selectOne("seller.mpiv.selectMpIvTranStatementDeleteCheck_v2", _map);
				
				if(del_chk.equals("00")){
					_rtnMsg = "납품실적이나 입고수량이 등록된 건입니다. 거래명세서 삭제를 할 수 없습니다.";
					
				} else {
					//IVDT에서 iv_seq ,po_no, po_seq 를 가져옴
					List<Map<String,String>> ivdtList = sqlSessionTemplate.selectList("seller.mpiv.selectDeliveryRecordRegIvdt",_map);
					
					for(int j = 0 ;j<ivdtList.size(); j++){
						_map.put("inv_seq", ivdtList.get(j).get("INV_SEQ"));
						_map.put("po_no", ivdtList.get(j).get("PO_NO"));
						_map.put("po_seq", ivdtList.get(j).get("PO_SEQ"));
						
						// 1. ICOMIVDT
						res_cnt = sqlSessionTemplate.update("seller.mpiv.deleteTranStatementIvdt_v2", _map);
						
						// 2. ICOMIVHD
						res_cnt = sqlSessionTemplate.update("seller.mpiv.deleteTranStatementIvhd_v2", _map);
		
						// 3. ICOMPORS
						res_cnt = sqlSessionTemplate.update("seller.mpiv.deleteTranStatementPors_v2", _map);
						
						// 4. ICOMPODT
						res_cnt = sqlSessionTemplate.update("seller.mpiv.deleteTranStatementPodt_v2", _map);
					
						// 5. ICOMPOHD
						res_cnt = sqlSessionTemplate.update("seller.mpiv.deleteTranStatementPohd_v2", _map);
					}
				}
			}
			
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("거래명세서 삭제가 실패하였습니다. 다시 한번 확인해 주시기 바랍니다.");
		}
		
		return _rtnMsg;	
	}
	
	public String updateSellerMpIvDeliveryRecordDeleteList_v2(Map<String,String> pMap){

		String _rtnMsg = "";
		Map<String,String> _map = null;
		List<Map<String,String>> _list = new ArrayList<Map<String,String>>();
		
		try{
			
			String query_str	= CommonUtil.nvl(pMap.get("st_query"),"");
			String check_str[]  = CommonUtil.StrToArray(query_str , "^||^");
			
			for(int i=0 ; i < check_str.length; i++){
				String str[] = check_str[i].split("@@",-1);
				
				_map = new HashMap<String, String>();
				
				_map.put("buyer", 			str[0]);
				_map.put("inv_no", 			str[1]);
				
				_list.add(_map);
			}
			
			for(int i=0; i < _list.size(); i++){
				Map<String,String> mp = _list.get(i);
				List<Map<String,String>> ivdtList = sqlSessionTemplate.selectList("seller.mpiv.selectDeliveryRecordRegIvdt",mp);
				for(int j = 0; j<ivdtList.size(); j++){
					mp.put("inv_seq", ivdtList.get(j).get("INV_SEQ"));
					mp.put("po_no", ivdtList.get(j).get("PO_NO"));
					mp.put("po_seq", ivdtList.get(j).get("PO_SEQ"));
					
					// 1. ICOMIVDT UPDATE
					sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordDeleteIvdt_v2", mp);
					
					// 2. ICOMPODT UPDATE
					sqlSessionTemplate.update("seller.mpiv.updateDeliveryRecordDeletePodt", mp);
				}
			}
				
		}catch(Exception e){
			logger.error("SQL ERROR : ", e);
			throw new RuntimeException("납품실적삭제 중 에러가 발생하였습니다.");
		}
		
		return _rtnMsg;
	}
}
