package com.koreab2b.mro.common.mpiv.controller;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mpiv.service.SellerMpIvTranStatementWritePopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvTranStatementWritePopController")
public class SellerMpIvTranStatementWritePopController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvTranStatementWritePopController.class);

	@Autowired
	private SellerMpIvTranStatementWritePopService sellerMpIvTranStatementWritePopService;
	
	/**
	 * 거래명세서작성 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getSellerMpIvTranStatementWritePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpIvTranStatementWritePop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getSellerMpIvTranStatementWritePop.do 요청 파라미터 for jsp : {}", pMap);
		

//		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
//		
//		pMap.put("st_user_id", _sessionInfo.getUserId()); // 사용자ID TEST
		
		// 거래명세서작성 기본정보조회
		Map<String,String> detailInfo = sellerMpIvTranStatementWritePopService.getInfo(pMap);
		
//		Map<String,String> map = (Map<String,String>)CommonUtil.getListNvl(detailInfo).get(0);
		
		
		pModel.addAttribute("info", detailInfo);
		

        logger.debug("SellerMpIvTranStatementWritePopController 거래명세서작성 기본정보조회 출력 start ====================");
        
        Set<String> keySet = detailInfo.keySet();
        Iterator<String> iterator = keySet.iterator();
        
        while(iterator.hasNext()){
        	String key = iterator.next();
        	String value = detailInfo.get(key);
        	logger.debug("key : "+key+", value : "+value);
        }
        
        logger.debug("SellerMpIvTranStatementWritePopController 거래명세서작성 기본정보조회 출력 end ====================");
        
        
        
		// 거래명세서작성 리스트조회
		List<Map<String, String>> _data = sellerMpIvTranStatementWritePopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		// 물류센터 고객사 체크
		String w001Flag = sellerMpIvTranStatementWritePopService.getW001Flag(pMap); 
		pModel.addAttribute("w001flag", w001Flag);
		
		
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mpiv/sellerMpIvTranStatementWritePop";
	}
	@RequestMapping(value = "/mpiv/showSellerMpIvTranStatementWritePop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvTranStatementWritePop_v2(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/showSellerMpIvTranStatementWritePop_v2.do 요청 파라미터 for jsp : {}", pMap);
		

		// 거래명세서작성 기본정보조회
		Map<String,String> detailInfo = sellerMpIvTranStatementWritePopService.getInfo(pMap);
		pModel.addAttribute("info", detailInfo);
		

        logger.debug("SellerMpIvTranStatementWritePopController 거래명세서작성 기본정보조회 출력 start ====================");
        
        Set<String> keySet = detailInfo.keySet();
        Iterator<String> iterator = keySet.iterator();
        
        while(iterator.hasNext()){
        	String key = iterator.next();
        	String value = detailInfo.get(key);
        	logger.debug("key : "+key+", value : "+value);
        }
        
        logger.debug("SellerMpIvTranStatementWritePopController 거래명세서작성 기본정보조회 출력 end ====================");
		
		// 물류센터 고객사 체크
		String w001Flag = sellerMpIvTranStatementWritePopService.getW001Flag(pMap); 
		pModel.addAttribute("w001flag", w001Flag);
		
		
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mpiv/sellerMpIvTranStatementWritePop_v2";
	}
	@RequestMapping(value = "/mpiv/showSellerMpIvTranStatementWritePop_v3.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvTranStatementWritePop_v3(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/showSellerMpIvTranStatementWritePop_v3.do 요청 파라미터 for jsp : {}", pMap);
		

		// 거래명세서작성 기본정보조회
		Map<String,String> detailInfo = sellerMpIvTranStatementWritePopService.getInfo(pMap);
		pModel.addAttribute("info", detailInfo);
		

        logger.debug("SellerMpIvTranStatementWritePopController 거래명세서작성 기본정보조회 출력 start ====================");
        
        Set<String> keySet = detailInfo.keySet();
        Iterator<String> iterator = keySet.iterator();
        
        while(iterator.hasNext()){
        	String key = iterator.next();
        	String value = detailInfo.get(key);
        	logger.debug("key : "+key+", value : "+value);
        }
        
        logger.debug("SellerMpIvTranStatementWritePopController 거래명세서작성 기본정보조회 출력 end ====================");
		
		// 물류센터 고객사 체크
		String w001Flag = sellerMpIvTranStatementWritePopService.getW001Flag(pMap); 
		pModel.addAttribute("w001flag", w001Flag);
		
		
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mpiv/sellerMpIvTranStatementWritePop_v3";
	}
	@RequestMapping(value = "/mpiv/getSellerMpIvTranStatementWritePop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpIvTranStatementWritePop_v2(HttpServletRequest req,ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("getSellerMpIvTranStatementWritePop_v2 요청 파라미터 : {}", pMap);
		
		// 거래명세서작성 리스트조회
		List<Map<String, String>> _data = sellerMpIvTranStatementWritePopService.getSellerMpIvTranStatementWritePop_v2(pMap); 
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
	
	
	/**
	 * 구매사 차량정보 입력 유무 확인.
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/getSellerMpivBuyerCarInfo.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpivBuyerCarInfo(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getSellerMpivBuyerCarInfo.do 요청 파라미터 for jsp : {}", pMap);
		
		// 구매사 차량정보 입력유무 조회
		String car_flag = sellerMpIvTranStatementWritePopService.getSellerMpivBuyerCarInfo(pMap);
		
		//pModel.addAttribute("info", (Map<String,String>)CommonUtil.getListNvl(carInfo).get(0));
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		_response.put("car_flag", car_flag );
		
		return _response;
	}
	

	/**
	 * 거래명세서 작성 저장
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/saveSellerMpIvTranStatementWritePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> saveSellerMpIvTranStatementWritePop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/saveSellerMpIvTranStatementWritePop.do 요청 파라미터 for jsp : {}", pMap); 
		
//		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		Map<String, String> _response = new HashMap<String, String>();
		
//		Parameters =  [ {
//		  st_query	= 	KRKITU0003@@PO14000014@@000001@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000002@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000003@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000004@@50@@20140620@@20140613@@Y^||^
//		, st_seller=KRKORE0001
//		, st_process_type=0
//		, st_inv_amt=
//		, st_inv_tax_amt=
//		, st_inv_tax_rate=
//		, st_inv_tot_amt=
//		, st_legacy_po_no=N
//		, st_inv_no=
//		, st_type=
//		, st_car_info=
//		, st_car_flag=N
//		, inv_amt=324500
//		, inv_tax_amt=32450
//		, inv_tax_rate=0.1
//		, st_invoice_date_text=2014/06/20
//		, inv_tot_amt=356950
//		, st_remark=
//		, st_buyer=KRKITU0003
//		, st_po_no=PO14000014
//		, st_ds_date=20140613
//		, st_po_seq=000001
//		, st_cd_qty=50
//		, st_po_qty=100
//		, st_iv_qty=50
//		, st_iv_cre_check=1
//		, checkbox0=, checkbox1=, checkbox2=, checkbox3=
//		, display_item_cnt=4
//		, legacy_po_seq_tot=@@@@@@@@
//		, st_pur_id=LKDSPQ09
//		, st_inv_data=}, ]
				

//		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
//		pMap.put("user_id", _sessionInfo.getUserId()); // 사용자ID TEST	
				
		_response = sellerMpIvTranStatementWritePopService.saveSellerMpIvTranStatementWritePop(CommonUtil.removeSlash(pMap));
		
//		_response.put("msg", flag);
				
		return _response;
	}
	@RequestMapping(value = "/mpiv/saveSellerMpIvTranStatementWritePop_v3.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> saveSellerMpIvTranStatementWritePop_v3(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/saveSellerMpIvTranStatementWritePop_v3.do 요청 파라미터 for jsp : {}", pMap); 
		
//		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		Map<String, String> _response = new HashMap<String, String>();
		
//		Parameters =  [ {
//		  st_query	= 	KRKITU0003@@PO14000014@@000001@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000002@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000003@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000004@@50@@20140620@@20140613@@Y^||^
//		, st_seller=KRKORE0001
//		, st_process_type=0
//		, st_inv_amt=
//		, st_inv_tax_amt=
//		, st_inv_tax_rate=
//		, st_inv_tot_amt=
//		, st_legacy_po_no=N
//		, st_inv_no=
//		, st_type=
//		, st_car_info=
//		, st_car_flag=N
//		, inv_amt=324500
//		, inv_tax_amt=32450
//		, inv_tax_rate=0.1
//		, st_invoice_date_text=2014/06/20
//		, inv_tot_amt=356950
//		, st_remark=
//		, st_buyer=KRKITU0003
//		, st_po_no=PO14000014
//		, st_ds_date=20140613
//		, st_po_seq=000001
//		, st_cd_qty=50
//		, st_po_qty=100
//		, st_iv_qty=50
//		, st_iv_cre_check=1
//		, checkbox0=, checkbox1=, checkbox2=, checkbox3=
//		, display_item_cnt=4
//		, legacy_po_seq_tot=@@@@@@@@
//		, st_pur_id=LKDSPQ09
//		, st_inv_data=}, ]
				

//		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
//		pMap.put("user_id", _sessionInfo.getUserId()); // 사용자ID TEST	
				
		_response = sellerMpIvTranStatementWritePopService.saveSellerMpIvTranStatementWritePop_v3(CommonUtil.removeSlash(pMap));
		
//		_response.put("msg", flag);
				
		return _response;
	}
	
	

	/**
	 * 거래명세서작성 조회 - TYPE3  분할납품가능 화면
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getSellerMpIvTranStatementWriteDoosanmecaPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpIvTranStatementWriteDoosanmecaPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getSellerMpIvTranStatementWriteDoosanmecaPop.do 요청 파라미터 for jsp : {}", pMap);
		

//		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
//		
//		pMap.put("st_user_id", _sessionInfo.getUserId()); // 사용자ID TEST
		
		// 거래명세서작성 기본정보조회
		Map<String,String> detailInfo = sellerMpIvTranStatementWritePopService.getInfo(pMap);
		
//		Map<String,String> map = (Map<String,String>)CommonUtil.getListNvl(detailInfo).get(0);
		
		
		pModel.addAttribute("info", detailInfo);
		

        logger.debug("getSellerMpIvTranStatementWriteDoosanmecaPop 거래명세서작성 기본정보조회 출력 start ====================");
        
        Set<String> keySet = detailInfo.keySet();
        Iterator<String> iterator = keySet.iterator();
        
        while(iterator.hasNext()){
        	String key = iterator.next();
        	String value = detailInfo.get(key);
        	logger.debug("key : "+key+", value : "+value);
        }
        
        logger.debug("getSellerMpIvTranStatementWriteDoosanmecaPop 거래명세서작성 기본정보조회 출력 end ====================");
        
        
		// 거래명세서작성 리스트조회
		List<Map<String, String>> _data = sellerMpIvTranStatementWritePopService.getDoosanmecaList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		// 물류센터 고객사 체크
		String w001Flag = sellerMpIvTranStatementWritePopService.getW001Flag(pMap); 
		pModel.addAttribute("w001flag", w001Flag);
		
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mpiv/sellerMpIvTranStatementWriteDoosanmecaPop";
	}
	
	@RequestMapping(value = "/mpiv/showSellerMpIvTranStatementWriteDoosanmecaPop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvTranStatementWriteDoosanmecaPop_v2(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/showSellerMpIvTranStatementWriteDoosanmecaPop_v2.do 요청 파라미터 for jsp : {}", pMap);
		

		// 거래명세서작성 기본정보조회
		Map<String,String> detailInfo = sellerMpIvTranStatementWritePopService.getInfo(pMap);
		
		pModel.addAttribute("info", detailInfo);
		

        logger.debug("getSellerMpIvTranStatementWriteDoosanmecaPop 거래명세서작성 기본정보조회 출력 start ====================");
        
        Set<String> keySet = detailInfo.keySet();
        Iterator<String> iterator = keySet.iterator();
        
        while(iterator.hasNext()){
        	String key = iterator.next();
        	String value = detailInfo.get(key);
        	logger.debug("key : "+key+", value : "+value);
        }
        
        logger.debug("getSellerMpIvTranStatementWriteDoosanmecaPop 거래명세서작성 기본정보조회 출력 end ====================");
        
		// 물류센터 고객사 체크
		String w001Flag = sellerMpIvTranStatementWritePopService.getW001Flag(pMap); 
		pModel.addAttribute("w001flag", w001Flag);
		
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mpiv/sellerMpIvTranStatementWriteDoosanmecaPop_v2";
	}
	@RequestMapping(value = "/mpiv/showSellerMpIvTranStatementWriteDoosanmecaPop_v3.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvTranStatementWriteDoosanmecaPop_v3(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/showSellerMpIvTranStatementWriteDoosanmecaPop_v3.do 요청 파라미터 for jsp : {}", pMap);
		

		// 거래명세서작성 기본정보조회
		Map<String,String> detailInfo = sellerMpIvTranStatementWritePopService.getInfo(pMap);
		
		pModel.addAttribute("info", detailInfo);
		

        logger.debug("getSellerMpIvTranStatementWriteDoosanmecaPop 거래명세서작성 기본정보조회 출력 start ====================");
        
        Set<String> keySet = detailInfo.keySet();
        Iterator<String> iterator = keySet.iterator();
        
        while(iterator.hasNext()){
        	String key = iterator.next();
        	String value = detailInfo.get(key);
        	logger.debug("key : "+key+", value : "+value);
        }
        
        logger.debug("getSellerMpIvTranStatementWriteDoosanmecaPop 거래명세서작성 기본정보조회 출력 end ====================");
        
		// 물류센터 고객사 체크
		String w001Flag = sellerMpIvTranStatementWritePopService.getW001Flag(pMap); 
		pModel.addAttribute("w001flag", w001Flag);
		
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mpiv/sellerMpIvTranStatementWriteDoosanmecaPop_v3";
	}
	@RequestMapping(value = "/mpiv/getSellerMpIvTranStatementWriteDoosanmecaPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpIvTranStatementWriteDoosanmecaPop_v2(HttpServletRequest req,ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("getSellerMpIvTranStatementWriteDoosanmecaPop_v2 요청 파라미터 : {}", pMap);
		
		// 거래명세서작성 리스트조회
		List<Map<String, String>> _data = sellerMpIvTranStatementWritePopService.getSellerMpIvTranStatementWriteDoosanmecaPop_v2(pMap); 
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	

	/**
	 * 거래명세서 작성 저장_Doosanmeca
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/saveSellerMpIvTranStatementWriteDoosanmecaPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> saveSellerMpIvTranStatementWriteDoosanmecaPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/saveSellerMpIvTranStatementWriteDoosanmecaPop.do 요청 파라미터 for jsp : {}", pMap); 
		
//		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		Map<String, String> _response = new HashMap<String, String>();
		
//		Parameters =  [ {
//		  st_query	= 	KRKITU0003@@PO14000014@@000001@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000002@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000003@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000004@@50@@20140620@@20140613@@Y^||^
//		, st_seller=KRKORE0001
//		, st_process_type=0
//		, st_inv_amt=
//		, st_inv_tax_amt=
//		, st_inv_tax_rate=
//		, st_inv_tot_amt=
//		, st_legacy_po_no=N
//		, st_inv_no=
//		, st_type=
//		, st_car_info=
//		, st_car_flag=N
//		, inv_amt=324500
//		, inv_tax_amt=32450
//		, inv_tax_rate=0.1
//		, st_invoice_date_text=2014/06/20
//		, inv_tot_amt=356950
//		, st_remark=
//		, st_buyer=KRKITU0003
//		, st_po_no=PO14000014
//		, st_ds_date=20140613
//		, st_po_seq=000001
//		, st_cd_qty=50
//		, st_po_qty=100
//		, st_iv_qty=50
//		, st_iv_cre_check=1
//		, checkbox0=, checkbox1=, checkbox2=, checkbox3=
//		, display_item_cnt=4
//		, legacy_po_seq_tot=@@@@@@@@
//		, st_pur_id=LKDSPQ09
//		, st_inv_data=}, ]
				

//		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
//		pMap.put("user_id", _sessionInfo.getUserId()); // 사용자ID TEST	
				
		_response = sellerMpIvTranStatementWritePopService.saveSellerMpIvTranStatementWriteDoosanmecaPop(CommonUtil.removeSlash(pMap));
		
//		_response.put("msg", flag);
				
		return _response;
	}
	@RequestMapping(value = "/mpiv/saveSellerMpIvTranStatementWriteDoosanmecaPop_v3.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> saveSellerMpIvTranStatementWriteDoosanmecaPop_v3(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/saveSellerMpIvTranStatementWriteDoosanmecaPop_v3.do 요청 파라미터 for jsp : {}", pMap); 
		
//		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		Map<String, String> _response = new HashMap<String, String>();
		
//		Parameters =  [ {
//		  st_query	= 	KRKITU0003@@PO14000014@@000001@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000002@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000003@@50@@20140620@@20140613@@Y^||^
//						KRKITU0003@@PO14000014@@000004@@50@@20140620@@20140613@@Y^||^
//		, st_seller=KRKORE0001
//		, st_process_type=0
//		, st_inv_amt=
//		, st_inv_tax_amt=
//		, st_inv_tax_rate=
//		, st_inv_tot_amt=
//		, st_legacy_po_no=N
//		, st_inv_no=
//		, st_type=
//		, st_car_info=
//		, st_car_flag=N
//		, inv_amt=324500
//		, inv_tax_amt=32450
//		, inv_tax_rate=0.1
//		, st_invoice_date_text=2014/06/20
//		, inv_tot_amt=356950
//		, st_remark=
//		, st_buyer=KRKITU0003
//		, st_po_no=PO14000014
//		, st_ds_date=20140613
//		, st_po_seq=000001
//		, st_cd_qty=50
//		, st_po_qty=100
//		, st_iv_qty=50
//		, st_iv_cre_check=1
//		, checkbox0=, checkbox1=, checkbox2=, checkbox3=
//		, display_item_cnt=4
//		, legacy_po_seq_tot=@@@@@@@@
//		, st_pur_id=LKDSPQ09
//		, st_inv_data=}, ]
				

//		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
//		pMap.put("user_id", _sessionInfo.getUserId()); // 사용자ID TEST	
				
		_response = sellerMpIvTranStatementWritePopService.saveSellerMpIvTranStatementWriteDoosanmecaPop_v3(CommonUtil.removeSlash(pMap));
		
//		_response.put("msg", flag);
				
		return _response;
	}

	/**
	 * 거래명세서작성 조회 - 두산인프라코어용 거래명세서 작성 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getSellerMpIvTranStatementWriteDiPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpIvTranStatementWriteDiPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getSellerMpIvTranStatementWriteDiPop.do 요청 파라미터 for jsp : {}", pMap);
       
		pModel.addAllAttributes(pMap);
		
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mpiv/sellerMpIvTranStatementWriteDiPop_v2";
		} else {
			// 거래명세서작성 리스트조회
			List<Map<String, String>> _data = sellerMpIvTranStatementWritePopService.getDiList(pMap); 
			pModel.addAttribute("data", CommonUtil.getListNvl(_data));
			
			return "common/popup/mpiv/sellerMpIvTranStatementWriteDiPop";
		}
		
	}
	@RequestMapping(value = "/mpiv/getSellerMpIvTranStatementWriteDiPop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpIvTranStatementWriteDiPop_v2(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("/mpiv/getSellerMpIvTranStatementWriteDiPop_v2.do 요청 파라미터 for jsp : {}", pMap);
       
		// 거래명세서작성 리스트조회
		List<Map<String, String>> _data = sellerMpIvTranStatementWritePopService.getSellerMpIvTranStatementWriteDiPop_v2(pMap); 
		
		pModel.addAllAttributes(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	/**
	 * 거래명세서작성 LEGACY_PO_NO 리스트 조회 - 두산인프라코어용 거래명세서 작성 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getSellerMpIvTranStatementWriteDiPoList.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> getSellerMpIvTranStatementWriteDiPoList(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getSellerMpIvTranStatementWriteDiPoList.do 요청 파라미터 for jsp : {}", pMap);
       
		Map<String, String> _response = new HashMap<String, String>();
		
		String _rtnMsg = "";
		String _results = "";
		
		// 거래명세서작성
		List<Map<String, String>> _data = sellerMpIvTranStatementWritePopService.getLegacyPoList(pMap);
		
		int _resCnt = _data.size();
		
		Map<String,String> _rowData = new HashMap<String,String>(); 
				
		if(_resCnt > 0){
			for(int i = 0; i < _resCnt; i++){
				_rowData = _data.get(i);
				
				_results += _rowData.get("LEGACY_PO") + "@@";
				
			}
		}
		
//		_results = "510292929900010@@510293791300010@@510294032500010@@510296332000010@@580004739000010@@580004754100010@@";		
		
//		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
//		pModel.addAllAttributes(pMap);
		
		_response.put("results", _results);
		_response.put("msg", _rtnMsg);
		
		return _response;
	}
	
	@RequestMapping(value = "/mpiv/saveKrdhimInvoice.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> saveKrdhimInvoice(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/saveKrdhimInvoice.do 요청 파라미터 for jsp : {}", pMap);
       
		Map<String, String> _response = new HashMap<String, String>();
		
		String _rtnMsg = "";
//		String _results = "";
		
		/*
		 * Doosan IF Server Type Check
		 */
		// TODO : Dooan If Check
		if ( "2".equals(CommonUtil.getDevRealLocalFlag(req)) ) {
			logger.debug("OP_TYPE : 운영");
			pMap.put("OP_TYPE","3");	// 운영
		} else if ("1".equals(CommonUtil.getDevRealLocalFlag(req))) {
			logger.debug("OP_TYPE : 품질");
			pMap.put("OP_TYPE","1");	// 품질
		} else {
			logger.debug("OP_TYPE : 개발");
			pMap.put("OP_TYPE","1");	// 개발 
		}

		// 거래명세서 작성 성공시 두산인터페이스 
		_rtnMsg = sellerMpIvTranStatementWritePopService.saveKrdhimInvoice(pMap);
		
