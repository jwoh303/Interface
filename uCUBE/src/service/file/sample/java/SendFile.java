/*=========================================================================
*Copyright(c) 2005 POSDATA
*
*@File           : SendFile.java
*
*@FileName       : TC 전송 샘플 프로그램
=========================================================================*/

// 1. u-CUBE package 선언
import com.posdata.eai.adapter.EAIHandler;

import java.util.Arrays;

public class SendFile 
{
    private int m_i = 0;
    
    public SendFile()
    {
   
    }

    public static void main(String[] args)
    {
        String tc = null;
        String configFilePath = null;        
        boolean flag = true;
        
        SendFile send = new SendFile();
        EAIHandler eaiHandler = new EAIHandler();
        
        // 2. u-CUBE Service Configuraion 파일 경로 지정
        configFilePath = "C:\\uCUBE\\service\\file\\config\\cfg\\SEND.xml";
        
        int returnValue = 0;
        
        try
        {
            // initialize UCUBE
            returnValue = eaiHandler.initialize(configFilePath);  
            if (returnValue == 0)
            {
                System.out.println("u-CUBE Engine과의 연결이 성공했습니다.");
            }
            else
            {
                System.out.println("u-CUBE Engine과의 연결을 실패했습니다. 결과=" + returnValue);
                System.exit(returnValue);
            }
       
            
            while(flag)
            {                
                /* Data 전송 */
                returnValue = eaiHandler.sendFile("DEST-SOUR-11", "C:\\ucube\\service\\file\\fileout",
                                                  "sendfile.txt");     
                
                /* 전송 결과 확인 */
                switch (returnValue)
                {
                    case 0  : 
                        System.out.println("송신 성공.");
                        break;
                    case 1  : 
                        System.out.println("송신 실패, Data가 로컬큐잉 되었습니다.");
                        break;
                    case -1 : 
                        System.out.println("송신 실패, 송신 IFD를 확인이 필요합니다.");
                        flag = false;
                        break;
                    case -2 :
                        System.out.println("송신 실패, 로컬큐잉을 하지 않은 Data입니다.");
                        break;
                    case -10 :
                        System.out.println("송신 실패, 로컬 큐 임계치가 초과되었습니다.");
                        break;                        
                    default :
                        System.out.println("송신 실패, CFG, IFD 파일 설정 오류. 결과=" + returnValue);
                        flag = false;
                        break;
                }   
                Thread.sleep(1000);
                
            } // end of while
            
        } catch (Exception ex)
        {
            ex.printStackTrace();            
        }
        
        /* u-CUBE Engine 과의 연결 종료 */
        eaiHandler.onClose();
        System.exit(returnValue);
    }

}
