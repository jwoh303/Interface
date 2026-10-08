package com.koreab2b.mro.buyer.mppo.controller;

import java.io.OutputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mppo.service.BuyerMpPoOrderReqReceiptService;
import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoOrderInfoService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpPoOrderReqReceiptController")
public class BuyerMpPoOrderReqReceiptController {
 

	@Autowired
	private BuyerMpPoOrderReqReceiptService buyerMpPoOrderReqReceiptService;
	@Autowired
	private BuyerMpSoOrderInfoService buyerMpSoOrderInfoService;
	// 조회 PG_06_B_016_00
	@RequestMapping(value = "/mppo/getBuyerMpPoOrderReqReceiptList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMpPoOrderReqReceiptList(ModelMap pModel  ,HttpServletRequest req,@RequestParam Map<String, String> pMap) {		
		
	//	logger.debug("/mppo/getBuyerMpPoOrderReqReceiptList.do 요청 파라미터 : {}", pMap);

		

		 SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		 
		// 조회일자 Convert
		String _st_from_date = pMap.get("st_from_date").replace("/", "");
		String _st_to_date = pMap.get("st_to_date").replace("/", "");
		pMap.put("st_from_date",_st_from_date);
		pMap.put("st_to_date",_st_to_date);
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpPoOrderReqReceiptService.getList(pMap);
		
		//선입고발주 제외대상 업체 조회
		String pre_goods_count  = buyerMpSoOrderInfoService.getNotPreGoodsCompany(pMap); 
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("pre_goods_count", pre_goods_count); 
		
		return "buyer/mppo/buyerMpPoOrderReqReceiptList";
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mppo/excelBuyerMpPoOrderReqReceiptList.do", method = RequestMethod.POST)
	public void excelBuyerMpPoOrderReqReceiptList(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		
		String _st_from_date = pMap.get("st_from_date").replace("/", "");
		String _st_to_date = pMap.get("st_to_date").replace("/", "");
		pMap.put("st_from_date",_st_from_date);
		pMap.put("st_to_date",_st_to_date);
		
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerMpPoOrderReqReceiptService.getList(pMap);  
		
		String title = "고객사명|요청부서|요청번호|품목코드|요청일|품목명|규격|요청수량|단위|승인수량|단가|금액|납기요청일|협력사|관리번호|결재유무|비고|비고2|요정자|요청자연락처|도착지주소|예산부서|예산계정|";
		String headers = "BUYER_NAME_LOC|REQ_DEPT|PR_NO|BUYER_ITEM_NO|CHANGE_DATE|DESCRIPTION|SPECIFICATION|TARGET_QTY|UNIT_MEASURE|RECV_QTY|UNIT_PRICE|AMT|RD_DATE|AGENT_NAME|REF_PR_NO|GUYLJAE_FLAG|REMARK|HD_REMARK|ADD_USER_NAME|ADD_USER_TEL|DELY_TO_LOCATION_TEXT|BUDGET_DEPT_NAME|ACCOUNT_NAME|";
		String excelHeader = title +"@@"+headers;		
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"구매요청접수.xls");
		 
	}
	
	
	 