//		_response.put("results", _results);
		_response.put("msg", _rtnMsg);
		
		return _response;
	}
	
	/**
	 * 물질정보 제출 협력사 요청
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/saveSellerMpIvTranStatementWriteChemicalInfo.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> saveSellerMpIvTranStatementWriteChemicalInfo(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/saveSellerMpIvTranStatementWriteChemicalInfo.do 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String, String> _response = new HashMap<String, String>();
		
		pMap.put("st_query", CommonUtil.nvl(pMap.get("st_msds_query"), pMap.get("st_query"))); // 협력사 거래명세서 작성 일괄에서 st_msds_query 로 사용 
		_response = sellerMpIvTranStatementWritePopService.saveSellerMpIvTranStatementWriteChemicalInfo(CommonUtil.removeSlash(pMap));
		
		return _response;
	}
	
	//품목별 - 거래명세서 생성 팝업
	@RequestMapping(value = "/mpiv/showSellerMpIvTranStatementWriteItemPop_v2.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvTranStatementWriteItemPop_v2(HttpServletRequest request,ModelMap pModel,@RequestParam Map<String, String> pMap) {
		return "common/popup/mpiv/sellerMpIvTranStatementWriteItemPop_v2";
	}
	@RequestMapping(value = "/mpiv/showSellerMpIvTranStatementWriteItemPop_v3.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvTranStatementWriteItemPop_v3(HttpServletRequest request,ModelMap pModel,@RequestParam Map<String, String> pMap) {
		return "common/popup/mpiv/sellerMpIvTranStatementWriteItemPop_v3";
	}
	
	//품목별 - 거래명세서 생성
	@RequestMapping(value = "/mpiv/saveSellerMpIvTranStatementWriteItemPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> saveSellerMpIvTranStatementWriteItemPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/saveSellerMpIvTranStatementWriteItemPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		
		Map<String, String> _response = new HashMap<String, String>();
				
		_response = sellerMpIvTranStatementWritePopService.saveSellerMpIvTranStatementWriteItemPop(CommonUtil.removeSlash(pMap));
		
		return _response;
	}
	@RequestMapping(value = "/mpiv/saveSellerMpIvTranStatementWriteItemPop_v3.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> saveSellerMpIvTranStatementWriteItemPop_v3(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/saveSellerMpIvTranStatementWriteItemPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		
		Map<String, String> _response = new HashMap<String, String>();
				
		_response = sellerMpIvTranStatementWritePopService.saveSellerMpIvTranStatementWriteItemPop_v3(CommonUtil.removeSlash(pMap));
		
		return _response;
	}
	
	//일괄 - 거래명세서 생성 팝업
	@RequestMapping(value = "/mpiv/showSellerMpIvTranStatementWriteAllPop_v2.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvTranStatementWriteAllPop_v2(HttpServletRequest request,ModelMap pModel,@RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/showSellerMpIvTranStatementWriteAllPop_v2.do 요청 파라미터 for jsp : {}", pMap); 
		Map<String, String> _info = new HashMap<String, String>();
		
		List<Map<String, String>> _data = sellerMpIvTranStatementWritePopService.getSellerMpIvTranStatementWriteListItemAll_v2(pMap);
		float tot_amt = 0;	// 총금액
		float seller_amt = 0;	// 공급가액
		float tax_amt = 0;	// 부가세
		
		for (Map<String, String> map : _data) {
			seller_amt += Float.parseFloat(CommonUtil.nvl(String.valueOf(map.get("SELLER_AMT")),"0"));
			tax_amt += Float.parseFloat(CommonUtil.nvl(String.valueOf(map.get("TAX_AMT")),"0"));
		}
		
		tot_amt = seller_amt + tax_amt;
		
		_info = _data.get(0);
		
		_info.put("SELLER_AMT", seller_amt+"");
		_info.put("TAX_AMT", tax_amt+"");
		_info.put("TOT_AMT", tot_amt+"");
		
		pModel.addAttribute("info", _data.get(0));
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mpiv/sellerMpIvTranStatementWriteAllPop_v2";
	}
	@RequestMapping(value = "/mpiv/showSellerMpIvTranStatementWriteAllPop_v3.do", method = {RequestMethod.GET , RequestMethod.POST })
	public String showSellerMpIvTranStatementWriteAllPop_v3(HttpServletRequest request,ModelMap pModel,@RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/showSellerMpIvTranStatementWriteAllPop_v3.do 요청 파라미터 for jsp : {}", pMap); 
		Map<String, String> _info = new HashMap<String, String>();
		
		List<Map<String, String>> _data = sellerMpIvTranStatementWritePopService.getSellerMpIvTranStatementWriteListItemAll_v2(pMap);
		float tot_amt = 0;	// 총금액
		float seller_amt = 0;	// 공급가액
		float tax_amt = 0;	// 부가세
		
		for (Map<String, String> map : _data) {
			seller_amt += Float.parseFloat(CommonUtil.nvl(String.valueOf(map.get("SELLER_AMT")),"0"));
			tax_amt += Float.parseFloat(CommonUtil.nvl(String.valueOf(map.get("TAX_AMT")),"0"));
		}
		
		tot_amt = seller_amt + tax_amt;
		
		_info = _data.get(0);
		
		_info.put("SELLER_AMT", seller_amt+"");
		_info.put("TAX_AMT", tax_amt+"");
		_info.put("TOT_AMT", tot_amt+"");
		
		pModel.addAttribute("info", _data.get(0));
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mpiv/sellerMpIvTranStatementWriteAllPop_v3";
	}
	
	//일괄 - 거래명세서 생성
	@RequestMapping(value = "/mpiv/saveSellerMpIvTranStatementWriteAllPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> saveSellerMpIvTranStatementWriteAllPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/saveSellerMpIvTranStatementWriteAllPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String, String> _response = new HashMap<String, String>();
				
		_response = sellerMpIvTranStatementWritePopService.saveSellerMpIvTranStatementWriteAllPop(CommonUtil.removeSlash(pMap));
		
		return _response;
	}
	@RequestMapping(value = "/mpiv/saveSellerMpIvTranStatementWriteAllPop_v3.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> saveSellerMpIvTranStatementWriteAllPop_v3(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/saveSellerMpIvTranStatementWriteAllPop_v3.do 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String, String> _response = new HashMap<String, String>();
				
		_response = sellerMpIvTranStatementWritePopService.saveSellerMpIvTranStatementWriteAllPop_v3(CommonUtil.removeSlash(pMap));
		
		return _response;
	}
}
