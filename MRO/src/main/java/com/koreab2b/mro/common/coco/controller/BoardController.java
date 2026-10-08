package com.koreab2b.mro.common.coco.controller;

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

import com.koreab2b.mro.common.coco.service.BoardService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.DateTimeUtil;

@Controller("BoardController")
public class BoardController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BoardController.class);

	@Autowired
	private BoardService boardService;
	
	@RequestMapping(value = "/master/boardViewList.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showBoardView(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		//페이징시 필요한 default value
		pMap.put("paging", "1");
		pMap.put("curPage", "1");
		pMap.put("onepagerow", "10");
		
		pMap.put("sbtype", "ALL");
		pMap.put("sacl", "ALL");
		pMap.put("st_open_flag", "ALL");
		pMap.put("startDate", DateTimeUtil.getFormatString("yyyyMMdd"));
		
		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0");
		
		List<Map<String, String>> _data = boardService.boardList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "common/board/boardList";
	}	
	
	
	
	
	@RequestMapping(value = "/master/boardViewList_new.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showBoardView_new(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		//페이징시 필요한 default value
		pMap.put("paging", "1");
		pMap.put("curPage", "1");
		pMap.put("onepagerow", "10");
		
		pMap.put("sbtype", "ALL");
		pMap.put("sacl", "ALL");
		pMap.put("st_open_flag", "ALL");
		pMap.put("startDate", DateTimeUtil.getFormatString("yyyyMMdd"));
		
		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0");
		
		List<Map<String, String>> _data = boardService.boardList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "common/board/boardList_new";
	}	
	
	
	
 
	/**
	 * 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/board/boardList.do", method = RequestMethod.POST)
	public String boardList(ModelMap pModel, @RequestParam Map<String, String> pMap) {

		if (pMap.get("startDate") != null){
			pMap.put("startDate" , pMap.get("startDate").replaceAll("/", ""));
		}
		
		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0");
		
		List<Map<String, String>> _data = boardService.boardList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "common/board/boardList";
	}	
	 
	/**
	 * 등록처리
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/board/boardWrite.do", method = RequestMethod.POST)
	public String boardWrite(HttpServletRequest request, ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		boardService.boardWrite(pMap);
		
		pModel.addAttribute("result", "S");
		
		return "common/board/boardWriteForm";
	}	
	
	/**
	 * 상세
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/board/boardDetail.do", method = RequestMethod.POST)
	public String boardDetail(HttpServletRequest request, ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
 
		
		Map<String, String> _detailMap = boardService.boardDetail(pMap);
		
		pModel.addAttribute("detail", _detailMap);
		
		return "common/board/boardDetailForm";
	}	
	
	/**
	 * 수정처리
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/board/boardUpdate.do", method = RequestMethod.POST)
	public String boardUpdate(HttpServletRequest request, ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		
		boardService.boardUpdate(pMap);
		
		pModel.addAttribute("result", "U");
		
		return "common/board/boardDetailForm";
	}	
	
	/**
	 * 삭제처리
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/board/boardDelete.do", method = RequestMethod.POST)
	public String boardDelete(HttpServletRequest request, ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
 
		 
		boardService.boardDelete(pMap);
		
		pModel.addAttribute("result", "D");
		
		return "common/board/boardDetailForm";
	}	
	 
	/**
	 * 코드 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/board/codeMasterList.do", method = RequestMethod.POST)
	public String codeMasterList(ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		  
		List<Map<String, String>> _data = boardService.codeMasterList(pMap); 
		pModel.addAttribute("data", _data);
		
		return "common/board/codeMasterViewList";
	}	
	 
	
	
	/**
	 * 코드 EXCEL 다운로드 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/board/codeMasterExcelList.do", method = RequestMethod.POST)
	public void codeMasterExcelList(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
 
		List<Map<String, String>> _data = boardService.codeMasterList(pMap); 
		   
		 
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
					HSSFCell cell1 = row.createCell(0 );cell1.setCellValue("TYPE");cell1.setCellStyle(titlestyle);					
					HSSFCell cell2 = row.createCell(1);cell2.setCellValue("CODE");cell2.setCellStyle(titlestyle);			
					HSSFCell cell3 = row.createCell(2);cell3.setCellValue("TEXT1");	cell3.setCellStyle(titlestyle);					
					HSSFCell cell4 = row.createCell(3);cell4.setCellValue("TEXT2");	cell4.setCellStyle(titlestyle);					
					HSSFCell cell5 = row.createCell(4);cell5.setCellValue("TEXT3");	cell5.setCellStyle(titlestyle);
					HSSFCell cell6 = row.createCell(5);cell6.setCellValue("TEXT4");	cell6.setCellStyle(titlestyle);
					HSSFCell cell7 = row.createCell(6);cell7.setCellValue("TEXT5");	cell7.setCellStyle(titlestyle);					
					HSSFCell cell8 = row.createCell(7);cell8.setCellValue("TEXT6");	cell8.setCellStyle(titlestyle);
					HSSFCell cell9 = row.createCell(8);cell9.setCellValue("FLAG");	cell9.setCellStyle(titlestyle);
					HSSFCell cell10 = row.createCell(9);cell10.setCellValue("VALUE1");cell10.setCellStyle(titlestyle);
					HSSFCell cell11 = row.createCell(10);cell11.setCellValue("ADD_DATE");cell11.setCellStyle(titlestyle);					 
					
					//내용 스타일 지정
					HSSFCellStyle style = workbook.createCellStyle();
					style.setFont(font);
			
					//내용중 가운데 정렬 추가
					HSSFCellStyle styleCenter = workbook.createCellStyle();
					styleCenter.setAlignment(HSSFCellStyle.ALIGN_CENTER);
					styleCenter.setFont(font);
					LOGGER.debug("codeMasterExcelList 요청 파라미터 for jsp : _data.size()  {}", _data.size());
					for (int i=0; i<_data.size();i++){
						Map<String,String> _tmp = _data.get(i);
					    row = sheet.createRow((i+1));
					   
					    cell1 = row.createCell(0 );cell1.setCellValue(CommonUtil.nvl( _tmp.get("TYPE")));cell1.setCellStyle(styleCenter);
					    cell2 = row.createCell(1 );cell2.setCellValue(CommonUtil.nvl( _tmp.get("CODE")));cell2.setCellStyle(styleCenter);					    
					    cell3 = row.createCell(2 );cell3.setCellValue(CommonUtil.nvl( _tmp.get("TEXT1")));cell3.setCellStyle(styleCenter);
					    cell4 = row.createCell(3 );cell4.setCellValue(CommonUtil.nvl( _tmp.get("TEXT2")));cell4.setCellStyle(styleCenter);
					    cell5 = row.createCell(4 );cell5.setCellValue(CommonUtil.nvl( _tmp.get("TEXT3")));cell5.setCellStyle(styleCenter);
					    cell6 = row.createCell(5 );cell6.setCellValue(CommonUtil.nvl( _tmp.get("TEXT4")));cell6.setCellStyle(styleCenter);
					    cell7 = row.createCell(6 );cell7.setCellValue(CommonUtil.nvl( _tmp.get("TEXT5")));cell7.setCellStyle(styleCenter);
					    cell8 = row.createCell(7 );cell8.setCellValue(CommonUtil.nvl( _tmp.get("TEXT6")));cell8.setCellStyle(styleCenter);
					    cell9 = row.createCell(8 );cell9.setCellValue(CommonUtil.nvl( _tmp.get("FLAG")));cell9.setCellStyle(styleCenter);
					    cell10 = row.createCell(9 );cell10.setCellValue(CommonUtil.bnvl( _tmp.get("VALUE1")));cell10.setCellStyle(styleCenter);
					    cell11 = row.createCell(10 );cell11.setCellValue(CommonUtil.nvl( _tmp.get("ADD_DATE")));cell11.setCellStyle(styleCenter);
					    
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
			        	LOGGER.error("파일 쓰기 실패 : ",e);
			        } finally {
			            if (fos != null) {
			                try {
			                    fos.flush();
			                    fos.close();
			                } catch (IOException e) {
			                	LOGGER.error("파일 닫기 실패 : ",e);
			                }
			            }
			        }
		 
	} 
	
	/**
	 * 코드 CRUD
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/board/codeMasterProcess.do", method = RequestMethod.POST)
	@ResponseBody
	public  Map<String, Object> codeMasterProcess(ModelMap pModel,@RequestParam MultiValueMap<String, String> pMap, HttpServletRequest request) {
 
		
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
 
		//System.out.println("codeMasterProcess " +_sessionInfo.getUserId()); // 세션테스트		
		_pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST
		
		boardService.codeMasterProcess(_list,_pMap); 
		pModel.addAttribute("result", "S");
		
		return _response;
	}
	
	/**
	 * 선택 회원사  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdam/getMasterMdAmSelectCompanyPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdAmSelectCompanyPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		 
		List<Map<String, String>> _data = boardService.getMasterMdAmSelectCompanyPop(pMap);
		pModel.addAttribute("data", _data); 
		return "common/popup/mdam/masterMdAmSelectCompanyPop";
	}	
	
	/**
	 * 승인/승인취소
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/board/boardConfirm.do", method = RequestMethod.POST)
	@ResponseBody
	public  Map<String, Object> boardConfirm(ModelMap pModel,@RequestParam Map<String, String> pMap, HttpServletRequest request) {
 		
		Map<String, Object> _response = new HashMap<String, Object>();  
		String flag = boardService.boardConfirm(pMap);
		_response.put("msg", flag);
		
		return _response;
	}
	 
}
