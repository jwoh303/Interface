package com.koreab2b.mro.manager.main.controller;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.koreab2b.mro.buyer.mcsc.service.BuyerMcScCustomerCenterService;
import com.koreab2b.mro.buyer.mdam.service.BuyerMdAmNoticeManageService;
import com.koreab2b.mro.buyer.mdcm.service.BuyerMdCmHistoryGoodsSearchService;
import com.koreab2b.mro.buyer.mdcm.service.BuyerMdCmMyGoodsSearchService;
import com.koreab2b.mro.common.coco.controller.CommonCaImApprovalController;
import com.koreab2b.mro.common.coco.controller.CommonMdCmStndApprovalController;
import com.koreab2b.mro.common.coco.controller.CommonNgNsRcPaApprovalController;
import com.koreab2b.mro.common.coco.controller.CommonPrPxApprovalController;
import com.koreab2b.mro.common.coco.controller.CommonWmReApprovalController;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.manager.login.service.LoginService;
import com.koreab2b.mro.manager.main.service.MainService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.DateTimeUtil;

@Controller("mainConrtroller")
public class MainController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(MainController.class);

	@Autowired
	private MainService mainService;
	
	@Autowired
	private BuyerMdAmNoticeManageService buyerMdAmNoticeManageService;

	@Autowired
	private BuyerMcScCustomerCenterService buyerMcScCustomerCenterService;
	
	@Autowired
	private BuyerMdCmHistoryGoodsSearchService buyerMdCmHistoryGoodsSearchService;
	@Autowired
	private BuyerMdCmMyGoodsSearchService buyerMdCmMyGoodsSearchService;

	@Autowired
	CommonNgNsRcPaApprovalController commonNgNsRcPaApprovalController;
	@Autowired
	CommonMdCmStndApprovalController commonMdCmStndApprovalController;
	@Autowired
	CommonWmReApprovalController commonWmReApprovalController;
	@Autowired
	CommonPrPxApprovalController commonPrPxApprovalController;
	@Autowired
	CommonCaImApprovalController commonCaImApprovalController;
	@Autowired
	private LoginService loginService;
	
	@RequestMapping(value = "/main.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getMainList(ModelMap pModel, HttpServletRequest request) {
		String _main_url = "";
		// 레거시 전환 파라미터 처리
//		String legacyParam = request.getParameter("legacy");
//		if ("Y".equals(legacyParam)) {
//			request.getSession().setAttribute("uiVersion", "original");
//			_main_url = "main/main";
//		} else {
//			request.getSession().setAttribute("uiVersion", "renewal");
//			String userLang = request.getLocale().toString();
//			if(userLang.equals("ko_KR")){
//				_main_url = "main/main_v2";
//			}else{
//				//_main_url = "main/en/main_en";
//				_main_url = "main/main_v2";
//			}
//		}
		
		//최종 오픈 전까진 이전 main화면
//		request.getSession().setAttribute("uiVersion", "renewal");
		_main_url = "main/main_v2";
		String session_st_gw_no = "";
		String session_st_gubun = "";
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		Map<String, String> pMapMain = new HashMap<String, String>();
		if(_sessionInfo != null){
			
			String uiVersion = (String) request.getSession().getAttribute("uiVersion");
			
			//결재바로 가기(참고로 밑의 css가 깨져서리) 버튼 클릭시 아래의 화면의 이동하며, 결재팝업까지 자동으로 뜸
			//결재바로 가기에서 바로 왔다는 것을 구분하기 위하여 session_st_gw_no 에 값을 넣어 추후 구분처리한다.
			session_st_gw_no =CommonUtil.nvl((String)request.getSession().getAttribute("session_st_gw_no"),""); // 결재상신 메일 관련 sso 처리를 위한 결재번호 리턴
			session_st_gubun =CommonUtil.nvl((String)request.getSession().getAttribute("session_st_gubun"),""); // 결재상신 메일 관련(참조메일)
			LOGGER.debug(" getMainList 결재상신 메일 관련 sso 처리를 위한 결재번호 리턴 session_st_gw_no {} ",session_st_gw_no);
			
			/**
			 * 사용자 권한에 따른 메인화면 분기처리 ICOMCMPY.BUSINESS_COND (회원사구분(B,S,M))
			 */
			String _tmp = _sessionInfo.getBusinessCond();
			
			
			if (!"".equals(session_st_gw_no)){ // 결재바로보기에서 왔을경우에만
				if ("M".equals(_tmp)) {
					if(session_st_gw_no.equals("pp_sso_login")){
							return "redirect:/master/masterFrame.do?upperId=m00901000000";  // 개선제안시스템 이동
					}else{
						return "redirect:/master/masterFrame.do?upperId=m00201080000&mailOpen=Y";  // 구매대행홈으로 이동 (운영사)
					}
				} else if ("B".equals(_tmp)) { 
					if ("renewal".equals(uiVersion)) {
						if(session_st_gw_no.equals("LOGIN_RE")){
							return "redirect:/mprq/showBuyerMpRqQuotaList_v2.do?menuId=br00102000000"; // 단가합의 화면으로 이동.
						}else{
							pMapMain.put("BUYER", _sessionInfo.getComCode());
							pMapMain.put("USER_ID", _sessionInfo.getUserId());
							pMapMain.put("DEPT", _sessionInfo.getDepartment());
							pMapMain.put("GW_NO", session_st_gw_no);
							List<Map<String,String>> _statusCount = mainService.getBuyerStatusCountMainSql(pMapMain);
							Map<String,String> _statusCountData = null;
							if (_statusCount == null || _statusCount.size() == 0){
							}else{
								_statusCountData = _statusCount.get(0);
								request.getSession().setAttribute("session_CART_CNT", CommonUtil.bnvl(_statusCountData.get("CART_CNT"))); // 장바구니 갯수를 알아내기 위한처리
							}			
		
							List<Map<String,String>> gwCount = mainService.getUserGwPass(pMapMain);
							String userGwNoFlag = "";
							if (gwCount == null || gwCount.size() == 0){
							}else{
								userGwNoFlag = gwCount.get(0).get("GW_PASS_FLAG");
							}			
							
							if(session_st_gubun != null && session_st_gubun.equals("TP")) { // 결재참조메일
								return "redirect:/mdap/showBuyerNewPassList_v2.do?menuId=br00401000000"; 
							} else {
								return "redirect:/mdap/showBuyerNewPassList_v2.do?menuId=br00401000000&tabIndex=2&mailOpen=Y&userGwNoFlag="+userGwNoFlag; // 결재대상조회로 이동처리 (고객사)
							}
						}
					}else{
						if(session_st_gw_no.equals("LOGIN_RE")){
							return "redirect:/mprq/showBuyerMpRqUnitpriceAgrmntNegoReq.do?upperId=b00100000000"; // 단가합의 화면으로 이동.
						}else{
							pMapMain.put("BUYER", _sessionInfo.getComCode());
							pMapMain.put("USER_ID", _sessionInfo.getUserId());
							pMapMain.put("DEPT", _sessionInfo.getDepartment());
							pMapMain.put("GW_NO", session_st_gw_no);
							List<Map<String,String>> _statusCount = mainService.getBuyerStatusCountMainSql(pMapMain);
							Map<String,String> _statusCountData = null;
							if (_statusCount == null || _statusCount.size() == 0){
							}else{
								_statusCountData = _statusCount.get(0);
								request.getSession().setAttribute("session_CART_CNT", CommonUtil.bnvl(_statusCountData.get("CART_CNT"))); // 장바구니 갯수를 알아내기 위한처리
							}			
		
							List<Map<String,String>> gwCount = mainService.getUserGwPass(pMapMain);
							String userGwNoFlag = "";
							if (gwCount == null || gwCount.size() == 0){
							}else{
								userGwNoFlag = gwCount.get(0).get("GW_PASS_FLAG");
							}			
							
							if(session_st_gubun != null && session_st_gubun.equals("TP")) { // 결재참조메일
								return "redirect:/mdap/showNewPassCompleteList.do?upperId=b00100000000"; 
							} else {
								return "redirect:/mdap/showNewPassRecvList.do?upperId=b00100000000&mailOpen=Y&userGwNoFlag="+userGwNoFlag; // 결재대상조회로 이동처리 (고객사)
							}
						}
					}
				}
			}
			
			
			if ("M".equals(_tmp)) {
				
				//pModel.put("master_data", mainService.getMasterMainInfo(pMap));
				
				_main_url = "master/masterMain";
			} else if ("B".equals(_tmp)) { 
				//펀치아웃고객사 리스트
				boolean p060000052 = CommonUtil.getSpecialCheckReturn(_sessionInfo.getComCode(),"P06-0000052");
		
				String check_date=DateTimeUtil.getFormatString("yyyyMMdd"); 
				pMapMain.put("check_date", check_date);
				pMapMain.put("pg_no", "1");
				pMapMain.put("row", "5");
				pMapMain.put("btype", "NT");
				pMapMain.put("BUYER", _sessionInfo.getComCode());
				pModel.addAttribute("ntBoard", mainService.getB2bBoardList(pMapMain));
				
				pMapMain.put("paging", "1");
				pMapMain.put("curPage", "1");
				pMapMain.put("onepagerow", "5");
				pMapMain = CommonUtil.PagingPrc(pMapMain); // 페이징처리
				 
				String isAdmin = _sessionInfo.getUserType().equals("A")?"Y":"N"; 
				pMapMain.put("isAdmin", isAdmin); 	
				pMapMain.put("st_byca_comorg_code", _sessionInfo.getBycaComorgCode());
				
				pModel.addAttribute("buyerBoard", buyerMdAmNoticeManageService.getList(pMapMain));

				// 내부 공지사항 (BUYERBOARD, BTYPE='NTC') - buyerMain_v2 하단 우측 박스
				Map<String,String> pMapIntNt = new HashMap<String,String>();
				pMapIntNt.put("st_byca_comorg_code", _sessionInfo.getBycaComorgCode());
				pMapIntNt.put("st_company", _sessionInfo.getComCode());
				pMapIntNt.put("st_user_id", _sessionInfo.getUserId());
				// 고객센터 내부공지 tab3와 동일한 isAdmin 판정(role 기반)으로 정합
				String _intNtRole = _sessionInfo.getRole() != null ? _sessionInfo.getRole() : "";
				pMapIntNt.put("isAdmin", (_intNtRole.indexOf("A") > -1 || _intNtRole.indexOf("M") > -1) ? "Y" : "N");
				pMapIntNt.put("isMain", "Y");
				pModel.addAttribute("internalNtBoard", buyerMcScCustomerCenterService.getInternalNoticeList(pMapIntNt));

				pMapMain.put("USER_ID", _sessionInfo.getUserId());
				pMapMain.put("DEPT", _sessionInfo.getDepartment());
		
				pModel.addAttribute("vocUser", mainService.getBuyerVocUserSql(pMapMain));//PM정보조회
				pModel.addAttribute("bmUser", mainService.getBuyerBmUserSql(pMapMain)); //BM정보조회

				pModel.addAttribute("companyPass", mainService.getCompanyPass(pMapMain));
				pModel.addAttribute("manualInfo", mainService.getManualInfo(pMapMain));
				request.getSession().setAttribute("SESSION_COWAY_SSO_LIST", mainService.getShortCutSso(pMapMain)); // 코웨이SSO 조회
				pModel.addAttribute("shotcutSsso", request.getSession().getAttribute("SESSION_COWAY_SSO_LIST"));
				
				if(p060000052 == true){
					_main_url = "buyer/buyerPCOMain";
				}else{
					
//					_main_url = "buyer/buyerMain";
					// UI 버전에 따른 분기 처리
					
					if ("renewal".equals(uiVersion)) {
						pModel.addAttribute("statusCount", mainService.getBuyerStatusCountMainSql_v2(pMapMain));
						Map<String, String> pMapMainTmp = new HashMap<String, String>();
						pMapMainTmp.put("st_com_code", _sessionInfo.getComCode());
						pMapMainTmp.put("st_user_id", _sessionInfo.getUserId());
						pMapMainTmp.put("st_order_flag", "MAIN"); //main화면에선 5개만 가져오기 위함
						pMapMainTmp.put("st_dept", _sessionInfo.getDepartment());
						pModel.addAttribute("bdgtAmt", mainService.getBuyerBdgtAmt_v2(pMapMainTmp));//예산조회
						pModel.addAttribute("historyGoodsList", buyerMdCmHistoryGoodsSearchService.selectBuyerMdCmHistoryGoodsSearchList_v2(pMapMainTmp));//이력상품 조회
						pModel.addAttribute("myGoodsList", buyerMdCmMyGoodsSearchService.selectBuyerMdCmMyGoodsSearchList_v2(pMapMainTmp));//나의상품 조회
						// 미확인 공지(공지사항 + 내부공지) 건수 - 메인 진입 시 전체화면 강제 팝업용 (pMapIntNt 재사용: st_company/st_user_id/st_byca_comorg_code/isAdmin)
						pModel.addAttribute("unread_notice_count", buyerMcScCustomerCenterService.getBuyerUnreadNoticeCount(pMapIntNt));
						// 공지사항 박스 = 고객센터 tab2와 동일 소스(ICOMBOARD_NOTICE: 공통 + 거래사별). 상위 3건은 JSP에서 cap. (레거시 162행 getB2bBoardList 결과를 덮어씀)
						Map<String, String> pMapNotice = new HashMap<String, String>();
						pMapNotice.put("st_company", _sessionInfo.getComCode());
						pMapNotice.put("st_user_id", _sessionInfo.getUserId());
						List<Map<String, String>> _noticeListV2 = buyerMcScCustomerCenterService.getNoticeListCommon(pMapNotice);
						_noticeListV2.addAll(buyerMcScCustomerCenterService.getNoticeListCompany(pMapNotice));
						pModel.addAttribute("ntBoard", _noticeListV2);
						_main_url = "buyer/buyerMain_v2";
					} else {
						pModel.addAttribute("statusCount", mainService.getBuyerStatusCountMainSql(pMapMain));
						_main_url = "buyer/buyerMain";
					}
				}
			} else if ("S".equals(_tmp)) {
				pMapMain.put("st_com_code", _sessionInfo.getComCode());
				// 공지 읽음 여부 판단을 위한 사용자 ID 추가
				pMapMain.put("st_user_id", _sessionInfo.getUserId());
				
				// UI 버전에 따른 분기 처리
				if ("renewal".equals(uiVersion)) {
					// 협력사 메인 공지사항 분리 (ICOMBOARD_NOTICE 기반)
					pModel.put("common_notice_data", mainService.getCommonNoticeList_v2(pMapMain));		// [공통 공지사항]
					pModel.put("company_notice_data", mainService.getCompanyNoticeList_v2(pMapMain));	// [거래사별 공지사항]
					pModel.put("unread_notice_count", mainService.getUnreadNoticeCount_v2(pMapMain));	// [미확인 공지 건수]
					pModel.put("total_data", mainService.getNewAgentHomeFindTotal_v2(pMapMain));
					pModel.put("po_mng_data", mainService.getNewAgentHomePoMngTotal_v2(pMapMain)); //요청현황 데이터
					_main_url = "seller/sellerMain_v2";
				} else {
					pModel.put("notice_data", mainService.getNewAgentHomeboardSelList(pMapMain));
					pModel.put("total_data", mainService.getNewAgentHomeFindTotal(pMapMain));
					_main_url = "seller/sellerMain";
				}
			} else if ("E".equals(_tmp)) {
				pMapMain.put("st_com_code", _sessionInfo.getComCode());
				pModel.put("notice_data", mainService.getNewExportHomeboardSelList(pMapMain));
				pModel.put("chart_data", mainService.getExportHomeChartList(pMapMain));
				_main_url = "export/exportMain";
			}
		}else{
			String strMsg = "";
			Map<String, ?> inputFlashMap = RequestContextUtils.getInputFlashMap(request);
			if (inputFlashMap != null) {
				strMsg = (String) inputFlashMap.get("message");
			}
			pModel.put("message", strMsg);
		}
		return _main_url;
	} 
	@RequestMapping(value = "/buyerPCOMain.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String buyerPCOMain(ModelMap pModel, HttpServletRequest request) {
		String _main_url = "";
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		Map<String, String> pMapBuyer = new HashMap<String, String>();
			if(_sessionInfo != null){
				String check_date=DateTimeUtil.getFormatString("yyyyMMdd"); 
				pMapBuyer.put("check_date", check_date);
				pMapBuyer.put("pg_no", "1");
				pMapBuyer.put("row", "5");
				pMapBuyer.put("btype", "NT");
				pMapBuyer.put("BUYER", _sessionInfo.getComCode());
				pModel.addAttribute("ntBoard", mainService.getB2bBoardList(pMapBuyer));
				
				pMapBuyer.put("paging", "1");
				pMapBuyer.put("curPage", "1");
				pMapBuyer.put("onepagerow", "5");
				pMapBuyer = CommonUtil.PagingPrc(pMapBuyer); // 페이징처리
				 
				String isAdmin = _sessionInfo.getUserType().equals("A")?"Y":"N"; 
				pMapBuyer.put("isAdmin", isAdmin); 	
				pMapBuyer.put("st_byca_comorg_code", _sessionInfo.getBycaComorgCode());
				
				pModel.addAttribute("buyerBoard", buyerMdAmNoticeManageService.getList(pMapBuyer));
				
				pMapBuyer.put("USER_ID", _sessionInfo.getUserId());
				pMapBuyer.put("DEPT", _sessionInfo.getDepartment());
				
				pModel.addAttribute("vocUser", mainService.getBuyerVocUserSql(pMapBuyer));
				pModel.addAttribute("statusCount", mainService.getBuyerStatusCountPCOMainSql(pMapBuyer));
				pModel.addAttribute("companyPass", mainService.getCompanyPass(pMapBuyer));
				pModel.addAttribute("manualInfo", mainService.getManualInfo(pMapBuyer));
				pModel.addAttribute("shotcutSsso", mainService.getShortCutSso(pMapBuyer));		
			}
		_main_url = "buyer/buyerPCOMain";

		return _main_url;
	}
	@RequestMapping(value = "/buyerMain.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String buyerMain(ModelMap pModel, HttpServletRequest request) {
		String _main_url = "";
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		Map<String, String> pMapBuyer = new HashMap<String, String>();
			if(_sessionInfo != null){
				String check_date=DateTimeUtil.getFormatString("yyyyMMdd"); 
				pMapBuyer.put("check_date", check_date);
				pMapBuyer.put("pg_no", "1");
				pMapBuyer.put("row", "5");
				pMapBuyer.put("btype", "NT");
				pMapBuyer.put("BUYER", _sessionInfo.getComCode());
				pModel.addAttribute("ntBoard", mainService.getB2bBoardList(pMapBuyer));
				
				pMapBuyer.put("paging", "1");
				pMapBuyer.put("curPage", "1");
				pMapBuyer.put("onepagerow", "5");
				pMapBuyer = CommonUtil.PagingPrc(pMapBuyer); // 페이징처리
				 
				String isAdmin = _sessionInfo.getUserType().equals("A")?"Y":"N"; 
				pMapBuyer.put("isAdmin", isAdmin); 	
				pMapBuyer.put("st_byca_comorg_code", _sessionInfo.getBycaComorgCode());
				
				pModel.addAttribute("buyerBoard", buyerMdAmNoticeManageService.getList(pMapBuyer));
				
				pMapBuyer.put("USER_ID", _sessionInfo.getUserId());
				pMapBuyer.put("DEPT", _sessionInfo.getDepartment());
				
				pModel.addAttribute("vocUser", mainService.getBuyerVocUserSql(pMapBuyer)); //PM정보조회
				pModel.addAttribute("bmUser", mainService.getBuyerBmUserSql(pMapBuyer)); //BM정보조회
				pModel.addAttribute("statusCount", mainService.getBuyerStatusCountMainSql(pMapBuyer));
				pModel.addAttribute("companyPass", mainService.getCompanyPass(pMapBuyer));
				pModel.addAttribute("manualInfo", mainService.getManualInfo(pMapBuyer));
				pModel.addAttribute("shotcutSsso", mainService.getShortCutSso(pMapBuyer));		
			}
		// UI 버전에 따른 최종 분기 처리 (일반적인 경우)
//		_main_url = "buyer/buyerMain";
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			pModel.addAttribute("statusCount", mainService.getBuyerStatusCountMainSql_v2(pMapBuyer));
			Map<String, String> pMapMainTmp = new HashMap<String, String>();
			pMapMainTmp.put("st_com_code", _sessionInfo.getComCode());
			pMapMainTmp.put("st_user_id", _sessionInfo.getUserId());
			pMapMainTmp.put("st_dept", _sessionInfo.getDepartment());
			pMapMainTmp.put("st_order_flag", "MAIN"); //main화면에선 5개만 가져오기 위함
			pModel.addAttribute("bdgtAmt", mainService.getBuyerBdgtAmt_v2(pMapMainTmp));//예산조회
			pModel.addAttribute("historyGoodsList", buyerMdCmHistoryGoodsSearchService.selectBuyerMdCmHistoryGoodsSearchList_v2(pMapMainTmp));//이력상품 조회
			pModel.addAttribute("myGoodsList", buyerMdCmMyGoodsSearchService.selectBuyerMdCmMyGoodsSearchList_v2(pMapMainTmp));//나의상품 조회
			// 내부 공지사항 (BUYERBOARD/NTC) - 고객센터 tab3와 동일 (role 기반 isAdmin)
			Map<String, String> pMapIntNt = new HashMap<String, String>();
			pMapIntNt.put("st_byca_comorg_code", _sessionInfo.getBycaComorgCode());
			pMapIntNt.put("st_company", _sessionInfo.getComCode());
			pMapIntNt.put("st_user_id", _sessionInfo.getUserId());
			String _intNtRole = _sessionInfo.getRole() != null ? _sessionInfo.getRole() : "";
			pMapIntNt.put("isAdmin", (_intNtRole.indexOf("A") > -1 || _intNtRole.indexOf("M") > -1) ? "Y" : "N");
			pMapIntNt.put("isMain", "Y");
			pModel.addAttribute("internalNtBoard", buyerMcScCustomerCenterService.getInternalNoticeList(pMapIntNt));
			// 미확인 공지(공지사항 + 내부공지) 건수 - 전체화면 강제 팝업용
			pModel.addAttribute("unread_notice_count", buyerMcScCustomerCenterService.getBuyerUnreadNoticeCount(pMapIntNt));
			// 공지사항 박스 = 고객센터 tab2와 동일 소스(ICOMBOARD_NOTICE: 공통 + 거래사별). 레거시 316행 getB2bBoardList 결과를 덮어씀
			Map<String, String> pMapNotice = new HashMap<String, String>();
			pMapNotice.put("st_company", _sessionInfo.getComCode());
			pMapNotice.put("st_user_id", _sessionInfo.getUserId());
			List<Map<String, String>> _noticeListV2 = buyerMcScCustomerCenterService.getNoticeListCommon(pMapNotice);
			_noticeListV2.addAll(buyerMcScCustomerCenterService.getNoticeListCompany(pMapNotice));
			pModel.addAttribute("ntBoard", _noticeListV2);
			_main_url = "buyer/buyerMain_v2";
		} else {
			_main_url = "buyer/buyerMain";
		}
		return _main_url;
	}
	
	@RequestMapping(value = "/masterMain.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String masterMain(ModelMap pModel, HttpServletRequest request) {
		String _main_url = "";
		
		//Map<String, String> pMap = new HashMap<String, String>();		
		//pModel.put("master_data", mainService.getMasterMainInfo(pMap));				
		_main_url = "master/masterMain"; 

		return _main_url;
	}
	
	@RequestMapping(value = "/masterDetailMain.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String masterDetailMain(ModelMap pModel, HttpServletRequest request) {
		String _main_url = "";
		
		//Map<String, String> pMap = new HashMap<String, String>();		
		//pModel.put("master_data", mainService.getMasterMainInfo(pMap));				
		_main_url = "master/masterDetailMain"; 

		return _main_url;
	}
	
	
	@RequestMapping(value = "/main/sub03/sendMail.do",  method = {RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> sendMail(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String strResult	= CommonUtil.nvl(mainService.sendMail(pMap));		

		_response.put("Result",strResult);
		return _response;
	}
	
	@RequestMapping(value = "/main/sub04/sub04_01notice.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showNoticeList(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		//페이징시 필요한 default value
		pMap.put("paging", "1");
		pMap.put("curPage", "1");
		pMap.put("onepagerow", "10");
		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		
		pMap.put("BTYPE", "NT");
		pMap.put("WHERE", "AND TO_CHAR(SYSDATE,'YYYYMMDD') BETWEEN FROM_DATE AND TO_DATE");
		List<Map<String, String>> _data = mainService.getNoticeList( pMap );
		
		pModel.addAttribute("dataList", _data);
		pModel.addAllAttributes(pMap);
		
		return "main/sub04/sub04_01notice";
	}
	
	@RequestMapping(value = "/main/sub04/sub04_01noticeList.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getNoticeList(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {

		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		
		pMap.put("BTYPE", "NT");
		pMap.put("WHERE", "AND TO_CHAR(SYSDATE,'YYYYMMDD') BETWEEN FROM_DATE AND TO_DATE");
		List<Map<String, String>> _data = mainService.getNoticeList( pMap );
		
		pModel.addAttribute("dataList", _data);
		pModel.addAllAttributes(pMap);
		
		return "main/sub04/sub04_01notice";
	}
	
	@RequestMapping(value = "/main/sub04/sub04_01notice_view.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getNoticeDetailList(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		
		pMap.put("WHERE", "AND TO_CHAR(SYSDATE,'YYYYMMDD') BETWEEN FROM_DATE AND TO_DATE");
		List<Map<String, String>> _data = mainService.getNoticeDetailList( pMap );
		
		pModel.addAttribute("dataList", _data);
		pModel.addAllAttributes(pMap);
		
		return "main/sub04/sub04_01notice_view";
	}
	
	@RequestMapping(value = "/main/sub04/sub04_02ebiz_news.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showEbizNewsList(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		//페이징시 필요한 default value
		pMap.put("paging", "1");
		pMap.put("curPage", "1");
		pMap.put("onepagerow", "10");
		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		
		pMap.put("BTYPE", "EB");
		pMap.put("WHERE", "And ACL ^='KEP'");
		List<Map<String, String>> _data = mainService.getNoticeList( pMap );
		
		pModel.addAttribute("dataList", _data);
		pModel.addAllAttributes(pMap);
		
		return "main/sub04/sub04_02ebiz_news";
	}
	
	@RequestMapping(value = "/main/sub04/sub04_02ebiz_newsList.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getEbizNewsList(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {

		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		
		pMap.put("BTYPE", "EB");
		pMap.put("WHERE", "And ACL ^='KEP'");
		List<Map<String, String>> _data = mainService.getNoticeList( pMap );
		
		pModel.addAttribute("dataList", _data);
		pModel.addAllAttributes(pMap);
		
		return "main/sub04/sub04_02ebiz_news";
	}
	
	@RequestMapping(value = "/main/sub04/sub04_02ebiz_news_view.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getEbizNewsDetailList(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		
		pMap.put("WHERE", "And ACL ^='KEP'");
		List<Map<String, String>> _data = mainService.getNoticeDetailList( pMap );
		
		pModel.addAttribute("dataList", _data);
		pModel.addAllAttributes(pMap);
		
		return "main/sub04/sub04_02ebiz_news_view";
	}
	
	
	@RequestMapping(value = "/main/sub05/getIdFindSome.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getIdFindSome(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		Map<String, String> _map = new HashMap<String, String>();
		String ip = "";
		
		List<Map<String, String>> _data = mainService.getIdFindSome( pMap );
		if (_data != null && _data.size() > 0){
			for(int i=0; i<_data.size(); i++){
				_map = _data.get(i);
				ip = request.getRemoteAddr();
				_map.put("ip", ip);
				mainService.insertLog( _map);
			}
			
			pModel.addAttribute("idData", _data);
			return "main/sub05/sub05_03id_search_check_ok";
		}else{
			return "main/sub05/sub05_03id_search_check_fail";
		}
		
	}
	
	@RequestMapping(value = "/main/sub05/sendOtpReg.do",  method = {RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> insertOtp(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String ip	= request.getRemoteAddr(); 
		pMap.put("ip", ip);
		
		String rtnMsg = mainService.insertOtp(pMap);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("RtnMsg", rtnMsg);
		return _response;
	}
	
	@RequestMapping(value = "/main/sub05/getOtpAuhen.do",  method = {RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getOtpAuhen(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String ip	= request.getRemoteAddr(); 
		pMap.put("ip", ip);
		
		String strResult	= CommonUtil.nvl(mainService.getOtpAuhen(pMap));		

		_response.put("Result",strResult);
		return _response;
	}
	
	@RequestMapping(value = "/main/sub05/getPwFindCheck.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getPwFindCheck(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		String strResult	= CommonUtil.nvl(mainService.getPwFindCheck(pMap));
		
		if("".equals(strResult) || "null".equals(strResult)){
			return "main/sub05/sub05_03pw_search_fail";
		}else{
			return "main/sub05/sub05_03pw_search_check";
		}
	}
	
	@RequestMapping(value = "/main/sub05/setNewPw.do",  method = {RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> setNewPw(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String ip	= request.getRemoteAddr(); 
		pMap.put("ip", ip);
		
		String rtnMsg = mainService.setNewPw(pMap);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("RtnMsg", rtnMsg);
		return _response;
	}
	
	
	
	/**
	 * 메인 클레임저장
	 * /kr/sysop/voc/voc_buyer_req_create_reg.jsp
	 */
	@RequestMapping(value = "/main/saveBuyerVocReqCreateReg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerVocReqCreateReg(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>(); 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo"); 
		pMap.put("userid", _sessionInfo.getUserId());  
		pMap.put("buyer", _sessionInfo.getComCode() ); 
		pMap.put("tel", _sessionInfo.getTel()); 
		pMap.put("userNameLoc", _sessionInfo.getUserNameLoc() ); 
		
		String msg = mainService.CreateSrReq(pMap); 
		msg ="SUCCESS@@"+msg;

		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	
	/**
	 * 메인 처리결과
	 * /kr/sysop/voc/customer_center.jsp
	 */
	@RequestMapping(value = "/main/getCustomerCenterList.do", method = { RequestMethod.POST, RequestMethod.GET }) 
	public String getCustomerCenterList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {


		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo"); 
		pMap.put("userid", _sessionInfo.getUserId());  
		pMap.put("buyer", _sessionInfo.getComCode() ); 
		
		pMap.put("fromDate", CommonUtil.onvl(pMap.get("fromDate"), "" )); 
		pMap.put("toDate", CommonUtil.onvl(pMap.get("toDate"), "" )); 
		pMap.put("st_recv_flag", CommonUtil.onvl(pMap.get("st_recv_flag"), "" )); 
		pMap.put("st_claim_master", CommonUtil.onvl(pMap.get("st_claim_master"), "" )); 
		
		pMap = CommonUtil.PagingPrc(pMap); 
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		
		List<Map<String,String>> list	= mainService.getCustomerCenterList(pMap);
		
		pModel.addAttribute("data", list);
		
	 	return "buyer/buyerCustomerCenterList"; 
	}
	
	
	
	/**
	 * 고객만족도 저장
	 */
	@RequestMapping(value = "/main/setCustomerRubUpdate.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> setCustomerRubUpdate(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>(); 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo"); 
		pMap.put("userid", _sessionInfo.getUserId());  
		pMap.put("buyer", _sessionInfo.getComCode() );  
		
		String msg = mainService.setCustomerRubUpdate(pMap); 
		msg ="SUCCESS";

		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	
	/**
	 *VOC 상태 팝업
	 */
	@RequestMapping(value = "/main/getCustomerCenterPop.do", method = { RequestMethod.POST, RequestMethod.GET }) 
	public String getCustomerCenterPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		if(pMap.get("admin_yn").equals("Y")){
			pMap.put("userid", CommonUtil.onvl(pMap.get("userid"), "" ));
			pMap.put("buyer", CommonUtil.onvl(pMap.get("buyer"), "" ));
			pMap.put("req_user_dept", CommonUtil.onvl(pMap.get("req_user_dept"), "" ));
		}else{
			pMap.put("userid", _sessionInfo.getUserId());
			pMap.put("buyer", _sessionInfo.getComCode() ); 
			pMap.put("req_user_dept", _sessionInfo.getDepartment() );	
		}
		
		pMap.put("vc_no", CommonUtil.onvl(pMap.get("vc_no"), "" ));  
		
		List<Map<String,String>> list	= mainService.getCustomerCenterPop(pMap);
		
		pModel.addAttribute("data", list);
		
	 	return "common/popup/coco/commonCoCoVocBuyerReqCreateRegStatusPop"; 
	}
	
	//2016 아이디 찾기
	@RequestMapping(value = "/main/2016/sub04/getIdFindUserInfo.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getIdFindUserInfo(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request, HttpServletResponse response) {
		Map<String, String> _map = new HashMap<String, String>();
		String ip = "";
		
		List<Map<String, String>> _data = mainService.getIdFindSome( pMap );

		// AJAX 요청 시 JSON 응답 (리뉴얼 v2 페이지용)
		if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
			try {
				response.setContentType("application/json; charset=utf-8");
				PrintWriter out = response.getWriter();
				StringBuilder json = new StringBuilder();
				if (_data != null && _data.size() > 0) {
					for (int i = 0; i < _data.size(); i++) {
						_map = _data.get(i);
						ip = request.getRemoteAddr();
						_map.put("ip", ip);
						mainService.insertLog(_map);
					}
					json.append("{\"status\":\"success\",\"idList\":[");
					for (int i = 0; i < _data.size(); i++) {
						Map<String, String> row = _data.get(i);
						String userId = CommonUtil.nvl(row.get("USER_ID"), "");
						String phone = CommonUtil.nvl(row.get("MOBILE_PHONE"), "");
						// ID 마스킹 처리
						int fLen = userId.length();
						int hLen = Math.round(fLen / 2);
						String maskedId = userId.substring(0, fLen - hLen);
						for (int j = 0; j < hLen; j++) { maskedId += "*"; }
						if (i > 0) json.append(",");
						json.append("{\"maskedId\":\"").append(maskedId).append("\"");
						json.append(",\"userId\":\"").append(userId).append("\"");
						json.append(",\"phone\":\"").append(phone).append("\"}");
					}
					json.append("]}");
				} else {
					json.append("{\"status\":\"fail\"}");
				}
				out.print(json.toString());
				out.flush();
			} catch (Exception e) {
				LOGGER.error("getIdFindUserInfo AJAX error", e);
			}
			return null;
		}

		// 기존 레거시 처리 (form POST)
		if (_data != null && _data.size() > 0){
			for(int i=0; i<_data.size(); i++){
				_map = _data.get(i);
				ip = request.getRemoteAddr();
				_map.put("ip", ip);
				mainService.insertLog( _map);
			}
			
			pModel.addAttribute("idData", _data);
			return "main/2016/sub04/sub04_search_ok_id";
		}else{
			return "main/2016/sub04/sub04_search_fail_id";
		}
		
	}
	//2016 패스워드찾기
	@RequestMapping(value = "/main/2016/sub04/getPwFind.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getPwFind(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request, HttpServletResponse response) {
		String strResult	= CommonUtil.nvl(mainService.getPwFindCheck(pMap));

		// AJAX 요청 시 JSON 응답 (리뉴얼 v2 페이지용)
		if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
			try {
				response.setContentType("application/json; charset=utf-8");
				PrintWriter out = response.getWriter();
				StringBuilder json = new StringBuilder();
				if ("".equals(strResult) || "null".equals(strResult)) {
					json.append("{\"status\":\"fail\"}");
				} else {
					// 이메일/전화번호 마스킹 처리
					String email = CommonUtil.nvl(pMap.get("st_mail_addr"), "");
					String phone = CommonUtil.nvl(pMap.get("st_phone_num1"), "") + "-"
							+ CommonUtil.nvl(pMap.get("st_phone_num2"), "") + "-"
							+ CommonUtil.nvl(pMap.get("st_phone_num3"), "");
					// 이메일 마스킹: ab***@naver.com
					String maskedEmail = email;
					if (email.contains("@")) {
						String[] emailParts = email.split("@");
						String local = emailParts[0];
						if (local.length() > 2) {
							maskedEmail = local.substring(0, 2) + "***@" + emailParts[1];
						}
					}
					// 전화번호 마스킹: 010-2856-****
					String maskedPhone = phone;
					if (phone.length() > 4) {
						maskedPhone = phone.substring(0, phone.length() - 4) + "****";
					}
					json.append("{\"status\":\"success\"");
					json.append(",\"email\":\"").append(maskedEmail).append("\"");
					json.append(",\"phone\":\"").append(maskedPhone).append("\"");
					json.append(",\"userId\":\"").append(strResult).append("\"}");
				}
				out.print(json.toString());
				out.flush();
			} catch (Exception e) {
				LOGGER.error("getPwFind AJAX error", e);
			}
			return null;
		}

		// 기존 레거시 처리 (form POST)
		if("".equals(strResult) || "null".equals(strResult)){
			return "main/2016/sub04/sub04_search_fail_pw";
		}else{
			return "main/2016/sub04/sub04_search_ok_pw";
		}
	}
	//2016 공지사항
	@RequestMapping(value = "/main/2016/sub03/getSub03_04notice.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getSub03_04notice(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		//페이징시 필요한 default value
		pMap.put("paging", "1");
		pMap.put("curPage", "1");
		pMap.put("onepagerow", "10");
		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		
		pMap.put("BTYPE", "NT");
		pMap.put("WHERE", "AND TO_CHAR(SYSDATE,'YYYYMMDD') BETWEEN FROM_DATE AND TO_DATE");
		List<Map<String, String>> _data = mainService.getNoticeList( pMap );
		
		pModel.addAttribute("dataList", _data);
		pModel.addAllAttributes(pMap);
		
		return "main/2016/sub03/sub03_04notice";
	}
	//2016 공지사항 상세
	@RequestMapping(value = "/main/2016/sub03/getSub03_04notice_view.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String getSub03_04notice_view(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		
		pMap.put("WHERE", "AND TO_CHAR(SYSDATE,'YYYYMMDD') BETWEEN FROM_DATE AND TO_DATE");
		List<Map<String, String>> _data = mainService.getNoticeDetailList( pMap );
		
		pModel.addAttribute("dataList", _data);
		pModel.addAllAttributes(pMap);
		
		return "main/2016/sub03/sub03_04notice_view";
	}
	//SMS보내기
	@RequestMapping(value = "/main/sms_sendList.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String sms_sendList(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		request.getSession().setAttribute("session_st_gw_no",""); // 결재상신 메일 관련 sso 처리 < 일반적 로그인이므로 빈값으로 넣는다
		return "main/sms_sendList";
	}
	//패스워드 입력
	@RequestMapping(value = "/main/sub_pw_insert.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String sub_pw_insert(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		
		String emp_no = CommonUtil.nvl((String)request.getSession().getAttribute("session_st_emp_no"), "");
		String emp_nm = CommonUtil.nvl((String)request.getSession().getAttribute("session_st_emp_nm"), "");
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		String com_type = "";
		
		if(_sessionInfo != null){
			emp_no = CommonUtil.nvl(_sessionInfo.getUserId(),"");
			emp_nm = CommonUtil.nvl(_sessionInfo.getUserNameLoc(),"");
			com_type = CommonUtil.nvl(_sessionInfo.getBusinessCond(),"");
		}
		
		if(emp_no.equals("") || emp_nm.equals("")) {
			return "redirect:/main.do";
		}else {
			pModel.addAttribute("user_Id", emp_no);
			pModel.addAttribute("user_nm", emp_nm);
			if("B".equals(com_type)) { // 고객사
				
				if ("renewal".equals(uiVersion)) { //이건 추후에 비밀번호 추가 인증 화면 새로 만들면(sub_pw_insert_v2.do) 거기로 옮겨주기
					pModel.addAttribute("after_url", "/mdam/showBuyerMdAmUserInfo.do?menuId=br00701000000&passFlag=Y");	
				}else{
					pModel.addAttribute("after_url", "/mdam/showBuyerMdAmUserInfo.do?upperId=b00000000000&leftMenu=N");	
				}
			}else { // 추후 운영사, 협력사 추가 여지 있음
				pModel.addAttribute("after_url", "");
			}
			
			if ("renewal".equals(uiVersion)) { //이건 추후에 비밀번호 추가 인증 화면 새로 만들면(sub_pw_insert_v2.do) 거기로 옮겨주기
				return "main/sub_pw_insert_v2";
			}else{
				return "main/sub_pw_insert";
			}
		}
	}
	// 패스워드 확인 후 개인정보로 이동
	@RequestMapping(value = "/main/getSubPwInsert.do", method = { RequestMethod.GET, RequestMethod.POST })
	@ResponseBody
	public Map<String, String> getSubPwInsert(@RequestParam Map<String, String> pMap, HttpServletRequest request) {
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());
		LOGGER.debug("요청 파라미터 for jsp : {}", pMap);
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		
		Map<String,String> _data = mainService.getSubPwInsert(pMap);
		return _data;
	}
	//3개월 초과시 운영사 패스워드 강제 변경.
	@RequestMapping(value = "/main/sub_login_pw_change.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String sub_login_pw_change(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		String _pwd_status = CommonUtil.nvl(request.getParameter("pageGbn"),"");
		String sslurl = CommonUtil.getSslURL(request, "http");
		String _userId = CommonUtil.nvl(request.getParameter("userId"),"");
		String _comCode = CommonUtil.nvl(request.getParameter("comCode"),"");
		pModel.addAttribute("pageGbn", _pwd_status);
		pModel.addAttribute("userId", _userId);
		pModel.addAttribute("comCode", _comCode);
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "main/sub_login_pw_change_v2";
		} else {
			return "main/sub_login_pw_change";
		}
		
	}
	//3개월 초과시 고객사, 협력사 패스워드 변경.
	@RequestMapping(value = "/main/sub_pw_change.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String sub_pw_change(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		String _pwd_status = CommonUtil.nvl(request.getParameter("pageGbn"),"");
		String sslurl = CommonUtil.getSslURL(request, "http");
		String _userId = CommonUtil.nvl(request.getParameter("userId"),"");
		String _comCode = CommonUtil.nvl(request.getParameter("comCode"),"");
		String _tempPw = CommonUtil.nvl(request.getParameter("tempPw"),"");
		
		
		pModel.addAttribute("pageGbn", _pwd_status);
		pModel.addAttribute("userId", _userId);
		pModel.addAttribute("comCode", _comCode);
		pModel.addAttribute("tempPw", _tempPw);
		
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "main/sub_pw_change_v2";
		} else {
			return "main/sub_pw_change";
		}
		
	}
	//PASSWORD_TYPE='S'인 사용자는 초기패스워드 발급자
	@RequestMapping(value = "/main/sub_buyer_pw_change.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String sub_buyer_pw_change(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		String _pwd_status = CommonUtil.nvl(request.getParameter("pageGbn"),"");
		String sslurl = CommonUtil.getSslURL(request, "http");
		String _userId = CommonUtil.nvl(request.getParameter("userId"),"");
		String _comCode = CommonUtil.nvl(request.getParameter("comCode"),"");
		pModel.addAttribute("pageGbn", _pwd_status);
		pModel.addAttribute("userId", _userId);
		pModel.addAttribute("comCode", _comCode);
		
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "main/sub_buyer_pw_change_v2";
		} else {
			return "main/sub_buyer_pw_change";
		}
		
	}
	//메일 승인반려-패스워드 입력
	@RequestMapping(value = "/main/sub_pw_insert_mail.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String sub_pw_insert_mail(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		String st_gj_user_id = CommonUtil.nvl((String)request.getSession().getAttribute("session_st_gj_user_id"),"");
		String st_gw_no = CommonUtil.nvl((String)request.getSession().getAttribute("session_st_gw_no"),"");
		String st_gj_type = CommonUtil.nvl((String)request.getSession().getAttribute("session_st_gj_type"),"");
		String st_password_type = CommonUtil.nvl((String)request.getSession().getAttribute("session_st_password_type"),"");
		pModel.addAttribute("session_st_gj_user_id", st_gj_user_id);
		pModel.addAttribute("session_st_gw_no", st_gw_no);
		pModel.addAttribute("session_st_gj_type", st_gj_type);
		pModel.addAttribute("session_st_password_type", st_password_type);
		return "main/sub_pw_insert_mail";
	}
	// 메일 승인 결과 창
	@RequestMapping(value = "/main/sub_mail_aprv.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String sub_mail_aprv(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		String gj_url = "";
		String gj_key1 = "";
		String gj_key2 = "";
		String gj_key3 = "";
		String doc_type = "";
		String rtn_result = "";
		String pass_kn = CommonUtil.nvl(pMap.get("PASS_KN"),"");
		String pass_change_flag = CommonUtil.nvl(_sessionInfo.getPasswordType(),"");
		String old_password = CommonUtil.nvl(pMap.get("old_password"),"");
		String new_password = CommonUtil.nvl(pMap.get("new_password"),"");
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		
		// 결재 과정 중 필수 필요
		pMap.put("COMPANY", _sessionInfo.getComCode());
		pMap.put("DOCU_NO", pMap.get("gw_no"));
		
		List<Map<String, String>> _data_MYPAGE1 = mainService.getMypage1List(pMap);
		List<Map<String, String>> _data_MYPAGE2 = mainService.getMypage2List(pMap);
		
		if(_data_MYPAGE1.size()>0){
			Map<String, String> _map_gj_info1 = _data_MYPAGE1.get(0);
			gj_key1 = _map_gj_info1.get("KEY_1");
			gj_key2 = _map_gj_info1.get("KEY_2");
			gj_key3 = _map_gj_info1.get("KEY_3");
		}
		
		if (_data_MYPAGE2.size()>0){
			Map<String, String> _map_gj_info2 = _data_MYPAGE2.get(0);
			gj_url = _map_gj_info2.get("TEXT4");
			doc_type = _map_gj_info2.get("EXTIF_TP");
			
			// 결재 과정 중 필수 필요
			pMap.put("DOC_TYPE", doc_type);
			pMap.put("KEY_1", gj_key1);
			pMap.put("KEY_2", gj_key2);
			pMap.put("KEY_3", gj_key3);
		}

		if("S".equals(pass_change_flag)){
			pMap.put("userId", CommonUtil.nvl(_sessionInfo.getUserId(),""));
			pMap.put("comCode", CommonUtil.nvl(_sessionInfo.getComCode(),""));
			pMap.put("st_old_password", CommonUtil.nvl(old_password,""));
			pMap.put("st_password", CommonUtil.nvl(new_password,""));
			String flag = loginService.setUserPwdUpdate(pMap);
			
			if("ERR_MATCH".equals(flag)){
				pModel.addAttribute("flag", "P");
				pModel.addAttribute("session_st_password_type", pass_change_flag);
				
				return "/main/sub_pw_insert_mail";
			}
		}
		
		// ICOMCOD1.TYPE=APPR 참고
		if("/common/approval/NgNsRcPaCommon".equals(gj_url)){
			rtnMap = commonNgNsRcPaApprovalController.commonApproval(pModel, pMap, request);
			rtnMap.put("status", "true");
		}else if("/common/approval/PrPxCommon".equals(gj_url)){
			rtnMap = commonPrPxApprovalController.commonApproval(pModel, pMap, request);
			rtnMap.put("status", "true");
		}else if("/common/approval/MdCmStndCommon".equals(gj_url)){
			rtnMap = commonMdCmStndApprovalController.commonApproval(pModel, pMap, request);
			rtnMap.put("status", "true");
		}else if("/common/approval/WmReCommon".equals(gj_url)){
			rtnMap = commonWmReApprovalController.commonApproval(pModel, pMap, request);
			rtnMap.put("status", "true");
		}else if("/common/approval/CaImCommon".equals(gj_url)){
			rtnMap = commonCaImApprovalController.commonApproval(pModel, pMap, request);
			rtnMap.put("status", "true");
		}else{
			rtnMap.put("status", "false");
		}
		
		rtn_result = (String)rtnMap.get("status");
		
		// 결재 처리 완료
		if("true".equals(rtn_result)){
			request.getSession().removeAttribute("sessionInfo");
			request.getSession().removeAttribute("session_st_gw_no");
			request.getSession().removeAttribute("session_st_gj_user_id");
			request.getSession().removeAttribute("session_st_gj_type");
			request.getSession().invalidate();
			
			pModel.addAttribute("result", pass_kn);
			return "main/sub_mail_result";
		// 결재 처리 오류
		}else{
			request.getSession().removeAttribute("sessionInfo");
			request.getSession().removeAttribute("session_st_gw_no");
			request.getSession().removeAttribute("session_st_gj_user_id");
			request.getSession().removeAttribute("session_st_gj_type");
			request.getSession().invalidate();
			
			pModel.addAttribute("flag", "E");
			return "/main/sub_pw_insert_mail";
		}
	}
	
	// 고객사 추가인증-SMS전송
	@RequestMapping(value = "/main/sub_buyer_sms_cert.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String sub_buyer_sms_cert(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		String _user_id = CommonUtil.nvl((String)request.getSession().getAttribute("session_user_id"),"");
		
		pMap.put("USER_ID", _user_id);
		List<Map<String, String>> _data = mainService.getBuyerSmsCertList( pMap );
		
		pModel.addAttribute("dataList", _data);
		
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "main/sub_buyer_sms_cert_v2";
		}else{
			return "main/sub_buyer_sms_cert";
		}
	}
	
	@RequestMapping(value = "/main/leftMenuData.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String leftMenuData(HttpServletRequest request,@RequestParam(value = "page") String pPage,
			ModelMap pModel) {
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		if(_sessionInfo != null){
			Map<String, String> pMapMain = new HashMap<String, String>();
			pMapMain.put("st_com_code", _sessionInfo.getComCode());
			
			pModel.put("left_data", mainService.getNewAgentHomeFindTotal_v2(pMapMain));
		}
		
		return "common/include/" + pPage;
	}
	
	@RequestMapping(value = "/main/leftMenuDataRefresh.do", method = { RequestMethod.GET, RequestMethod.POST })
	@ResponseBody
	public Map<String,List<Map<String,String>>> leftMenuDataRefresh(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		Map<String,List<Map<String,String>>> _response = new HashMap<String,List<Map<String,String>>>();
		List<Map<String,String>> rtnMsg = new ArrayList<Map<String,String>>();
		Map<String,String> tmp = new HashMap<String, String>();
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		
		if(_sessionInfo != null){
			Map<String, String> pMapMain = new HashMap<String, String>();
			pMapMain.put("st_com_code", _sessionInfo.getComCode());
			
			List<Map<String, String>> _data = mainService.getNewAgentHomeFindTotal_v2(pMapMain);
			if(_data != null && _data.size() != 0){
				_response.put("leftData", _data);
				_response.put("menuList", _sessionInfo.getMyMenuList());
			}
			else{
				tmp.put("msg", "새로고침에 실패하였습니다.");
				rtnMsg.add(tmp);
				_response.put("msg", rtnMsg);
			}
		}else{
			tmp.put("msg", "새로고침에 실패하였습니다.");
			rtnMsg.add(tmp);
			_response.put("msg", rtnMsg);
		}
		
		return _response;
	}
	
	@RequestMapping(value = "/main/showBuyerMyPage_v2.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showBuyerMyPage_v2(HttpServletRequest request, ModelMap pModel, @RequestParam Map<String, String> pMap) { 
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		
		Map<String, Object> pMapMainObj = new HashMap<String, Object>();
		Map<String, String> pMapMainTmp = new HashMap<String, String>();
		pMapMainTmp.put("BUYER", _sessionInfo.getComCode());
		pMapMainTmp.put("st_com_code", _sessionInfo.getComCode());
		pMapMainTmp.put("st_user_id", _sessionInfo.getUserId());
		pMapMainTmp.put("st_order_flag", "MY_PAGE"); //5개만 가져오기 위함
		
		pMapMainObj.put("st_com_code", _sessionInfo.getComCode());
		pMapMainObj.put("st_user_id", _sessionInfo.getUserId());
		pMapMainObj.put("st_order_flag", "MY_PAGE"); //5개만 가져오기 위함
		
		pModel.addAttribute("historyGoodsList", buyerMdCmHistoryGoodsSearchService.selectBuyerMdCmHistoryGoodsSearchList_v2(pMapMainTmp));//이력상품 조회
		pModel.addAttribute("myGoodsList", buyerMdCmMyGoodsSearchService.selectBuyerMdCmMyGoodsSearchList_v2(pMapMainTmp));//나의상품 조회
		pModel.addAttribute("vocList", mainService.getCustomerCenterList_v2(pMapMainObj));
		pModel.addAttribute("orderInfo", mainService.getCustomerOrderInfo_v2(pMapMainTmp));
		pModel.addAttribute("vocUser", mainService.getBuyerVocUserSql(pMapMainTmp));//PM정보조회
			
		return "buyer/buyerMyPage_v2";
	}
	
	@RequestMapping(value = "/main/vocCancel_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> vocCancel_v2(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>(); 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo"); 
		pMap.put("userid", _sessionInfo.getUserId());  
		pMap.put("buyer", _sessionInfo.getComCode() );  
		
		String msg = mainService.vocCancel_v2(pMap); 

		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
}
