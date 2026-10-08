<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook" %>
<%@ page import="org.apache.poi.poifs.filesystem.POIFSFileSystem" %>
<%@ page import="org.apache.poi.ss.usermodel.Cell" %>
<%@ page import="org.apache.poi.ss.usermodel.DateUtil" %>
<%@ page import="org.apache.poi.ss.usermodel.Row" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFCell" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFRow" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFSheet" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFWorkbook" %>
<%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
	if(request.getProtocol().equals("HTTP/1.1"))
	response.setHeader("Cache-Control", "no-cache");

    //====================================================================================================
    // [ 사용자 환경 설정 #1 ]
    //====================================================================================================
    // Html 페이지의 엔코딩이 utf-8 로 구성되어 있으면 "isUTF8 = true;" 로 설정하십시오.
    // 한글 헤더가 있는 그리드에서 엑셀 로딩이 동작하지 않으면 이 값을 바꿔 보십시오.
    // Down2Excel.jsp 에서의 설정값과 동일하게 바꿔주십시오.
    //====================================================================================================
	boolean isUTF8 = false;
	//boolean isUTF8 = true;

    //====================================================================================================
    // [ 사용자 환경 설정 #2 ]
	//====================================================================================================
	// LoadExcel 용도의 엑셀파일을 업로드하여 임시보관할 임시폴더경로를 지정해 주십시오.
	// 예 : "C:/tmp/"   "/usr/tmp/"
	//====================================================================================================
	String tmpFolder = "d:/";

	//====================================================================================================
	// 이하는 Java Server Page 전문가만 수정을 권장합니다.
	//====================================================================================================
	String MustDeletePath = "";

//out.println(XSSFCell.CELL_TYPE_NUMERIC+"//");

