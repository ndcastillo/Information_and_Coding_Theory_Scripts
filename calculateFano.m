function [L tal eficiencia Resultado fano]=calculateFano(mensaje)
mensaje = char(mensaje);
mensaje = strrep(mensaje,' ','_');       %Se reemplaza el espacio por un "_" para una mejor visualizacion
disp(mensaje)

simbolo = unique(mensaje);      %Obtengo todos los distintos caracteres presentes 
lM = length(mensaje);         %Número total de caracteres 
lS = length(simbolo);           %Número total de caracteres 

for i=1:lS                         %Identifico cuantas veces se repite cada caracter distinto
    cont = 0;                      %Variables auxiliar para contar el número de repeticiones de un caracter
    codigo{i,1}='';
    for j=1:lM
        if simbolo(i)==mensaje(j)
            cont=cont+1;
        end
    end
    prob(i,1)=cont/lM;             %matriz para almacenar las probabilidades de cada simbolo              
end 

respaldo=[];
%             
%             %Se ordena la matriz de probabilidades de forma descendente
[prob,o]=sort(prob,'descend');
simbolo=simbolo(o);
inicio=1; fin=length(prob); cont=0;
while cont ~= length(prob)
P = prob(inicio:fin);
ref= sum(P)/2;
acum=0;resta1=1;resta2=1;i=1;k=1;

while(resta1==resta2)
    acum=acum+P(i);
    resta2=abs(ref-acum);
    if resta2<resta1
        k=i+inicio-1;
        resta1=resta2;
    end
    i=i+1;
end
%Agrego un 0 al codigo desde el punto inicial hasta el punto medio
%y agrego un 1 al codigo desde el punto medio hasta el fin
for i=inicio:k

    codigo{i,1}=strcat(codigo{i,1},'0');
end
for i=k+1:fin

    codigo{i,1}=strcat(codigo{i,1},'1');
end
%************************************
if inicio == k
    cont=cont+1;
    if fin == k+1
        cont=cont+1;
        L=length(respaldo);
        if cont ~= length(prob)
            inicio = respaldo(L-1);
            fin = respaldo(L);
            if L > 2
                respaldo = respaldo(1:L-2);
            else
                respaldo = [];
            end
        end
    else
        inicio = k+1;
    end
else
    if fin == k+1
        cont=cont+1;
    else
        respaldo =[respaldo k+1 fin];
    end
    fin=k;
end
end

fano=mensaje;
%Se crea el vector de bits de la codificacion Huffman
for j=1:length(simbolo)
    fano = strrep(fano, simbolo(j), codigo{j,1});
end


%creamos un cellarray para observar las variables, probabilidad y codigo
for j=1:1:lS
    Resultado{j,1} = simbolo(j);
    Resultado{j,2} = num2str(prob(j));
    Resultado{j,3} = codigo{j,1};
end


%Longitud Media
L=0;
for j=1:1:(length(simbolo))
   Efc=prob(j,1)*length(codigo{j,1});
   L=L+Efc;
end
%Se presenta el resultado

%Cálculo de la Entropia
my_str=simbolo;
tal = sum(prob.*(log2(1./prob)));


%Cálculo de la Eficiencia
eficiencia=(tal/L)*100;

end