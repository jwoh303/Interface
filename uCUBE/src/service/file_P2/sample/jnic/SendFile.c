/***********************************************************************/
/* Version       :  1.0                                                */  
/* File NAme     :  SendFile.c                                         */
/* Function      :                                                     */
/***********************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*Declare u-CUBE Header*/
#include <jmsjni.h> 
int sCount = 0;
int bCount = 0;

int main()
{    
	int returnValue = -1;
	int i = 0;
	char* rcvData = NULL;
	char* ifd = NULL;
    int flag = 1;
    char *file_dir = "C:\\ucube\\service\\file\\fileout"';
    char *file_name = "sendfile.txt";
    
	// initialize UCUBE   
	returnValue = initialize("C:\\uCUBE\\service\\file\\config\\cfg\\SEND.xml");
    if(returnValue == 0)    
    {		
    	printf("u-CUBE Engine과의 연결이 성공했습니다.\n");
    }
    else	
    {		
    	printf("u-CUBE Engine과의 연결을 실패했습니다. 결과=[%d]\n", returnValue);
        return returnValue;
	}	
	
    while(flag)    
    {    		
    	/* Wait Send Event */	    
    	/* 전송 Data 편성 */        
    	sendData = editSendData(sendData);
    	
		/* Data 전송 */				
		returnValue = sendFile("DEST-SOUR-11", file_dir, file_name);
		switch (returnValue)		
		{		    
			case 0  :                 
			    printf ("송신 성공. 보낸 Data=[%.20s]\n", sendData);
                break;
		    case 1  :                 
		        printf ("송신 실패, Data가 로컬큐잉 되었습니다.\n");
                break;
		    case -1 : 			    
		        printf ("송신 실패, 송신 IFD를 확인이 필요합니다.\n");
				flag = 0;
			    break;
		    case -2 :			    
		        printf ("송신 실패, 로컬큐잉을 하지 않은 Data입니다.\n");
			    break;
		    case -2 :			    
		        printf ("송신 실패, 송신 파일이 존재하지 않습니다.\n");
			    break;			    
            default :                
                printf ("송신 실패, CFG, IFD 파일 설정 오류. 결과=%d\n", returnValue);
				flag = 0;
                break;
        } 
        
        Sleep(10000);       
    }    
       		
    
    /* u-CUBE Engine 과의 연결 종료 */    
    onClose();
    return returnValue;
    
}