try{
	// 업로드 엑셀 파일을 수신하고 임시폴더에 저장함
	String contentType = request.getContentType();
	request.setCharacterEncoding("utf-8");

	if ((contentType == null))
	{
		out.println("<script>try{parent.document.getElementById('IBSheetLoadExcelFileFinder').click();}catch(e){}</script>");
	}

	// 자료를 수신한 경우의 로딩자료 리턴
	if ((contentType != null) && (contentType.indexOf("multipart/form-data") >= 0))
	{
		MyData data = new MyData();

		// 자료를 수신함
		DataInputStream in = new DataInputStream(request.getInputStream());
		int formDataLength = request.getContentLength();
		data.dataBytes = new byte[formDataLength];
		data.LoadRowCount = 0;
		int byteRead = 0;
		int totalBytesRead = 0;
		String rdata="";

		// 수신 자료를 메모리에 담음
		while (totalBytesRead < formDataLength)
		{
			byteRead = in.read(data.dataBytes,totalBytesRead,formDataLength);
			totalBytesRead += byteRead;
		}

		// 수신 자료를 분석함
		if(isUTF8)
		{
			rdata = new String(data.dataBytes,"UTF-8");
		}
		else
		{
			rdata = new String(data.dataBytes);
		}

//out.println("수신자료:"+rdata+"<br><br>");
		String ColumnTagValue = "";
		String UploadFileName = "";

		int lastIndex = contentType.lastIndexOf("=");
		String boundary = contentType.substring(lastIndex + 1,contentType.length());

		ColumnTagValue = rdata.substring(rdata.indexOf("name=\"ColumnTag\"") + 20);
		ColumnTagValue = ColumnTagValue.substring(0, ColumnTagValue.indexOf(boundary));
//out.println("<textarea>컬럼정보:"+ColumnTagValue+"<br><br>");

		UploadFileName = rdata.substring(rdata.indexOf("filename=\"") + 10);
		UploadFileName = UploadFileName.substring(0, UploadFileName.indexOf("\n"));
		UploadFileName = UploadFileName.substring(UploadFileName.lastIndexOf("/") + 1,UploadFileName.indexOf("\""));


		// 첨부파일을 가려냄
		int startPos = 0;
		int endPos = 0;

		startPos = mGetPos(0, data.dataBytes,("name=\"file\"; filename=").getBytes("8859_1"));
		startPos = mGetPos(startPos, data.dataBytes,("\r\n\r\n").getBytes("8859_1"));
		endPos = mGetPos(startPos, data.dataBytes,boundary.getBytes("8859_1"))-boundary.length()-4;

		// 첨부파일을 임시폴더에 저장함
		String UploadFileExt = "";
		String SaveFileName = "";
		UploadFileExt = UploadFileName.substring(UploadFileName.lastIndexOf(".")+1);
//out.println("업로드 확장자:"+UploadFileExt+"<br><br>");

		if(UploadFileExt.indexOf("xls")>=0) // 엑셀 파일들만 로딩 허용함
		{
			Random r = new Random();
			int UniqNo = r.nextInt(32768*32768);
			SaveFileName = UniqNo+"."+UploadFileExt;

//out.println("저장파일명:"+SaveFileName+"<br><br>");

			MustDeletePath = tmpFolder + SaveFileName;
			FileOutputStream fileOut=null;
			fileOut = new FileOutputStream(tmpFolder + SaveFileName);
			fileOut.write(data.dataBytes, startPos,(endPos - startPos)); // 받은 파일 저장하기
			fileOut.flush();
			fileOut.close();

			// LoadExel 인자를 받아 적용함
			data.ColList = ColumnTagValue;
			data.Mode = getPropValue(data.ColList,"Mode");
			data.SearchMode = getPropValue(data.ColList,"SearchMode");
			data.OrgColList = data.ColList;
			data.MaxCols = Integer.parseInt(getPropValue(data.ColList,"MaxCols"));
			data.filePath = tmpFolder + SaveFileName;
			data.headerRows = Integer.parseInt(getPropValue(data.ColList,"HeaderRows"));
			if(data.Mode.equals("NoHeader") || data.Mode.equals("NOHEADER"))
			{
				data.headerRows = 0;
			}
			data.saveName = new String[512]; //최대 512 개의 엑셀 컬럼 로딩을 지원함
			data.colType = new String[512];
			data.colFormat = new String[512];
			
			data.ColumnMapping = getPropValue(data.ColList,"ColumnMapping").split("\\|");
			data.StatusCol = getPropValue(data.ColList,"StatusCol");
			data.saveNameOrg = getPropValue(data.ColList,"SaveNames").split("\\|");
//out.println("<<"+getPropValue(data.ColList,"SaveNames")+">>");
			if(getPropValue(data.ColList,"ColumnMapping").equals("")) data.isColumnMapping = false;
			else data.isColumnMapping = true;

			data.WorkSheetName = getPropValue(data.ColList,"WorkSheetName");
			data.WorkSheetNo = Integer.parseInt(getPropValue(data.ColList,"WorkSheetNo"));
			data.StartRow = Integer.parseInt(getPropValue(data.ColList,"StartRow"));
//			data.bUnMatchColHidden = Integer.parseInt(getPropValue(data.ColList,"UnMatchColHidden"));

			if(data.StartRow < 1)
			{
				data.StartRow=1;
			}
			data.EndRow = Integer.parseInt(getPropValue(data.ColList,"EndRow"));

			// JSON 결과를 리턴함
			out.print("<html><head><script>var targetWnd = null; if(opener!=null) {targetWnd = opener;} else {targetWnd = parent;} targetWnd.gJson='{data:[[");
			if(UploadFileExt.indexOf("xlsx")>=0)
			{
				LoadExcelx(out, data);
			}
			else
			{
				LoadExcel(out, data);
			}
			mDeleteFile(MustDeletePath);


			String sUnMatchColumn = "";
/*			
			for(int i=0;i<data.saveNameOrg.length;i++)
			{
				if(!(""+data.saveName[i]).equals(data.saveNameOrg[i]))
				{
					sUnMatchColumn += "|"+data.saveNameOrg[i];
				}
			}
*/

			out.print("]]}';"+((data.SearchMode.equals("3"))?"targetWnd.Grids[targetWnd.gTargetExcelSheetID].SetTotalRows("+data.LoadRowCount+");":"")+"targetWnd.Grids[targetWnd.gTargetExcelSheetID].DoSearchScript('gJson','EXCEL');");
//targetWnd.Grids[targetWnd.gTargetExcelSheetID].mRaiseEventOnLoadExcel(targetWnd.Grids[targetWnd.gTargetExcelSheetID]);
//((data.SearchMode==2)?"targetWnd.Grids[targetWnd.gTargetExcelSheetID].SetTotalRows("+data.LoadRowCount+");":"")
			if(data.bUnMatchColHidden==1)
			{
				out.print("targetWnd.Grids[targetWnd.gTargetExcelSheetID].mUnMatchColHidden('"+sUnMatchColumn+"');");
			}
			out.print("</script></head></body></html>");
		}
	}
}
catch(Exception e)
{
	e.printStackTrace();
	mDeleteFile(MustDeletePath);
}
%>


