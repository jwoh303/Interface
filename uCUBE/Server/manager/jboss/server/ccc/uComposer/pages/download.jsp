<%@ page contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.io.*" %> 
<% 
	//응답 헤더의 Content-Type을 세팅한다. 
	response.setContentType("application/x-msdownload"); 
	
	String filepath = request.getParameter("filepath"); 
	//Content-Disposition 헤더에 세팅하기위해 file 이름을 코드 변환한다. 
	//한글파일 Download 시에 에러가 나는게 이 코드가 빠져 있어서 
	String filename2 = new String(filepath.getBytes("UTF-8"),"8859_1"); 
	//Content-Disposition 헤더에 파일 이름 세팅. 
	response.setHeader("Content-Disposition","attachment; filename="+filename2); 
	//해당 경로의 파일 객체를 만든다. 
	File file = new File (filepath); 
	//파일 스트림을 저장하기 위한 바이트 배열 생성. 
	byte[] bytestream = new byte[(int)file.length()]; 
	//파일 객체를 스트림으로 불러온다. 
	FileInputStream filestream = new FileInputStream(file); 
	//파일 스트림을 바이트 배열에 넣는다. 
	int i = 0, j = 0; 
	
	while((i = filestream.read()) != -1) { 
	bytestream[j] = (byte)i; 
	j++; 
	} 
	// 응답 스트림 객체를 생성한다. 
	OutputStream outStream = response.getOutputStream(); 
	// 응답 스트림에 파일 바이트 배열을 쓴다. 
	outStream.write(bytestream); 
	outStream.close(); 
%> 
