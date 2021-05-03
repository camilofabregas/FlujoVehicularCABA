# Trabajo Pr�ctico 1 - Grupo 17 - Modelaci�n N�merica - 1er cuatrimestre 2021

#Item a.
datos = load('FlujoVehicular2019.dat'); # Lee el conjunto de datos del archivo.

#------------------------------------------------------

#FUNCIONES

# Recibe una tabla de datos y va calculando el balance para cada hora.
function balPorHora = balancePorHora(tabla)
  
  balPorHora = zeros(24,1);
  
  for i = 1:rows(tabla)
    balPorHora = acumularBalancesPorHora(tabla,i,balPorHora);
  endfor
  
endfunction

# Recibe una tabla de datos y va calculando el balance para cada hora en una
# estaci�n espec�fica.
function balPorHora = balanceEstacionPorHora(tabla,estacion)
  
  balPorHora = zeros(24,1);
  
  for i = 1:rows(tabla)
    if(tabla(i,5) == estacion)
      balPorHora = acumularBalancesPorHora(tabla,i,balPorHora);
    endif
  endfor
  
endfunction

# Acumula balances por hora en un vector y lo devuelve.
function balPorHora = acumularBalancesPorHora(tabla,i,balancesPorHora)
  
  balPorHora = balancesPorHora;
  
  if(tabla(i,6) == 1) #Si es ingreso.
    balPorHora(tabla(i,3)+1) += tabla(i,9); #Sumo cantidad de pasos a la hora.
  else #Si es egreso.
    balPorHora(tabla(i,3)+1) -= tabla(i,9); #Resto cantidad de pasos a la hora.
  endif
  
endfunction

# Busca y devuelve la estaci�n de peaje con mayor cantidad de pasos totales.
function estacion = mayorCantPasos(datos)
  
  pasosPorEstacion = zeros(8,1);
  
  for i = 1:rows(datos)
    pasosPorEstacion(datos(i,5)) += datos(i,9); #Acumula pasos para c/estaci�n.
  endfor
  
  cantPasos = 0;
  
  for j = 1:8
    if(pasosPorEstacion(j)>cantPasos) #Busca estacion con mayor cant. de pasos.
      cantPasos = pasosPorEstacion(j);
      estacion = j;
    endif
  endfor
  
  disp(pasosPorEstacion);
  disp(estacion);
  
endfunction


#------------------------------------------------------

#Item b.
figure(1);
plot(0:23, balancePorHora(datos));
title("Balances totales por hora.");

#Item c.
figure(2);
estacion = mayorCantPasos(datos);
titulo = strcat("Balance de estaci�n con mayor cantidad de pasos (", int2str(estacion), ")");
plot(0:23, balanceEstacionPorHora(datos,estacion));
title(titulo);

#Item d.

#Item e.

#Item f.

#Item g.

#Item h.

#Item i.

#------------------------------------------------------

 
 
 
 
 
 
 
 
 
 
 
 
 