<%!

void mDeleteFile(String path) throws Exception
{
	if(path.equals("")) return;

	try
	{
		// 사용했던 파일 제거
		File myFile = null;
		myFile = new File(path);
		myFile.delete();
	}
	catch(Exception e)
	{

	}
}


// 엑셀문서의 셀자료를 브라우저로 전송합니다.
void mCellMap(JspWriter out, MyData data, int row, int col, String TheText, String TheText2, String TheText3) throws Exception
{

	int i;
	int ExcelColumnNo = 0;
	// 헤더분석
	if (row < data.headerRows+data.StartRow-1 || (data.Mode.equals("NoHeader") || data.Mode.equals("NOHEADER")) && row==data.StartRow-1) // 헤더자료면 헤더-컬럼속성 자료 준비
	{
		if(data.Mode.equals("HeaderMatch") || data.Mode.equals("HEADERMATCH"))
		{
//out.println("[["+data.ColList.replace("","").replace("\r","")+"::"+TheText+"~~"+getPropValue(data.ColList.replace("\r","").replace("",""),TheText.replace("\r","").replace("",""))+"]]");

			// 2012.05.11 필수컬럼 (*) 에러 픽스
			TheText = TheText.replace("(*)", "");
			
			if(!getPropValue(data.ColList, TheText).equals(""))
			{
				data.saveName[col]  = getPropValue(data.ColList, TheText);	// 해당 엑셀컬럼이 그리드의 어떤 SaveName 인지 찾아냄.
				data.colType[col]   = getPropValue(data.ColList, TheText+"_IBSCT");	// 해당 엑셀컬럼이 그리드의 어떤 SaveName 인지 찾아냄.
				data.colFormat[col] = getPropValue(data.ColList, TheText+"_IBSCF");
					
			}
			System.out.println("data.saveName[col] " + data.saveName[col]);

			//헤더매칭 처리
			data.ColList = data.ColList.replaceFirst("<"+TheText+">","");
			data.ColList = data.ColList.replaceFirst("</"+TheText+">","");
			data.ColList = data.ColList.replaceFirst("<"+TheText+"_IBSCT>","");
			data.ColList = data.ColList.replaceFirst("</"+TheText+"_IBSCT>","");
			data.ColList = data.ColList.replaceFirst("<"+TheText+"_IBSCF>","");
			data.ColList = data.ColList.replaceFirst("</"+TheText+"_IBSCF>","");
		}
		else
		{
			data.saveName[col] = getPropValue(data.ColList,col+"");	// 해당 엑셀컬럼이 그리드의 어떤 SaveName 인지 찾아냄.
			data.colType[col] = getPropValue(data.ColList,col+"_IBSCT");	// 해당 엑셀컬럼이 그리드의 어떤 SaveName 인지 찾아냄.
			data.colFormat[col] = getPropValue(data.ColList,col+"_IBSCF");
				
		}
	}
//System.out.println("data.saveName[col] " + data.saveName[col]);
	// 데이터 처리
		if (row >= data.headerRows+data.StartRow-1) // 데이타이면 헤더컬럼속성 따라 매핑
		{
			if(data.TempRow_StatusCol!=row) //그리드에 상태 컬럼있으면 상태값 I 강제 추가
			{
				if(!data.StatusCol.equals(""))
				{
					out.print(data.StatusCol+":\"I\",");
					data.TempRow_StatusCol=row;
				}
			}

			if((""+data.saveName[col]).equals("")){return;} //SaveName 못찾은 항목은 제외됨
	
			// 0.0 이 1처럼 체크되는 현상
			if(" CheckBox Radio DelCheck ".indexOf(" "+data.colType[col]+" ")>-1)
			{
				if(TheText.equals("0.0"))
				{
					TheText = "0";
				}
			}

			// 소수타입에서 소수점 짤림 현상
			if(" AutoSum AutoAvg Float NullFloat ".indexOf(" "+data.colType[col]+" ")>-1)
			{
				TheText = TheText2;
			}

			// 소수타입에서 소수점 짤림 현상
			if(" Text Date ".indexOf(" "+data.colType[col]+" ")>-1)
			{
				if(" Ymd Ym Md Hms Hm ".indexOf(" "+data.colFormat[col]+" ")>-1)
				{
					if(TheText.length() == 8)	// 2012.05.02 20120502 날자형식 지원
					{
						TheText = TheText.substring(0, 4) + "-" + TheText.substring(4, 6) + "-" + TheText.substring(6, 8);
						TheText3 = "";
					}
					
					if(!TheText3.equals(""))
					{
						if(TheText3.indexOf("-")==-1)
						{
							TheText = mDateValue(data,col, TheText3);
						}
					}
				}
			}

			if(data.isColumnMapping) //컬럼매핑
			{
				for(i=0;i<data.ColumnMapping.length;i++)
				{
					ExcelColumnNo = Integer.parseInt("0"+data.ColumnMapping[i]);
					if(ExcelColumnNo>0 && (col+1)==ExcelColumnNo)
					{
						// 소수타입에서 소수점 짤림 현상
						if(" Status ".indexOf(" "+data.colType[i]+" ")>-1)
						{
							;// 레코드별로 엑셀에 상태컬럼없어도 그리드에 상태컬럼있으면 강제로라도 설정해야 해서 일단 여기서 처리하지 않음.
						}
						else
						{
							if(i<data.saveNameOrg.length)
							{
								if(!data.isFirst)
								{
									out.print(",");
								}
								out.print(data.saveNameOrg[i]+":\""+TheText.replace("\r","\\\\r").replace("\n","\\\\n").replace("\"","\\\\\"").replace("'","\\\'")+"\"");
								data.isFirst = false;
							}
						}
					}
				}
			}
			else //일반
			{
				// 소수타입에서 소수점 짤림 현상
				if(" Status ".indexOf(" "+data.colType[col]+" ")>-1)
				{
					return; // 레코드별로 엑셀에 상태컬럼없어도 그리드에 상태컬럼있으면 강제로라도 설정해야 해서 일단 여기서 처리하지 않음.
				}
				if(data.saveName[col]!=null)
				{
					if(!data.isFirst)
					{
						out.print(",");
					}
					out.print(data.saveName[col]+":\""+TheText.replace("\r","\\\\r").replace("\n","\\\\n").replace("\"","\\\\\"").replace("'","\\\'")+"\"");
					data.isFirst = false;
				}
	
			}



		}
	
	return;
}


