function [L tal eficiencia Resultado huffman]=calculateHuffman(mensaje)
    mensaje=char(mensaje);
    %mensaje = 'LA PROXIMA SEMANA INICIAN LOS EXAMENES INTERCICLO'
    mensaje = strrep(mensaje,' ','_');       %Se reemplaza el espacio por un "_" para una mejor visualizacion


    frase = unique(mensaje);      %Obtengo todos los distintos caracteres presentes 
    lM = length(mensaje);         %Número total de caracteres 
    lS = length(frase);           %Número total de caracteres 

    for i=1:lS                         %Identifico cuantas veces se repite cada caracter distinto
        cont = 0;                      %Variables auxiliar para contar el número de repeticiones de un caracter
        for j=1:lM
            if frase(i)==mensaje(j)
                cont=cont+1;
            end
        end
        prob(i,1)=cont/lM;             %matriz para almacenar las probabilidades de cada simbolo              
    end 

    probabilidad=prob;                 %Se hace un respaldo de la matriz de probabilidades original

    %Se ordena la matriz de probabilidades de forma descendente
    [prob,o]=sort(prob,'descend');
    frase=frase(o);
    prob1=prob;
    %Se hace la tabla de probabilidades para la codificacion: se suman las dos
    %ultimas probabilidades, se eliminan y se introduce la suma como un nuevo
    %termino y reordena de forma descendente hasta que se tengan dos
    %probabilidades, ademas creamos una matriz que guarde las divisiones para
    %la posterior codificacion.
    for j=1:1:lS-1
        flag=0;                            %Para terminar la operacion
        aux=prob(lS-j+1,j)+prob(lS-j,j);   %Sumamos las probablidades de los 2 últimos términos
        if aux < 0.999999999               %Definimos el límite
            for i=1:1:lS-j                 %Recorte de la matriz
                if aux<prob(i,j)                
                    prob(i,j+1)=prob(i,j);
                    rastro(i,j+1)=i;
                elseif aux>=prob(i,j)             
                    if flag==0             %Solo permite un reemplazamiento
                        for k=i:1:lS-j-1   %Se eliminan los 2 últimos términos de la matriz
                            prob(k+1,j+1)=prob(k,j);
                            rastro(k+1,j+1)=k;                   
                        end
                        prob(i,j+1)=aux;
                        rastro(i,j+1)=0;               
                        flag=1;
                    end 
                end 
            end 
        end
    end

    %Definimos el primer termino como 0 para la probabilidad mas grande y 1
    %para la mas pequeña

    codigo{1,lS-1}='0';
    codigo{2,lS-1}='1';

    %Siguiendo el rastro codifico agregando 1 y 0 segun corresponda
    for j=1:1:lS-2
        for i=1:1:j+1    
            if rastro(i,lS-j)==0          
                lp=codigo{i,lS-j};
                codigo{j+1,lS-j-1}=strcat(lp,'0');
                codigo{j+2,lS-j-1}=strcat(lp,'1');
            else
                ras=rastro(i,lS-j);
                codigo{ras,lS-j-1}=codigo{i,lS-j};
            end
        end
    end

    huffman=mensaje;

    %Se crea el vector de bits de la codificacion Huffman
    for j=1:length(frase)
        huffman = strrep(huffman, frase(j), codigo{j,1});
    end

    %creamos un cellarray para observar las variables, probabilidad y codigo
    for j=1:1:lS
        Resultado{j,1}=frase(j);
        Resultado{j,2}=num2str(prob(j,1));
        Resultado{j,3}=codigo{j,1};
    end


    %Longitud Media
    L=0;
    for j=1:1:(length(frase))
       Efc=prob(j,1)*length(codigo{j,1});
       L=L+Efc
    end

    %Cálculo de la Entropia
    my_str=frase;
    tal = sum(probabilidad.*(log2(1./probabilidad)));

    %Cálculo de la Eficiencia
    eficiencia=(tal/L)*100;
end