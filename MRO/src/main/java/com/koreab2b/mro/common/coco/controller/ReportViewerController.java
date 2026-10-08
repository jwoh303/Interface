package com.koreab2b.mro.common.coco.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.mybatis.spring.SqlSessionTemplate;
import com.koreab2b.mro.util.CommonUtil;

import com.koreab2b.mro.common.mpso.controller.BuyerMpSoNameCardInfoPopController;
import com.koreab2b.mro.manager.login.domain.SessionInfo;

@Controller("reportViewerController")
public class ReportViewerController {

	@Value("#{reportProps['cx.fileOpen']}")
	private String fileOpen;
	
	@Value("#{reportProps['cx.fileOpenNonActiveX']}")
	private String fileOpenNonActiveX;
	
	@Value("#{reportProps['cx.rdServer']}")
	private String rdServer;
	
	@Value("#{reportProps['cx.rdServerNonActiveXService']}")
	private String rdServerNonActiveXService;
	
	@Value("#{reportProps['cx.rdServerNonActiveXServiceNew']}")
	private String rdServerNonActiveXServiceNew;
	
	@Value("#{reportProps['cx.rdServerHtml5Download']}")
	private String rdServerHtml5Download;
	
	@Value("#{reportProps['cx.rdServerHtml5DownloadNew']}")
	private String rdServerHtml5DownloadNew;
	
	@Value("#{reportProps['cx.rdImage']}")
	private String rdImage;
	
	@Value("#{reportProps['cx.sidRdServerReal']}")
	private String sidRdServerReal;
	
	@Value("#{reportProps['cx.sidRdServerDev']}")
	private String sidRdServerDev;
	
	@Value("#{reportProps['cx.sid']}")
	private String sid;
	@Value("#{reportProps['cx.Codebase']}")
	private String codeBase;
	@Value("#{reportProps['cx.barcodeSid']}")
	private String barcodeSid;
	@Value("#{reportProps['cx.barcodeCodebase']}")
	private String barcodeCodebase;
	
