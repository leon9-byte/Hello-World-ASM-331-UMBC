#include <stdio.h>

int main()
{
    int myNum;
    printf("Tell me the number\n:");
    
    // Get and save the number the user types
    scanf("%d", &myNum);
    
    myNum = myNum * 2;
    
    printf("Your number doubled: %d", myNum);
    return 0;
}
