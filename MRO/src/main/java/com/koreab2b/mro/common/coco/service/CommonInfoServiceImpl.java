package com.koreab2b.mro.common.coco.service;

import java.io.File;
import java.io.FileInputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.common.coco.dao.CommonInfoDao;
import com.koreab2b.mro.util.CommonAwsS3;
import com.koreab2b.mro.util.CommonUtil;

@Service("commonInfoService")
public class CommonInfoServiceImpl implements CommonInfoService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonInfoServiceImpl.class);

	@Autowired
	private CommonInfoDao commonInfoDao; 

	public List<Map<String, String>> loginProcess(Map<String, String> pMap) {
		return commonInfoDao.loginProcess(pMap);
	}

	public List<Map<String, String>> ajaxCombo(Map<String, String> pMap) {
		return commonInfoDao.ajaxCombo(pMap);
	}
	
	public List<Map<String,String>> ajaxQueryIdCombo(String queryId)	{
		return commonInfoDao.ajaxQueryIdCombo(queryId);
	}

	public List<Map<String,String>> ajaxQueryIdCombo(Map<String, String> pMap) {
		return commonInfoDao.ajaxQueryIdCombo(pMap);
	}

	public List<Map<String,String>> ajaxQueryIdComboNoCache(Map<String, String> pMap) {
		return commonInfoDao.ajaxQueryIdComboNoCache(pMap);
	}
	
	public String fileUpload(FileUploadForm uploadForm, Map<String,String> _pList) {
		return commonInfoDao.fileUpload(uploadForm, _pList);
	}

	public String imageFileUpload(FileUploadForm uploadForm, Map<String,String> _pList) {
		return commonInfoDao.imageFileUpload(uploadForm, _pList);
	}
	
	public List<Map<String,String>> getFileUploadList(Map<String,String>  pMap) {
		return commonInfoDao.getFileUploadList(pMap); 
	}
	
	public void removeFileInfo(Map<String, String> pMap) {
		commonInfoDao.removeFileInfo(pMap); 
	}
	
	public Map<String,String> getFileUploadDetail(Map<String, String> pMap){
		return commonInfoDao.getFileUploadDetail(pMap); 
	}
	
	public List<Map<String, String>> getFileUploadDetail_v2(Map<String, String> pMap){
		return commonInfoDao.getFileUploadDetail_v2(pMap); 
	}
	public List<Map<String, String>> getFileUploadDetailMulti_v2(Map<String, Object> pMap){
		return commonInfoDao.getFileUploadDetailMulti_v2(pMap); 
	}
	
	public List<Map<String, String>> getFieldNames() {
		return commonInfoDao.selectFieldNames();
	}
	
	/**
	 * 사용자권한조회(도안관리용)
	 */
	public Map<String,String> getUserRole(Map<String,String> formData) {
		return commonInfoDao.selectUserRole(formData);
	}		
	
	// VOC 유형별 담당자 ID 조회
	@Override
	public Map<String,String> getVOCUser(Map<String, String> pMap) {
		return commonInfoDao.getVOCUser(pMap);
	}
	
	public String  excelFileUpload(HttpServletRequest request, 
			ModelMap pModel, 
			@ModelAttribute("uploadForm") FileUploadForm uploadForm, 
			@RequestParam Map<String, String> pMap) {
		
		return excelFileUpload( request, 
				 pModel, 
				 uploadForm, 
				 pMap, "X");
	}
	
	public String  excelFileUpload(HttpServletRequest request, 
			ModelMap pModel, 
			@ModelAttribute("uploadForm") FileUploadForm uploadForm, 
			@RequestParam Map<String, String> pMap, String sheetNum) {

		LOGGER.debug("Excel Upload 요청 파라미터 for jsp : {}", pMap);
		 
		String ret = "";
		String osName = System.getProperty("os.name");
		String _path = CommonUtil.realUploadPath+"/TEMP";
		String saveFileName = "";
		String cellCount = CommonUtil.onvl(pMap.get("cellCount"),"0");
		
		List<MultipartFile> _files = uploadForm.getFiles(); 
		if (null != _files && _files.size() > 0) {
			for (MultipartFile _multipartFile : _files) {
				String _fileName = _multipartFile.getOriginalFilename(); 
				try
				{
					
				 File _destFile = new File(_path + "/" + _fileName); 
				 CommonAwsS3.upload(_multipartFile, _path+ "/" , _fileName);
				 saveFileName = _path + "/" + _fileName;
				 
				 File excelfile = new File(_multipartFile.getOriginalFilename());
				 _multipartFile.transferTo(excelfile);
				 // Excel 처리
                 // Excel 97~2003(.xls)과 Excel 2007(.xlsx)은 각각 처리해야 한다.
                 if( saveFileName.indexOf(".xlsx") > -1 )
                 {
                	 ret = readExcel2007( excelfile,saveFileName , cellCount , sheetNum);
                 } 
                 else if( saveFileName.indexOf(".xls") > -1 ) 
            	 {
                	 ret = readExcel( excelfile,saveFileName , cellCount , sheetNum);
            	 }

                 if( _destFile.exists() ) _destFile.delete();  
                 
				}
				catch(Exception e){ 
					e.printStackTrace();
					throw new RuntimeException("엑셀 업로드 실패하였습니다.");
				} 
			}
		}
		return ret;

	}
	
	
	 // Excel 2007(.xlsx) 이상 파일처리
    public String readExcel2007( File file,String excel  , String cellCount, String sheetNum) throws Exception {
        // check file
//        File file = new File( excel );
        if( !file.exists() || !file.isFile() || !file.canRead() ) {
        	throw new RuntimeException("엑셀 업로드 실패하였습니다.");
        }
        
        int lastCell = 0;
        if ("0".equals(cellCount) || "".equals(cellCount)){
        	lastCell  = 0;
        }else{
        	lastCell = Integer.parseInt(cellCount);
        }
        
        StringBuilder sb = new StringBuilder(); 

        // http://poi.apache.org/apidocs/index.html?overview-summary.html
        // http://poi.apache.org/apidocs/org/apache/poi/xssf/usermodel/XSSFWorkbook.html
        XSSFWorkbook wb = new XSSFWorkbook( new FileInputStream(file) );
        
        int sheetLimit = 0;
        if ("X".equals(sheetNum)){
        	sheetLimit = wb.getNumberOfSheets();
        }else{
        	sheetLimit = Integer.parseInt(sheetNum);
        }
        
        try {
            for( int i=0; i<sheetLimit; i++ ) {            	
                for( Row row : wb.getSheetAt(i) ) { 
                	if (lastCell == 0) lastCell = row.getLastCellNum() ;
                	
                	boolean isEmptyRow = true;
                    for (int inx = 0; inx < lastCell; inx++) {
                        Cell cell = row.getCell(inx);
                        if (cell != null && cell.getCellType() != Cell.CELL_TYPE_BLANK 
                            && !cell.toString().trim().isEmpty()) {
                            isEmptyRow = false;
                            break;
                        }
                    }
                    if (isEmptyRow) continue;
                    
                	for(int inx = 0 ; inx < lastCell ; inx++){
                		Cell cell = row.getCell(inx);
                		
                		if(cell == null){
                			sb.append(""); 
                        	sb.append("@@");
                			continue;
                		}
                		
                        switch( cell.getCellType() ) {
                            case XSSFCell.CELL_TYPE_STRING:
                            	sb.append(cell.getRichStringCellValue().getString());
                            	sb.append("@@");
                                break;
                            case XSSFCell.CELL_TYPE_NUMERIC:
                            	cell.setCellType(XSSFCell.CELL_TYPE_STRING);
                            	sb.append(cell.getRichStringCellValue().getString());
                            	//sb.append(Double.valueOf( cell.getNumericCellValue() ).intValue());
                            	sb.append("@@");
                                break;
                            case XSSFCell.CELL_TYPE_FORMULA:
                            	sb.append(cell.getCellFormula());
                            	sb.append("@@");
                                break;
                            case XSSFCell.CELL_TYPE_BOOLEAN:
                            	sb.append(cell.getBooleanCellValue());
                            	sb.append("@@");
                                break;
                            case XSSFCell.CELL_TYPE_ERROR: 
                            	sb.append(cell.getErrorCellValue()); 
                            	sb.append("@@");
                                break;
                            case XSSFCell.CELL_TYPE_BLANK: 
                            	sb.append(""); 
                            	sb.append("@@");
                            	break;
                            default:
                            	sb.append(""); 
                            	sb.append("@@");
                            	break;
                        }                         
                    }
                    sb.append("|");
                }
            }
                        
            LOGGER.debug("Excel Upload readExcel2007 결과 : {}", sb.toString());
        } catch( Exception ex ) {
        	ex.printStackTrace();
        	throw new RuntimeException("엑셀 업로드 실패하였습니다.");
        }
        
        return sb.toString();
    }


    // Excel 97~2003(.xls) 파일처리
    public String readExcel( File file,String excel  , String cellCount , String sheetNum) throws Exception {
        // check file
//        File file = new File( excel );
        
        if( !file.exists() || !file.isFile() || !file.canRead() ) {
        	throw new RuntimeException("엑셀 업로드 실패하였습니다.");
        }
        
        int lastCell = 0;
        if ("0".equals(cellCount) || "".equals(cellCount)){
        	lastCell  = 0;
        }else{
        	lastCell = Integer.parseInt(cellCount);
        }
        
        StringBuilder sb = new StringBuilder();

        // http://poi.apache.org/apidocs/index.html?overview-summary.html
        // http://poi.apache.org/apidocs/org/apache/poi/hssf/usermodel/HSSFWorkbook.html
        HSSFWorkbook wb = new HSSFWorkbook(new FileInputStream(file));
        
        int sheetLimit = 0;
        if ("X".equals(sheetNum)){
        	sheetLimit = wb.getNumberOfSheets();
        }else{
        	sheetLimit = Integer.parseInt(sheetNum);
        }
        try {
            for( int i=0; i<sheetLimit; i++ ) { 
                for( Row row : wb.getSheetAt(i) ) { 
                	if (lastCell == 0) lastCell = row.getLastCellNum() ;
                	
                	boolean isEmptyRow = true;
                    for (int inx = 0; inx < lastCell; inx++) {
                        Cell cell = row.getCell(inx);
                        if (cell != null && cell.getCellType() != Cell.CELL_TYPE_BLANK 
                            && !cell.toString().trim().isEmpty()) {
                            isEmptyRow = false;
                            break;
                        }
                    }
                    if (isEmptyRow) continue;
                    
                	for(int inx = 0 ; inx < lastCell ; inx++){
                		Cell cell = row.getCell(inx);
                		
                		if(cell == null){
                			sb.append(""); 
                        	sb.append("@@");
                			continue;
                		}

                		switch( cell.getCellType() ) {
                            case HSSFCell.CELL_TYPE_STRING:
                            	sb.append(cell.getRichStringCellValue().getString()); 
                            	sb.append("@@");
                                break;
                            case HSSFCell.CELL_TYPE_NUMERIC: 
                            	cell.setCellType(XSSFCell.CELL_TYPE_STRING);
                            	sb.append(cell.getRichStringCellValue().getString());
                            	//sb.append(Double.valueOf( cell.getNumericCellValue() ).intValue());
                            	sb.append("@@");
                                break;
                            case HSSFCell.CELL_TYPE_FORMULA:
                            	sb.append(cell.getCellFormula());   
                            	sb.append("@@");
                                break;
                            case HSSFCell.CELL_TYPE_BOOLEAN:
                            	sb.append(cell.getBooleanCellValue()); 
                            	sb.append("@@");
                                break;
                            case HSSFCell.CELL_TYPE_ERROR:
                            	sb.append(cell.getErrorCellValue());  
                            	sb.append("@@");
                                break;
                            case HSSFCell.CELL_TYPE_BLANK:
                            	sb.append(""); 
                            	sb.append("@@");
                            	break;
                            default: 
                            	sb.append(""); 
                            	sb.append("@@");
                            	break;
                        }                        
                    }
                    sb.append("|");
                }
            }
            LOGGER.debug("Excel Upload readExcel 결과 : {}", sb.toString());
        } catch( Exception ex ) {
        	ex.printStackTrace();
        	throw new RuntimeException("엑셀 업로드 실패하였습니다.");
        }
        
        return sb.toString();
        
    }

	public Map<String, String> getFileUploadDetailMsds(Map<String, String> pMap) {
		return commonInfoDao.getFileUploadDetailMsds(pMap);
	}

	/**
	 * ICOMATCH 테이블에서 파일 완전 삭제 (DELETE)
	 * @param pMap - D_DOC_NO, D_DOC_SEQ 포함
	 */
	@Override
	public void removeIcomatch(Map<String, String> pMap) {
		commonInfoDao.removeIcomatch(pMap);
	}

	@Override
	public int getFileUploadAtYnCnt(Map<String, String> pMap) {
		return commonInfoDao.getFileUploadAtYnCnt(pMap);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