	/**
	 * 수량 변경 사유저장
	 *  /kr/customer/proxybuy/pr_recv_return_reason_reg2.jsp 
	 */
	@RequestMapping(value = "/mppo/savePrRecvReturnReasonReg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> savePrRecvReturnReasonReg(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdcm/saveBuyerMdCmGoodsLisList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("userid", _sessionInfo.getUserId()); 
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = buyerMpPoOrderReqReceiptService.savePrRecvReturnReasonReg(pMap);
		
		String createOk = "OK";
		_msg.put("MSG", createOk); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	/**
	 * 부서이관 
	 */
	@RequestMapping(value = "/mppo/saveDeptTramsfer.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveDeptTramsfer(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdcm/saveBuyerMdCmGoodsLisList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("userid", _sessionInfo.getUserId()); 
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = buyerMpPoOrderReqReceiptService.saveDeptTramsfer(pMap);
		 
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	
	/**
	 * 반려  setPR_Return
	 */
	@RequestMapping(value = "/mppo/saveSerPrReturn.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSerPrReturn(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdcm/saveBuyerMdCmGoodsLisList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("userid", _sessionInfo.getUserId()); 
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = buyerMpPoOrderReqReceiptService.saveSerPrReturn(pMap);
		 
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	/**
	 * 반려  setPR_Return
	 */
	@RequestMapping(value = "/mppo/saveSerPrDetailReturn.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSerPrDetailReturn(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdcm/saveBuyerMdCmGoodsLisList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("userid", _sessionInfo.getUserId()); 
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = buyerMpPoOrderReqReceiptService.saveSerPrDetailReturn(pMap);
		 
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	/**
	 * 구매발주  setSavePR
	 */
	@RequestMapping(value = "/mppo/saveSetSavePR.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSetSavePR(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdcm/saveBuyerMdCmGoodsLisList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("userid", _sessionInfo.getUserId()); 
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = buyerMpPoOrderReqReceiptService.saveSetSavePR(pMap);
	 
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	/**
	 * 구매발주  insertMergePxPo
	 */
	@RequestMapping(value = "/mppo/saveInsertMergePxPo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveInsertMergePxPo(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdcm/saveBuyerMdCmGoodsLisList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("userid", _sessionInfo.getUserId()); 
		pMap.put("buyer", _sessionInfo.getComCode() );
		pMap.put("comCode", _sessionInfo.getComCode() );
		
		String msg = buyerMpPoOrderReqReceiptService.saveInsertMergePxPo(pMap);
		 
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	/**
	 * 구매발주  insertMergePxPo
	 */
	@RequestMapping(value = "/mppo/saveInsertMergePxPoDetail.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveInsertMergePxPoDetail(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdcm/saveBuyerMdCmGoodsLisList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("userid", _sessionInfo.getUserId()); 
		pMap.put("buyer", _sessionInfo.getComCode() );
		pMap.put("comCode", _sessionInfo.getComCode() );
		
		String msg = buyerMpPoOrderReqReceiptService.saveInsertMergePxPoDetail(pMap);
		 
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	/**
	 * 발주보류(임시저장)  changeMergePxPo
	 */
	@RequestMapping(value = "/mppo/saveChangeMergePxPo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveChangeMergePxPo(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdcm/saveBuyerMdCmGoodsLisList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("userid", _sessionInfo.getUserId()); 
		pMap.put("buyer", _sessionInfo.getComCode() );
		pMap.put("comCode", _sessionInfo.getComCode() ); 
		
		String msg = buyerMpPoOrderReqReceiptService.saveChangeMergePxPo(pMap);
		
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	/**
	 * buyerAdminBdgtTempQtyCheck
	 * 
	 * @param pMap
	 * @return
	 * 
	 * /kr/customer/proxybuy/bdgt/buyer_admin_bdgt_temp_qty_check.jsp?
	 */
	@RequestMapping(value = "/mppo/buyerAdminBdgtTempQtyCheck.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> buyerAdminBdgtTempQtyCheck(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
 
		Map<String, Object> _response = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo"); 
		pMap.put("userid", _sessionInfo.getUserId()); 
		pMap.put("buyer", _sessionInfo.getComCode() );
		pMap.put("comCode", _sessionInfo.getComCode() );  
	 
		List<Map<String, String>> _data = buyerMpPoOrderReqReceiptService.getBuyerAdminBdgtTempQtyCheck( pMap );
		// _msgList.addAll(_msg);
		// System.out.println("_data " +_data);
		_response.put("data", _data);
		// System.out.println("_response " +_response);
		return _response;
	}
	
	/**
	 * buyerAdminBdgtTempOrderCheck
	 * 
	 * @param pMap
	 * @return
	 * 
	 * /kr/customer/proxybuy/bdgt/buyer_admin_bdgt_temp_order_check.jsp?
	 */
	@RequestMapping(value = "/mppo/buyerAdminBdgtTempOrderCheck.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> buyerAdminBdgtTempOrderCheck(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
 
		Map<String, Object> _response = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo"); 
		pMap.put("userid", _sessionInfo.getUserId()); 
		pMap.put("buyer", _sessionInfo.getComCode() );
		pMap.put("comCode", _sessionInfo.getComCode() );  
	 
		List<Map<String, String>> _data = buyerMpPoOrderReqReceiptService.getBuyerAdminBdgtTempOrderCheck( pMap );
		// _msgList.addAll(_msg);
		// System.out.println("_data " +_data);
		_response.put("data", _data);
		// System.out.println("_response " +_response);
		return _response;
	}
	
	/**
	 * buyerAdminBdgtTempOrderDetailCheck
	 * 
	 * @param pMap
	 * @return
	 * 
	 * /kr/customer/proxybuy/bdgt/buyer_admin_bdgt_temp_order_check.jsp?
	 */
	@RequestMapping(value = "/mppo/buyerAdminBdgtTempOrderDetailCheck.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> buyerAdminBdgtTempOrderDetailCheck(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
 
		Map<String, Object> _response = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo"); 
		pMap.put("userid", _sessionInfo.getUserId()); 
		pMap.put("buyer", _sessionInfo.getComCode() );
		pMap.put("comCode", _sessionInfo.getComCode() );  
	 
		List<Map<String, String>> _data = buyerMpPoOrderReqReceiptService.getBuyerAdminBdgtTempOrderDetailCheck( pMap );
		_response.put("data", _data);
		return _response;
	}
	
	@RequestMapping(value = "/mppo/getBuyerMpPoOrdeHongikrReqReceiptList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMpPoHongikOrderReqReceiptList(ModelMap pModel  ,HttpServletRequest req,@RequestParam Map<String, String> pMap) {	

		 SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		 
		// 조회일자 Convert

		String _st_from_date = pMap.get("st_from_date");
		String _st_to_date = pMap.get("st_to_date");
		
		pMap.put("st_com_code", CommonUtil.onvl(pMap.get("st_com_code") ,_sessionInfo.getComCode() ));
		pMap.put("st_user_id", CommonUtil.onvl(pMap.get("st_user_id") ,_sessionInfo.getUserId() ));
		pMap.put("st_department", CommonUtil.onvl(pMap.get("st_department") ,_sessionInfo.getDepartment() ));
		
		pMap.put("st_from_date", CommonUtil.onvl(_st_from_date ,CommonUtil.addDate(new Date(),"M",-3,1)) );
		pMap.put("st_to_date", CommonUtil.onvl(_st_to_date,CommonUtil.formatDateNoDateGubun(new Date(),1)) );
		 
		pMap.put("st_from_date", pMap.get("st_from_date").replace("/", ""));
		pMap.put("st_to_date", pMap.get("st_to_date").replace("/", ""));
		
		pMap.put("st_req_dept_code", CommonUtil.onvl(pMap.get("st_req_dept_code") , ""));
		pMap.put("st_pr_no", CommonUtil.onvl(pMap.get("st_pr_no") , ""));
		
		List<Map<String, String>> _data = buyerMpPoOrderReqReceiptService.getBuyerMpPoHongikOrderReqReceiptList(pMap); 
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		return "buyer/mppo/buyerMpPoOrderHongikReqReceiptList";
	}
	
	
	//구매요청접수PR기준
	@RequestMapping(value = "/mppo/getBuyerMpPoOrdePrReqReceiptList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMpPoOrdePrReqReceiptList(ModelMap pModel  ,HttpServletRequest req,@RequestParam Map<String, String> pMap) {	

		 SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		 
		// 조회일자 Convert

		String _st_from_date = pMap.get("st_from_date");
		String _st_to_date = pMap.get("st_to_date");
		
		pMap.put("st_com_code", CommonUtil.onvl(pMap.get("st_com_code") ,_sessionInfo.getComCode() ));
		pMap.put("st_user_id", CommonUtil.onvl(pMap.get("st_user_id") ,_sessionInfo.getUserId() ));
		pMap.put("st_department", CommonUtil.onvl(pMap.get("st_department") ,_sessionInfo.getDepartment() ));
		
		pMap.put("st_from_date", CommonUtil.onvl(_st_from_date ,CommonUtil.addDate(new Date(),"M",-3,1)) );
		pMap.put("st_to_date", CommonUtil.onvl(_st_to_date,CommonUtil.formatDateNoDateGubun(new Date(),1)) );
		 
		pMap.put("st_from_date", pMap.get("st_from_date").replace("/", ""));
		pMap.put("st_to_date", pMap.get("st_to_date").replace("/", ""));
		
		pMap.put("st_req_dept_code", CommonUtil.onvl(pMap.get("st_req_dept_code") , ""));
		pMap.put("st_pr_no", CommonUtil.onvl(pMap.get("st_pr_no") , ""));
		
		List<Map<String, String>> _data = buyerMpPoOrderReqReceiptService.getBuyerMpPoOrdePrReqReceiptList(pMap); 
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		return "buyer/mppo/buyerMpPoOrderPrReqReceiptList";
	}
	/**
	 * 관리번호 저장 기능
	 */
	@RequestMapping(value = "/mppo/saveRefPrNo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveRefPrNo(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("userid", _sessionInfo.getUserId()); 
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		String msg = buyerMpPoOrderReqReceiptService.saveRefPrNo(pMap);
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	
}
