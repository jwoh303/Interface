package com.koreab2b.mro.seller.mdam.controller;

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
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.seller.mdam.service.SellerMdAmTodoService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMdAmTodoController")
public class SellerMdAmTodoController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMdAmTodoController.class);

	@Autowired
	private SellerMdAmTodoService sellerMdAmTodoService;
	
	// 조회
	@RequestMapping(value = "/mdam/getSellerMdAmTodoList.do", method = RequestMethod.POST)
	public String getSellerMdAmTodoList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mdam/getSellerMdAmTodoList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 

		// 조회일자 Convert
		String _st_from_date = pMap.get("st_from_date").replace("/", "");
		String _st_to_date = pMap.get("st_to_date").replace("/", "");
		pMap.put("st_from_date",_st_from_date);
		pMap.put("st_to_date",_st_to_date);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMdAmTodoService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "seller/mdam/sellerMdAmTodoList";
	}
	
	// 저장
	@RequestMapping(value = "/mdam/saveSellerMdAmTodoList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMdAmTodo(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdam/saveSellerMdAmTodoList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		_pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		
		String flag = sellerMdAmTodoService.updateSelectedData(_pMap, _list);
		_response.put("msg", flag);

		return  _response;
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mdam/excelSellerMdAmTodoList.do", method = RequestMethod.POST)
	public void excelSellerMdAmTodo(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/mdam/excelSellerMdAmTodoList.do 요청 파라미터 for jsp : {}", pMap);
		
		// 조회일자 Convert
		String _st_from_date = pMap.get("st_from_date").replace("/", "");
		String _st_to_date = pMap.get("st_to_date").replace("/", "");
		pMap.put("st_from_date",_st_from_date);
		pMap.put("st_to_date",_st_to_date);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = sellerMdAmTodoService.getList(pMap); 
		   
				response.setHeader("Content-Disposition", "attachment; filename=file.xls");
			  
			 //ModelAndView model = new ModelAndView("excel");
			 // Creating an instance of HSSFWorkbook.
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
					HSSFCell cell1 = row.createCell(0 );cell1.setCellValue("견적번호");cell1.setCellStyle(titlestyle);					
					HSSFCell cell2 = row.createCell(1);cell2.setCellValue("순번");cell2.setCellStyle(titlestyle);			
					HSSFCell cell3 = row.createCell(2);cell3.setCellValue("진행상태");	cell3.setCellStyle(titlestyle);					
					HSSFCell cell4 = row.createCell(3);cell4.setCellValue("상품코드");	cell4.setCellStyle(titlestyle);					
					HSSFCell cell5 = row.createCell(4);cell5.setCellValue("견적의뢰일");	cell5.setCellStyle(titlestyle);
					HSSFCell cell6 = row.createCell(5);cell6.setCellValue("회신요청일");	cell6.setCellStyle(titlestyle);
					HSSFCell cell7 = row.createCell(6);cell7.setCellValue("상품명");	cell7.setCellStyle(titlestyle);					
					HSSFCell cell8 = row.createCell(7);cell8.setCellValue("규격");	cell8.setCellStyle(titlestyle);
					HSSFCell cell9 = row.createCell(8);cell9.setCellValue("수량");	cell9.setCellStyle(titlestyle);
					HSSFCell cell10 = row.createCell(9);cell10.setCellValue("단위");cell10.setCellStyle(titlestyle);
					HSSFCell cell11 = row.createCell(10);cell11.setCellValue("제조사");cell11.setCellStyle(titlestyle);					 
					HSSFCell cell12 = row.createCell(11);cell12.setCellValue("원산지");cell12.setCellStyle(titlestyle);					 
					HSSFCell cell13 = row.createCell(12);cell13.setCellValue("견적단가");cell13.setCellStyle(titlestyle);					 
					HSSFCell cell14 = row.createCell(13);cell14.setCellValue("Nego단가");cell14.setCellStyle(titlestyle);					 
					HSSFCell cell15 = row.createCell(14);cell15.setCellValue("협력사");cell15.setCellStyle(titlestyle);					 
					HSSFCell cell16 = row.createCell(15);cell16.setCellValue("KeP담당자");cell16.setCellStyle(titlestyle);					 
					HSSFCell cell17 = row.createCell(16);cell17.setCellValue("요청자");cell17.setCellStyle(titlestyle);					 
					HSSFCell cell18 = row.createCell(17);cell18.setCellValue("요청부서");cell18.setCellStyle(titlestyle);					 
					HSSFCell cell19 = row.createCell(18);cell19.setCellValue("비고");cell19.setCellStyle(titlestyle);					 
					
					//내용 스타일 지정
					HSSFCellStyle style = workbook.createCellStyle();
					style.setFont(font);
			
					//내용중 가운데 정렬 추가
					HSSFCellStyle styleCenter = workbook.createCellStyle();
					styleCenter.setAlignment(HSSFCellStyle.ALIGN_CENTER);
					styleCenter.setFont(font);
					logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
					for (int i=0; i<_data.size();i++){
						Map<String,String> _tmp = _data.get(i);
					    row = sheet.createRow((i+1));
					   
					    cell1 = row.createCell(0 );cell1.setCellValue(CommonUtil.nvl( _tmp.get("A")));cell1.setCellStyle(styleCenter);
					    cell2 = row.createCell(1 );cell2.setCellValue(CommonUtil.nvl( _tmp.get("B")));cell2.setCellStyle(styleCenter);					    
					    cell3 = row.createCell(2 );cell3.setCellValue(CommonUtil.nvl( _tmp.get("J")));cell3.setCellStyle(styleCenter);
					    cell4 = row.createCell(3 );cell4.setCellValue(CommonUtil.nvl( _tmp.get("D")));cell4.setCellStyle(styleCenter);
					    cell5 = row.createCell(4 );cell5.setCellValue(CommonUtil.nvl( _tmp.get("C")));cell5.setCellStyle(styleCenter);
					    cell6 = row.createCell(5 );cell6.setCellValue(CommonUtil.nvl( _tmp.get("L")));cell6.setCellStyle(styleCenter);
					    cell7 = row.createCell(6 );cell7.setCellValue(CommonUtil.nvl( _tmp.get("D")));cell7.setCellStyle(styleCenter);
					    cell8 = row.createCell(7 );cell8.setCellValue(CommonUtil.nvl( _tmp.get("M")));cell8.setCellStyle(styleCenter);
					    cell9 = row.createCell(8 );cell9.setCellValue(CommonUtil.nvl( String.valueOf(_tmp.get("N"))));cell9.setCellStyle(styleCenter);
					    cell10 = row.createCell(9 );cell10.setCellValue(CommonUtil.bnvl( _tmp.get("E")));cell10.setCellStyle(styleCenter);
					    cell11 = row.createCell(10 );cell11.setCellValue(CommonUtil.nvl( _tmp.get("G")));cell11.setCellStyle(styleCenter);
					    cell12 = row.createCell(11 );cell12.setCellValue(CommonUtil.nvl( _tmp.get("H")));cell12.setCellStyle(styleCenter);
					    cell13 = row.createCell(12 );cell13.setCellValue(CommonUtil.nvl( String.valueOf(_tmp.get("O"))));cell13.setCellStyle(styleCenter);
					    cell14 = row.createCell(13 );cell14.setCellValue(CommonUtil.nvl( String.valueOf(_tmp.get("O"))));cell14.setCellStyle(styleCenter);
					    cell15 = row.createCell(14 );cell15.setCellValue(CommonUtil.nvl( _tmp.get("U")));cell15.setCellStyle(styleCenter);
					    cell16 = row.createCell(15 );cell16.setCellValue(CommonUtil.nvl( _tmp.get("W")));cell16.setCellStyle(styleCenter);
					    cell17 = row.createCell(16 );cell17.setCellValue(CommonUtil.nvl( _tmp.get("I")));cell17.setCellStyle(styleCenter);
					    cell18 = row.createCell(17 );cell18.setCellValue(CommonUtil.nvl( _tmp.get("Q")));cell18.setCellStyle(styleCenter);
					    cell19 = row.createCell(18 );cell19.setCellValue(CommonUtil.nvl( _tmp.get("P")));cell19.setCellStyle(styleCenter);
					    
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
