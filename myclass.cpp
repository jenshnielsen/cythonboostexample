#include "myclass.h"
#include <iostream>
#include <cctype>
//#include <ctype.h>
#include <clocale>
namespace myexample{
    int myexample::myclass::dosomething(){
        using namespace std;
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
