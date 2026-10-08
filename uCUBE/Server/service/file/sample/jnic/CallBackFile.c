/***********************************************************************/
/* PROJECT       :  u-CUBE TEST UAP (FILEUAP)                          */
/* Copyright(c) 2005 POSDATA                                           */
/* Version       :  1.0                                                */  
/* File NAme     :  CallBackFile                                       */
/* Description   :  This source is EAI C UAP sample.                   */ 
/* Function      :                                                     */
/***********************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <windows.h>

/*Declare u-CUBE Header*/
#include <jmsjni.h>

int main()
{
    int returnValue = -1;
	int testnum = 0;

	/* connect to u-CUBE Engine */
    returnValue = initialize("C:\\uCUBE\\service\\file\\config\\cfg\\RECEIVE.xml");
    if(returnValue == 0)
    {
		printf("u-CUBE Engine과의 연결이 성공했습니다.\n");
    }
    else
	{
		printf("u-CUBE Engine과의 연결을 실패했습니다. 결과=[%d]\n", returnValue);
        return returnValue;
	}

    while(1)
    {    
        Sleep(10000);		
	}

	/* u-CUBE Engine 과의 연결 종료 */ 
    onClose();

    return returnValue;    
}

int handleData(char *recvData, char *ifid, int ret)
{
    printf ("수신 DATA=%d::%d::%s::%.40s\n", strlen(recvData), ret, ifid, recvData);
    
    return 0;
}
