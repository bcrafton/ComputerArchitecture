#include<stdio.h>

int string_length(char* string);
void reverse_string(char* src, char* dst);
void is_palindrome(char* src, char *dst);

main()
{
	char* source_string = "kayak";
	char reverseString[40];
	
	printf("The length of %s is %d\n", source_string, string_length(source_string));
	
	reverse_string(source_string, reverseString);
	
	is_palindrome(source_string, reverseString);
}

int string_length(char* string)
{
	char c;
	int counter = 0;
	do{
		c = string[counter];
		if(c != '\0')
		{
			counter++;
		}
	}
	while(c != '\0');
	return counter;
}

void reverse_string(char* src, char* dst)
{
	int src_string_length = string_length(src);
	int counter = 0;
	for(counter = 0; counter < src_string_length; counter++)
	{
		dst[counter] = src[src_string_length - counter - 1];
	}
}

void is_palindrome(char* src, char *dst)
{
	int src_string_length = string_length(src);
	int counter = 0;
	for(counter = 0; counter < src_string_length; counter++)
	{
		if(dst[counter] != src[counter])
		{
			printf("%s is not a palindrome \n", src);
			return;
		}
		dst[counter] = src[src_string_length - counter - 1];
	}
	printf("%s is a palindrome \n", src);
}