// 사용하는 변수들을 선언합니다.
public class MyData
{
	int MaxCols = 0;
	int headerRows = 0;
	int StartRow = 0;
	int EndRow = 0;
	int TempRow_StatusCol = -1;
	int LoadRowCount = 0;
	String SearchMode = "";
	String Mode = "";
	String StatusCol = "";
	String ColList = "";
	String OrgColList = "";
	String filePath = "";
	String saveName[] = null;
	String saveNameOrg[] = null;
	String colType[] = null;
	String colFormat[] = null;
	String dataType[] = null;
	String ColumnMapping[] = null;
	boolean isColumnMapping = false;
	int bUnMatchColHidden = 0; // 사용자가 1 설정하면 1로 들어가서 언매치 컬럼들이 컬럼히든처리됨
	boolean isFirst = false;
	int WorkSheetNo = 0;
	String WorkSheetName = "";
	byte dataBytes[] = null;
}

// 속성 값을 얻어 냅니다.
String getPropValue(String Header, String prop) throws Exception
{
	int findS = 0;
	int findE = 0;

	Header = Header.replace("\r","");
	prop = prop.replace("\r","");

	findS = Header.indexOf("<"+prop+">");
	findE = Header.indexOf("</"+prop+">");

	if(findS != -1 && findE != -1) return Header.substring(findS+prop.length()+2,findE);		// 시작 태그를 제외하고 데이타만 리턴해줌
	else return "";
}


String mDateValue(MyData data , int col, String TheText3) throws Exception
{
	SimpleDateFormat df = null;
	if(data.colFormat[col].equals("Ymd"))
	{
		df = new SimpleDateFormat("yyyy-MM-dd");
	}
	if(data.colFormat[col].equals("Ym"))
	{
		df = new SimpleDateFormat("yyyy-MM");
	}
	if(data.colFormat[col].equals("Md"))
	{
		df = new SimpleDateFormat("MM-dd");
	}
	if(data.colFormat[col].equals("Hms"))
	{
		df = new SimpleDateFormat("HH:mm:ss");
	}
	if(data.colFormat[col].equals("Hm"))
	{
		df = new SimpleDateFormat("HH:mm");
	}
	return df.format(new Date(Long.parseLong(TheText3)));
}