	@Value("#{reportProps['cx.sidX64']}")
	private String sidX64;
	@Value("#{reportProps['cx.CodebaseX64']}")
	private String codeBaseX64;
	@Value("#{reportProps['cx.barcodeSidX64']}")
	private String barcodeSidX64;
	@Value("#{reportProps['cx.barcodeCodebaseX64']}")
	private String barcodeCodebaseX64;
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoNameCardInfoPopController.class);
	
	@RequestMapping(value = "/coco/showReportViewer.do", method = { RequestMethod.GET , RequestMethod.POST })
	public String rdViewer(HttpServletRequest request, ModelMap pModel) {

		pModel.addAttribute("fileOpen", fileOpen);
		pModel.addAttribute("fileOpenNonActiveX", fileOpenNonActiveX);
		pModel.addAttribute("rdServer", rdServer);
		pModel.addAttribute("rdImage", rdImage);
		pModel.addAttribute("sidRdServerReal", sidRdServerReal);
		pModel.addAttribute("sidRdServerDev", sidRdServerDev);
		
		pModel.addAttribute("sid", sid);
		pModel.addAttribute("codeBase", codeBase);
		pModel.addAttribute("barcodeSid", barcodeSid);
		pModel.addAttribute("barcodeCodebase", barcodeCodebase);
		
		pModel.addAttribute("sidX64", sidX64);
		pModel.addAttribute("codeBaseX64", codeBaseX64);
		pModel.addAttribute("barcodeSidX64", barcodeSidX64);
		pModel.addAttribute("barcodeCodebaseX64", barcodeCodebaseX64);
		
		pModel.addAttribute("rdServerNonActiveXService", rdServerNonActiveXService);
		pModel.addAttribute("rdServerNonActiveXServiceNew", rdServerNonActiveXServiceNew);
		
		String fileName = CommonUtil.nvl((String) request.getParameter("fileName"),"");
		String param = CommonUtil.nvl((String) request.getParameter("param"),"");
		// mrd 이력 파일 insert
		Map<String, String> _pMap = new HashMap<String, String>();
		_pMap.put("MRD", fileName);
		_pMap.put("PARAM",param);
//		call_PROC_PGM_CNT(_pMap); MRD 호출 이력저장 프로시저 (HTML5 뷰어 테스트 용)

		String p01103203 = "";
		String ocx_viewer_flag = "N";
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		String session_user_id = CommonUtil.nvl(_sessionInfo.getUserId(), "");
		
		try {
			p01103203 = CommonUtil.getSpecialCheckReturn("KRKORE0001","P01-1032-03","COL01_DATA");
		} catch (Exception e) {
			p01103203 = "";
		}
		
		if (!"".equals(p01103203)){
			String userId[] = p01103203.split("\\^");
			if (userId != null){
				if (userId.length>0){
					for (int i=0; i<userId.length; i++){
						if (session_user_id.equals(userId[i])){
							ocx_viewer_flag = "Y";
						}
					}
				}
			}
		}
		
		if("Y".equals(ocx_viewer_flag)){ // 무조건 OCX 뷰어 작동
			return "common/popup/reportViewer";
		}else { 
			return "common/popup/reportViewer_html5";
	    }
	}
	
	// 뷰어 1개에 mrd 다중으로 붙여서 출력시 사용(연속 출력)
	@RequestMapping(value = "/coco/showReportMultiViewer.do", method = { RequestMethod.GET , RequestMethod.POST })
	public String rdMultiViewer(HttpServletRequest request, ModelMap pModel) {

		pModel.addAttribute("fileOpen", fileOpen);
		pModel.addAttribute("fileOpenNonActiveX", fileOpenNonActiveX);
		pModel.addAttribute("rdServer", rdServer);
		pModel.addAttribute("rdImage", rdImage);
		pModel.addAttribute("sidRdServerReal", sidRdServerReal);
		pModel.addAttribute("sidRdServerDev", sidRdServerDev);
		
		pModel.addAttribute("sid", sid);
		pModel.addAttribute("codeBase", codeBase);
		pModel.addAttribute("barcodeSid", barcodeSid);
		pModel.addAttribute("barcodeCodebase", barcodeCodebase);
		
		pModel.addAttribute("sidX64", sidX64);
		pModel.addAttribute("codeBaseX64", codeBaseX64);
		pModel.addAttribute("barcodeSidX64", barcodeSidX64);
		pModel.addAttribute("barcodeCodebaseX64", barcodeCodebaseX64);
		
		pModel.addAttribute("rdServerNonActiveXService", rdServerNonActiveXService);
		pModel.addAttribute("rdServerNonActiveXServiceNew", rdServerNonActiveXServiceNew);
		
		String fileName = CommonUtil.nvl((String) request.getParameter("fileName"),"");
		String param = CommonUtil.nvl((String) request.getParameter("param"),"");

		Map<String, String> _pMap = new HashMap<String, String>();
		_pMap.put("MRD", fileName);
		_pMap.put("PARAM",param);

		return "common/popup/reportViewer_html5_multi";
	}
	
	//mrd 이력파일 insert
	public void call_PROC_PGM_CNT(Map<String, String> formData) {
		sqlSessionTemplate.update("buyer.mpso.call_PROC_PGM_CNT", formData);
	}
	
	@RequestMapping(value = "/coco/showReportHtmlViewer.do", method = { RequestMethod.GET , RequestMethod.POST })
	public String rdHtmlViewer(HttpServletRequest request, ModelMap pModel) {
		
		pModel.addAttribute("fileOpen", fileOpen);
		pModel.addAttribute("fileOpenNonActiveX", fileOpenNonActiveX);
		pModel.addAttribute("rdServer", rdServer);
		pModel.addAttribute("rdImage", rdImage);
		pModel.addAttribute("sidRdServerReal", sidRdServerReal);
		pModel.addAttribute("sidRdServerDev", sidRdServerDev);
		
		pModel.addAttribute("sid", sid);
		pModel.addAttribute("codeBase", codeBase);
		pModel.addAttribute("barcodeSid", barcodeSid);
		pModel.addAttribute("barcodeCodebase", barcodeCodebase);
		
		pModel.addAttribute("sidX64", sidX64);
		pModel.addAttribute("codeBaseX64", codeBaseX64);
		pModel.addAttribute("barcodeSidX64", barcodeSidX64);
		pModel.addAttribute("barcodeCodebaseX64", barcodeCodebaseX64);
		
		pModel.addAttribute("rdServerNonActiveXService", rdServerNonActiveXService);
		pModel.addAttribute("rdServerNonActiveXServiceNew", rdServerNonActiveXServiceNew);
//		<entry key="rd.fileOpen"><![CDATA[http://docu.koreab2b.com/rddata/]]></entry>
//		<entry key="rd.rdServer"><![CDATA[[http://docu.koreab2b.com/DataServer/rdagent.jsp]]]></entry>
		
//		<entry key="rd.rdImage"><![CDATA[RD_IMAGES_BASEURL[http://docu.koreab2b.com/images/rdimages/]]]></entry>
//		<entry key="rd.sidRdServer"><![CDATA[[kepmp]]]></entry>
//		
//		<entry key="rd.sid"><![CDATA[clsid:DF793F07-89E0-4a63-A56B-D06A3C836127]]></entry>
//		<entry key="rd.Codebase"><![CDATA[http://docu.koreab2b.com/DataServer/cxviewer60.cab#version=6,2,2,116]]></entry>
//		<entry key="rd.barcodeSid"><![CDATA[clsid:C1829AD9-98E1-4050-A3E5-B7B089C6FFFA]]></entry>
//		<entry key="rd.barcodeCodebase"><![CDATA[http://docu.koreab2b.com/DataServer/rdbarcode10.cab#version=10,2,6,13785]]></entry>
//
//		<entry key="rd.sidX64"><![CDATA[clsid:DF793F07-89E0-4a63-A56B-D06A3C836127]]></entry>
//		<entry key="rd.CodebaseX64"><![CDATA[http://docu.koreab2b.com/DataServer/x64/cxviewer60_x64.cab#version=6,2,2,116]]></entry>
//		<entry key="rd.barcodeSidX64"><![CDATA[clsid:65B198E7-A284-4854-94D6-13EFA4E19D31]]></entry>
//		<entry key="rd.barcodeCodebaseX64"><![CDATA[http://docu.koreab2b.com/DataServer/x64/TBarCode10_x64.cab#version=10,2,7,13885]]></entry>

		return "common/popup/reportViewer_html5";
	}	
	
	@RequestMapping(value = "/coco/showReportViewerHtml.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showReportViewerHtml() {
		return "common/popup/report_html5_viewer";
	}
	
	// 고객사 월간리포트 출력시 사용
	@RequestMapping(value = "/coco/showChartViewer.do", method = { RequestMethod.GET , RequestMethod.POST })
	public String chartViewer(HttpServletRequest request, ModelMap pModel) {

		pModel.addAttribute("fileOpen", fileOpen);
		pModel.addAttribute("fileOpenNonActiveX", fileOpenNonActiveX);
		pModel.addAttribute("rdServer", rdServer);
		pModel.addAttribute("rdImage", rdImage);
		pModel.addAttribute("sidRdServerReal", sidRdServerReal);
		pModel.addAttribute("sidRdServerDev", sidRdServerDev);
		
		pModel.addAttribute("sid", sid);
		pModel.addAttribute("codeBase", codeBase);
		pModel.addAttribute("barcodeSid", barcodeSid);
		pModel.addAttribute("barcodeCodebase", barcodeCodebase);
		
		pModel.addAttribute("sidX64", sidX64);
		pModel.addAttribute("codeBaseX64", codeBaseX64);
		pModel.addAttribute("barcodeSidX64", barcodeSidX64);
		pModel.addAttribute("barcodeCodebaseX64", barcodeCodebaseX64);
		
		pModel.addAttribute("rdServerNonActiveXService", rdServerNonActiveXService);
		pModel.addAttribute("rdServerNonActiveXServiceNew", rdServerNonActiveXServiceNew);
		
		String fileName = CommonUtil.nvl((String) request.getParameter("fileName"),"");
		String param = CommonUtil.nvl((String) request.getParameter("param"),"");
		String download_flag = CommonUtil.nvl((String) request.getParameter("download_flag"),"Y");
		
		// mrd 이력 파일 insert
		Map<String, String> _pMap = new HashMap<String, String>();
		_pMap.put("MRD", fileName);
		_pMap.put("PARAM",param);
		
		if("N".equals(download_flag)) { // 문서프로그램 연결 아이콘 숨김
			return "common/popup/chartViewer_html5_hidden";
		}else if("B".equals(download_flag)){ // 고객사 월간리포트 출력용 PDF 전환만 가능(다른 파일 적용 시 디자인 깨짐)
			return "common/popup/chartViewer_html5_buyer";
		}else {
			return "common/popup/chartViewer_html5";	
		}
	}
	
	// 뷰어 없이 해당 내용 출력시 사용(바로 출력)
	@RequestMapping(value = "/coco/showReportHtmlViewerInvoker.do", method = { RequestMethod.GET , RequestMethod.POST })
	public String rdHtmlViewerInvoker(HttpServletRequest request, ModelMap pModel) {
		
		pModel.addAttribute("fileOpen", fileOpen);
		pModel.addAttribute("fileOpenNonActiveX", fileOpenNonActiveX);
		pModel.addAttribute("rdServer", rdServer);
		pModel.addAttribute("rdImage", rdImage);
		pModel.addAttribute("sidRdServerReal", sidRdServerReal);
		pModel.addAttribute("sidRdServerDev", sidRdServerDev);
		
		pModel.addAttribute("sid", sid);
		pModel.addAttribute("codeBase", codeBase);
		pModel.addAttribute("barcodeSid", barcodeSid);
		pModel.addAttribute("barcodeCodebase", barcodeCodebase);
		
		pModel.addAttribute("sidX64", sidX64);
		pModel.addAttribute("codeBaseX64", codeBaseX64);
		pModel.addAttribute("barcodeSidX64", barcodeSidX64);
		pModel.addAttribute("barcodeCodebaseX64", barcodeCodebaseX64);
		
		pModel.addAttribute("rdServerNonActiveXService", rdServerNonActiveXService);
		pModel.addAttribute("rdServerNonActiveXServiceNew", rdServerNonActiveXServiceNew);
		
		pModel.addAttribute("rdServerHtml5Download", rdServerHtml5Download);
		pModel.addAttribute("rdServerHtml5DownloadNew", rdServerHtml5DownloadNew);
		
		return "common/popup/reportViewer_html5_invoker";
	}
}
