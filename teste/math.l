
%{ 
#include <stdio.h> 
#include <string.h> 
    int contagem_operadores = 0, contagem_operandos = 0, is_valid = 1, topo = -1, l = 0, j = 0, topo_valid = 1; 
    char operandos[10][10], operadores[10][10], stack[100]; 
%} 
%%
"(" { 
    topo++;
    if(topo > 0) {
        topo_valid = 0;
    } 
    stack[topo] = '('; 
} 
")" { 
    if (stack[topo] != '(') { 
        is_valid = 0;     
    } 
    else if(contagem_operandos>0 && (contagem_operandos-contagem_operadores)!=1){
        is_valid=0;
    }
    else{
        topo--;
        contagem_operandos=1;
        contagem_operadores=0;
    } 
} 
"+"|"-"|"*"|"/" { 
    contagem_operadores++; 
    strcpy(operadores[l], yytext); 
    l++; 
} 
[0-9]+|[a-zA-Z][a-zA-Z0-9_]* { 
    contagem_operandos++; 
    strcpy(operandos[j], yytext); 
    j++; 
} 
%% 
  
  
int yywrap() 
{ 
    return 1; 
} 
int main() 
{ 
    int k; 
    printf("Digite uma expressao matematica: "); 
    yylex(); 
  
    if (is_valid == 1 && topo == -1 && topo_valid == 1) { 
        printf("\nExpressao valida\n"); 
    } 
    else
        printf("\nExpressao invalida\n"); 
  
    return 0;
}