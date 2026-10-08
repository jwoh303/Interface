package com.kep.mail.service;

import java.io.File;
import java.io.FileOutputStream;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import org.apache.log4j.Logger;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.kep.common.CommonUtil;
import com.kep.mail.dao.SendMailDao;
import com.kep.mail.dao.SendMailDaoImpl;

public class SendMailServiceImpl implements SendMailService {

	private Logger log	= Logger.getLogger( this.getClass().getName() );

	@Override
	public void executeCretecItemChange() {
		SendMailDao dao = new SendMailDaoImpl();
		List<Map<String, String>> tList	= null;
		/**
		 * 1. 체크 대상 확인 - 카탈로그 관리정보 기준
		 * 2. 대상별 메일 수신자 확인 
		 *   1) GPL은 이관희 과장 / 최진수 / 최철규
		 *   2) 각 고객사 담당자
		 */
		try {
			tList	= dao.getCretecItemTargetList();
			
			for ( Map<String, String> iMap : tList) {
				
			}
		} catch (Exception e) {
			log.error("SendMailService Error : " + e.getMessage());
		}
	}
	
	@Override
	public void execute() {
		SendMailDao dao = new SendMailDaoImpl();
		List<Map<String, String>> tList	= null;
		
		try {
			tList = dao.getTargetList();			
			
			for(Map<String, String> iMap : tList) {
				List<Map<String, Object>> excelList = dao.getExcelDataList(iMap);
				
				// 파일 생성
//				iMap.put("FILE_PATH", "/home/kepm/mail_test/filetmp/");
				iMap.put("FILE_PATH", "D:/temp/filetmp/");

				String[]	arSubject	= {"Site","P/O No.","P/O Seq.","P/O일자","BQMS코드","[제조사] 품명","[모델] 사양","단위","요청자","주문자","예산부서 코드","예산부서 이름","G/R No.","G/R일","정상수량","지불 금액"};
				String[]	arColId		= {"PLANT","LEGACY_PO_NO","LEGACY_PO_SEQ","PO_CREATE_DATE","BUYER_ITEM_NO","DESCRIPTION","SPECIFICATION","UNIT_MEASURE","REQUESTER","PURCHASER","BUDGET_DEPT","BUDGET_NAME","LEGACY_GR_NO","GR_DATE","ITEM_QTY","ITEM_AMT"};
				String sheetSubject	= "마감내역";
				
				String fileName	= makeExcelFile(iMap, excelList, sheetSubject, arSubject, arColId);
				
				if (!"X".equals(fileName)) {
					// 파일 생성 성공
					iMap.put("FILE_NAME", fileName);
					 
					StringBuffer textStr	= new StringBuffer();
					textStr.append("안녕하세요. 코리아이플랫폼 입니다.\n");
					textStr.append("\n");
					textStr.append("아래와 같이 발행 된 계세금산서 상세 내역을 첨부와 같이 송부드리오니 업무 참조 바랍니다.\n");
					textStr.append("\n");
					textStr.append("* 국세청번호 : "+iMap.get("ISSUE_ID")+"\n");
					textStr.append(iMap.get("GR_TERM") + "\n");
					textStr.append(iMap.get("KEP_USER_INFO") + "\n");
					textStr.append("\n");
					textStr.append("감사합니다.\n");
					
					iMap.put("CONTENTS", textStr.toString());
					
					boolean isSuccess = sendMail(iMap);
					
					if (isSuccess == true) {
						iMap.put("RTN_FLG", "S");
						iMap.put("RTN_MSG", "성공");
					} else {
						iMap.put("RTN_FLG", "E");
						iMap.put("RTN_MSG", "메일발송실패");
					}
					// 파일 삭제
					deleteExcelFile(iMap);
				} else {
					// 파일 생성 실패
					iMap.put("RTN_FLG", "E");
					iMap.put("RTN_MSG", "파일 생성 실패.");
				}
				dao.setResult(iMap);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private boolean sendMail(Map<String, String> pMap) {
		String from	= "master@koreab2b.com";
		boolean bRtn	= false;
		
		final String username = "sender";//change accordingly
		final String password = "sender";//change accordingly
		
		// Assuming you are sending email through relay.jangosmtp.net
		String host = "10.20.110.32";
		
		Properties props = new Properties();
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.port", "25");
		props.put("mail.smtp.auth", "true");
		
		// Get the Session object.
		Session session = Session.getInstance(props,
		   new javax.mail.Authenticator() {
		      protected PasswordAuthentication getPasswordAuthentication() {
		    	  return new PasswordAuthentication(username, password);
		      }
			});
		
		try {
			 // Create a default MimeMessage object.
			Message message = new MimeMessage(session);

			InternetAddress toAddrs = new InternetAddress(pMap.get("TO_MAIL"), pMap.get("TO_NAME"));
			InternetAddress fromAddr = new InternetAddress(from, "Master");
			
			 // Set From: header field of the header.
			 message.setFrom(fromAddr);
			
			 // Set To: header field of the header.
			 message.setRecipient(Message.RecipientType.TO, toAddrs);
			
			 // Set Subject: header field
			 message.setSubject(pMap.get("SUBJECT"));
			
			 // Create the message part
			 BodyPart messageBodyPart = new MimeBodyPart();
			
			 // Now set the actual message
			 messageBodyPart.setText(pMap.get("CONTENTS"));
			
			 // Create a multipar message
			 Multipart multipart = new MimeMultipart();
			
			 // Set text message part
			 multipart.addBodyPart(messageBodyPart);
			
			 // Part two is attachment
			 messageBodyPart = new MimeBodyPart();
			 DataSource source = new FileDataSource(pMap.get("FILE_PATH") + pMap.get("FILE_NAME"));
			 messageBodyPart.setDataHandler(new DataHandler(source));
			 messageBodyPart.setFileName(pMap.get("FILE_NAME"));
			 multipart.addBodyPart(messageBodyPart);
			
			 // Send the complete message parts
			 message.setContent(multipart);
			
			 // Send message
			 Transport.send(message);
			
			 log.info("Sent "+pMap.get("ISSUE_ID")+" success....");
			 
			 bRtn = true;
			 
			 if (bRtn == false) {
				toAddrs = new InternetAddress("jinsoo97@koreab2b.com", "최진수");
				
				 // Set From: header field of the header.
				 message.setFrom(fromAddr);
				
				 // Set To: header field of the header.
				 message.setRecipient(Message.RecipientType.TO, toAddrs);
				
				 // Set Subject: header field
				 message.setSubject(pMap.get("SUBJECT"));
				
				 // Create the message part
				 messageBodyPart = new MimeBodyPart();
				
				 // Now set the actual message
				 messageBodyPart.setText(pMap.get("CONTENTS"));
				
				 // Create a multipar message
				 multipart = new MimeMultipart();
				
				 // Set text message part
				 multipart.addBodyPart(messageBodyPart);
				
				 // Part two is attachment
				 messageBodyPart = new MimeBodyPart();
				 source = new FileDataSource(pMap.get("FILE_PATH") + pMap.get("FILE_NAME"));
				 messageBodyPart.setDataHandler(new DataHandler(source));
				 messageBodyPart.setFileName(pMap.get("FILE_NAME"));
				 multipart.addBodyPart(messageBodyPart);
				
				 // Send the complete message parts
				 message.setContent(multipart);
				
				 // Send message
				 Transport.send(message);
			 }
			 
		} catch (Exception e) {
			e.printStackTrace();
			bRtn = false;
			log.info("Sent "+pMap.get("FILE_NAME")+" fail! : " + pMap.get("SUBJECT") + " / " + pMap.get("TO_MAIL") + " / " + pMap.get("TO_NAME"));
        }
		return bRtn;
	}

	@SuppressWarnings("resource")
	private String makeExcelFile(Map<String, String> pMap, List<Map<String, Object>> pList, String sheetSubject, String[] arSubject, String[] arColId) {

		String fileName	= "X";
		
		try {
			
			if (arSubject.length != arColId.length) {
				throw new Exception("Column of ExcelFile is incorrect!!!");
			}
			
			fileName = pMap.get("SRC_FILE_NAME");
			
			//1차로 workbook을 생성
			XSSFWorkbook workbook=new XSSFWorkbook();
			//2차는 sheet생성
			XSSFSheet sheet=workbook.createSheet(sheetSubject);
			//엑셀의 행
			XSSFRow row=null;
			//엑셀의 셀
			XSSFCell cell=null;
			//임의의 DB데이터 조회
			if(pList !=null && pList.size() > 0){
			    int i=0;
				
				// header 생성
				row=sheet.createRow((short) i++);
				for( int cIdx = 0 ; cIdx < arSubject.length ; cIdx++) {

					cell=row.createCell(cIdx+1);
					cell.setCellValue(arSubject[cIdx]);
				}
				
			    for(Map<String,Object> iMap  : pList){

					row=sheet.createRow((short) i++);
					for( int cIdx = 0 ; cIdx < arColId.length ; cIdx++) { 
						cell=row.createCell(cIdx+1);
						if (iMap.get(arColId[cIdx]) instanceof String) {
							cell.setCellValue(String.valueOf(iMap.get(arColId[cIdx])));
						} else if (iMap.get(arColId[cIdx]) instanceof Integer) {
							cell.setCellValue(Integer.valueOf(String.valueOf(iMap.get(arColId[cIdx]))));
						} else if (iMap.get(arColId[cIdx]) instanceof BigDecimal) {
							cell.setCellValue(Integer.valueOf(String.valueOf(iMap.get(arColId[cIdx]))));
						}
					}
			    }
			}
			FileOutputStream fileoutputstream=new FileOutputStream(pMap.get("FILE_PATH") + fileName);
			//파일을 쓴다
			workbook.write(fileoutputstream);
			//필수로 닫아주어야함
			fileoutputstream.close();
		} catch (Exception e) {
			e.printStackTrace();
			fileName	= "X";
			log.error("makeExcelFile ---->\n " + CommonUtil.printStackTraceToString(e));
		}
		return fileName;
    }

	private void deleteExcelFile(Map<String, String> pMap) {
		
		try {
			File f = new File(pMap.get("FILE_PATH") + pMap.get("FILE_NAME"));
			
			if (f.delete()) {
				log.info(pMap.get("FILE_NAME") + " is deleted.");
			} else {
				log.info(pMap.get("FILE_NAME") + " isn't deleted.");
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("deleteExcelFile ---->\n " + CommonUtil.printStackTraceToString(e));
		}
	}

	@Override
	public void executeCowayScrapMail(String FROM_DT, String TO_DT) {
		SendMailDao dao = new SendMailDaoImpl();
		/**
		 * 1. 엑셀 데이터 조회
		 * 2. 엑셀 파일 생성
		 * 3. 메일 수신자 조회
		 * 4. 수신자별 메일 발송
		 * 5. 파일 삭제.
		 */
		
		try {
			List<Map<String, String>> recvs = dao.selectCowayScrapRecvMailList();
			Map<String, String> pMap = new HashMap<String, String>();
			pMap.put("FROM_DT", FROM_DT);
			pMap.put("TO_DT", TO_DT);
			
			List<Map<String, Object>> scraps = dao.selectCowayScrapList(pMap);
			
			if (scraps.size() > 0) {
				Map<String, String> iMap = new HashMap<String, String>();
				// 파일 생성
				iMap.put("FILE_PATH", "/EAI/B2B/java/kepmp/batch/BatchClient/filetmp");
				iMap.put("SRC_FILE_NAME", "COWAYSCRAP_"+FROM_DT+"_"+TO_DT+".xlsx");

				String[]	arSubject	= {"고객사", "협력사", "품목코드", "관리번호", "생성일", "입고일", "품명", "규격", "제조사", "단위", "발주수량", "입고수량", "매출단가", "매출금액", "매입단가", "매입금액", "발주부서", "발주자", "요청부서", "요청자"};
				String[]	arColId		= {"BUYER_NAME", "SELLER_NAME", "BUYER_ITEM_NO", "REF_IF_NO", "ADD_DATE", "GR_DATE", "DESCRIPTION", "SPECIFICATION", "MAKER_NAME", "UNIT_MEASURE", "PO_QTY", "GR_QTY", "UNIT_PRICE", "AMT", "AGENT_PRICE", "AGENT_AMT", "PURCHASER_DEPT", "PURCHASER_NAME", "REQ_USER_DEPT", "REQ_USER_NAME"};
				String sheetSubject	= "폐기발주_"+FROM_DT+"_"+TO_DT;
				String fileName	= makeExcelFile(iMap, scraps, sheetSubject, arSubject, arColId);

				if (!"X".equals(fileName)) {
					// 파일 생성 성공
					iMap.put("FILE_NAME", fileName);
					iMap.put("SUBJECT", "코웨이 폐기발주 내역 전달");
					 
					StringBuffer textStr	= new StringBuffer();
					textStr.append("안녕하세요. 코리아이플랫폼 입니다.\n");
					textStr.append("\n");
					textStr.append("아래와 같이 폐기발주 상세내역을 첨부와 같이 송부드리오니 업무 참조 바랍니다.\n");
					textStr.append("\n");
					textStr.append("발주일 : "+FROM_DT+" ~ "+TO_DT+" \n");
					textStr.append("\n");
					textStr.append("감사합니다.\n");
					
					iMap.put("CONTENTS", textStr.toString());
					for(Map<String, String> rMap : recvs) {
						iMap.put("TO_MAIL", rMap.get("TO_MAIL"));
						iMap.put("TO_NAME", rMap.get("TO_NAME"));
						boolean isSuccess = sendMail(iMap);	
						
						if (isSuccess == true) {
							iMap.put("RTN_FLG", "S");
							iMap.put("RTN_MSG", "성공");
						} else {
							iMap.put("RTN_FLG", "E");
							iMap.put("RTN_MSG", "메일발송실패");
						}
					}
					// 파일 삭제
					deleteExcelFile(iMap);
				} else {
					// 파일 생성 실패
					log.error("executeCowayScrapMail 파일 생성 실패[ "+FROM_DT+" ~ "+TO_DT+" ]");
				}
			} else {
				log.info("executeCowayScrapMail No Data[ "+FROM_DT+" ~ "+TO_DT+" ]");
			}
		} catch (Exception e) {
			log.error("executeCowayScrapMail : " + CommonUtil.printStackTraceToString(e));
		}
	}
}