// 받은 내용안에서 첨부파일의 위치를 얻어냅니다.
int mGetPos(int StartPos, byte data[], byte findData[]) throws Exception
{
	int i=0, j=0;

	for(i=StartPos;i<data.length;i++)
	{
		for(j=0;j<findData.length;j++)
		{
			if(data[i+j] != findData[j])
			{
				break;
			}
		}
		if(j==findData.length)
		{
			return i+findData.length;
		}
	}

	return -1;
}
// XLS 문서를 로딩합니다.
boolean LoadExcel(JspWriter out, MyData data) throws Exception
{
	POIFSFileSystem excel = new POIFSFileSystem(new FileInputStream(data.filePath));
	HSSFWorkbook workBook = new HSSFWorkbook(new FileInputStream(new File(data.filePath)));
	HSSFSheet sheet = null;
	HSSFRow row = null;
	HSSFCell cell = null;
	DecimalFormat df = new DecimalFormat("#.#################");	

	org.apache.poi.ss.usermodel.FormulaEvaluator evaluator1 = workBook.getCreationHelper().createFormulaEvaluator(); 
	String TheText = "";
	String TheText2 = "";
	String TheText3 = "";
	int sheetNum = workBook.getNumberOfSheets();

	for(int k=0;k<sheetNum;k++)
	{
		if(!data.WorkSheetName.equals(""))
		{
			if(!data.WorkSheetName.equals(workBook.getSheetName(k)))continue;
		}
		else if(data.WorkSheetNo!=0)
		{
			if(k!=data.WorkSheetNo-1)continue;
		}
	    sheet = workBook.getSheetAt(k);
	    int rows = sheet.getLastRowNum();

		for(int r=data.StartRow-1;r<=rows;r++)
		{
			if(data.EndRow!=0)
			{
				if(r>data.EndRow-1) break;
			}

			row = sheet.getRow(r);
			int cells = 0;
			if(row!=null)
			{
				//cells = row.getLastCellNum();//getPhysicalNumberOfCells();
				cells = data.MaxCols;
			}

			//레코드 1개의 시작
			if(r>=data.headerRows+data.StartRow-1)
			{
				out.print("{");
			}
	
			
			if (r < data.headerRows+data.StartRow-1 || (data.Mode.equals("NoHeader") || data.Mode.equals("NOHEADER")) && r==data.StartRow-1) // 헤더자료면 헤더-컬럼속성 자료 준비
			{
				//헤더제외
			}
			else
			{
				if(cells<=0) //빈문서인 경우
				{
					if(!data.StatusCol.equals(""))
					{
						out.print(data.StatusCol+":\"I\"");
					}
				}
			}

			data.isFirst = true;
			for(short c=0;c<cells;c++)
			{
				if(row!=null)
				{
				cell = row.getCell(c);
					if(cell== null)
					{
						TheText = "";
						TheText2 = "";
						TheText3 = "";
					}
					else
					{
				switch(cell.getCellType())
				{
					case 0: // Cell.CELL_TYPE_NUMERIC
					case 1: // Cell.CELL_TYPE_STRING
					case 2: // Formula
					case 3: // Cell.CELL_TYPE_BLANK
					case 5: // Cell.CELL_TYPE_ERROR

						TheText = "";
						TheText2 = "";
						TheText3 = "";

						try
						{
							TheText = cell.getStringCellValue()+"";
							TheText2 = TheText;
						}
						catch(IllegalStateException e)
						{
							try
							{
								TheText3 = cell.getDateCellValue().getTime()+"";
							}
							catch(Exception e3)
							{
							}
								
							try
							{
								
								cell.setCellType(Cell.CELL_TYPE_STRING);
								TheText = cell.getStringCellValue()+"";
								TheText2 = TheText;
								
								if(TheText.length()>4)
								{
									if(TheText.indexOf("E")>-1)
									{
										if((TheText+"  ").substring(1,2).equals("."))
										{
											if(TheText.substring(TheText.length()-4,TheText.length()).indexOf("E")>-1)
											{
												TheText = df.format(Double.parseDouble(TheText));
												TheText2 = TheText;
											}
										}
									}
								}
								
								
							}
							catch(Exception e2) // # 등 오류
							{
								TheText = "";
								TheText2 = "";
								TheText3 = "";
							}
						}
						break;


					case 4: //Cell.CELL_TYPE_BOOLEAN
						TheText = Boolean.toString(cell.getBooleanCellValue());
						break;
					default:
				}
					}
				mCellMap(out, data, r, c, TheText, TheText2, TheText3);
				}
			}//cell

			//레코드 1개의 끝
			if(r>=data.headerRows+data.StartRow-1)
			{
				data.LoadRowCount ++;
				out.print("},");
			}
		}//row
	}//sheet
	return true;
}

