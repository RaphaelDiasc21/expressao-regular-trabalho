
%{ 
#include <stdio.h> 
#include <stdlib.h>
#include <string.h> 
    int contagem_operadores = 0, contagem_operandos = 0, is_valid = 1, topo = -1, l = 0, j = 0, topo_valid = 1, is_comment = 0; 
	int operands_index = 0;
	int operators_index = 0;
	char operands[10];
	int operators[10];
	int is_aberto = 0, is_seguido;
	char operandos[10][10], operadores[10][10];
%} 
%%
"//" {
	is_comment = 1;
}

"(" { 
	if(is_comment != 1) {
	    topo++;
		if(topo > 0) {
			topo_valid = 0;
		} 
	}
} 
")" { 

	if(is_comment != 1) {
		if(contagem_operandos>0 && (contagem_operandos-contagem_operadores)!=1){
			is_valid=0;
		}
		else{
			topo--;
			contagem_operandos=1;
			contagem_operadores=0;
		} 
	}
} 
"+"|"-"|"*"|"/" { 
	if(is_comment != 1) {
		if(is_aberto == 1) {
			is_valid = 0;
		} else {
			contagem_operadores++; 
			operands[operands_index] = yytext[0];
			operands_index++;
			is_aberto = 1;
			is_seguido++;
			strcpy(operadores[l], yytext); 
			l++; 
		}
	}
} 
[0-9]+|[a-zA-Z][a-zA-Z0-9_]* { 
	if(is_comment != 1) {
		contagem_operandos++; 
		is_aberto = 0;
		operators[operators_index] = yytext[0]-'0';
		operators_index++;
		is_seguido--;
		strcpy(operandos[j], yytext); 
		j++; 
	}
}
"\n" {
	if (is_valid == 1 && topo == -1 && topo_valid == 1 && is_aberto == 0) { 
		int result;
		for(int i = 0; i < operators_index; i++) {
			if(i == 0) {
				result = operators[i];
			}else {
				printf("%d",result);
				if(operands[i-1] == '+') {
					result = result + operators[i];
				}else if(operands[i-1] == '-') {
					result = result - operators[i];
				}else if(operands[i-1] == '*') {
					result = result * operators[i];
				}else if(operands[i-1] == '/') {
					result = result / operators[i];
				}
			}
		}

        printf("\nExpressao valida\n"); 
		printf("\nResultado: %d", result); 
    } 
    else
        printf("\nExpressao invalida\n"); 

	topo_valid = 1;
	is_comment = 0;
	contagem_operadores = 0;
	contagem_operandos = 0;
	topo = -1;
	l = 0;
	j = 0;
} 
%% 
  
  
int yywrap() 
{ 
    return 1; 
} 
int main() 
{ 
    int k; 
    yylex(); 
  
    if (is_valid == 1 && topo == -1 && topo_valid == 1 && is_aberto == 0) { 
        printf("\nExpressao valida\n"); 
    } 
    else
        printf("\nExpressao invalida\n"); 
  
    return 0;
}
