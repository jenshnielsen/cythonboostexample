#include "myclass.h"
#include <stdio.h>
#include <ctype.h>
namespace myexample{
    int myexample::myclass::dosomething(){
        int i=0;
        char str[]="Test String.\n";
        char c;
        while (str[i]){
            c=str[i];
            putchar (tolower(c));
            i++;
        }
        return 0;
    }
}