// XLSX 문서를 로딩합니다.
boolean LoadExcelx(JspWriter out, MyData data) throws Exception
{
	XSSFWorkbook workBook  =  new XSSFWorkbook(new FileInputStream(new File(data.filePath)));
	XSSFSheet sheet    =  null;
	XSSFRow row     =  null;
	XSSFCell cell    =  null;
	
	DecimalFormat df = new DecimalFormat("#.#################");	

	String TheText = "";
	String TheText2 = "";
	String TheText3 = "";
	int sheetNum = workBook.getNumberOfSheets();

	for(int k=0;k<sheetNum;k++)
	{
		if(!data.WorkSheetName.equals(""))
		{
			if(!data.WorkSheetName.equals(workBook.getSheetName(k)))continue;
		}
		else if(data.WorkSheetNo!=0)
		{
			if(k!=data.WorkSheetNo-1)continue;
		}
	    sheet = workBook.getSheetAt(k);
	    int rows = sheet.getLastRowNum();

		for(int r=data.StartRow-1;r<=rows;r++)
		{
//out.println(r+"<br>");
			if(data.EndRow!=0)
			{
				if(r>data.EndRow-1) break;
			}

			row = sheet.getRow(r);
			int cells = 0;
			if(row!=null)
			{
				//cells = row.getLastCellNum();//getPhysicalNumberOfCells();
				cells = data.MaxCols;
			}

			//레코드 1개의 시작
			if(r>=data.headerRows+data.StartRow-1)
			{
				out.print("{");
			}


			if (r < data.headerRows+data.StartRow-1 || (data.Mode.equals("NoHeader") || data.Mode.equals("NOHEADER")) && r==data.StartRow-1) // 헤더자료면 헤더-컬럼속성 자료 준비
			{
				//헤더제외
			}
			else
			{
				if(cells<=0) //빈문서인 경우
				{
					if(!data.StatusCol.equals(""))
					{
						out.print(data.StatusCol+":\"I\"");
					}
				}
			}

			data.isFirst = true;
			for(short c=0;c<cells;c++)
			{
				if(row!=null)
				{

				cell = row.getCell(c);
					if(cell== null)
					{
						TheText = "";
						TheText2 = "";
						TheText3 = "";
					}
					else
					{
				switch(cell.getCellType())
				{
					case 0: // Cell.CELL_TYPE_NUMERIC
					case 1: // Cell.CELL_TYPE_STRING
					case 2: // Formula
					case 3: // Cell.CELL_TYPE_BLANK
					case 5: // Cell.CELL_TYPE_ERROR
						TheText = "";
						TheText2 = "";
						TheText3 = "";

						try
						{
							TheText = cell.getStringCellValue()+"";
							TheText2 = TheText;
						}
						catch(IllegalStateException e)
						{
							try
							{
								TheText3 = cell.getDateCellValue().getTime()+"";
							}
							catch(Exception e3)
							{
							}
								
							try
							{
								cell.setCellType(Cell.CELL_TYPE_STRING);
								TheText = cell.getStringCellValue()+"";
								TheText2 = TheText;
								
								if(TheText.length()>4)
								{
									if(TheText.indexOf("E")>-1)
									{
										if((TheText+"  ").substring(1,2).equals("."))
										{
											if(TheText.substring(TheText.length()-4,TheText.length()).indexOf("E")>-1)
											{
												TheText = df.format(Double.parseDouble(TheText));
												TheText2 = TheText;
											}
										}
									}
								}
							}
							catch(Exception e2) // # 등 오류
							{
								TheText = "";
								TheText2 = "";
								TheText3 = "";
							}
						}
						break;


					case 4: //Cell.CELL_TYPE_BOOLEAN
						TheText = Boolean.toString(cell.getBooleanCellValue());
						break;
					default:
				}
					}

				mCellMap(out, data, r, c, TheText,TheText2, TheText3);
				}
			}//cell

			//레코드 1개의 끝
			if(r>=data.headerRows+data.StartRow-1)
			{
				data.LoadRowCount ++;
				out.print("},");
			}
		}//row
	}//sheet
	return true;
}

%>
