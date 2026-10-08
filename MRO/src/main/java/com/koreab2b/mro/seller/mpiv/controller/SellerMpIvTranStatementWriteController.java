package com.koreab2b.mro.seller.mpiv.controller;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
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
import com.koreab2b.mro.seller.mpiv.service.SellerMpIvTranStatementWriteService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvTranStatementWriteController")
public class SellerMpIvTranStatementWriteController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvObtnodrReceiptController.class);

	@Autowired
	private SellerMpIvTranStatementWriteService sellerMpIvTranStatementWriteService;
	
	/**
	 * 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/getSellerMpIvTranStatementWriteList.do", method = RequestMethod.POST)
	public String getSellerMpIvTranStatementWriteList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpIvTranStatementWriteService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "seller/mpiv/sellerMpIvTranStatementWriteList";
	}
	//PO별 
	@RequestMapping(value = "/mpiv/getSellerMpIvTranStatementWriteListPO_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpIvTranStatementWriteList_v2(HttpServletRequest req,ModelMap pModel ,@RequestParam Map<String, Object> pMap) {		
		logger.debug("/mpiv/getSellerMpIvTranStatementWriteListPO_v2.do 요청 파라미터 for jsp : {}", pMap);
		
		// 화면 조회
		pMap = IBSheetUtil.removeSlash(pMap);
		
		List<Map<String,String>> _data = sellerMpIvTranStatementWriteService.getSellerMpIvTranStatementWriteListPO_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	//품목별,일괄
	@RequestMapping(value = "/mpiv/getSellerMpIvTranStatementWriteListItem_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpIvTranStatementWriteListItem_v2(HttpServletRequest req,ModelMap pModel ,@RequestParam Map<String, Object> pMap) {		
		logger.debug("/mpiv/getSellerMpIvTranStatementWriteListItem_v2.do 요청 파라미터 for jsp : {}", pMap);
		
		// 화면 조회
		pMap = IBSheetUtil.removeSlash(pMap);
		
		List<Map<String,String>> _data = sellerMpIvTranStatementWriteService.getSellerMpIvTranStatementWriteListItem_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	//출력
	@RequestMapping(value = "/mpiv/getSellerMpIvTranStatementWritePrintList_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpIvTranStatementWritePrintList_v2(HttpServletRequest req,ModelMap pModel ,@RequestParam Map<String, Object> pMap) {		
		logger.debug("/mpiv/getSellerMpIvTranStatementWritePrintList_v2.do 요청 파라미터 for jsp : {}", pMap);
		
		// 화면 조회
		pMap = IBSheetUtil.removeSlash(pMap);
		
		List<Map<String,String>> _data = sellerMpIvTranStatementWriteService.getSellerMpIvTranStatementWritePrintList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	//출력화면 report파일
	@RequestMapping(value = "/mpiv/getSellerMpIvTranStatementWriteRptUrl_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String,Object> getSellerMpIvTranStatementWriteRptUrl_v2(HttpServletRequest req,ModelMap pModel ,@RequestParam Map<String, Object> pMap) {		
		logger.debug("/mpiv/getSellerMpIvTranStatementWritePrintList_v2.do 요청 파라미터 for jsp : {}", pMap);
		Map<String,Object> _response = new HashMap<String, Object>();
		// 화면 조회
		pMap = IBSheetUtil.removeSlash(pMap);
		
		_response = sellerMpIvTranStatementWriteService.getSellerMpIvTranStatementWriteRptUrl_v2(pMap);
		
		return _response;
	}
	
		
	/**
	 * EXCEL 다운로드 
	 * @param pModel
	 * @param pMap
	 * @param response
	 * @param outputStream
	 */
	@RequestMapping(value = "/mpiv/excelSellerMpIvTranStatementWriteList.do", method = RequestMethod.POST)
	public void getExcelDown(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/mpiv/excelSellerMpIvObtnodrReceiptList.do 요청 파라미터 for jsp : {}", pMap);
		
		pMap = CommonUtil.PagingPrc(pMap);
		
		pMap.put("paging", "0"); // Excel Down을 위한 구분
		
		List<Map<String, String>> _data = sellerMpIvTranStatementWriteService.getList(pMap); 
		  
		response.setHeader("Content-Disposition", "attachment; filename=file.xls");
		  
		HSSFWorkbook workbook = new HSSFWorkbook();
        
		//Font 설정.
		HSSFFont font = workbook.createFont();
		font.setFontName(HSSFFont.FONT_ARIAL);

		//제목의 스타일 지정
		HSSFCellStyle titlestyle = workbook.createCellStyle();
		titlestyle.setFillForegroundColor(HSSFColor.SKY_BLUE.index);
		titlestyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		titlestyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		titlestyle.setFont(font);

        // Create two sheets in the excel document and name it First Sheet and
        // Second Sheet.
        HSSFSheet sheet  = workbook.createSheet("FIRST SHEET"); 

        // Manipulate the firs sheet by creating an HSSFRow wich represent a
        // single row in excel sheet, the first row started from 0 index. After
        // the row is created we create a HSSFCell in this first cell of the row
        // and set the cell value with an instance of HSSFRichTextString
        // containing the words FIRST SHEET.
        HSSFRow row = sheet.createRow(0); 
        
		//Cell 생성
		HSSFCell cell1 = row.createCell(0);cell1.setCellValue("고객사");	cell1.setCellStyle(titlestyle);					
		HSSFCell cell2 = row.createCell(1);cell2.setCellValue("발주일");	cell2.setCellStyle(titlestyle);							
		HSSFCell cell3 = row.createCell(2);cell3.setCellValue("발주번호");	cell3.setCellStyle(titlestyle);					
		HSSFCell cell4 = row.createCell(3);cell4.setCellValue("납품총금액");cell4.setCellStyle(titlestyle);
		HSSFCell cell5 = row.createCell(4);cell5.setCellValue("납품품목수");cell5.setCellStyle(titlestyle);
		HSSFCell cell6 = row.createCell(5);cell6.setCellValue("납기요청일");cell6.setCellStyle(titlestyle);
		HSSFCell cell7 = row.createCell(6);cell7.setCellValue("납품예정일");cell7.setCellStyle(titlestyle);
		HSSFCell cell8 = row.createCell(7);cell8.setCellValue("도착지주소");		cell8.setCellStyle(titlestyle);
		HSSFCell cell9 = row.createCell(8);cell9.setCellValue("비고");		cell9.setCellStyle(titlestyle);
		HSSFCell cell10 = row.createCell(9);cell10.setCellValue("비고2");		cell10.setCellStyle(titlestyle);
		HSSFCell cell11 = row.createCell(10);cell11.setCellValue("KEP담당자");		cell11.setCellStyle(titlestyle);		
		
		//내용 스타일 지정
		HSSFCellStyle style = workbook.createCellStyle();
		style.setFont(font);

		//내용중 가운데 정렬 추가
		HSSFCellStyle styleCenter = workbook.createCellStyle();
		styleCenter.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		styleCenter.setFont(font);
		
		//logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		for (int i=0; i<_data.size();i++){
			Map<String,String> _tmp = _data.get(i);
		    row = sheet.createRow((i+1));
		   
		    cell1 = row.createCell(0);cell1.setCellValue(CommonUtil.nvl( _tmp.get("BUYER_NAME")));cell1.setCellStyle(styleCenter);
		    cell2 = row.createCell(1);cell2.setCellValue(CommonUtil.formatDate( _tmp.get("PO_CREATE_DATE")));cell2.setCellStyle(style);					    
		    cell3 = row.createCell(2);cell3.setCellValue(CommonUtil.nvl( _tmp.get("PO_NO")));cell3.setCellStyle(styleCenter);
		    cell4 = row.createCell(3);cell4.setCellValue(Double.parseDouble(CommonUtil.formatNumber( _tmp.get("AGENT_SUM_PRICE"), false, 0, 3)));cell4.setCellStyle(style);
		    cell5 = row.createCell(4);cell5.setCellValue(Double.parseDouble(CommonUtil.formatNumber( _tmp.get("DS_ITEM_QTY"), false, 0, 0)));cell5.setCellStyle(style);
		    cell6 = row.createCell(5);cell6.setCellValue(CommonUtil.formatDate( _tmp.get("RD_DATE")));cell6.setCellStyle(styleCenter);
		    cell7 = row.createCell(6);cell7.setCellValue(CommonUtil.formatDate( _tmp.get("DS_DATE")));cell7.setCellStyle(styleCenter);
		    cell8 = row.createCell(7);cell8.setCellValue(CommonUtil.nvl( _tmp.get("DELY_TO_LOCATION_TEXT")));cell8.setCellStyle(style);
		    cell9 = row.createCell(8);cell9.setCellValue(CommonUtil.nvl( _tmp.get("PO_REMARK2")));cell9.setCellStyle(style);
			cell10 = row.createCell(9);cell10.setCellValue(CommonUtil.nvl( _tmp.get("PO_REMARK")));cell10.setCellStyle(style);
			cell11 = row.createCell(10);cell11.setCellValue(CommonUtil.nvl( _tmp.get("KEP_USER_INFO")));cell11.setCellStyle(style);			
		}
		
        // To write out the workbook into a file we need to create an output
        // stream where the workbook content will be written to.
       
        FileOutputStream fos = null;
        try {
         workbook.write(outputStream);
         outputStream.flush();
           // fos = new FileOutputStream(new File("c:/CreateExcelDemo.xls"));
            //workbook.write(fos);
        } catch (IOException e) {
        	logger.error("파일 쓰기 실패 : ",e);
        } finally {
            if (fos != null) {
                try {
                    fos.flush();
                    fos.close();
                } catch (IOException e) {
                	logger.error("파일 닫기 실패 : ",e);
                }
            }
        }
			 
	}
}
