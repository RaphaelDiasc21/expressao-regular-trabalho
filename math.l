
%{ 
#include <stdio.h> 
#include <stdlib.h>
#include <string.h> 
#include <math.h>
    int contagem_operadores = 0, contagem_operandos = 0, is_valid = 1, topo = -1, l = 0, j = 0, topo_valid = 1, is_comment = 0; 
	int operands_index = 0;
	int operators_index = 0;
	char operands[10];
	int operators[10];
	int aux_operator = 0;
	int qt_operators = 0;
	int ref_operands = 0;
	int is_aberto = 0, is_seguido;
	char operandos[10][10], operadores[10][10];
	int linha = 1;
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
"+"|"-"|"*"|"/"|"^" { 
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
		operators[operators_index] = atoi(yytext);
		operators_index++;
		is_seguido--;
		strcpy(operandos[j], yytext); 
		j++; 
	}
}
"\n" {

	if (is_valid == 1 && topo == -1 && topo_valid == 1 && is_aberto == 0) { 
		int result;
		int is_first = 1;

		for(int i = aux_operator; i < operators_index; i++) {
			if(is_first == 1) {
				result = operators[i];
				is_first = 0;
			}else {
				if(operands[ref_operands] == '+') {
					ref_operands++;
					result = result + operators[i];
				}else if(operands[ref_operands] == '-') {
					result = result - operators[i];
					ref_operands++;
				}else if(operands[ref_operands] == '*') {
					result = result * operators[i];
					ref_operands++;
				}else if(operands[ref_operands] == '/') {
					result = result / operators[i];
					ref_operands++;
				}else if(operands[ref_operands] == '^') {
					result = pow(result, operators[i]);
					ref_operands++;
				}
			}
		}
		
		aux_operator = operators_index;

        printf("Expressao valida\n"); 
		printf("Resultado: %d\n\n", result);  
    } 
    else
        printf("Expressao invalida\n\n"); 
	linha++;
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

	printf("linha: %d \n", linha);
	if (is_valid == 1 && topo == -1 && topo_valid == 1 && is_aberto == 0) { 
		int result;
		int is_first = 1;
		for(int i = aux_operator; i < operators_index; i++) {
			if(is_first == 1) {
				result = operators[i];
				is_first = 0;
			}else {
				if(operands[ref_operands] == '+') {
					ref_operands++;
					result = result + operators[i];
				}else if(operands[ref_operands] == '-') {
					ref_operands++;
					result = result - operators[i];
				}else if(operands[ref_operands] == '*') {
					ref_operands++;
					result = result * operators[i];
				}else if(operands[ref_operands] == '/') {
					ref_operands++;
					result = result / operators[i];
				}
			}
		}
		
		aux_operator = operators_index;
        printf("Expressao valida\n"); 
		printf("Resultado: %d\n\n", result);  
    } 
    else
        printf("Expressao invalida\n\n"); 
  
    return 0;
}
